%{
	int lino;
%}

%%
^.*\n { printf("%4d\t%s", ++lino, yytext); }
%%
