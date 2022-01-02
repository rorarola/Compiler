%{
#include<stdio.h>
#include <stdlib.h>
#include<string.h>
void yyerror(const char *message);
void print_err(int);
%}
%code requires {
	typedef struct {
		int r, c;
	} Matrix;
}
%union {
	int ival;
	Matrix matrix;
}
%token TRANS
%token <ival> INTEGER
%left <ival> '+' '-'
%left <ival> '*'
%nonassoc BRAC
%type <matrix> expr
%%
expr 	: '[' INTEGER ',' INTEGER ']' { $$.r = $2; $$.c = $4; }
	| expr TRANS 	{ $$ = (Matrix){$1.c, $1.r}; }
	| expr '+' expr	{ 
				if($1.r != $3.r || $1.c != $3.c) print_err($2); 
				$$ = $1; 
			}
	| expr '-' expr { 
				if($1.r != $3.r || $1.c != $3.c) print_err($2); 
				$$ = $1; 
			}
	| expr '*' expr { 
				if($1.c != $3.r) print_err($2); 
				$$ = $1; 
			}
	| '(' expr ')' %prec BRAC { $$ = $2; }
	;
%%

void print_err(int x) {
	printf("Semantic error on col %d\n", x);
	exit(0);
}

void yyerror(const char *message) {
    fprintf(stderr, "%s\n", message);
}

int main(int argc, char * argv[]) {
	yyparse();
	printf("Accepted\n");
	return(0);
}
