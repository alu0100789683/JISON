/* Lexer */

%{
    var reserved_words = {
        BEGIN: 'BEGIN',
        CALL: 'CALL',
        CONST: 'CONST',
        DO: 'DO',
        ELSE: 'ELSE',
        END: 'END',
        IF: 'IF',
        ODD: 'ODD',
        PROCEDURE: 'PROCEDURE',
        THEN: 'THEN',
        VAR: 'VAR',
        WHILE: 'WHILE'
    }

    function idORrw(x) {
        return (x.toUpperCase() in reserved_words)? x.toUpperCase() : 'ID'
    }

    %}

%%

[\s\t\n\r] /* Ignorar espacios */

[<>=!]'=' return 'COMPARISON_OP'
[<>] return 'COMPARISON_OP'

'=' return 'ASSIGN'
[*/+-] return yytext

\b[a-zA-Z_]\w*\b return idORrw(yytext)
\b[0-9]+\b return 'NUMBER'

',' return 'COMMA'
';' return 'END_SENTENCE'
'.' return 'END_SYMBOL'
'(' return 'LEFTPAR'
')' return 'RIGHTPAR'

<<EOF>> return 'EOF'

. return 'INVALID'