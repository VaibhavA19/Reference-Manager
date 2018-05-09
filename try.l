%{
	#include<stdio.h>
	#include<ctype.h>
	#include<string.h>
	int c1 = 0 , c2 = 0 , c3 = 0  , c4 = 0 , title = 0 , author = 0 ;
	int getYear(char *t);
	char  authors[10][20] ;
	char titles[200] ;
	int year ;
	char pagerank[20] ;
	int vol  ;
	void getVol(char *s);
	char locp[100];
%}
%%
[.," "][^.]*:[^.]*[,.] { strcpy(locp,yytext);printf("location:publisher %s",yytext);}

(Vol|vol)(\." "?[0-9]+)  {getVol(yytext);}
[0-9]+/(" "?\," "?[0-9]+\-[0-9]+) { vol = atoi(yytext) ;printf("VOL %s",yytext);}

\((1[0-9]{3}|20[012][0-9]\)) {char *t = &yytext[1] ;  t[strlen(t)-1]='\0' ;year = atoi(t); printf("date : %d ",year);}

[0-9]+\-[0-9]+ { strcpy(pagerank,yytext) ;}

([A-Z][A-Za-z]+" "){2,4}/(" "?,|\.|" "and|," "&) { strcpy(authors[author++],yytext);}
[A-Z][A-Za-z]+," "[A-Z]\.+ { strcpy(authors[author++],yytext);}
([A-Z][A-Za-z]+," "([A-Z]\.)+)/(" "\() { strcpy(authors[author++],yytext);}

\“.*\” { strcpy(titles,yytext);printf("title matcheddd:%d",++title);}
\([0-9]{4}\)\.[^.]*/\. { printf("title :%d %s",++title,yytext);getYear(yytext);} 
\((" ")?[0-9]{4}(" ")?,(" ")?[A-Za-z]+(" ")?[0-9][0-9](" ")?\)\.[^.]*/\. { printf("title :%d",++title);}
\".*\" { printf("title :%d",++title);}


. {} ;
%%
int getYear(char * t){
	int i = 0 ; 
	int number = 0 ;
	int index = -1 ;
	char * temp ;
	while(t != 0 && t[i] != '\0'){
		if(isdigit(t[i])){
			number =  number * 10 + (t[i] -48) ;
			index = i ;
		}else if(t[i] == ')'){
			index = i ;
		}
		i++;
	}
	printf("index %d",index);
	if(index != -1){
		temp  = &t[index+1];
		strcpy(titles,temp);
		printf("tit : %s",titles);
	}
	printf("%d",number);
	year = number;
	return number ;
}
void getVol(char * t){
	int i = 0 ; 
	int number = 0 ;
	char * temp ;
	while(t != 0 && t[i] != '\0'){
		if(isdigit(t[i])){
			number =  number * 10 + (t[i] -48) ;
		}
		i++;
	}
	vol = number ;
}
int yywrap(){
	return 1 ;
}
int main(int argc  , char  *argv[]){
	FILE *ip = fopen(argv[1],"r");
	yyin = ip ;
	yylex();
	int i ;
	FILE *fp = fopen(argv[2],"w");
	for(i = 0 ; i < author-1; i++){
		fprintf(fp ," %s,",authors[i]);
	}
	fprintf(fp ," & %s",authors[i]);
	fprintf(fp ,"(%d)%s., %d, %s. %s",year , titles ,vol ,pagerank,locp);
}