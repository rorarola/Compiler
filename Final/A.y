%{
#include<stdio.h>
#include <stdlib.h>
#include<string.h>
void yyerror(const char *message);
int num_same = 1, bool_and = 1, bool_or = 0;
int id_size = 0;
%}
%code requires {
	typedef struct Data {
		int type; // 0: number, 1: boolean, 2: function
		int val;
	} Data;
	typedef struct ID {
		char id[500];
		Data data;
	} ID;
	ID ids[105];
}
%union {
	int integer;
	char string[500];
	struct Data data; 
}
%token <integer> bool_val and or not number fun _if
%token <string> id;
%token print_num print_bool mod define
%left '+' '-'
%left '*'
%type <string> VARIABLE
%type <integer> EXP NUM-OP PLUS PLUS-EXPS MINUS MULTIPLY MULTI-EXPS DIVIDE MODULUS GREATER SMALLER EQUAL EQUAL-EXPS LOGICAL-OP AND-OP AND-EXPS OR-OP OR-EXPS NOT-OP IF-EXP TEST-EXP THEN-EXP ELSE-EXP 
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
	| VARIABLE	{ for(int i = 0; i < id_size; i++) if(strcmp(ids[i].id, $1) == 0) $$ = ids[i].data.val; }
	| NUM-OP	{ $$ = $1; }
	| LOGICAL-OP	{ $$ = $1; }
	| FUN-EXP
	| FUN-CALL
	| IF-EXP	{ $$ = $1; }
	;
NUM-OP	: PLUS		{ $$ = $1; }
	| MINUS		{ $$ = $1; }
	| MULTIPLY	{ $$ = $1; }
	| DIVIDE	{ $$ = $1; }
	| MODULUS	{ $$ = $1; }
	| GREATER	{ $$ = $1; }
	| SMALLER	{ $$ = $1; }
	| EQUAL		{ $$ = $1; }
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
GREATER	: '(' '>' EXP EXP ')'	{ $$ = ($3 > $4); }
	;
SMALLER : '(' '<' EXP EXP ')'	{ $$ = ($3 < $4); }
	;
EQUAL	: '(' '=' EXP EQUAL-EXPS ')'	{ fprintf(stderr, "[EQUAL<-EXP EQUAL-EXPS=%d=%d]\n", $3, $4); $$ = num_same && ($3 == $4); num_same = 1;}
	;
EQUAL-EXPS	: EXP			{ $$ = $1; }
		| EXP EQUAL-EXPS	{ num_same &= ($1 == $2); $$ = $1; }
		;
LOGICAL-OP	: AND-OP	{ $$ = $1; }
		| OR-OP		{ $$ = $1; }
		| NOT-OP	{ $$ = $1; }
		;
AND-OP	: '(' and EXP AND-EXPS ')'	{ $$ = bool_and && ($3 == $4); bool_and = 1;}
	;
AND-EXPS: EXP				{ $$ = $1; }
	| EXP AND-EXPS			{ bool_and &= ($1 == $2); $$ = $1; }
	;
OR-OP	: '(' or EXP OR-EXPS ')'	{ $$ = bool_or || ($3|$4); bool_or = 0; }
	;
OR-EXPS	: EXP				{ $$ = $1; }
	| EXP OR-EXPS			{ bool_or |= ($1|$2); $$ = 0; }
	;
NOT-OP	: '(' not EXP ')'		{ $$ = !$3; }
	;
DEF-STMT: '(' define VARIABLE EXP ')'	{ strcpy(ids[id_size].id, $3); ids[id_size++].data = (Data){0, $4}; }
	;
VARIABLE: id				{ strcpy($$, $1); }
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
IF-EXP	: '(' _if TEST-EXP THEN-EXP ELSE-EXP ')' { $$ = ($3 ? $4 : $5); }	
	;
TEST-EXP: EXP	{ $$ = $1; }
	;
THEN-EXP: EXP	{ $$ = $1; }
	;
ELSE-EXP: EXP	{ $$ = $1; }
	;

%%
void yyerror(const char *message) {
	printf("syntax error\n");
}

int main(int argc, char * argv[]) {
	yyparse();
	return(0);
}
