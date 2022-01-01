%{
#include<stdio.h>
#include<string.h>
void yyerror(const char *message);
void push(int);
void pop();
int top();
int isempty();
void opr(int);
void opr2(int);
%}
%union{
	int ival;
};
%token <ival> INTEGER
%token add sub mul mod inc dec 
%%
stmt	: expr stmt
	|
	;
expr 	: INTEGER	{ push($1); }
	| add { opr(1); }
	| sub { opr(2); }
	| mul { opr(3); }
	| mod { opr(4); }
	| inc { opr2(1); }
	| dec { opr2(2); }
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
	if(tot + 1 == SIZE) printf("\nOverflow!!\n");
	else stack[++tot] = x;
}

void pop() {
	if(tot == -1) printf("\nno element to pop...\n");
	else tot--;
}

int top() {
	return stack[tot];	
}

int isempty() {
	return (tot == -1);
}

int ok = 1;

void opr(int opr) { // binary operator
	if(tot < 1) { ok = 0; return; }
	int a = top(); pop(); 
	int b = top(); pop();
	switch(opr) {
		case 1: a = a + b; break;
		case 2: a = a - b; break;
		case 3: a = a * b; break;
		case 4: a = a % b; break;
		default: break;
	}
	push(a);
}

void opr2(int opr) {
	if(tot == -1) { ok = 0; return; }
	int a = top(); pop();
	if(opr == 1) a++;
	else a--;
	push(a);
}
	

int main(int argc, char * argv[]) {
	yyparse();
	if(tot != 0 || ok == 0) printf("Invalid format\n");
	else printf("%d\n", top());
	return(0);
}
