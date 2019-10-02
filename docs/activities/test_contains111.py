##############################
# test_contains111.py        #
# Barb Wahl, 9-25-2018       #
##############################

from utils import rf
from simulateTM import simulateTM

def main():
   should_reject = ["", "1", "x", "11", "xx", "11x1", "abcd11"]
   should_accept = ["111", "1110", "0111", "xy111z", "1111"]
   run_tests("contains111.tm", should_reject, "no")
   run_tests("contains111.tm", should_accept, "yes")

def run_tests(prog_file, L, expected):
   for I in L:
      result = simulateTM(rf(prog_file), I)
      if result == expected:
         decorator = " -- correct."
      else:
         decorator = " -- ERROR!"
      print_report("contains111", I, result + decorator)

def print_report(fun_name, I, msg):
   print(fun_name + "(" + I + ") = " + msg)

main()
