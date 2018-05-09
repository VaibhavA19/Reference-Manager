%{
	#include<stdlib.h>
	#include<stdio.h>
	#include<string.h>
	#include<ctype.h>
	int yyerror(char *s);
	int yylex();
	int year , an = 0 ;
	char title[300] , vol[10] , pr[30] , author[10][50] , location[20] , publisher[40] ;
	extern FILE * yyin ;
	void getYear(char *s);
	void getVol(char *s);
	void getPR(char *s);
	void addAuth(char *s);
	void getLOCP(char *s);
	void printMLA();
%}
%token AUTH VOL DATE PR TITLE LOCP
%start stat
%union{
	char val[300];
}
%%
stat : author TITLE VOL PR LOCP{ getYear($<val>2); getVol($<val>3) ; getPR($<val>4); getLOCP($<val>5); };
author : AUTH author {addAuth($<val>1);} |  ;
%%
int yyerror(char *s){
	printf("error :%s",s);
	exit(0);
}
void addAuth(char *s){
	strcpy(author[an++],s);
}
void getPR(char *s){
	strcpy(pr,s);
}
void getVol(char *s){
	strcpy(vol,s);
}
void getLOCP(char *s){
	int i = 0 ;
	while(s[i] != '\0' && s[i] != ':') i++;
	char *t = &s[i+1];
	s[i]='\0';
	strcpy(location,s);
	strcpy(publisher,t);
}
void getYear(char *t){
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
	//printf("index %d",index);
	if(index != -1){
		temp  = &t[index+1];
		strcpy(title,temp);
		//printf("tit : %s",title);
	}
	//printf("%d",number);
	year = number;
}
void printMLA(){
	int i ;
	for(i = 0 ;  i < an - 1; i++){
		printf(" %s," , author[i]);
	}
	if(an != 1){
		printf(" and %s."  , author[i]);
	}else{
		printf(" %s."  , author[i]);
	}
	printf("\"%s\"",title);
	printf(", Vol. %s",vol);
	printf(", %d",year) ;
	printf(", %s",pr);
	printf(" , %s",publisher);
	printf(" , %s",location);	
}
int main(int argc , char * argv[]){
	printf("MLA\n");
	//yyin = fopen("C:\\Users\\ITCONTROLLER\\Desktop\\ooo.txt", "r");
	yyin = fopen(argv[1],"r") ;
	if(yyin == NULL){
		printf("invalid file path");
		return 0 ;
	}
	yyparse();
	printMLA();
	return 0 ;
}