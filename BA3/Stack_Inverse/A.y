%{
#include<stdio.h>
#include<string.h>
void yyerror(const char *message);
void push(int);
void pop();
int top();
void opr(int);
void swap();
%}
%token INTEGER
%token add sub mul mod inc dec inverse print
%%
stmt	: expr stmt
	|
	;
expr 	: INTEGER	{ push($1); }
	| inc 		{ opr(1); }
	| dec 		{ opr(2); }
	| inverse 	{ swap(); }
	| print		{ printf("%d\n", top()); }
      ;
%%
void yyerror(const char * message)
{
	fprintf(stderr, "%s\n", message);
}

#define SIZE 100
int stack[SIZE];
int tot = -1;
void push(int x) {
	if(tot + 1 == SIZE) printf("\nOverflow!!\n"); // 
	else stack[++tot] = x;
}

void pop() {
	if(tot == -1) printf("\nno element to pop...\n");
	else tot--;
}

int top() { return stack[tot]; }

int ok = 1;

void opr(int opr) { // ++, --
	if(tot == -1) { ok = 0; return; }
	int a = top(); pop();
	if(opr == 1) a++;
	else a--;
	push(a);
}

void swap() {
	int a = top(); pop();
	int b = top(); pop();
	push(a);
	push(b);
}
	

int main(int argc, char * argv[]) {
	yyparse();
	return(0);
}
