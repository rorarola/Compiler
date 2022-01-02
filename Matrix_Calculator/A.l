%{
#include "y.tab.h"
int pos = 0;
%}
%%
[0-9]+	{ 
		pos += yyleng;
		yylval.ival = atoi(yytext);
		return INTEGER;
	}
"^T"	{
		pos += yyleng;
		return TRANS;
	}
		
[()[\]*+-,]	{
		pos += yyleng;
		yylval.ival = pos;
		return *yytext;
	}
. 	pos += yyleng;

%%
