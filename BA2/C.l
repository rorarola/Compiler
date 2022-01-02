%{
#include <stdio.h>
#include <string.h>
unsigned int level = 0;
unsigned int checked = 0;
unsigned int inList = 0;
unsigned int inQuote = 0;
char linkName[500];
%}
%x DEF1
%x DEF3
%x DEF4
%x DEF6
%x DEF7
%%
[#]{1,6}[ ]		{ BEGIN DEF1; level = yyleng - 1; }
<DEF1>[\r]?[\n]	{ BEGIN INITIAL; }
<DEF1>[^\r\n]*	{ printf("<h%d>%s</h%d>\n", level, yytext, level); }

"---"		{
	if(inList) {
		printf("</ul>\n");
		inList = 0;
	}
	if(inQuote) {
		printf("</blockquote>\n");
		inQuote = 0;
	}
	 printf("<hr />\n"); 
	 }

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
"- [x] "  { BEGIN DEF4; checked = 1; }
"- [ ] "  { BEGIN DEF4; checked = 0; }
<DEF4>[^\r\n]+ {
	if(checked) {
		printf("<p>\n\t<input checked=\"checked\" type=\"checkbox\" /> %s\n</p>\n", yytext); 
	} else {
		printf("<p>\n\t<input type=\"checkbox\" /> %s\n</p>\n", yytext); 
	}
	}
<DEF4>[\r]?[\n]	{ BEGIN INITIAL; }

^[*][ ][^\n]* {
	if(inList == 0) {
		printf("<ul>\n");
		inList = 1;
	}
	printf("\t<li>%s</li>", &yytext[2]);

}


[[]	{ BEGIN DEF6; }
<DEF6>[a-zA-Z0-9| ]*[\]] {
	memset(linkName, 0, sizeof(linkName));
	for(int i = 0; i < yyleng-1; i++) linkName[i] = yytext[i];
}
<DEF6>[(][^)\r\n\t]+[)] { 
	printf("<a href=\"");
	for(int i = 1; i < yyleng-1; i++) printf("%c", yytext[i]);
	printf("\">\n");
	printf("\t<span>%s</span>\n</a>\n", linkName);
}
<DEF6>[\r]?[\n]	{ BEGIN INITIAL; }

^[>][ ] { 
	BEGIN DEF7; 
	if(inQuote == 0) printf("<blockquote>\n"); 
	inQuote = 1;
}
<DEF7>[^\r\n*]* { printf("%s", yytext); }
<DEF7>[*]{2}[a-zA-Z0-9| ]*[*]{2} {
	printf("<strong>");
	for(int i = 2; i < yyleng-2; i++) printf("%c", yytext[i]);
	printf("</strong>");
}
<DEF7>\n { BEGIN INITIAL; printf("\n"); }


%%
int main(void) {
		yylex();
		return(0);
}
