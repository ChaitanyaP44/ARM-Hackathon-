#include "stm32f4xx.h"
#include <string.h>
#include <stdio.h>

void printValue(int a)
{
	 float a1=*((float*) &a);
	 
	 char Msg1[100];
	 
	 char *ptr;
	 sprintf(Msg1, "%f, \n", a1);
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
   }

void printNextline()
{
	ITM_SendChar('\n')	 ;
}
void print_delimeter()
{
	
	 ITM_SendChar(',')	 ;
}

void printheader()
{
	 char Msg[100]="ANGLE,X,Y";
	 
	 char *ptr;
	 
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 ITM_SendChar('\n');
	
}	