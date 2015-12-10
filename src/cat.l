%{

#include <stdio.h>
#include <err.h>
#include <errno.h>

/********** globals ************/
static char **fpath;
static int lino = -1;

/********** functions **********/
static FILE* next_file();
static void usage(FILE *fp, const char *prog);
static int has_next_file();

%}

%%

^.|\n {
	if (lino >= 0) {
		printf("%8d  ", ++lino);
	}
	ECHO;
}

<<EOF>> {
	if (has_next_file())
		yyin = next_file();
	else
		yyterminate();
}

%%

int main(int argc, char *argv[]) {
	int opt;
	while ((opt = getopt(argc, argv, "hn")) != -1) {
		switch (opt) {
			case 'n':
				++lino;
				break;
			case 'h':
				usage(stdout, argv[0]);
				return 0;
		}
	}
	argc -= optind;
	argv += optind;
	fpath = argv;

	if (has_next_file())
		yyin = next_file();
	return yylex();
}

static void usage(FILE *fp, const char *prog) {
	fprintf(fp, "Usage: %s files...\n", prog);
}

static int has_next_file() {
	return *fpath != NULL;
}

static FILE* next_file() {
	FILE *in = fopen(*fpath++, "r");
	if (in == NULL)
		err(errno, "%s", *fpath);
	return in;
}

int yywrap() {
	return 1;
}
