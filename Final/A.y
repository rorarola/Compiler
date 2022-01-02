%{
#include<stdio.h>
#include <stdlib.h>
#include<string.h>
void yyerror(const char *message);
%}
%token bool-val and or mod not id print-num print-bool number define fun _if
%%
PROGRAM	: STMT PROGRAM
	|
	;
STMT	: EXP
	| DEF-STMT
	| PRINT-STMT
	;
PRINT-STMT	: print-num EXP
		| print-bool EXP
		;
EXP	: bool-val
	| number
	| VARIABLE
	| NUM-OP
	| LOGICAL-OP
	| FUN-EXP
	| FUN-CALL
	| IF-EXP
	;
NUM-OP	: PLUS
	| MINUS
	| MULTIPLY
	| DIVIDE
	| MODULUS
	| GREATER
	| SMALLER
	| EQUAL
	;
PLUS	: '(' '+' EXP PLUS-EXPS ')'
	;	 
PLUS-EXPS 	: EXP
		| EXP PLUS-EXPS
		;
MINUS	: '(' '-' EXP EXP ')'
	;
MULTIPLY	: '(' '*' EXP MULTI-EXPS ')'
		;
MULTI-EXPS	: EXP
		| EXP MULTI-EXPS
		;
DIVIDE	: '(' '/' EXP EXP ')'
	;
MODULUS	: '(' mod EXP EXP ')'
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
	printf("Accepted\n");
	return(0);
}
