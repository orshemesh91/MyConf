
#include <stdio.h>
#include <time.h>	// for clock_t, clock()
#include <unistd.h>	// for sleep()
#include <stdlib.h>

#define BILLION  1000000000.0
#define LOOPS  1000

// A function that terminates when enter key is pressed 
void fun() 
{ 
    int i;

    printf("fun() starts \n"); 
    printf("Press enter to stop fun \n"); 
    for(i = 0; i < LOOPS; ++i) {
        void *pointer = malloc(45 * 1024 * 1024);
    } 
    printf("fun() ends \n"); 
} 

// main function to find the execution time of a C program
int main()
{
	struct timespec start, end;

	clock_gettime(CLOCK_REALTIME, &start);

	// do some stuff here
	fun();

	clock_gettime(CLOCK_REALTIME, &end);

	// time_spent = end - start
	double time_spent = (end.tv_sec - start.tv_sec) +
						(end.tv_nsec - start.tv_nsec) / BILLION;

    printf("Time elpased is %f seconds, each malloc took %f\n", time_spent, time_spent/LOOPS);

	return 0;
}
