/* lexical grammar */
%{
var reserved_words ={ PI: 'PI',
                      E : 'E',
                      CONST: 'const',
                      VAR: 'var',
                      PROCEDURE: 'procedure',
                      CALL: 'call',
                      BEGIN: 'begin',
                      END: 'end',
                      IF: 'if',
                      THEN: 'then',
                      WHILE: 'while',
                      DO: 'do',
                      ODD: 'odd'}

function idORrw(x) {
  return (x.toUpperCase() in reserved_words)? x.toUpperCase() : 'ID'
}

%}
%%

\s+|\#.*                         /* skip whitespace and comments */
\b\d+("."\d*)?([eE][-+]?\d+)?\b  return 'NUMBER'
\b[A-Za-z_]\w*\b                 return idORrw(yytext)
[-*/+^!%=();,]                   return yytext;
[<>=!][=]                        return yytext;
[<>]                             return yytext;
'.'                              return 'DOT'
<<EOF>>                          return 'EOF'
.                                return 'INVALID'