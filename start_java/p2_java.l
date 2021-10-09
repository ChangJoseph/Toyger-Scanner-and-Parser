 /* CS440 Proj 2 Fall 2021
      Name: Joseph Chang
      G#: G01189913
      Language: Java
  */
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

static int num_functions=0;
static int num_comments=0;
static int num_strings=0;

/* additional definitions here */
private void lexical_error() {
	System.err.printf(lexical_err_msg,yyline+1);
	System.exit(1);
}
public int get_function_count() {
	return num_functions;
}
public int get_comment_count() {
	return num_comments;
}
public int get_string_count() {
	return num_strings;
}
public int get_line() {
	return yyline+1;
}

%} 

%type int
 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

// keyword = let|in|end|var|function|printint|printstring|getint|return|if|then|else|for|to|do|int|string|void
// punctuation = \(|\)|:|,|=|;
// operator = :=|\+|-|\*|\/|==|<|<=|>|>=|<>
id = [A-Za-z][_A-Za-z0-9]*
number = [1-9][0-9]*
string = \"((\\\")|[^\n\"])*\"
comment = \/\/[^\n]*

%% 

printstring		{return(PRINTSTRING_TOKEN);}
printint		{return(PRINTINT_TOKEN);}
function		{num_functions++;return(FUNCTION_TOKEN);}
return			{return(RETURN_TOKEN);}
getint			{return(GETINT_TOKEN);}
string			{return(STRING_TOKEN);}
void			{return(VOID_TOKEN);}
else			{return(ELSE_TOKEN);}
then			{return(THEN_TOKEN);}
let				{return(LET_TOKEN);}
end				{return(END_TOKEN);}
var				{return(VAR_TOKEN);}
for				{return(FOR_TOKEN);}
int				{return(INT_TOKEN);}
in				{return(IN_TOKEN);}
if				{return(IF_TOKEN);}
do				{return(DO_TOKEN);}
to				{return(TO_TOKEN);}
{id}			{return(ID);}
{number}		{return(NUMBER);}
{string}		{num_strings++;return(STRING_LITERAL);}
{comment}		{num_comments++;}
:=				{return(ASSIGNMENT_TOKEN);}
==				{return(EQUALITY_TOKEN);}
:				{return(COLON_TOKEN);}
=				{return(EQUAL_TOKEN);}
\(				{return(LEFT_PARENTHESIS_TOKEN);}
\)				{return(RIGHT_PARENTHESIS_TOKEN);}
,				{return(COMMA_TOKEN);}
;				{return(SEMI_COLON_TOKEN);}
\+				{return(PLUS_TOKEN);}
-				{return(MINUS_TOKEN);}
\*				{return(MULTIPLY_TOKEN);}
\/				{return(DIVISOR_TOKEN);}
\<=				{return(LESS_EQUAL_TOKEN);}
\<>				{return(NOT_EQUAL_TOKEN);}
\<				{return(LESS_THAN_TOKEN);}
>=				{return(GREATER_EQUAL_TOKEN);}
>				{return(GREATER_THAN_TOKEN);}

\r|\n|\r\n		{/*return(EOLN)*/;}
" "				{;}
.				{lexical_error();}

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

