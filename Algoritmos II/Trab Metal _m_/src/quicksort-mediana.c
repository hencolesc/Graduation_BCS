#include "particiona.h"

/* -------------------------------------------------------------------------- */
/* devolve a mediana de a, b e c                                              */

static int mediana(int a, int b, int c)
{
if((b >= a || c >= a) && (b <= a || c <= a))
	{
	return a;
	}
else if((a >= b || c >= b) && (a <= b || c <= b)) 
		{
		return b;
		}
return c;
}

/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* ordena v[a..b]  usando o algoritmo  "QuickSort com mediana de  3" e
   devolve v                                                                  */

int *quicksort_mediana(int v[], int a, int b)
{
if(a >= b)
{
return v;
}

int i = sorteia(a,b),j = sorteia(a,b),k = sorteia(a,b), med = mediana(v[i],v[j],v[k]);

if(v[i] == med)
{
troca(v,i,b);
}
else if(v[j] == med)
	 	{
	  	troca(v,j,b);
	 	}
	 else
	 	{
	 	troca(v,k,b);
	 	}
	 	
int m = particiona(v,a,b,v[b]);

quicksort_mediana(v,a,m-1);
quicksort_mediana(v,m+1,b);
return v;
}
