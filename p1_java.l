 /* CS440 Proj 1 Fall 2021
      Name: Joseph Chang
      G#: G01189913
      Language: Java

      Note:	added %line to us yyline for keeping track of current lex line number
			Each state checks if next line has next state's transition condition
			*except for YYINITIAL because of how I looped the end of HISTORY to SUBMISSIONS*
			
			General parsing logic:
			When name (SUBMITTERS) is parsed, count & groupCount increments
			When a new student is found, another record is inserted.
			-> subs.add(new Record(yytext(),currSubID));
			When subsequent email and sid is found, insert it to newest record
			-> subs.get(subs.size()-1).email=yytext();
			-> subs.get(subs.size()-1).sid=yytext();
			When (SCORE) state is reached, start score writing loop
			-- purpose: to write submission "Score" for each submitter found
			When (HISTORY) state is reached, count each {historyScore} pattern and add 1 (the final submission); start submission count loop
			-- purpose: to write "Num Submission" for each submitter found
			
			Calculation row is done by simply using variables to keep track of min, max, and avg (count is subs.size())
  */

import java.io.*; 
import java.lang.Integer;
import java.lang.Float;
import java.util.ArrayList;

class Record {
	String sid, name, email, subID; float score; int subCount;
	/*public Record() {
		this("n/a","n/a","n/a","n/a",0f,0);
	}*/
	public Record(String name, String subID) {
		this("n/a",name,"n/a",subID,0f,0);
	}
	public Record(String sid, String name, String email, String subID, float score, int subCount) {
		this.sid = sid;
		this.name = name;
		this.email = email;
		this.subID = subID;
		this.score = score;
		this.subCount = subCount;
	}
}

 /* addtional imports/ declarations here */

%% 

%class p1_java 
%unicode 
%line
%{ 

public static void main(String [] args) throws IOException 
{ 
     // read from standard input
     p1_java lexer = new p1_java(new InputStreamReader(System.in));
     lexer.yylex(); 
	 
	 if (exit) return;
	 
	 /* TODO Add all the implementation for main rows */
	 /* use groupCount to set scores for multiple records */
	 /* make a sub-class for storing record information */
	 /* use arraylist to store each record */
	 System.out.printf(title_row);
	 for (int index = 0; index < subs.size(); index++) {
		Record rec = subs.get(index);
	 	System.out.printf(row_pattern,index+1,rec.sid,rec.name,rec.email,rec.subID,rec.score,rec.subCount);
		
	 }
	 System.out.printf(stats_header);
	 if (subs.size() > 0) avgScore = avgScore / subs.size();
	 System.out.printf(stats_pattern,subs.size(),maxScore,minScore,avgScore);
} 


 /* header rows and patterns */
static String title_row = "\"Index\",\"Student ID\",\"Name\",\"Email\",\"Submission ID\",\"Score\",\"Num Submissions\"\n";
static String row_pattern = "\"%d\",\"%s\",\"%s\",\"%s\",\"%s\",\"%.2f\",\"%d\"\n";

static String stats_header = "\"Count\",\"Max Score\",\"Min Score\",\"Avg Score\"\n";
static String stats_pattern = "\"%d\",\"%.2f\",\"%.2f\",\"%.2f\"\n"; 


 /* error messages */
static String email_err_msg = "Line %d: incorrect email!\n";
static String gnum_err_msg = "Line %d: incorrect G# format!\n";
static String na_err_msg = "Line %d: symbol %c not allowed!\n";

 /* additional definitions here */
 /* Records Variables */
static ArrayList<Record> subs = new ArrayList<Record>(5);
 /* Calculation Variables */
static String currSubID = ""; /* Keeping track of the submission id per each iteration */
static int groupCount = 0; /* Counting how many students in a single submission */
static int groupSubCount = -1; /* Counting how many submissions per group */
static int totalSubCount = 0; /* Submission count */
static float maxScore = -1; /* Max score */
static float minScore = Integer.MAX_VALUE; /* Min score */
static float avgScore = 0; /* Average score */
 /* Extras */
static float temp = 0; /* For storing parsed scores */
static boolean exit = false; /* flag to prevent main() from printing */

%} 

%type Object    //this line changes the return type of yylex into Object 
 /* lex comments: cannot start with the leftmost location of a line */
 /* add your regular definitions here */

start = ---\n
end = \.\.\.
number = [0-9]+
doubleQuote = .*\".*
prespace = \s{2,16}
name = [A-Za-z ,\.\-]+
email = [A-Za-z0-9]+"@"[A-Za-z0-9]+"."[A-Za-z0-9]+
sid = "G"[0-9]{5}
score = [0-9]+"."[0-9]+
historyScore = \n{prespace}"- :score: "{score}\n{prespace}":id: "{number}

 /* Checks for new submission block or for end of YAML file */
%state SUBMISSION
 /* Checks for each submitter for the current submission (name check is embedded into state SUBMITTERS) */
%state SUBMITTERS
%state EMAIL
%state SID
 /* Final score of submission */
%state SCORE
 /* Counts number of historical submissions */
%state HISTORY
 /* newline after end of file (...) token */
%state END

%% 

<YYINITIAL> {
	{start}							{yybegin(SUBMISSION);} /*---\n*/
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<SUBMISSION> {
	"submission_"					{totalSubCount+=1;groupCount=0;} /*submission_*/
	{number}						{currSubID=yytext();} /* the id number of the submission */
	":"\n{prespace}":submitters:"	{yybegin(SUBMITTERS);} /* Confirms SUBMITTERS state change */
	
	/* End case if no more submissions and error case if quotation is found */
	{end}							{yybegin(END);} /*...*/
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<SUBMITTERS> { /* For each person, state goes from SUBMITTERS, EMAIL, SID, then back to SUBMITTERS */
	\n{prespace}"- :name: " 		{groupCount+=1;} /* Accept name key and prepare for name value */
	{name} 							{subs.add(new Record(yytext(),currSubID));} /* Insert a new record with a name */
	\n?{prespace}":email: "			{yybegin(EMAIL);} /* Checks if state needs to change to EMAIL state */
	\n{prespace}":score: "			{yybegin(SCORE);} /* Checks if state needs to change to SCORE state */
	
	/* Error case if quotation is found */
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<EMAIL> {
	{email}							{subs.get(subs.size()-1).email=yytext();} /* Email written to most recently created record */
	\n?{prespace}":sid: "			{yybegin(SID);} /* Checks if state needs to change to SID state */
	
	/* Error case if email is invalid or quotation is found */
	.								{exit=true;System.err.printf(email_err_msg,yyline+1);return(null);}
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<SID> {
	{sid}							{subs.get(subs.size()-1).sid=yytext();;yybegin(SUBMITTERS);} /* Record SID */
	
	/* Error case if gnumber (sid) is invalid or quotation is found */
	.								{exit=true;System.err.printf(gnum_err_msg,yyline+1);return(null);}
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<SCORE> {
	{score}	{
		/* temp is equal to the given score */
		/* This is most of the calculation row's calculations are done */
		temp = Float.parseFloat(yytext());
		if (temp > maxScore) maxScore = temp;
		if (temp < minScore) minScore = temp;
		avgScore += temp * groupCount; /* considering multiple people in this single submission */
		
		/* Writing score to its corresponding records */
		for (int i = 1; i <= groupCount; i++) {
			/* Submitters in a group will be the 'i' most "recent" (at time of scoring) records created */
			subs.get(subs.size()-i).score = temp;
		}
	}
	\n{prespace}":history:"			{groupSubCount=1;yybegin(HISTORY);}
	
	/* Error case if quotation is found */
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<HISTORY> {
	" []"							{}
	{historyScore} {
		groupSubCount+=1;
	}
	\n {
		/* Writing Num Submissions to its corresponding records */
		for (int i = 1; i <= groupCount; i++) {
			subs.get(subs.size()-i).subCount = groupSubCount;
		}
		yybegin(SUBMISSION);
	}
	
	/* Error case if quotation is found */
	{doubleQuote}					{exit=true;System.err.printf(na_err_msg,yyline+1,'"');return(null);}
}
<END> [^]							{return(0);}

	/* Debuggin Patterns */
	/* {doubleQuote}				{exit=true;System.err.printf(na_err_msg,yyline,'"');return(null);} */
	/* .							{exit=true;System.err.printf("Unknown Error\n");return(null);} */
	/* [^]							{System.out.print(yytext());} */
 

