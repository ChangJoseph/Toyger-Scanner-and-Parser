import java.io.*; 
import java.util.ArrayList;

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

/* additional definitions here */
public static int lookahead;
public static lexer lex = new lexer(new InputStreamReader(System.in));

/* Program Report variables */
public static ArrayList<GlobalVariable> variable_list = new ArrayList<GlobalVariable>();
public static int num_functions=0;
public static int num_comments=0;
public static int num_strings=0;
/* Extra debug variables */
public static int num_spaces=0;
public static int num_skips=0;

public static class GlobalVariable {
	public String var_id;
	public int line_num;
	public GlobalVariable(String v, int l) {
		var_id = v;
		line_num = l;
	}
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
	globalVarAdd(lex.yytext(),lex.yyline); // TODO check if lex.* funcs work
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
			globalVarAdd();
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
		globalVarAdd();
		parameters(); // G
		if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
			match(lookahead);
			if (lookahead == COLON_TOKEN) {
				match(lookahead);
				if (firstType()) {
					type(); // E
					if (lookahead == EQUAL_TOKEN) {
						match(lookahead);
						if (lookahead == ID) {
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
		if (lookahead == RIGHT_PARENTHESIS_TOKEN) {
			match(lookahead);
			if (lookahead == COLON_TOKEN) {
				match(lookahead);
				if (firstType()) {
					type(); // E
					if (lookahead == EQUAL_TOKEN) {
						match(lookahead);
						if (lookahead == ID) {
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
	else syntax_error();
	parameters();
}
public static void parameters() throws IOException { // G
	if (lookahead == ID) {
		parameter(); // H
		if (lookahead == SEMI_COLON_TOKEN) {
			parameters_2(); // G`
		}
		else syntax_error();
	}
	else syntax_error();
}
public static void parameters_2() throws IOException { // G`
	if (lookahead == SEMI_COLON_TOKEN) {
		match(lookahead);
		if (lookahead == ID) {
			parameter(); // H
			if (lookahead == SEMI_COLON_TOKEN) {
				parameters_2(); // G`
			}
			else syntax_error();
		}
		else syntax_error();
	}
	else {
		return; // epsilon
	}
}
public static void parameter() throws IOException { // H
	if (lookahead == ID) {
		globalVarAdd();
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
	if (lookahead == ID) {
		statement(); // J
		if (lookahead == SEMI_COLON_TOKEN) {
			statements_2(); // I`
		}
		else syntax_error();
	}
	else syntax_error();
}
public static void statements_2() throws IOException { // I`
	if (lookahead == SEMI_COLON_TOKEN) {
		match(lookahead);
		if (lookahead == ID) {
			statement(); // J
			if (lookahead == SEMI_COLON_TOKEN) {
				statements_2(); // I`
			}
			else syntax_error();
		}
		else syntax_error();
	}
	else return; // epsilon
}
public static void statement() throws IOException { // J
	if (lookahead == ID) {
		globalVarAdd();
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
		if (firstFactor()) {
			statement_4(); // J```
		}
		else return;
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

}
public static void statement_3() throws IOException { // J``

}
public static void statement_4() throws IOException { // J```

}
public static void expr() throws IOException { // K

}
public static void expr_2() throws IOException { // K`

}
public static void term() throws IOException { // L

}
public static void term_2() throws IOException { // L`

}
public static boolean firstFactor() { // first(M)
	return (lookahead == LEFT_PARENTHESIS_TOKEN || lookahead == NUMBER || lookahead == STRING_LITERAL || lookahead == ID);
}
public static void factor() throws IOException { // M

}
public static void factor_2() throws IOException { // M`

}
public static void expr_list() throws IOException { // N

}
public static void expr_list_2() throws IOException { // N`

}



public static void main(String [] args) throws IOException {
	look();
	start();
	if (lookahead == EOF) {
		System.err.println("Input Accepted");
	}
	else {
		syntax_error();
	}
}

public static void syntax_error() {
	System.err.printf(lexical_err_msg,lex.yyline);
	System.exit(1);
}

%} 

%type int
 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

 /* TODO check regex */
// keyword = let|in|end|var|function|printint|printstring|getint|return|if|then|else|for|to|do|int|string|void
// punctuation = \(|\)|:|,|=|;
// operator = :=|\+|-|\*|\/|==|<|<=|>|>=|<>
id = [A-Za-z0-9][_A-Za-z0-9]
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

\r|\n|\r\n		{return(EOLN);}
" "				{num_spaces++;}
.				{num_skips++;}

 
	/* copy from input to output */
	/* compiled with --legacydot so that . matches [^\n] instead of
		[^\n\r\u000B\u000C\u0085\u2028\u2029] */
 

