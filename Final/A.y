%{
#include<stdio.h>
#include <stdlib.h>
#include<string.h>
void yyerror(const char *message);
%}
%union {
	int integer;
	char* string;
}
%token <integer> bool_val and or not number define fun _if
%token <string> id;
%token print_num print_bool mod
%left '+' '-'
%left '*'
%type <integer> EXP NUM-OP PLUS PLUS-EXPS MINUS MULTIPLY MULTI-EXPS DIVIDE MODULUS GREATER SMALLER EQUAL
%%
PROGRAM	: STMT PROGRAM
	|
	;
STMT	: EXP
	| DEF-STMT
	| PRINT-STMT
	;
PRINT-STMT	: print_num EXP		{ printf("%d\n", $2); }
		| print_bool EXP	{ 
						if($2 == 0) printf("#f\n");
						else printf("#t\n");
					}
		;
EXP	: bool_val
	| number	{ fprintf(stderr, "[number=%d]\n", $1); }
	| VARIABLE
	| NUM-OP	{ $$ = $1; }
	| LOGICAL-OP
	| FUN-EXP
	| FUN-CALL
	| IF-EXP
	;
NUM-OP	: PLUS		{ $$ = $1; }
	| MINUS		{ $$ = $1; }
	| MULTIPLY	{ $$ = $1; }
	| DIVIDE	{ $$ = $1; }
	| MODULUS	{ $$ = $1; }
	| GREATER
	| SMALLER
	| EQUAL
	;
PLUS	: '(' '+' EXP PLUS-EXPS ')'	{ fprintf(stderr, "[PLUS<-EXP PLUS-EXPS=%d+%d]\n", $3, $4); $$ = $3 + $4; }

	;	 
PLUS-EXPS 	: EXP			{ fprintf(stderr, "[PLUS-EXPS<-EXP=%d\n", $1); $$ = $1; }
		| EXP PLUS-EXPS		{ fprintf(stderr, "[PLUS-EXPS<-EXP PLUS-EXPS=%d+%d\n", $1, $2); $$ = $1 + $2; }

		;
MINUS	: '(' '-' EXP EXP ')'		{ fprintf(stderr, "[MINUS<-EXP-EXP=%d-%d]\n", $3, $4); $$ = $3 - $4; }
	;
MULTIPLY	: '(' '*' EXP MULTI-EXPS ')'	{ $$ = $3 * $4; }
		;
MULTI-EXPS	: EXP				{ $$ = $1; }
		| EXP MULTI-EXPS		{ $$ = $1 * $2; }
		;
DIVIDE	: '(' '/' EXP EXP ')'	{ $$ = $3 / $4; }
	;
MODULUS	: '(' mod EXP EXP ')'	{ $$ = $3 % $4; }
	;
GREATER	: '(' '>' EXP EXP ')'
	;
SMALLER : '(' '<' EXP EXP ')'
	;
EQUAL	: '(' '=' EXP EQUAL-EXPS ')'
	;
EQUAL-EXPS	: EXP
		| EXP EQUAL-EXPS
		;
LOGICAL-OP	: AND-OP
		| OR-OP
		| NOT-OP
		;
AND-OP	: '(' and EXP AND-EXPS ')'
	;
AND-EXPS: EXP
	| EXP AND-EXPS
	;
OR-OP	: '(' or EXP OR-EXPS ')'
	;
OR-EXPS	: EXP
	| EXP OR-EXPS
	;
NOT-OP	: '(' not EXP ')'
	;
DEF-STMT: '(' define VARIABLE EXP ')'
	;
VARIABLE: id
	;
FUN-EXP	: '(' fun FUN-IDs FUN-BODY ')'
	;
FUN-IDs	: '(' id ')'
	| '(' ')'
	;
FUN-BODY: EXP
	;
FUN-CALL: '(' FUN-EXP ')'
	| '(' FUN-EXP PARAM ')'
	| '(' FUN-NAME ')'
	| '(' FUN-NAME PARAM ')'
	;
PARAM	: EXP
	;
FUN-NAME: id
	;
IF-EXP	: '(' _if TEST-EXP THEN-EXP ELSE-EXP ')'
	;
TEST-EXP: EXP
	;
THEN-EXP: EXP
	;
ELSE-EXP: EXP
	;

%%
void yyerror(const char *message) {
    fprintf(stderr, "%s\n", message);
}

int main(int argc, char * argv[]) {
	yyparse();
	return(0);
}
