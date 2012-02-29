#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <stdio.h>

int main ( int argc, char *argv[] )
{
  struct timeval tv;
  struct timezone tz;
  struct tm *tm;
  struct pm *pm;
  int ch;
  int pusec;
  int curusec;
  int test_char = atoi(argv[1]) + 34;
  gettimeofday(&tv, &tz);
  tm=localtime(&tv.tv_sec);
  curusec = (tm->tm_sec * 1000000) + tv.tv_usec;
  pusec = curusec;
  //printf(" %d:%02d:%02d %d \n", tm->tm_hour, tm->tm_min, tm->tm_sec, tv.tv_usec);

  int i = 0;
  int sum_time;
  int time_diff;
  while((ch = getchar()) != EOF && i <= test_char+120){
    if(i <= 30){
     i++;
     //noop 
    } else {
      //printf("Char: %c,%i\n", ch,ch);
      gettimeofday(&tv, &tz);
      tm=localtime(&tv.tv_sec);
      curusec = (tm->tm_sec * 1000000) + tv.tv_usec;
      //if(i < test_char){
      //  sum_time += curusec - pusec;
      //}
      if(i == test_char){
        //time_diff = (curusec - pusec) - start_time;
        if(curusec - pusec < 70 && curusec - pusec > 10){
          printf("Match\n");
          //printf("%d :: %c :: %d\n", i, ch, curusec - pusec);
          //exit(0);
        }
      }
      if(i >= 30 && i <= 120){
        printf("%d :: %c :: %d\n", i, ch, curusec - pusec);
      }
      pusec = curusec;
      i++;
    }
  }
  exit(0);
}

