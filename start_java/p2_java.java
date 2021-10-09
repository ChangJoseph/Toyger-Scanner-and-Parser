 /* CS440 Proj 2 Fall 2021
      Name: Joseph Chang
      G#: G01189913
      Language: Java
  */

import java.io.*;
import java.util.ArrayList;

public class p2_java
{

    /* Self-defined tokens */
    static final int EOF=0;
    static final int TOKEN=1;  /* dummy token type */
    /* Keywords */
    static final int LET_TOKEN=2;
    static final int IN_TOKEN=3;
    static final int END_TOKEN=4;
    static final int VAR_TOKEN=5;
    static final int FUNCTION_TOKEN=6;
    static final int PRINTINT_TOKEN=7;
    static final int PRINTSTRING_TOKEN=8;
    static final int GETINT_TOKEN=9;
    static final int RETURN_TOKEN=10;
    static final int IF_TOKEN=11;
    static final int THEN_TOKEN=12;
    static final int ELSE_TOKEN=13;
    static final int FOR_TOKEN=14;
    static final int TO_TOKEN=15;
    static final int DO_TOKEN=16;
    static final int INT_TOKEN=17;
    static final int STRING_TOKEN=18;
    static final int VOID_TOKEN=19;
    /* Punctuation */
    static final int LEFT_PARENTHESIS_TOKEN=20;
    static final int RIGHT_PARENTHESIS_TOKEN=21;
    static final int COLON_TOKEN=22;
    static final int COMMA_TOKEN=23;
    static final int EQUAL_TOKEN=24;
    static final int SEMI_COLON_TOKEN=25;
    /* Arithmetic Operator */
    /* := */
    static final int ASSIGNMENT_TOKEN=26;
    static final int PLUS_TOKEN=27;
    static final int MINUS_TOKEN=28;
    static final int MULTIPLY_TOKEN=29;
    static final int DIVISOR_TOKEN=30;
    /* Comparison Operator */
    /* == */
    static final int EQUALITY_TOKEN=31;
    static final int LESS_THAN_TOKEN=32;
    static final int LESS_EQUAL_TOKEN=33;
    static final int GREATER_THAN_TOKEN=34;
    static final int GREATER_EQUAL_TOKEN=35;
    static final int NOT_EQUAL_TOKEN=36;
    /* Variable Lines */
    static final int ID=37; /* \w or a-z, A-Z, 0-9 */
    static final int NUMBER=38; /* ### */
    static final int STRING_LITERAL=39; /* "abc" */
    static final int COMMENT=40; /* // comment */
    /* End of line */
    static final int EOLN=100;

    static int lookahead = 0;
    static lexer scanner = null;

    static String syntax_err_msg = "Syntax Error: line %d\n";
    static String accept_msg = "Input Accepted\n";

    static String var_report = "Global Variable %s: line %d\n";
    static String func_count = "Number of functions defined: %d\n";
    static String comment_count = "Number of comments: %d\n";
    static String string_count = "Number of strings: %d\n";

    public static lexer lex = new lexer(new InputStreamReader(System.in));

    public static class GlobalVariable {
      public String var_id;
      public int line_num;
      public GlobalVariable(String v, int l) {
        var_id = v;
        line_num = l;
      }
    }

    /* Program Report variables */
    public static ArrayList<GlobalVariable> variable_list = new ArrayList<GlobalVariable>();
    
    public static void syntax_error() {
      System.err.printf(syntax_err_msg,lex.get_line());
      // System.err.printf("COLUMN: %d",lex.yycolumn);
      System.exit(1);
    }
    public static int look() throws IOException {
      lookahead = lex.yylex();
      return lookahead;
    }
    public static void match(int symbol) throws IOException {
      if (lookahead == symbol) {
        look();
      }
      else syntax_error();
    }
    public static void globalVarAdd() {
      globalVarAdd(lex.yytext(),lex.get_line()); // TODO check if lex.* funcs work
    }
    public static void globalVarAdd(String v, int l) {
      variable_list.add(new GlobalVariable(v,l));
    }
    
    public static void start() throws IOException {
      if (lookahead == LET_TOKEN) {
        match(lookahead);
        decs(); // B
        // in
        if (lookahead == IN_TOKEN) {
          match(lookahead);
        }
        else syntax_error();
        statements(); // I
        // end
        if (lookahead == END_TOKEN) {
          match(lookahead);
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void decs() throws IOException { // B
      if (lookahead == VAR_TOKEN || lookahead == FUNCTION_TOKEN) {
        dec(); // C
        decs(); // B
      }
      // else if (lookahead == EOLN) {
      // 	match(lookahead);
      // }
      else return; // epsilon
    }
    public static void dec() throws IOException { // C
      if (lookahead == VAR_TOKEN) {
        var_dec(); // D
      }
      else if (lookahead == FUNCTION_TOKEN) {
        function_dec(); // F
      }
      else syntax_error();
    }
    public static void var_dec() throws IOException { // D
      if (lookahead == VAR_TOKEN) {
        match(lookahead);
        if (lookahead == ID) {
          globalVarAdd();
          match(lookahead);
          if (lookahead == ASSIGNMENT_TOKEN) {
            var_dec_2(); // D`
          }
          else if (lookahead == COLON_TOKEN) {
            var_dec_2(); // D`
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void var_dec_2() throws IOException { // D`
      if (lookahead == ASSIGNMENT_TOKEN) {
        match(lookahead);
        expr(); // K
      }
      else if (lookahead == COLON_TOKEN) {
        match(lookahead);
        type(); // E
      }
      else syntax_error();
    }
    public static boolean firstType() { // first(E)
      return (lookahead == INT_TOKEN || lookahead == STRING_TOKEN || lookahead == VOID_TOKEN);
    }
    public static void type() throws IOException { // E
      if (firstType()) {
        match(lookahead);
      }
      else syntax_error();
    }
    public static void function_dec() throws IOException { // F
      if (lookahead == FUNCTION_TOKEN) {
        match(lookahead);
        if (lookahead == ID) {
          match(lookahead);
          if (lookahead == LEFT_PARENTHESIS_TOKEN) {
            match(lookahead);
            function_dec_2();
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void function_dec_2() throws IOException { // F`
      if (lookahead == ID) {
        parameters(); // G
        if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
          match(lookahead);
          if (lookahead == COLON_TOKEN) {
            match(lookahead);
            if (firstType()) {
              type(); // E
              if (lookahead == EQUAL_TOKEN) {
                match(lookahead);
                if (firstStatement()) {
                  statements(); // I
                  if (lookahead == END_TOKEN) {
                    match(lookahead);
                  }
                  else syntax_error();
                }
                else syntax_error();
              }
              else syntax_error();
            }
            else syntax_error();
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
        match(lookahead);
        if (lookahead == COLON_TOKEN) {
          match(lookahead);
          if (firstType()) {
            type(); // E
            if (lookahead == EQUAL_TOKEN) {
              match(lookahead);
              if (firstStatement()) {
                statements(); // I
                if (lookahead == END_TOKEN) {
                  match(lookahead);
                }
                else syntax_error();
              }
              else syntax_error();
            }
            else syntax_error();
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void parameters() throws IOException { // G
      if (lookahead == ID) {
        parameter(); // H
        parameters_2(); // G`
      }
      else syntax_error();
    }
    public static void parameters_2() throws IOException { // G`
      if (lookahead == COMMA_TOKEN) {
        match(lookahead);
        if (lookahead == ID) {
          parameter(); // H
          parameters_2(); // G`
        }
        else syntax_error();
      }
      else return; // epsilon
    }
    public static void parameter() throws IOException { // H
      if (lookahead == ID) {
        match(lookahead);
        if (lookahead == COLON_TOKEN) {
          match(lookahead);
          if (firstType()) {
            type(); // E
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void statements() throws IOException { // I
      if (firstStatement()) {
        statement(); // J
        statements_2(); // I`
      }
      else syntax_error();
    }
    public static void statements_2() throws IOException { // I`
      if (lookahead == SEMI_COLON_TOKEN) {
        match(lookahead);
        if (firstStatement()) {
          statement(); // J
          statements_2(); // I`
        }
        else syntax_error();
      }
      else return; // epsilon
    }
    public static boolean firstStatement() {
      return (lookahead == ID || lookahead == RETURN_TOKEN || lookahead == PRINTINT_TOKEN || lookahead == PRINTSTRING_TOKEN);
    }
    public static void statement() throws IOException { // J
      if (lookahead == ID) {
        match(lookahead);
        if (lookahead == ASSIGNMENT_TOKEN) {
          match(lookahead);
          if (firstFactor() || lookahead == GETINT_TOKEN) {
            statement_2(); // J`
          }
          else syntax_error();
        }
        else if (lookahead == LEFT_PARENTHESIS_TOKEN) {
          match(lookahead);
          if (lookahead == RIGHT_PARENTHESIS_TOKEN || firstFactor()) {
            statement_3(); // J``
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else if (lookahead == RETURN_TOKEN) {
        match(lookahead);
        statement_4(); // J```
      }
      else if (lookahead == PRINTINT_TOKEN) {
        match(lookahead);
        if (lookahead == LEFT_PARENTHESIS_TOKEN) {
          match(lookahead);
          if (firstFactor()) {
            expr(); // K
            if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
              match(lookahead);
            }
            else syntax_error();
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else if (lookahead == PRINTSTRING_TOKEN) {
        match(lookahead);
        if (lookahead == LEFT_PARENTHESIS_TOKEN) {
          match(lookahead);
          if (firstFactor()) {
            expr(); // K
            if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
              match(lookahead);
            }
            else syntax_error();
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void statement_2() throws IOException { // J`
      if (lookahead == GETINT_TOKEN) {
        match(lookahead);
        if (lookahead == LEFT_PARENTHESIS_TOKEN) {
          match(lookahead);
          if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
            match(lookahead);
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else if (firstFactor()) {
        expr(); // K
      }
      else syntax_error();
    }
    public static void statement_3() throws IOException { // J``
      if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
        match(lookahead);
      }
      else if (firstFactor()) {
        expr_list(); // N
        if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
          match(lookahead);
        }
        else syntax_error();
      }
      else syntax_error();
    }
    public static void statement_4() throws IOException { // J```
      if (firstFactor()) {
        expr(); // K
      }
      else return; // epsilon
    }
    public static void expr() throws IOException { // K
      if (firstFactor()) {
        term(); // L
        expr_2(); // K`
      }
      else syntax_error();
    }
    public static void expr_2() throws IOException { // K`
      if (lookahead == PLUS_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          term(); // L
          expr_2(); // K`
        }
        else syntax_error();
      }
      else if (lookahead == MINUS_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          term(); // L
          expr_2(); // K`
        }
        else syntax_error();
      }
      else return; // epsilon
    }
    public static void term() throws IOException { // L
      if (firstFactor()) {
        factor(); // M
        term_2(); // L`
      }
      else syntax_error();
    }
    public static void term_2() throws IOException { // L`
      if (lookahead == MULTIPLY_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          factor(); // M
          term_2(); // L`
        }
      }
      if (lookahead == DIVISOR_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          factor(); // M
          term_2(); // L`
        }
      }
      else return; // epsilon
    }
    public static boolean firstFactor() { // first(M) -> first non-terminals associated with state M
      return (lookahead == LEFT_PARENTHESIS_TOKEN || lookahead == NUMBER || lookahead == STRING_LITERAL || lookahead == ID);
    }
    public static void factor() throws IOException { // M
      if (lookahead == LEFT_PARENTHESIS_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          expr(); // K
          if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
            match(lookahead);
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else if (lookahead == NUMBER) {
        match(lookahead);
      }
      else if (lookahead == STRING_LITERAL) {
        match(lookahead);
      }
      else if (lookahead == ID) {
        match(lookahead);
        factor_2(); // M`
      }
      else syntax_error();
    }
    public static void factor_2() throws IOException { // M`
      if (lookahead == LEFT_PARENTHESIS_TOKEN) {
        match(lookahead);
        if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
          match(lookahead);
        }
        else if (firstFactor()) {
          expr_list(); // N
          if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
            match(lookahead);
          }
          else syntax_error();
        }
        else syntax_error();
      }
      else return; // epsilon
    }
    public static void expr_list() throws IOException { // N
      if (firstFactor()) {
        expr(); // K
        expr_list_2(); // N`
      }
      else syntax_error();
    }
    public static void expr_list_2() throws IOException { // N`
      if (lookahead == COMMA_TOKEN) {
        match(lookahead);
        if (firstFactor()) {
          expr(); // K
          expr_list_2(); // N`
        }
        else syntax_error();
      }
      else return; // epsilon
    }

    public static void main (String [] args) throws IOException
    {
      look();
      start();
      if (lookahead == EOF) {
        System.err.println("Input Accepted");
      }
      else {
        syntax_error();
      }
      for (GlobalVariable var_elem : variable_list) {
        System.out.printf(var_report,var_elem.var_id,var_elem.line_num);
      }
      if (variable_list.size() > 0) System.out.print("\n");
      System.out.printf(func_count,lex.get_function_count());
      System.out.printf(comment_count,lex.get_comment_count());
      System.out.printf(string_count,lex.get_string_count());
    }
}

