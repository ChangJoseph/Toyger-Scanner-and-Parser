import java.io.*;

public class p2_java
{
    static int lookahead = 0;
    static lexer scanner = null;

    static String syntax_err_msg = "Syntax Error: line %d\n";
    static String accept_msg = "Input Accepted\n";

    static String var_report = "Global Variable %s: line %d\n";
    static String func_count = "Number of functions defined: %d\n";
    static String comment_count = "Number of comments: %d\n";
    static String string_count = "Number of strings: %d\n";

    public static void main (String [] args) throws IOException
    {
    	scanner = new lexer(new InputStreamReader(System.in));
	    lookahead = scanner.yylex();
	    while (lookahead != 0){ //yylex() returns zero at EOF
	      System.err.print(lookahead+" ");
	      lookahead = scanner.yylex();
	    }
    }
}

