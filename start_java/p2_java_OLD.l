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
static final int IDENTIFIER_TOKEN=37;
static final int NUMBERS_TOKEN=38;
static final int STRINGS_TOKEN=39;
static final int COMMENTS_TOKEN=40;
/* End of line */
static final int EOLN=100;

/* additional definitions here */

public static void main(String [] args) throws IOException 
{
	lexer lex = new lexer(new InputStreamReader(System.in));
    lex.yylex();
}

%} 

%type int
 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

%% 

let							{return(LET_TOKEN);}
in							{return(IN_TOKEN);}
end							{return(END_TOKEN);}
var							{return(VAR_TOKEN);}
function					{return(FUNCTION_TOKEN);}
printint					{return(PRINTINT_TOKEN);}
printstring					{return(PRINTSTRING_TOKEN);}
getint						{return(GETINT_TOKEN);}
return						{return(RETURN_TOKEN);}
if							{return(IF_TOKEN);}
then						{return(THEN_TOKEN);}
else						{return(ELSE_TOKEN);}
for							{return(FOR_TOKEN);}
to							{return(TO_TOKEN);}
do							{return(DO_TOKEN);}
int							{return(INT_TOKEN);}
string						{return(STRING_TOKEN);}
void						{return(VOID_TOKEN);}

(							{return(LEFT_PARENTHESIS_TOKEN);}
)							{return(RIGHT_PARENTHESIS_TOKEN);}
:							{return(COLON_TOKEN);}
,							{return(COMMA_TOKEN);}
=							{return(EQUAL_TOKEN);}
;							{return(SEMI_COLON_TOKEN);}

:=							{return(ASSIGNMENT_TOKEN);}
+							{return(PLUS_TOKEN);}
-							{return(MINUS_TOKEN);}
*							{return(MULTIPLY_TOKEN);}
/							{return(DIVISOR_TOKEN);}

==							{return(EQUALITY_TOKEN);}
<							{return(LESS_THAN_TOKEN);}
<=							{return(LESS_EQUAL_TOKEN);}
>							{return(GREATER_THAN_TOKEN);}
>=							{return(GREATER_EQUAL_TOKEN);}
<>							{return(NOT_EQUAL_TOKEN);}

[A-Za-z0-9][_A-Za-z0-9]		{return(IDENTIFIER_TOKEN);}
[1-9][0-9]*					{return(NUMBERS_TOKEN);}
"[(\")^"]"					{return(STRINGS_TOKEN);}
//[^\n]*					{return(COMMENTS_TOKEN);}

\r|\n|\r\n		{return(EOLN);}
.				{;}

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

