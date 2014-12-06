LEX		:= flex
YACC	:= bison
YFLAGS	:= -v -d
CFLAGS	:= -Wall -g
LDFLAGS	:= -ll
CC		:= gcc

all: cat inip wc calc rpcalc ltcalc

cat: cat.o
	$(CC) -o $@ $^ $(LDFLAGS)

inip: inip.tab.o inip.yy.o
	$(CC) -o $@ $^ $(LDFLAGS)

rpcalc: rpcalc.tab.o
	$(CC) -o $@ $^ $(LDFLAGS) -lm

ltcalc: ltcalc.tab.o
	$(CC) -o $@ $^ $(LDFLAGS) -lm

wc: wc.o
	$(CC) -o $@ $^ $(LDFLAGS)

calc: calc.tab.o calc.yy.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.tab.h %.tab.c: %.y
	$(YACC) $(YFLAGS) $<

%.yy.c: %.l %.tab.h
	$(LEX) -o $@ $<
#
#	Bison options:
#
#	-v	Generate micro.output showing states of LALR parser
#	-d	Generate micro.tab.h containing token type definitions
#
clean:
	$(RM) *.o *.yy.c *.tab.c *.tab.h
