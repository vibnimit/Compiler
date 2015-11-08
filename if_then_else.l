%{
	#include "y.tab.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
%}

ALPHA [A-Za-z]
DIGIT [0-9]
%%

if				{return IF;}
then				{return THEN;}
else    	        	return ELSE;
print				return PRINT;
for				return FOR;
int				return INTEGER;
char				return CHARACTER;
float				return FLOAT;
double				return DOUBLE;
while				return WHILE;
do				return DO;
"{"				return OPENBR;
"}"				return CLOSEBR;
{ALPHA}({ALPHA}|{DIGIT})*    	return ID;
{DIGIT}+             		{yylval.num=atoi(yytext); return NUM;}
[ \t]                 		;
\n                		yyterminate();
"<="         			return LE;
">="         			return GE;
"=="         			return EQ;
"!="          			return NE;
"||"            		return OR;
"&&"         			return AND;
.				{return yytext[0];}
%%
