%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%

"="     { printf("PHASE 1 TOKEN: ASSIGN\n"); return ASSIGN; }
";"     { printf("PHASE 1 TOKEN: SEMICOLON\n"); return SEMI; }

"+"     { printf("PHASE 1 TOKEN: PLUS\n"); return PLUS; }
"-"     { printf("PHASE 1 TOKEN: MINUS\n"); return MINUS; }
"*"     { printf("PHASE 1 TOKEN: MUL\n"); return MUL; }
"/"     { printf("PHASE 1 TOKEN: DIV\n"); return DIV; }

"("     { return LPAREN; }
")"     { return RPAREN; }

{DIGIT}+ {
            printf("PHASE 1 TOKEN: NUMBER (%s)\n", yytext);
            yylval.num = atoi(yytext);
            return NUMBER;
         }

{ID}    {
            printf("PHASE 1 TOKEN: ID (%s)\n", yytext);
            yylval.id = strdup(yytext);
            return ID;
        }

[ \t\n]+   ;   // ignore spaces

.       {
            printf("❌ PHASE 1 ERROR: Invalid token %s\n", yytext);
            exit(0);
        }

%%

int yywrap(){
    return 1;
}
