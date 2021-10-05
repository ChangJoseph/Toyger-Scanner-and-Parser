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
static final int LET=2;  /* example token for keyword let */

/* additional definitions here */

%} 

%type int
 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

%% 

let   {return(LET);}  /* keyword let */
.|\n  {return(TOKEN);} /* default: need to change/remove */

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

