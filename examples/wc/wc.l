%{
	#include <unistd.h>
	// yet another wc impl
	int nchar = 0;
	int nword = 0;
	int nline = 0;
%}
%%
\n { ++nline; ++nchar; }
[^ \t\n]+ { ++nword; nchar += yyleng; }
. { ++nchar; }
%%

int main(int argc, char *argv[]) {
	int* keys[3] = {NULL, NULL, NULL};
	int spec = 0;
	int opt;
	while ((opt = getopt(argc, argv, "cwl")) != -1) {
		switch (opt) {
			case 'c':
				spec = 1;
				keys[0] = &nchar;
				break;
			case 'w':
				spec = 1;
				keys[1] = &nword;
				break;
			case 'l':
				spec = 1;
				keys[2] = &nline;
				break;
			default: /* '?' */
				fprintf(stderr, "Usage: %s [-c|w|l] file\n", argv[0]);
				exit(EXIT_FAILURE);
		}
	}

	yylex();
	if (spec) {
		int i;
		for (i = 0; i < 3; ++i) {
			if (keys[i])
				printf("\t%d", *keys[i]);
		}
	} else {
		printf("\t%d\t%d\t%d\n", nline, nword, nchar);
	}

	return 0;
}

int yywrap() {
	return 1;
}
