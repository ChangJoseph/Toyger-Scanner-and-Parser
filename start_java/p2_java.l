import java.io.*; 

 /* lex comments: cannot start with the leftmost location of a line */
 /* addtional imports/ declarations here */

%% 

%class lexer
%unicode 
%line
%column
%eofval{
	return 0; //returns zero for EOF
%eofval}

%{ 

static String lexical_err_msg = "Lexical Error: line %d\n";

/* Self-defined tokens */
static final int TOKEN=1;  /* dummy token type */
/* Keywords */
static final int KEYWORD=2; /* let|in|end|var|etc... */
/* Punctuation */
static final int PUNCTUATION=3; /* \(|\)|:|,|=|; */
/* Operator */
static final int OPERATOR=4; /* :=|\+|-|\*|\/|==|<|<=|>|>=|<> */
/* Variable Lines */
static final int ID=5; /* \w or a-z, A-Z, 0-9 */
static final int NUMBER=6; /* ### */
static final int STRING_LITERAL=7; /* "abc" */
static final int COMMENT=8; /* // comment */
/* End of line */
static final int EOLN=100;

/* additional definitions here */

public static int lookahead;
public static String lookaheadStr;
public static lexer lex = new lexer(new InputStreamReader(System.in));


public static void start() {
	if (lookahead == 2) {
		// match(token); nextState();
	}
	else if (lookahead == 2) {
		
	}
	else {
		syntax_error();
	}
}
public static void decs() {

}
public static void dec() {

}
public static void var_dec() {

}
public static void var_dec_2() {

}
public static void type() {

}
public static void function_dec() {

}
public static void function_dec_2() {

}
public static void parameters() {

}
public static void parameters_2() {

}
public static void parameter() {

}
public static void statements() {

}
public static void statements_2() {

}
public static void statement() {

}
public static void statement_2() {

}
public static void statement_3() {

}
public static void statement_4() {

}
public static void expr() {

}
public static void expr_2() {

}
public static void term() {

}
public static void term_2() {

}
public static void factor() {

}
public static void factor_2() {

}
public static void expr_list() {

}
public static void expr_list_2() {

}



public static void main(String [] args) throws IOException {
	lookahead = lex.yylex();
	start();
	while ((lookahead) != EOLN) {
		
		lookahead = lex.yylex();
	}
}

public static void syntax_error() {
	System.err.printf(lexical_err_msg,lex.yyline);
}

%} 

%type int
 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

 /* TODO check regex */
keyword = let|in|end|var|function|printint|printstring|getint|return|if|then|else|for|to|do|int|string|void
punctuation = \(|\)|:|,|=|;
operator = :=|\+|-|\*|\/|==|<|<=|>|>=|<>
id = [A-Za-z0-9][_A-Za-z0-9]
number = [1-9][0-9]*
string = \"((\\\")|[^\n\"])*\"
comment = \/\/[^\n]*

%% 

{keyword}		{lookaheadStr=yytext();return(KEYWORD);}
{punctuation}	{lookaheadStr=yytext();return(PUNCTUATION);}
{operator}		{lookaheadStr=yytext();return(OPERATOR);}
{id}			{lookaheadStr=yytext();return(ID);}
{number}		{lookaheadStr=yytext();return(NUMBER);}
{string}		{lookaheadStr=yytext();return(STRING_LITERAL);}
{comment}		{lookaheadStr=yytext();return(COMMENT);}

\r|\n|\r\n		{return(EOLN);}
.				{;}

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

