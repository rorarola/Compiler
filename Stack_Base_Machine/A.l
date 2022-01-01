%{
#include "y.tab.h"
%}
%x DEF
%%
^"load " { BEGIN DEF; }
<DEF>[0-9]+	{ 
			yylval.ival = atoi(yytext);
			return INTEGER; 
		}
<DEF>\n	{ BEGIN INITIAL; }
^(add)$	{return add;}
^(sub)$	{return sub;}
^(mul)$	{return mul;}
^(mod)$	{return mod;}
^(inc)$	{return inc;}
^(dec)$	{return dec;}
%%
