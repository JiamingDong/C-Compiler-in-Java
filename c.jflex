import java.io.*;
import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;
import java.util.*;

%%

%class Lexer
%cup
%line
%char
%column
%implements sym

%{

    ComplexSymbolFactory symbolFactory;
    public Lexer(java.io.Reader in, ComplexSymbolFactory sf){
	this(in);
	symbolFactory = sf;
    }
  
    private Symbol symbol(int sym) {
      return symbolFactory.newSymbol("sym", sym, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+yylength(),yychar+yylength()));
  }
  private Symbol symbol(int sym, Object val) {
      Location left = new Location(yyline+1,yycolumn+1,yychar);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol("sym", sym, left, right,val);
  } 
  private Symbol symbol(int sym, Object val,int buflength) {
      Location left = new Location(yyline+1,yycolumn+yylength()-buflength,yychar+yylength()-buflength);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol("sym", sym, left, right,val);
  } 
    
    private int typecheck(String s){
	     return IDENT;
    }
    
%}

%eofval{
     return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval}

D		=	[0-9]
L		=	[a-zA-Z_]
H		=	[a-fA-F0-9]
E		=	[Ee][+-]?{D}+
FS		=	(f|F|l|L)
IS		=	(u|U|l|L)*
TC              =       "/*" [^*] ~"*/" | "/*" "*"+ "/"
EC              =       "//" [^\r\n]* {new_line}    
new_line        =       \r|\n|\r\n
white_space     =       {new_line} | [ \t\f]

%%
{EC}                    { }
{TC}                    { }

"string"			{ return symbol(STRING,yytext()); }
"do"			{ return symbol(DO,yytext()); }
"else"			{ return symbol(ELSE,yytext()); }
"extern"		{ return symbol(EXTERN,yytext()); }
"for"			{ return symbol(FOR,yytext()); }
"if"			{ return symbol(IF,yytext()); }
"int"			{ return symbol(INT,yytext()); }
"return"		{ return symbol(RETURN,yytext()); }
"while"			{ return symbol(WHILE,yytext()); }

{L}({L}|{D})*		{ return symbol(typecheck(yytext()), yytext()); }

0[xX]{H}+{IS}?		{ return symbol(CONST_INT,yytext()); }
0{D}+{IS}?		{ return symbol(CONST_INT,yytext()); }
{D}+{IS}?		{ return symbol(CONST_INT,yytext()); }
L?'(\\.|[^\\'])+'	{ return symbol(CONST_INT,yytext()); }

{D}+{E}{FS}?		{ return symbol(CONST_INT,yytext()); }
{D}*"."{D}+({E})?{FS}?	{ return symbol(CONST_INT,yytext()); }
{D}+"."{D}*({E})?{FS}?	{ return symbol(CONST_INT,yytext()); }

L?\"(\\.|[^\\\"])*\"  { return symbol(CONST_STRING,yytext()); }

";"			{ return symbol(SEMI); }
("{")		{ return symbol(CURLYL); }
("}")		{ return symbol(CURLYR); }
","			{ return symbol(COMMA); }
"="			{ return symbol(ASSIGN); }
"("			{ return symbol(PARAL); }
")"			{ return symbol(PARAR); }
"-"			{ return symbol(MINUS); }
"+"			{ return symbol(PLUS,"+"); }
"*"			{ return symbol(MULTI,"*"); }
"/"			{ return symbol(DIV,"/"); }
"%"			{ return symbol(MODULO,"%"); }
"<"			{ return symbol(INF,"<"); }
">"			{ return symbol(SUP,">"); }
">>"      { return symbol(SHIFTRIGHT); }
"<<"      { return symbol(SHIFTLEFT); }
"<="      { return symbol(INFEQUAL,"<="); }
">="      { return symbol(SUPEQUAL,">="); }
"=="      { return symbol(EGAL,"=="); }
"!="      { return symbol(DIFF,"!="); }

{white_space}		{ /* ignore bad characters */ }
.|\n			{ System.err.println("Error: invalid symbol: "+yytext()+" "+(yyline+1)+"/"+(yycolumn+1)); }

