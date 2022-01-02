%{
#include "y.tab.h"
%}
separator	[\t\n\r ]
digit		[0-9]
letter 		[a-z]
%%
(0|[1-9]{digit}*|-[1-9]{digit}*)	{ printf("number = %s", yytext); }
{letter}({letter}|{digit}|-)*		{ printf("ID = %s", yytext); }
("#t"|"#f")				{ printf("bool-val = %s", yytext); }

%%
