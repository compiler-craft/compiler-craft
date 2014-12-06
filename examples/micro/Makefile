LEX		:= flex
LFLAGS	:= --yylineno
YACC	:= bison
YFLAGS	:= -v -d
CFLAGS	:= -Wall -g
LDFLAGS	:= -ll
CC=		gcc

all: imicro microc gmicro

imicro: micro.tab.o micro.yy.o interpreter.o
		$(CC) -o $@ $^ $(LDFLAGS)
microc: micro.tab.o micro.yy.o compiler.o
		$(CC) -o $@ $^ $(LDFLAGS)
gmicro: micro.tab.o micro.yy.o graphiz.o
		$(CC) -o $@ $^ $(LDFLAGS)

%.tab.h %.tab.c: %.y
	$(YACC) $(YFLAGS) $<

%.yy.c: %.l %.tab.h
	$(LEX) $(LFLAGS) -o $@ $<
#
#	Bison options:
#
#	-v	Generate micro.output showing states of LALR parser
#	-d	Generate micro.tab.h containing token type definitions
#
clean:
	$(RM) *.o *.yy.c *.tab.c *.tab.h
