### Load scripts ###
source ~/rdb/src/tools/gdb/gdb_scripts
source ~/rdb/src/tools/gdb/gdb_scripts.py

### History ###
set history save on
set history filename ~/.gdb_history

### Breakpoints ####
#breakpoint before asserting and keep the process alive:
set_breakpoint_on_assert

### General settings ###
#print in a user-friendly format:
set print pretty on
