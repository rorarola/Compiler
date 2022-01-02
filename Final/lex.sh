echo "What is your filename?"
read FILENAME
flex -o $FILENAME.yy.c $FILENAME.l
gcc -o $FILENAME $FILENAME.yy.c -lfl
