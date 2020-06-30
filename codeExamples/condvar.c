#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <signal.h>
#include <assert.h>

#define THREADS_IN_GROUP 1000
#define NUM_OF_THREAD_GROUPS 1000
#define MAIN_INIT_SLEEP 15

#define MOS_MB()\
{\
    asm volatile("mfence":::"memory");\
}

#define PRINT_W(_format, ...) \
    printf("%x, g:%d, t:%d(w): "_format, self, pGroup->id, pThread->id, ##__VA_ARGS__)
#define PRINT_S(_format, ...) \
    printf("%x, g:%d, t:%d(s) - "_format, self, pGroup->id, pThread->id, ##__VA_ARGS__)

//#define DEBUG_TRACES
#ifdef DEBUG_TRACES
#define DEBUG_PRINT_W(_format, ...) \
        PRINT_W(_format, ##__VA_ARGS__)
#define DEBUG_PRINT_S(_format, ...) \
        PRINT_S(_format, ##__VA_ARGS__)
#else
#define DEBUG_PRINT_W(_format, ...)
#define DEBUG_PRINT_S(_format, ...)
#endif

struct ThreadGroup;

typedef struct ThreadEnv {
    struct ThreadGroup *pGroup;
    pthread_t *t;
    bool bWakeUp;
    pthread_cond_t cv;
    pthread_mutex_t lock;
    int id;
    int threadToWakeUp;
}ThreadEnv, *PThreadEnv;

typedef struct ThreadGroup {
    ThreadEnv threads[THREADS_IN_GROUP];
    int id;
}ThreadGroup, *PThreadGroup;

ThreadGroup threadGroupArr[NUM_OF_THREAD_GROUPS];

void *thread_Waiter(void *v);
void *thread_Signaller(void *v);

main()
{
    int groupId, threadId;
    PThreadGroup pCurrGroup;
    PThreadEnv pCurrThread;

	printf("\n\tmain: creating %d thread groups\n\n", NUM_OF_THREAD_GROUPS);
    for (groupId = 0; groupId < NUM_OF_THREAD_GROUPS; groupId++) {
        pCurrGroup = &threadGroupArr[groupId];
        pCurrGroup->id = groupId;
        printf("\tmain: create thread group %d(%p).\n",
               groupId, pCurrGroup);

        /* Create waiting threads. They start aleeping and after the first
         * wakes up, it signalls the next and so on...
         */
        for (threadId = 0; threadId < THREADS_IN_GROUP - 1; threadId++) {
            printf("\tmain: create waiting thread(%d) in group:%d(%p).\n",
                   threadId, groupId, pCurrGroup);
            pCurrThread = &pCurrGroup->threads[threadId];
            pCurrThread->id = threadId;
            pCurrThread->threadToWakeUp = threadId + 1;
            pCurrThread->pGroup = pCurrGroup;
            pCurrThread->t = (pthread_t *)malloc(sizeof(pthread_t));
            pthread_create(pCurrThread->t, NULL, thread_Waiter, pCurrThread);		
        }

        /* Create first signaller thread. It signalls the first waiter in
         * the group
         */
        printf("\tmain: create signalling thread(%d) in group:%d(%p).\n",
               threadId, groupId, pCurrGroup);
        pCurrThread = &pCurrGroup->threads[threadId];
        pCurrThread->id = threadId;
        pCurrThread->threadToWakeUp = 0;
        pCurrThread->pGroup = pCurrGroup;
        pCurrThread->t = (pthread_t *)malloc(sizeof(pthread_t));
        pthread_create(pCurrThread->t, NULL, thread_Signaller, pCurrThread);		

        printf("\tmain: group %d(%p) initialized - thread list start\n",
               groupId, pCurrGroup);
        for (threadId = 0; threadId < THREADS_IN_GROUP; threadId++) {
            pCurrThread = &pCurrGroup->threads[threadId];
            printf("\tmain: t%d(%p)\n", threadId, *pCurrThread->t);
        }
        printf("\tmain: group %d(%p) initialized - thread list end\n",
               groupId, pCurrGroup);
    }

    printf("\tmain: sleeping before death.\n");
    sleep(1000);

	printf("\n\tmain: END\n");
}

void *thread_Waiter(void *arg)
{
    PThreadEnv pThread = (PThreadEnv)arg;
    PThreadGroup pGroup = pThread->pGroup;
    PThreadEnv pThreadToWakeUp = &pGroup->threads[pThread->threadToWakeUp];
    pthread_t self;

    /* Let main finish thread initializations */
    sleep(MAIN_INIT_SLEEP);

    self = pthread_self();
    printf("\nstarted waiter in group:%p\n*pThread->t:%p(self:%x), *pThreadToWakeUp->t:%p\n\n",
           pGroup, *pThread->t, self, *pThreadToWakeUp->t);

    while (1) {

        /* Cond wait */
        pthread_mutex_lock(&pThread->lock);
        DEBUG_PRINT_W("Locked before wait\n");
        while (!pThread->bWakeUp) {
            PRINT_W("Waiting\n");
            pthread_cond_wait(&pThread->cv, &pThread->lock);
            PRINT_W("Returned from wait\n");
        }
        pThread->bWakeUp = false;
        pthread_mutex_unlock(&pThread->lock);
        DEBUG_PRINT_W("Unlocked after wait\n");

        /* Wake up next */
        pthread_mutex_lock(&pThreadToWakeUp->lock);
        DEBUG_PRINT_W("Locked before updating other's bool\n");
        pThreadToWakeUp->bWakeUp = true;
        pthread_mutex_unlock(&pThreadToWakeUp->lock);
        DEBUG_PRINT_W("Unlocked after updating other's bool\n");
        MOS_MB();
        pthread_cond_signal(&pThreadToWakeUp->cv);
        PRINT_W("Signalled\n");
    }

    return NULL;
}

void *thread_Signaller(void *arg)
{
    PThreadEnv pThread = (PThreadEnv)arg;
    PThreadGroup pGroup = pThread->pGroup;
    PThreadEnv pThreadToWakeUp = &pGroup->threads[pThread->threadToWakeUp];
    pthread_t self;

    /* Let main finish thread initializations */
    sleep(MAIN_INIT_SLEEP);

    self = pthread_self();
    printf("\nStarted signaller in group:%p\n*pThread->t:%p(self:%x), *pThreadToWakeUp->t:%p\n\n",
           pGroup, *pThread->t, self, *pThreadToWakeUp->t);

    while (1) {

        /* Wake up next */
        pthread_mutex_lock(&pThreadToWakeUp->lock);
        DEBUG_PRINT_S("Locked before updating other's bool\n");
        pThreadToWakeUp->bWakeUp = true;
        pthread_mutex_unlock(&pThreadToWakeUp->lock);
        DEBUG_PRINT_S("Unlocked after updating other's bool\n");
        MOS_MB();
        pthread_cond_signal(&pThreadToWakeUp->cv);
        PRINT_S("Signalled\n");

        /* Cond wait */
        pthread_mutex_lock(&pThread->lock);
        DEBUG_PRINT_S("Locked before wait\n");
        while (!pThread->bWakeUp) {
            PRINT_S("Waiting\n");
            pthread_cond_wait(&pThread->cv, &pThread->lock);
            PRINT_S("Returned from wait\n");
        }
        pThread->bWakeUp = false;
        pthread_mutex_unlock(&pThread->lock);
        DEBUG_PRINT_S("Unlocked after wait\n");
    }

    return NULL;
}
