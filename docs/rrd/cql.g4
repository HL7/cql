grammar cql;

/*
 * Clinical Quality Language Grammar Specification
 * Version 2.0 - Mixed Normative/Trial-Use
 */

/*
 * Parser Rules
 */

directive
    : '#' identifier (':' STRING)?
    ;

library
    :
    directive*
    libraryDefinition?
    definition*
    statement*
    EOF
    ;

/*
 * Definitions
 */

libraryDefinition
    : 'library' qualifiedIdentifier ('version' STRING)?
    ;

definition
    : usingDefinition
    | includeDefinition
    | codesystemDefinition
    | valuesetDefinition
    | codeDefinition
    | conceptDefinition
    | parameterDefinition
    ;

usingDefinition
    : 'using' qualifiedIdentifier ('version' STRING)? ('called' identifier)?
    ;

includeDefinition
    : 'include' qualifiedIdentifier ('version' STRING)? ('called' identifier)? ('bind' tupleSelector)?
    ;

accessModifier
    : 'public'
    | 'private'
    ;

parameterDefinition
    : accessModifier? 'parameter' identifier (typeSpecifier)? ('default' expression)?
    ;

codesystemDefinition
    : accessModifier? 'codesystem' identifier ':' STRING ('version' STRING)?
    ;

valuesetDefinition
    : accessModifier? 'valueset' identifier ':' STRING ('version' STRING)? codesystems?
    ;

codesystems
    : 'codesystems' '{' qualifiedIdentifier (',' qualifiedIdentifier)* '}'
    ;

codeDefinition
    : accessModifier? 'code' identifier ':' STRING 'from' qualifiedIdentifier displayClause?
    ;

conceptDefinition
    : accessModifier? 'concept' identifier ':' '{' (qualifiedIdentifier (',' qualifiedIdentifier)*)? '}' displayClause?
    ;

/*
 * Type Specifiers
 */

typeSpecifier
    : namedTypeSpecifier
    | listTypeSpecifier
    | intervalTypeSpecifier
    | tupleTypeSpecifier
    | choiceTypeSpecifier
    ;

namedTypeSpecifier
    : qualifiedIdentifier
    ;

listTypeSpecifier
    : 'List' '<' typeSpecifier '>'
    ;

intervalTypeSpecifier
    : 'Interval' '<' typeSpecifier '>'
    ;

tupleTypeSpecifier
    : 'Tuple' '{' (tupleElementDefinition (',' tupleElementDefinition)*)? '}'
    ;

tupleElementDefinition
    : identifier typeSpecifier
    ;

choiceTypeSpecifier
    : 'Choice' '<' typeSpecifier (',' typeSpecifier)* '>'
    ;

/*
 * Statements
 */

statement
    : expressionDefinition
    | contextDefinition
    | functionDefinition
    | contextInfoDefinition
    | typeInfoDefinition
    | conversionInfoDefinition
    ;

expressionDefinition
    : 'define' accessModifier? identifier ':' expression
    ;

contextDefinition
    : 'context' qualifiedIdentifier
    ;

functionDefinition
    : 'define' accessModifier? 'fluent'? 'function' identifier '(' operandList? ')'
        ('returns' typeSpecifier)?
        ':' (functionBody | 'external')
    ;

operandList
    : operandDefinition (',' operandDefinition)*
    ;

operandDefinition
    : identifier typeSpecifier
    ;

functionBody
    : expression
    ;

contextInfoDefinition
    : 'define' 'context' identifier 'of' 'type' namedTypeSpecifier 'with' 'key' '{' identifier (',' identifier)* '}'
    ;

typeInfoDefinition
    : 'define' accessModifier? 'type' qualifiedIdentifier baseTypeSpecifier? typeElements? typeInfo contextRelationship*
    ;

baseTypeSpecifier
    : 'extends' namedTypeSpecifier
    ;

typeElements
    : '{' typeElementDefinition (',' typeElementDefinition)* '}'
    ;

typeElementDefinition
    : identifier typeSpecifier
    ;

typeInfo
    : ('label' identifier)? ('identifier' STRING)? 'retrievable'? ('primary' 'code' 'path' simplePath)?
    ;

contextRelationship
    : 'related' 'to' qualifiedIdentifier 'context' 'by' '{' identifier (',' identifier)* '}'
    ;

conversionInfoDefinition
    : 'define' accessModifier? ('implicit' | 'explicit') 'conversion' 'from' typeSpecifier 'to' typeSpecifier 'using' identifier
    ;

/*
 * Expressions
 */

querySource
    : retrieve
    | qualifiedIdentifier
    | '(' expression ')'
    ;

aliasedQuerySource
    : querySource identifier
    ;

queryInclusionClause
    : withClause
    | withoutClause
    ;

withClause
    : 'with' aliasedQuerySource 'such that' expression
    ;

withoutClause
    : 'without' aliasedQuerySource 'such that' expression
    ;

retrieve
    : '[' (qualifiedIdentifier '->')? namedTypeSpecifier (':' (codePath codeComparator)? terminology)? ']'
    ;

codePath
    : simplePath
    ;

codeComparator
    : 'in'
    | '='
    | '~'
    ;

terminology
    : qualifiedIdentifier
    | expression
    ;

query
    : sourceClause letClause? queryInclusionClause* whereClause? (aggregateClause | returnClause)? sortClause?
    ;

sourceClause
    : 'from'? aliasedQuerySource (',' aliasedQuerySource)*
    ;

letClause
    : 'let' letClauseItem (',' letClauseItem)*
    ;

letClauseItem
    : identifier ':' expression
    ;

whereClause
    : 'where' expression
    ;

returnClause
    : 'return' ('all' | 'distinct')? expression
    ;

aggregateClause
    : 'aggregate' ('all' | 'distinct')? identifier startingClause? ':' expression
    ;

startingClause
    : 'starting' (simpleLiteral | quantity | ('(' expression ')'))
    ;

sortClause
    : 'sort' ( sortDirection | ('by' sortByItem (',' sortByItem)*) )
    ;

sortDirection
    : 'asc' | 'ascending'
    | 'desc' | 'descending'
    ;

sortByItem
    : expressionTerm sortDirection?
    ;

qualifiedIdentifier
    : (identifier '.')* identifier
    ;

simplePath
    : identifier                                       #simplePathReferentialIdentifier
    | simplePath '.' identifier                        #simplePathQualifiedIdentifier
    | simplePath '[' simpleLiteral ']'                 #simplePathIndexer
    ;

simpleLiteral
    : STRING                                           #simpleStringLiteral
    | NUMBER                                           #simpleNumberLiteral
    ;

expression
    : expressionTerm
    | retrieve
    | query
    | booleanExpression
    | typeExpression
    | castExpression
    | unaryLogicalExpression
    | betweenExpression
    | durationExpression
    | setExpression
    | comparisonExpression
    | expression intervalOperatorPhrase expression
    | membershipExpression
    | binaryLogicalExpression
    ;

booleanExpression
    : expression 'is' 'not'? ('null' | 'true' | 'false')
    ;

typeExpression
    : expression ('is' | 'as') typeSpecifier
    ;

castExpression
    : 'cast' expression 'as' typeSpecifier
    ;

unaryLogicalExpression
    : ('not' | 'exists') expression
    ;

comparisonExpression
    : expression ('=' | '!=' | '~' | '!~' | '<=' | '<' | '>' | '>=') expression
    ;

binaryLogicalExpression
    : expression ('and' | 'or' | 'xor' | 'implies') expression
    ;

membershipExpression
    : expression ('in' | '~in' | 'contains' | '~contains' ) dateTimePrecisionSpecifier? expression
    ;

setExpression
    : expression ('|' | 'union' | 'intersect' | 'except') expression
    ;

betweenExpression
    : expression 'properly'? 'between' expressionTerm 'and' expressionTerm
    ;

durationExpression
    : (('duration' | 'difference') 'in')? pluralDateTimePrecision (('between' expressionTerm 'and' expressionTerm) | ('of' expressionTerm))
    ;

dateTimePrecision
    : 'year' | 'month' | 'week' | 'day' | 'hour' | 'minute' | 'second' | 'millisecond'
    ;

pluralDateTimePrecision
    : 'years' | 'months' | 'weeks' | 'days' | 'hours' | 'minutes' | 'seconds' | 'milliseconds'
    ;

dateTimeComponent
    : dateTimePrecision
    | 'date'
    | 'time'
    | 'timezoneoffset'
    ;

expressionTerm
    : term
    | invocationExpressionTerm
    | indexerExpressionTerm
    | conversionExpressionTerm
    | polarityExpressionTerm
    | dateTimeComponentExpressionTerm
    | unaryIntervalExpressionTerm
    | typeExtentExpressionTerm
    | binaryArithmeticExpressionTerm
    | ifExpressionTerm
    | caseExpressionTerm
    | aggregateExpressionTerm
    | setAggregateExpressionTerm
    ;

unaryIntervalExpressionTerm
    : (('start' | 'end' | 'width' | 'successor' | 'predecessor') 'of') | (('singleton' | 'point') 'from') expressionTerm
    ;

invocationExpressionTerm
    : expressionTerm '.' invocation
    ;

invocation
    : identifier
    | function
    ;

indexerExpressionTerm
    : expressionTerm '[' expression ']'
    ;

conversionExpressionTerm
    : 'convert' expression 'to' (typeSpecifier | unit)
    ;

polarityExpressionTerm
    : ('+' | '-') expressionTerm
    ;

dateTimeComponentExpressionTerm
    : dateTimeComponent 'from' expressionTerm
    ;

typeExtentExpressionTerm
    : ('minimum' | 'maximum') namedTypeSpecifier
    ;

aggregateExpressionTerm
    : ('distinct' | 'flatten') expression
    ;

setAggregateExpressionTerm
    : ('expand' | 'collapse') expression ('per' (dateTimePrecision | expression))?
    ;

binaryArithmeticExpressionTerm
    : expressionTerm ('^' | '*' | '/' | 'div' | 'mod' | '+' | '-' | '&') expressionTerm
    ;

ifExpressionTerm
    : 'if' expression 'then' expression 'else' expression
    ;

caseExpressionTerm
    : 'case' expression? caseExpressionItem+ 'else' expression 'end'
    ;

caseExpressionItem
    : 'when' expression 'then' expression
    ;

dateTimePrecisionSpecifier
    : dateTimePrecision 'of'
    ;

relativeQualifier
    : 'or before'
    | 'or after'
    ;

offsetRelativeQualifier
    : 'or more'
    | 'or less'
    ;

exclusiveRelativeQualifier
    : 'less than'
    | 'more than'
    ;

quantityOffset
    : (quantity offsetRelativeQualifier?)
    | (exclusiveRelativeQualifier quantity)
    ;

temporalRelationship
    : ('on or'? ('before' | 'after'))
    | (('before' | 'after') 'or on'?)
    ;

intervalOperatorPhrase
    : concurrentWithIntervalOperatorPhrase
    | includesIntervalOperatorPhrase
    | includedInIntervalOperatorPhrase
    | beforeOrAfterIntervalOperatorPhrase
    | withinIntervalOperatorPhrase
    | meetsOrOverlapsIntervalOperatorPhrase
    | startsOrEndsIntervalOperatorPhrase
    ;

concurrentWithIntervalOperatorPhrase
    : ('starts' | 'ends' | 'occurs')? 'same' dateTimePrecision? (relativeQualifier | 'as') ('start' | 'end')?
    ;

includesIntervalOperatorPhrase
    : 'properly'? 'includes' dateTimePrecisionSpecifier? ('start' | 'end')?
    ;

includedInIntervalOperatorPhrase
    : ('starts' | 'ends' | 'occurs')? 'properly'? ('during' | 'included in') dateTimePrecisionSpecifier?
    ;

beforeOrAfterIntervalOperatorPhrase
    : ('starts' | 'ends' | 'occurs')? quantityOffset? temporalRelationship dateTimePrecisionSpecifier? ('start' | 'end')?
    ;

withinIntervalOperatorPhrase
    : ('starts' | 'ends' | 'occurs')? 'properly'? 'within' quantity 'of' ('start' | 'end')?
    ;

meetsOrOverlapsIntervalOperatorPhrase
    : ('meets' | 'overlaps') ('before' | 'after')? dateTimePrecisionSpecifier?
    ;

startsOrEndsIntervalOperatorPhrase
    : ('starts' | 'ends') dateTimePrecisionSpecifier?
    ;

term
    : identifier
    | literal
    | selector
    | function
    | iterationIdentifier
    | externalConstant
    | '(' expression ')'
    ;

iterationIdentifier
    : '$this'                           #thisInvocation
    | '$index'                          #indexInvocation
    | '$total'                          #totalInvocation
    ;

function
    : identifier '(' paramList? ')'
    ;

paramList
    : expression (',' expression)*
    ;

selector
    : intervalSelector      #intervalSelectorTerm
    | tupleSelector         #tupleSelectorTerm
    | instanceSelector      #instanceSelectorTerm
    | listSelector          #listSelectorTerm
    | codeSelector          #codeSelectorTerm
    | conceptSelector       #conceptSelectorTerm
    ;

literal
    : 'true'                                                #trueLiteral
    | 'false'                                               #falseLiteral
    | 'null'                                                #nullLiteral
    | STRING                                                #stringLiteral
    | NUMBER                                                #numberLiteral
    | LONGNUMBER                                            #longNumberLiteral
    | DATETIME                                              #dateTimeLiteral
    | DATE                                                  #dateLiteral
    | TIME                                                  #timeLiteral
    | quantity                                              #quantityLiteral
    | ratio                                                 #ratioLiteral
    ;

quantity
    : NUMBER unit?
    ;

unit
    : dateTimePrecision
    | pluralDateTimePrecision
    | STRING // UCUM syntax for units of measure
    ;

ratio
    : quantity ':' quantity
    ;

externalConstant
    : '%' ( identifier | STRING )
    ;

intervalSelector
    : 'Interval' ('['|'(') expression ',' expression (']'|')')
    ;

tupleSelector
    : 'Tuple'? '{' (':' | (tupleElementSelector (',' tupleElementSelector)*)) '}'
    ;

tupleElementSelector
    : identifier ':' expression
    ;

instanceSelector
    : namedTypeSpecifier '{' (':' | (instanceElementSelector (',' instanceElementSelector)*)) '}'
    ;

instanceElementSelector
    : identifier ':' expression
    ;

listSelector
    : ('List' ('<' typeSpecifier '>')?)? '{' (expression (',' expression)*)? '}'
    ;

displayClause
    : 'display' STRING
    ;

codeSelector
    : 'Code' STRING 'from' qualifiedIdentifier displayClause?
    ;

conceptSelector
    : 'Concept' '{' (codeSelector (',' codeSelector)*)? '}' displayClause?
    ;

keyword
    : 'after'
    | 'aggregate'
    | 'all'
    | 'and'
    | 'as'
    | 'asc'
    | 'ascending'
    | 'before'
    | 'between'
    | 'bind'
    | 'by'
    | 'called'
    | 'case'
    | 'cast'
    | 'code'
    | 'Code'
    | 'codesystem'
    | 'codesystems'
    | 'collapse'
    | 'concept'
    | 'Concept'
    | '~contains'
    | 'contains'
    | 'context'
    | 'conversion'
    | 'convert'
    | 'date'
    | 'day'
    | 'days'
    | 'default'
    | 'define'
    | 'desc'
    | 'descending'
    | 'difference'
    | 'display'
    | 'distinct'
    | 'div'
    | 'duration'
    | 'during'
    | 'else'
    | 'end'
    | 'ends'
    | 'except'
    | 'exists'
    | 'expand'
    | 'explicit'
    | 'extends'
    | 'false'
    | 'flatten'
    | 'fluent'
    | 'from'
    | 'function'
    | 'hour'
    | 'hours'
    | 'identifier'
    | 'if'
    | 'implicit'
    | 'implies'
    | '~in'
    | 'in'
    | 'include'
    | 'includes'
    | 'included in'
    | 'intersect'
    | 'Interval'
    | 'is'
    | 'key'
    | 'label'
    | 'let'
    | 'library'
    | 'List'
    | 'maximum'
    | 'meets'
    | 'millisecond'
    | 'milliseconds'
    | 'minimum'
    | 'minute'
    | 'minutes'
    | 'mod'
    | 'month'
    | 'months'
    | 'not'
    | 'null'
    | 'occurs'
    | 'of'
    | 'on or'
    | 'or'
    | 'or after'
    | 'or before'
    | 'or less'
    | 'or more'
    | 'or on'
    | 'overlaps'
    | 'parameter'
    | 'path'
    | 'per'
    | 'point'
    | 'predecessor'
    | 'primary'
    | 'private'
    | 'properly'
    | 'public'
    | 'related'
    | 'retrievable'
    | 'return'
    | 'same'
    | 'second'
    | 'seconds'
    | 'singleton'
    | 'start'
    | 'starting'
    | 'starts'
    | 'sort'
    | 'successor'
    | 'such that'
    | 'then'
    | 'time'
    | 'timezoneoffset'
    | 'to'
    | 'true'
    | 'Tuple'
    | 'type'
    | 'union'
    | 'using'
    | 'valueset'
    | 'version'
    | 'week'
    | 'weeks'
    | 'where'
    | 'when'
    | 'width'
    | 'with'
    | 'within'
    | 'without'
    | 'xor'
    | 'year'
    | 'years'
    ;

identifier
    : IDENTIFIER
    | DELIMITEDIDENTIFIER
    | QUOTEDIDENTIFIER
    ;

QUOTEDIDENTIFIER
    : '"' (ESC | .)*? '"'
    ;

DATE
    : '@' DATEFORMAT
    ;

DATETIME
    : '@' DATEFORMAT 'T' TIMEFORMAT? TIMEZONEOFFSETFORMAT?
    ;

TIME
    : '@' 'T' TIMEFORMAT
    ;

fragment DATEFORMAT
    : [0-9][0-9][0-9][0-9] ('-'[0-9][0-9] ('-'[0-9][0-9])?)?
    ;

fragment TIMEFORMAT
    : [0-9][0-9] (':'[0-9][0-9] (':'[0-9][0-9] ('.'[0-9]+)?)?)?
    ;

fragment TIMEZONEOFFSETFORMAT
    : ('Z' | ('+' | '-') [0-9][0-9]':'[0-9][0-9])
    ;

IDENTIFIER
    : ([A-Za-z] | '_')([A-Za-z0-9] | '_')*            // Added _ to support CQL (FHIR could constrain it out)
    ;

DELIMITEDIDENTIFIER
    : '`' (ESC | .)*? '`'
    ;

STRING
    : '\'' (ESC | .)*? '\''
    ;

NUMBER
    : [0-9]+('.' [0-9]+)?
    ;

LONGNUMBER
    : [0-9]+'L'
    ;

// Pipe whitespace to the HIDDEN channel to support retrieving source text through the parser.
WS
    : [ \r\n\t]+ -> channel(HIDDEN)
    ;

COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> channel(HIDDEN)
    ;

fragment ESC
    : '\\' ([`'"\\/fnrt] | UNICODE)    // allow \`, \', \", \\, \/, \f, etc. and \uXXX
    ;

fragment UNICODE
    : 'u' HEX HEX HEX HEX
    ;

fragment HEX
    : [0-9a-fA-F]
    ;
