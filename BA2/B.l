%{
#include <stdio.h>
unsigned int level = 0;
unsigned int checked = 0;
%}
%x DEF1
%x DEF3
%x DEF4
%%
[#]{1,6}[ ]		{ BEGIN DEF1; level = yyleng - 1; }
<DEF1>[\r]?[\n]	{ BEGIN INITIAL; }
<DEF1>[^\r\n]*	{ printf("<h%d>%s</h%d>\n", level, yytext, level); }

"---"		{ printf("<hr />\n"); }

[!] { BEGIN DEF3; }
<DEF3>[[][a-zA-Z0-9| ]+[\]] {
	printf("<img alt=\"");
	for(int i = 1; i < yyleng-1; i++) printf("%c", yytext[i]);
	}
<DEF3>[(][^)\r\n\t]+[)] { 
	printf("\" src=\"");
	for(int i = 1; i < yyleng-1; i++) printf("%c", yytext[i]);
	printf("\">\n");
	}
<DEF3>[\r]?[\n]	{ BEGIN INITIAL; }

"- [X] "  { BEGIN DEF4; checked = 1;}
"- [x] " { BEGIN DEF4; checked = 1; }
"- [ ] " { BEGIN DEF4; checked = 0; }
<DEF4>[^\r\n]+ {
	if(checked) {
		printf("<p>\n\t<input checked=\"checked\" type=\"checkbox\" /> %s\n</p>\n", yytext); 
	} else {
		printf("<p>\n\t<input type=\"checkbox\" /> %s\n</p>\n", yytext); 
	}
	}
<DEF4>[\r]?[\n]	{ BEGIN INITIAL; }

%%
int main(void) {
		yylex();
		return(0);
}
