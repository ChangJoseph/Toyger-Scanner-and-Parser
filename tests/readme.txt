Test cases with no syntax nor lexical errors:
  - test1: empty declarations
  - test2: one variable declaration
  - test3: one function declaration
  - test4: both var and function declarations
  - test5: different types; function w/ parameters
  - test6: expressions
  - test7: more complicated program

- check testX.out for expected output to stdout for testX.tog

==========================================
Test cases w/ syntax or lexical errors:

  - test11: missing end (line 4 / 5)
  - test12: lexical error: unknown symbol !(line 6)
  - test13: redundant semicolon (line 4)
  - test14: incorret position of assignment operator  (line 2)
  - test15: incorrect keyword IN (case sensitive) (line 5)
  - test16: missing function body (line 3)

  - check testX.err for expected output to stderr for testX.tog
  - For certain cases, it is possible/acceptable that the reported line number of the error is off by 1, if the error cannot be determined until the next token is encountered.  Example: test11. 
