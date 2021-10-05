# Toyger Scanner and Parser

A CS 440 Project

## Overview
A compiler for our Toyger language, which is inspired by Tiger (Andrew Appel, Modern Compiler Implementation in C, Cambridge University Press) but a much simplified version. A scanner and a parser to perform syntax analysis for a subset of Toyger programs using lex (flex, jflex) with lexical analysis and a recursive descent parser for syntax checking. Able to generate a report for an input program.

## Other Resources
http://cs.gmu.edu/~white/CS540/Examples/

## Compilation and Run Example
### Linux/Unix
user:\~/.../start_java>**make**  
user:\~/.../start_java>**java p2_java <test1.tog >out1.txt 2>err1.txt**  
### Windows
C:\\...\\start_java>**java -jar jflex-full-1.7.0.jar p2_java.l**  
C:\\...\\start_java>**javac lexer.java**  
C:\\...\\start_java>**java lexer**