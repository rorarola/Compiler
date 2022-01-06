%{
#include "y.tab.h"
#include <stdio.h>
%}
separator	[\t\n\r ]
digit		[0-9]
letter 		[a-z]
%%
"print-num"				{ return print_num; }
"print-bool"				{ return print_bool; }
"mod"					{ return mod; }
"or"					{ return or; }
"and"					{ return and; }
"not"					{ return not; }
"define"				{ return define; }
"if"					{ return _if; }
(0|[1-9]{digit}*|-[1-9]{digit}*)	{ yylval.integer = atoi(yytext); return number; }
{letter}({letter}|{digit}|-)*		{ strcpy(yylval.string, yytext); return id; }
("#t"|"#f")				{ 
						yylval.integer = (strcmp(yytext, "#t") == 0)? 1 : 0; 
						return bool_val; 
					}
[+*//()<>=-]				{ return *yytext; }
.
[\n]
%%
