/* description: Parses end executes mathematical expressions. */

%{
var symbol_e = [];
symbol_e[0] = [];
var Index = 0;

var symbol_table = {};
var ambito = {};

function downIndex() {
   Index--;
}

function upIndex() {
   Index++;
   symbol_e[Index] = [];
}

function odd (n) {
   return (n%2)==0 ? 1 : 0
}

%}

%token PROCEDURE CALL BEGIN END IF THEN WHILE DO
%token ID E PI EOF CONST VAR NUMBER DOT

/* operator associations and precedence */
%right '='
%left '<=' '>=' '==' '!=' '<' '>' 
%left '+' '-'
%left '*' '/'
%left '^'
%right '%'
%left UMINUS
%left '!'

%right THEN ELSE

%start program

%% /* language grammar */

program
    : block DOT EOF
        { 
          $$ = $1;
          return $$;
        }
    ;

block
    : consts vars proclists statement
       {
          $1 ? c = $1 : c = 'NULL'
          $2 ? v = $2 : v = 'NULL'
          $3 ? p = $3 : p = 'NULL'
          
           $$ = {
                type: 'BLOCK',
                consts: c,
                vars: v,
                procs: p,
                stat: $4
           };
       }
    ;
//----------------- INI CONSTANTES
consts
    : /*empty*/
    | CONST constant_n constlist ';'
       {
          list = [$2];
          if ($3 && $3.length > 0)
             list = list.concat($3);
          $$ = {
             type: 'CONST',
             consts: list
          };
       }
    ;
    
constlist
    : /*empty*/
    | ',' constant_n constlist
       {
          $$ = [$2];
          if ($3 && $3.length > 0)
             $$ = $$.concat($3);
       }
    ;
constant_n
: ID '=' number
{
    symbol_e[Index].push({type: 'CONST',id: $1,value: $3.value});
    $$ = {
        id: $1,
        value: $3.value
    };
}
;
//----------------- FIN CONSTANTES
//----------------- INI VAR
vars
    : /*empty*/
    | VAR ID varmore ';'
       {
          vl = [$2];
           symbol_e[Index].push({type: 'VAR', id: $2 ,value: null});
           if ($3 && $3.length > 0){
               vl = vl.concat($3);
           }
           $$ = {
             type: 'VAR',
             var_list: vl
          };
       }
    ;
    
varmore
    : /*empty*/
    | ',' ID varmore
       {
          symbol_e[Index].push({type: 'VAR', id: $2 ,value: null});
          $$ = [$2];
          if ($3 && $3.length > 0){
             $$ = $$.concat($3);
          }
       }
    ;
//----------------- FIN VAR
//----------------- INI PROC
proclists
    : /*empty*/
    | decl_proc arguments ';' block ';' proclists
      {
         symbol_table[$1.name] = {
            type: $1.type,
            name: $1.name,
            arguments: $2,
            bloque: $4,
            value: $4.value
         };
         $$ = symbol_table[$1.name];
         downIndex();
      }
    ;

decl_proc
    : PROCEDURE ID
      {
         upIndex();
          symbol_table[$2] ={type: 'PROCEDURE', value: -1};
         $$ = {
            type: $1,
            name: $2
         };
      }
    ;
    
arguments
    : /*empty*/
    | '(' ID varmore ')'
      {
         $$ = [$2]
         if ($3 && $3.length > 0)
             $$ = $$.concat($3);
      }
    ;
    
statement
    :  ID '=' expression
       {
           var obj = null;
           var i;
           for (i=0;i<symbol_e[Index].length;i++){
               if(symbol_e[0][i].id == $1){
                   obj = symbol_e[0][i];
                   symbol_e[0][i].value = $3.value;
               }
               if(symbol_e[Index][i].id == $1){
                   obj = symbol_e[Index][i];
                   symbol_e[Index][i].value = $3.value;
               }
           }
           if (!obj){
               throw new Error("No se ha definido "+$1);
           }
           if (obj.type == 'CONST'){
               throw new Error("Las constantes no pueden ser redefinidas "+$1);
           }
           if (obj.type != 'VAR'){
               throw new Error("No se ha definido como variable: "+$1);
           }
           //throw new Error(JSON.stringify(symbol_e));
           $$ = {
            type: $2,
            value: obj.value,
            right: $1,
            left: $3
           };

      }
    | CALL ID arguments
      {
         if (!symbol_table[$2])
            throw new Error("No existe el procedimiento"+$2);
         $$ = {
           type: $1,
           name: $2,
           arguments: $3,
           value: symbol_table[$2].value
         };
      }
    | BEGIN statement statementlist END
      {
         sl = [$2];
         if ($3 && $3.length > 0)
             sl = sl.concat($3);
         $$ = {
            type: $1,
            statement_list: sl
         };
      }
    | IF condition THEN statement
      {
         $$ = {
            type: $1,
            cond: $2,
            st: ($2.value == 1) ? $4 : 'NULL',
            value: ($2.value == 1) ? $4.value : 0
         };
      }
    | WHILE condition DO statement
      {
         $$ = {
            type: $1,
            cond: $2,
            st: ($2.value == 1) ? $4 : 'NULL',
            value: ($2.value == 1) ? $4.value : 0
         };
      }
    ;
    
statementlist
    : /*empty*/
    | ';' statement statementlist
       {
          $$ = [$2];
          if ($3 && $3.length > 0)
             $$ = $$.concat($3);
       }
    ;
// ------ EXP y COND
expression
: ID '=' expression
{
    var obj = null;
    var i;
    for (i=0;i<symbol_e[Index].length;i++){
        if(symbol_e[Index][i].id == $1){
            obj = symbol_e[Index][i];
            symbol_e[Index][i].value = $3.value;
        }
        if(symbol_e[0][i].id == $1){
            obj = symbol_e[0][i];
            symbol_e[0][i].value = $3.value;
        }
    }
    if (!obj){
        throw new Error("No se ha definido "+$1);
    }
    if (obj.type == 'CONST'){
        throw new Error("Las constantes no pueden ser redefinidas "+$1);
    }
    if (obj.type != 'VAR'){
        throw new Error("No se ha definido como variable: "+$1);
    }
    //throw new Error(JSON.stringify(symbol_e));
    $$ = {
    type: $2,
    value: obj.value,
    right: $1,
    left: $3
    };

}
| expression '+' expression
{
    if($1.value == null | $3.value == null){
        throw new Error("No se puede realizar operaciones con variables sin inicializar");
    }
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: $1.value + $3.value
    };
}
| expression '-' expression
{
    if($1.value == null | $3.value == null){
        throw new Error("No se puede realizar operaciones con variables sin inicializar");
    }
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: $1.value - $3.value
    };
}
| expression '*' expression
{
    if($1.value == null | $3.value == null){
        throw new Error("No se puede realizar operaciones con variables sin inicializar");
    }
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: $1.value * $3.value
    };
}
| expression '/' expression
{
    if($1.value == null | $3.value == null){
        throw new Error("No se puede realizar operaciones con variables sin inicializar");
    }
    if ($3.value == 0) throw new Error("Division by zero, error!");
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: $1.value / $3.value
    };
}
| expression '^' expression
{
    if($1.value == null | $3.value == null){
        throw new Error("No se puede realizar operaciones con variables sin inicializar");
    }
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: Math.pow($1.value, $3.value)
    };
}
| expression '%'
{
    $$ = {
    type: $2,
    left: $1,
    right: $3,
    value: $1.value/100
    };
}
| '-' expression %prec UMINUS
{$$ = {
type: 'MINUS',
value: -$2.value
};}
| '(' expression ')'
{$$ = $2;}
| number
{$$ = $1;}
| E
{$$ = {name: $1, value: Math.E};}
| PI
{$$ = {name: $1, value: Math.PI};}
| ID
{
    var obj = null;
    var i;
    for (i=0;i<symbol_e[Index].length;i++){
        if(symbol_e[Index][i].id == $1){
            obj = symbol_e[Index][i].value;
        }
    }
    $$ = {
    type: 'ID',
    name: $1,
    value: obj
    }
    ;
}
;
condition
    : ODD expression
      {
         $$ = {
            type: $1,
            right: $2,
            value: odd($2.value)
         };
      }
    | expression '==' expression
      {
         $$ = {
            type: 'COMPARISSON ==',
            left: $1,
            right: $3,
            value: ($1.value == $3.value) ? 1 : 0
         };
      }
    | expression '#' expression
      {
         $$ = {
            type: 'COMPARISSON #',
            left: $1,
            right: $3,
            value: ($1.value != $3.value) ? 1 : 0
         };
      }
    | expression '<' expression
      {
         $$ = {
            type: 'COMPARISSON <',
            left: $1,
            right: $3,
            value: ($1.value < $3.value) ? 1 : 0
         };
      }
    | expression '<=' expression
      {
         $$ = {
            type: 'COMPARISSON <=',
            left: $1,
            right: $3,
            value: ($1.value <= $3.value) ? 1 : 0
         };
      }
    | expression '>' expression
      {
         $$ = {
            type: 'COMPARISSON >',
            left: $1,
            right: $3,
            value: ($1.value > $3.value) ? 1 : 0
         };
      }
    | expression '>=' expression
      {
         $$ = {
            type: 'COMPARISSON >=',
            left: $1,
            right: $3,
            value: ($1.value >= $3.value) ? 1 : 0
         };
      }
    ;
// ------  FIN EXP y COND
// ------  TERMINALES
number
    : NUMBER { $$ = {
                      type: 'NUMBER',
                      value: Number(yytext)
                    };
             }
    ;
    
