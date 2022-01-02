bison -d -o y.tab.c A.y
gcc -c -g -I.. y.tab.c
flex -o lex.yy.c A.l
gcc -c -g -I.. lex.yy.c
gcc -o A y.tab.o lex.yy.o -ll
