%{
#include "y.tab.h"
%}
%x DEF
%%
^"push " { BEGIN DEF; }
<DEF>[0-9]+	{ 
			yylval = atoi(yytext);
			return INTEGER; 
		}
<DEF>\n	{ BEGIN INITIAL; }
^(inverse)$	{return inverse;}
^(inc)$	{return inc;}
^(dec)$	{return dec;}
"$"	{return print; }
.
%%
