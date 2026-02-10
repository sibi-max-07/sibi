%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

/* PHASE 3 – SYMBOL TABLE */
char sym[50][20];
int symCount = 0;

int exists(char *s){
    for(int i=0;i<symCount;i++)
        if(strcmp(sym[i],s)==0) return 1;
    return 0;
}

void add(char *s){
    if(!exists(s))
        strcpy(sym[symCount++], s);
}

/* PHASE 4 – TAC */
char tac[100][50];
int tc = 0;
int temp = 0;

char* newtemp(){
    char *t = (char*)malloc(10);
    sprintf(t,"t%d",++temp);
    return t;
}

void emit(char *s){
    strcpy(tac[tc++], s);
}
%}

%union{
    int num;
    char *id;
    char *place;
}

%token <id> ID
%token <num> NUMBER
%token ASSIGN SEMI
%token PLUS MINUS MUL DIV
%token LPAREN RPAREN

%type <place> expr term factor

%left PLUS MINUS
%left MUL DIV

%%

program:
      program stmt
    | /* empty */
    ;

stmt:
      ID ASSIGN expr SEMI
      {
        add($1);   /* PHASE 3 */
        char line[50];
        sprintf(line,"%s = %s",$1,$3);
        emit(line); /* PHASE 4 */
      }
    ;

expr:
      expr PLUS term
      {
        char *t=newtemp();
        char line[50];
        sprintf(line,"%s = %s + %s",t,$1,$3);
        emit(line);
        $$=t;
      }
    | term { $$=$1; }
    ;

term:
      term MUL factor
      {
        char *t=newtemp();
        char line[50];
        sprintf(line,"%s = %s * %s",t,$1,$3);
        emit(line);
        $$=t;
      }
    | factor { $$=$1; }
    ;

factor:
      NUMBER
      {
        char *v=(char*)malloc(10);
        sprintf(v,"%d",$1);
        $$=v;
      }
    | ID
      {
        if(!exists($1)){
            printf("❌ PHASE 3 ERROR: %s not declared\n",$1);
            exit(0);
        }
        $$=$1;
      }
    | LPAREN expr RPAREN { $$=$2; }
    ;

%%

void yyerror(const char *s){
    printf("❌ PHASE 2 ERROR: Syntax Error\n");
}

int main(){
    printf("==============================\n");
    printf("PHASE 1: LEXICAL ANALYSIS\n");
    printf("==============================\n");

    printf("\n==============================\n");
    printf("PHASE 2: SYNTAX ANALYSIS\n");
    printf("==============================\n");

    yyparse();   // Phase 1 & 2 actually execute here

    printf("\n==============================\n");
    printf("PHASE 3: SYMBOL TABLE\n");
    printf("==============================\n");
    for(int i=0;i<symCount;i++)
        printf("%s\n", sym[i]);

    printf("\n==============================\n");
    printf("PHASE 4: THREE ADDRESS CODE\n");
    printf("==============================\n");
    for(int i=0;i<tc;i++)
        printf("%s\n", tac[i]);

    printf("\n==============================\n");
    printf("PHASE 5: CODE OPTIMIZATION\n");
    printf("==============================\n");
    printf("Constant folding (theory)\n");

    printf("\n==============================\n");
    printf("PHASE 6: TARGET CODE\n");
    printf("==============================\n");
    for(int i=0;i<tc;i++)
        printf("MOV %s\n", tac[i]);

    printf("\n🎉 ALL 6 PHASES COMPLETED\n");
    return 0;
}
