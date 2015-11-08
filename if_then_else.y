%{
extern char* yytext;
#include "lex.yy.c"
#include<ctype.h>
char st[100][10];
int top=0;
char i_[2]="0";
char temp[2]="t";

int label[20];
int lnum=0,no=0;
int ltop=0;

%}

//Remember variable no has to be removed later on;

%union {char str[100]; int num;}
%token ID IF THEN ELSE PRINT FOR LE EQ GE NE OR AND INTEGER CHARACTER FLOAT DOUBLE WHILE DO OPENBR CLOSEBR
%token <num> NUM
%token <str> STRING
%right '='
%left  OR AND
%left '+' '-'
%left '>' '<' LE GE EQ NE
%left '!' '*' '/' '%' 
%left UMINUS
%%

S : 	IF '(' E ')'{lab1();} 
	THEN P EL
  |	PRINT EXP ';'
  |	DATATYPE V PUNCT {printf("good\n");}	
  |	FOR'('E{lab4();}';'E{lab5();}';' E{lab6();}')'P{lab7();}
  |	WHILE'(' {lab8();} E ')'{lab9();} P {lab10();}
  |	DO {lab8();} E ';' WHILE '(' E ')' ';'{lab11();}
  ;

PUNCT   : ','V PUNCT
	| ';'
	;

DATATYPE : INTEGER|CHARACTER|FLOAT|DOUBLE
   ;

EL :	ELSE {lab2();}P{lab3();}
   |{lab3();}
   ;

P  : 	S P
   | 	E';' P
   |  	
   ;

E :V '='{push();} E{codegen_assign();}
  | E '+'{push();} E{codegen();}
  | E '-'{push();} E{codegen();}
  | E '*'{push();} E{codegen();}
  | E '/'{push();} E{codegen();}
  | E '<'{push();} E{codegen();}
  | E '>'{push();} E{codegen();}
  | E LE{push();} E{codegen();}
  | E GE{push();} E{codegen();}
  | E EQ{push();} E{codegen();}
  | E NE{push();} E{codegen();}
  | E OR{push();} E{codegen();}
  | E AND{push();} E{codegen();}
  | E '%'{push();} E{codegen();}
  | E'!'{push();} E{codegen();}
  | '(' E ')'
  | '-'{push();} E{codegen_umin();} %prec UMINUS
  | V
  | NUM{push();}
  |
  ;
V : ID {push();}
  ;
EXP: STRING{printf("Printing %s %s\n",yytext,$1);}	|ID	{printf("Printing %s\n",yytext);}		
   ;
%%



main()
 {
 printf("Enter the expression : ");
 yyparse();
 }
	
push()
 {
  strcpy(st[++top],yytext);
 }

print()
 {
printf("%s \n",yytext);
 
 }

codegen()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
  printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
  top-=2;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_umin()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
 printf("%s = -%s\n",temp,st[top]);
 top--;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_assign()
 {
 printf("%s = %s\n",st[top-2],st[top]);
 top-=2;
 }

lab1()
{
lnum+=no;
 printf("if %s \ngoto L%d\n",st[top],lnum);
 lnum++;
printf("goto L%d\n",lnum);
printf("L%d: ",lnum-1);
 label[++ltop]=lnum;
lnum++;
no++;
}

lab2(){
int x;
x=label[ltop--];
printf("goto L%d\n",lnum);
printf("L%d: ",x);
label[++ltop]=lnum++;
}
lab3()
{
int y;
y=label[ltop--];
printf("L%d:\n",y);

}
lab4()
{
	no++;
    printf("L%d: ",lnum++);
}

lab5()
{
    printf("if %s\ngoto L%d\n",st[top],lnum++);
    label[++ltop]=lnum;
    printf("goto L%d\n",lnum++);
    label[++ltop]=lnum;
    label[++ltop]=lnum-2;
    printf("L%d: ",lnum++);
}

lab6()
{
    int x;
    x=label[ltop--];
    printf("goto L%d \n",x-1);
    printf("L%d: ",x);
   
}

lab7()
{
    int x;
    x=label[ltop--];
    printf("goto L%d \n",x);   
	printf("L%d:\n",label[ltop--]);
	
}

lab8()
{
	no++;
    printf("L%d: ",lnum);
    label[++ltop]=lnum++;	
}

lab9()
{
 printf("if %s \ngoto L%d\n",st[top],lnum);
 lnum++;
printf("goto L%d\n",lnum);
printf("L%d: ",lnum-1);
 label[++ltop]=lnum;
lnum++;
no++;
}

lab10()
{
    int x;
    x=label[ltop--];
    printf("goto L%d \n",label[ltop--]);
    printf("L%d: ",x);
   
}

lab11()
{
 printf("if %s \ngoto L%d\n",st[top],label[ltop--]);
printf("goto L%d\n",lnum);
printf("L%d: ",lnum);
 label[++ltop]=lnum;
no++;
}
