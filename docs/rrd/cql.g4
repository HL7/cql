grammar cql;

/*
 * Clinical Quality Language Grammar Specification
 * Version 1.5 - Mixed Normative/Trial-Use
 */

/*
 * Parser Rules
 */

library
    :
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
    : 'using' identifier ('version' STRING)?
    ;

includeDefinition
    : 'include' qualifiedIdentifier ('version' STRING)? ('called' identifier)?
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
    : accessModifier? 'concept' identifier ':' '{' qualifiedIdentifier (',' qualifiedIdentifier)* '}' displayClause?
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
    : 'Tuple' '{' tupleElementDefinition (',' tupleElementDefinition)* '}'
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
    | comparisonExpression
    | expression intervalOperatorPhrase expression
    | membershipExpression
    | binaryLogicalExpression
    | setExpression
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
    : expression ('in' | 'contains') dateTimePrecisionSpecifier? expression
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
    : 'true'
    | 'false'
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
    : 'Concept' '{' codeSelector (',' codeSelector)* '}' displayClause?
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
    | 'contains'
    | 'context'
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
    | 'false'
    | 'flatten'
    | 'fluent'
    | 'from'
    | 'function'
    | 'hour'
    | 'hours'
    | 'if'
    | 'implies'
    | 'in'
    | 'include'
    | 'includes'
    | 'included in'
    | 'intersect'
    | 'Interval'
    | 'is'
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
    | 'per'
    | 'point'
    | 'predecessor'
    | 'private'
    | 'properly'
    | 'public'
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

// NOTE: Not used, this is the set of reserved words that may not appear as identifiers in ambiguous contexts
reservedWord
    : 'aggregate'
    | 'all'
    | 'and'
    | 'as'
    | 'after'
    | 'before'
    | 'between'
    | 'case'
    | 'cast'
    | 'Code'
    | 'collapse'
    | 'Concept'
    | 'convert'
    | 'day'
    | 'days'
    | 'difference'
    | 'distinct'
    | 'duration'
    | 'during'
    | 'else'
    | 'exists'
    | 'expand'
    | 'false'
    | 'flatten'
    | 'from'
    | 'if'
    | 'in'
    | 'included in'
    | 'is'
    | 'hour'
    | 'hours'
    | 'Interval'
    | 'let'
    | 'List'
    | 'maximum'
    | 'millisecond'
    | 'milliseconds'
    | 'minimum'
    | 'minute'
    | 'minutes'
    | 'month'
    | 'months'
    | 'not'
    | 'null'
    | 'occurs'
    | 'of'
    | 'on or'
    | 'or'
    | 'or on'
    | 'per'
    | 'point'
    | 'properly'
    | 'return'
    | 'same'
    | 'second'
    | 'seconds'
    | 'singleton'
    | 'sort'
    | 'such that'
    | 'then'
    | 'to'
    | 'true'
    | 'Tuple'
    | 'week'
    | 'weeks'
    | 'when'
    | 'with'
    | 'within'
    | 'without'
    | 'year'
    | 'years'
    ;

// Keyword identifiers are keywords that may be used as identifiers in a referential context
// Effectively, keyword except reservedWord
keywordIdentifier
    : 'asc'
    | 'ascending'
    | 'by'
    | 'called'
    | 'code'
    | 'codesystem'
    | 'codesystems'
    | 'concept'
    | 'contains'
    | 'context'
    | 'date'
    | 'default'
    | 'define'
    | 'desc'
    | 'descending'
    | 'display'
    | 'div'
    | 'end'
    | 'ends'
    | 'except'
    | 'fluent'
    | 'function'
    | 'implies'
    | 'include'
    | 'includes'
    | 'intersect'
    | 'library'
    | 'meets'
    | 'mod'
    | 'or after'
    | 'or before'
    | 'or less'
    | 'or more'
    | 'overlaps'
    | 'parameter'
    | 'predecessor'
    | 'private'
    | 'public'
    | 'start'
    | 'starting'
    | 'starts'
    | 'successor'
    | 'time'
    | 'timezoneoffset'
    | 'union'
    | 'using'
    | 'valueset'
    | 'version'
    | 'where'
    | 'width'
    | 'xor'
    ;

// Function identifiers are keywords that may be used as identifiers for functions
functionIdentifier
    : 'after'
    | 'aggregate'
    | 'all'
    | 'and'
    | 'as'
    | 'asc'
    | 'ascending'
    | 'before'
    | 'between'
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
    | 'contains'
    | 'context'
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
    | 'false'
    | 'flatten'
    | 'fluent'
    | 'from'
    | 'function'
    | 'hour'
    | 'hours'
    | 'if'
    | 'implies'
    | 'in'
    | 'include'
    | 'includes'
    | 'included in'
    | 'intersect'
    | 'Interval'
    | 'is'
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
    | 'or'
    | 'or after'
    | 'or before'
    | 'or less'
    | 'or more'
    | 'overlaps'
    | 'parameter'
    | 'per'
    | 'point'
    | 'predecessor'
    | 'private'
    | 'properly'
    | 'public'
    | 'return'
    | 'same'
    | 'singleton'
    | 'second'
    | 'seconds'
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

// Reserved words that are also type names
typeNameIdentifier
    : 'Code'
    | 'Concept'
    | 'date'
    | 'time'
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
