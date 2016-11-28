#include "biblioteca.h"

/* -------------------------------------------------------------------------- */
/* ordena v[a..b] pelo m�todo da inser��o e devolve v */

int busca(int x, int *v, int a, int b)
{
int m;

if(a>b)
	{ 
	return (a-1);
	}
m=(int)((a+b)/2);
if (compara(x,v[m])==-1)
	{ 
	return busca(x,v,a,m-1);
	}
else
	{
	return busca(x,v,m+1,b);
	}
}

//--------------------------------------------------------------------------

int *insere(int v[], int a, int b)
{
int i, p;

i=b;
p=busca(v[b],v,a,b);
while(i>p+1)
	{
	troca(v,i,i-1);
	i--;
	}
return v;
}

//---------------------------------------------------------------------------

int *insercao(int v[], int a, int b)
{
if (a>=b)
{
return v;
}
insercao(v, a, b-1);
insere(v, a, b);
return v;
}
