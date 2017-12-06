#include <stdlib.h>
#include <stdio.h>

//this is the starting point

/*how do multi-line comments work
 *do i need these stars
 *they are annoying
 */
//without star or double slash my chars are white. sad. need stars.


int main(int argc, char *argv[]) {
  printf("hello world! \n");

  
  //print hi ten times
  //looks like the counter needs to be initialized. gcc complains if u don't
  int i=27450 ;
  for (i=0; i<5; i++) {
    printf("hi number %d\n", i);
  }

  int numargs=argc-1 ;
  //print command line args
  printf("There are %d command line arguments. \n", numargs);
  printf("There are:\n");

  //is argc a special variable that just knows it's supposed to be the number of args?
  for (i=1; i<argc; i++) {
    printf(" %d: %s\n", i, argv[i]);
  }

  //arrays
  int A[10];
  //fill and print
  for (i=0; i<0;i++) {
    A[i]=i;
    printf("A[%d] = %d\n", i, A[i]);
  }
    
  int N=11;
  int B[N]; //array of length N
  //fill and print
  for (i=0; i<N; i++) {
    B[i]=i;
    printf("B[%d] = %d\n", i, B[i]);
  }

  //error checking
  if (argc

  
}

  

//it appears double quotes are strings and single quotes are something else
