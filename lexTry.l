%{
	#include "yta.tab.h"
	#include<string.h>
	int debug  = 0 ; 
%}
%%

[.," "][^.]*:[^.]*[,.] { strcpy(yylval.val,yytext);return LOCP ;}

(Vol|vol)(\." "?[0-9]+)  {}
[0-9]+/(" "?\," "?[0-9]+\-[0-9]+) { strcpy(yylval.val,yytext); return VOL ;}

\((1[0-9]{3}|20[012][0-9]\)) { strcpy(yylval.val,yytext);if(debug){printf("date :%s",yytext);} return DATE ; }

[0-9]+\-[0-9]+ { strcpy(yylval.val,yytext); if(debug){printf("pr :%s",yytext);}return PR ; }

([A-Z][A-Za-z]+" "){2,4}/(" "?,|\.|" "and|," "&) { strcpy(yylval.val,yytext); if(debug){printf("auth1 :%s",yytext);} return AUTH ;}
[A-Z][A-Za-z]+," "[A-Z]\.+ { strcpy(yylval.val,yytext); if(debug) {printf("auth2 :%s",yytext);} return AUTH ; }
([A-Z][A-Za-z]+," "([A-Z]\.)+)/(" "\() {strcpy(yylval.val,yytext); if(debug){printf("auth3 :%s",yytext);} return AUTH ;}

\([0-9]{4}\)\.[^.]*/\. { strcpy(yylval.val,yytext); if(debug){printf("title :%s",yytext);} return TITLE ;} 
\((" ")?[0-9]{4}(" ")?,(" ")?[A-Za-z]+(" ")?[0-9][0-9](" ")?\)\.[^.]*/\. { strcpy(yylval.val,yytext); if(debug){printf("title :%s",yytext);}return TITLE ;}
\".*\" { return TITLE ;}
\“.*\” { return TITLE ;}

. { if(debug){printf(".... :%s",yytext);}} 
%%
int yywrap(){
	return 1 ;
}