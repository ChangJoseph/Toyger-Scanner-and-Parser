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
static final int KEYWORD=2;
/* Punctuation */
static final int PUNCTUATION=3;
/* Operator */
static final int OPERATOR=4;
/* Variable Lines */
static final int ID=5;
static final int NUMBER=6;
static final int STRING_LITERAL=7;
static final int COMMENT=8;
/* End of line */
static final int EOLN=100;

/* additional definitions here */

public static int lookahead;
public static lexer lex = new lexer(new InputStreamReader(System.in));

public static void start() {
	if (lookahead == 1) {
		// match(token); nextState();
	}
	else if (lookahead == 2) {
		
	}
	else {
		syntax_error();
	}
}

public static void main(String [] args) throws IOException {
	lookahead = lex.yylex();
	start();
	if (lookahead == EOLN) {
		return; // Accept state
	}
	else {
		syntax_error();
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

{keyword}		{return(KEYWORD);}
{punctuation}	{return(PUNCTUATION);}
{operator}		{return(OPERATOR);}
{id}			{return(ID);}
{number}		{return(NUMBER);}
{string}		{return(STRING_LITERAL);}
{comment}		{return(COMMENT);}

\r|\n|\r\n		{return(EOLN);}
.				{;}

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

