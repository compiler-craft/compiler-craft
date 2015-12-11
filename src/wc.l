%{

#include <err.h>

	static int nline = 0;
	static int nchar = 0;
	static int nword = 0;
	static int nbyte = 0;

	static int opt_flags = 0;

	static char **fpath;

	static int has_next_file();
	static FILE* next_file();
	static void report();
	static void reset();
%}

LINE \n
WORD [^ \t\n]+
CHAR .

%%
{LINE} { ++nline; ++nchar; }
{WORD} { ++nword; nchar += yyleng; }
{CHAR} { ++ nchar; }
<<EOF>> {
	report();
	reset();
	if (has_next_file())
		yyin = next_file();
	else
		yyterminate();
}
%%

enum FLAGS {
	CHAR = 1 << 0,
	WORD = 1 << 1,
	LINE = 1 << 2,
	BYTE = 1 << 3,
};

int main(int argc, char *argv[]) {
	int opt;

	while ((opt = getopt(argc, argv, "clw")) != -1) {
		switch (opt) {
			case 'c':
				opt_flags |= CHAR;
				break;
			case 'l':
				opt_flags |= LINE;
				break;
			case 'w':
				opt_flags |= WORD;
				break;
			default:
				return 1;
				break;
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

static void report() {
	int flags[] = {LINE,  WORD,  CHAR,  BYTE};
	int count[] = {nline, nword, nchar, nbyte};
	int len = sizeof(flags)/sizeof(flags[0]);
	int i = -1;
	while (++i < len) {
		if (opt_flags == 0 || opt_flags & flags[i])
			printf(" %d", count[i]);
	}
	if (yyin != stdin)
		printf(" %s\n", *(fpath-1));
}

static void reset() {
	nbyte = 0;
	nchar = 0;
	nword = 0;
	nline = 0;
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
