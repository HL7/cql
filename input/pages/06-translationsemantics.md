{% include styles.html %}

As discussed in the introductory section, this specification covers three levels of definition, the Conceptual or Author level, the Logical level, and the Physical level. The Conceptual level is concerned with the representation of logic in a format suitable for authoring and consumption by clinical experts; the Physical level is concerned with the representation of logic in a format suitable for processing and transferring by machines; and the Logical level is concerned with providing a mapping between the Conceptual and Physical levels in a way that preserves the semantics of the logic represented while also enabling integration and execution functionality.

To achieve these goals, the Logical level establishes a semantically complete bi-directional mapping between the Conceptual and Physical levels. This chapter describes this mapping in more detail, and sketches a process for translation from the Conceptual to the Logical, and from the Logical to the Conceptual. The Physical level is an isomorphic concrete realization of the Logical level; translation between the Logical and Physical levels is therefore a matter of serialization and realization of the data model, and is covered in detail in the [Physical Representation](07-physicalrepresentation.html) chapter.

## CQL-to-ELM

Every statement of CQL has a semantically equivalent representation in ELM. As such, it is possible to programmatically translate any statement of CQL into its equivalent ELM representation. The following sections define the mappings between the language elements of CQL and their equivalent ELM representations, as well as providing a sketch for how these mappings could be used to translate from CQL to ELM.

{: #declarations-1}
### Declarations

In both CQL and ELM, the basic container for all declarations is the _Library_. In CQL, a library corresponds to a single source document, usually represented as a text file. In ELM, a library is represented as a single instance of the _Library_ class which contains all the declarations for the library.

The identifier and version of the library are set as part of the library metadata.

The following table specifies the ELM equivalent for each CQL declaration:

<a name="table-6-a"></a>
[cols=",",options="header",]
|===============================
|CQL Declaration |ELM Equivalent
|<span class="kw">library</span> |Library
|<span class="kw">using</span> |UsingDef
|<span class="kw">include</span> |IncludeDef
|<span class="kw">codesystem</span> |CodeSystemDef
|<span class="kw">valueset</span> |ValueSetDef
|<span class="kw">parameter</span> |ParameterDef
|<span class="kw">define</span> |ExpressionDef
|<span class="kw">function</span> |FunctionDef
|===============================

Table 6‑A - The ELM equivalent for each CQL declaration

{: #types-1}
### Types

To represent types, CQL uses the _type-specifier_ construct. In ELM, an equivalent TypeSpecifier abstract class is defined, with appropriate subclasses to represent the various types of specifiers, as detailed in the following table:

<a name="table-6-b"></a>
[cols=",",options="header",]
|================================================
|CQL Specifier |ELM Equivalent
|*_named-type-specifier_* |NamedTypeSpecifier
|*_interval-type-specifier_* |IntervalTypeSpecifier
|*_list-type-specifier_* |ListTypeSpecifier
|*_tuple-type-specifier_* |TupleTypeSpecifier
|*_choice-type-specifier_* |ChoiceTypeSpecifier
|================================================

Table 6‑B - The ELM equivalent for each CQL type-specifier

Note that for named type specifiers, the name of the type is a qualified identifier, with the qualifier representing the name of the data model that defines the type. For example, the system-defined integer type in CQL is named System.Integer, with System as the name of the data model, and Integer as the name of the type.

{: #literals-and-selectors-1}
### Literals and Selectors

The following table defines the mapping between the various CQL literals and their equivalent representation in ELM:

<a name="table-6-c"></a>
[cols=",",options="header",]
|================================================
|CQL Literal |ELM Equivalent
|<span class="kw">null</span> |Null
|*_boolean-literal_* |Boolean
|*_integer-literal_* |Literal (valueType="Integer")
|*_long-literal_* |Literal (valueType="Long")
|*_decimal-literal_* |Literal (valueType="Decimal")
|*_quantity-literal_* |Quantity
|*_ratio-literal_* |Ratio
|*_string-literal_* |Literal (valueType="String")
|*_date-literal_* |Date
|*_date-time-literal_* |DateTime
|*_time-literal_* |Time
|*_interval-selector_* |Interval
|*_list-selector_* |List
|*_tuple-selector_* |Tuple
|*_instance-selector_* |Instance
|================================================

Table 6‑C - The ELM equivalent for each CQL Literal

### Functions

Most of the functions and operations available in CQL have a direct counterpart in ELM. For ease of reference, the operations and functions are grouped the same way they are in the CQL Reference.

{: #logical-operators-2}
#### Logical Operators

<a name="table-6-d"></a>
[cols=",",options="header",]
|============================
|CQL Operator |ELM Equivalent
|<span class="kw">and</span> |And
|<span class="kw">not</span> |Not
|<span class="kw">or</span> |Or
|<span class="kw">xor</span> |Xor
|<span class="kw">*implies*</span> |Implies
|============================

Table 6‑D - The ELM equivalent for each CQL logical operator

#### Type Operators

<a name="table-6-e"></a>
[cols=",",options="header",]
|============================
|CQL Operator |ELM Equivalent
|<span class="kw">as</span> |As
|<span class="kw">convert</span> |Convert
|<span class="kw">is</span> |Is
|<span class="id">Children</span> |Children
|<span class="id">Descendents</span> |Descendents
|============================

Table 6‑E - The ELM equivalent for each CQL type operator

Note that for supported conversions, a more efficient implementation would be to emit a specific operator to perform the conversion, rather than a generic Convert as specified here. For example, consider the following CQL conversion expression:

convert B to String

Rather than emitting a _Convert_, an implementation could emit a _ToString_ which took an integer parameter. This would prevent the run-time type check required for implementation of a general purpose _Convert_ operator.

Note also that when translating to ELM, an implementation could emit all implicit conversions directly, avoiding the need for an ELM translator or execution engine to deal with implicit conversion.

{: #nullological-operators-2}
#### Nullological Operators

<a name="table-6-f"></a>
[cols=",",options="header",]
|============================
|CQL Operator |ELM Equivalent
|<span class="id">Coalesce</span> |Coalesce
|<span class="kw">is null</span> |IsNull
|<span class="kw">is false</span> |IsFalse
|<span class="kw">is true</span> |IsTrue
|============================

Table 6‑F - The ELM equivalent for each CQL nullological operator

{: #comparison-operators-3}
#### Comparison Operators

<a name="table-6-g"></a>
[cols=",",options="header",]
|================================================================================
|CQL Operator |ELM Equivalent
|<span class="kw">between</span> |And of comparisons (for point types) or IncludedIn (for Interval types)
|<span class="sym">=</span> |Equal
|<span class="sym">></span> |Greater
|<span class="sym">>=</span> |GreaterOrEqual
|<span class="sym"><</span> |Less
|<span class="sym">\<=</span> |LessOrEqual
|<span class="sym">~</span> |Equivalent
|<span class="sym">!=</span> |NotEqual
|<span class="sym">!~</span> |Not of Equivalent
|================================================================================

Table 6‑G - The ELM equivalent for each CQL comparison operator

{: #arithmetic-operators-3}
#### Arithmetic Operators

<a name="table-6-h"></a>
[cols=",",options="header",]
|============================
|CQL Operator |ELM Equivalent
|<span class="id">Abs</span> |Abs
|<span class="sym">+</span> |Add
|<span class="id">Ceiling</span> |Ceiling
|<span class="sym">/</span> |Divide
|<span class="id">Floor</span> |Floor
|<span class="id">Exp</span> |Exp
|<span class="id">Log</span> |Log
|<span class="id">Ln</span> |Ln
|<span class="kw">maximum</span> |MaxValue
|<span class="kw">minimum</span> |MinValue
|<span class="kw">mod</span> |Modulo
|<span class="sym">*</span> |Multiply
|<span class="sym">-</span> *(unary minus)* |Negate
|<span class="kw">predecessor</span> |Predecessor
|<span class="sym">^</span> |Power
|<span class="id">Round</span> |Round
|<span class="sym">-</span> |Subtract
|<span class="kw">successor</span> |Successor
|<span class="id">Truncate</span> |Truncate
|<span class="kw">div</span> |TruncatedDivide
|============================

Table 6‑H - The ELM equivalent for each CQL arithmetic operator

{: #string-operators-2}
#### String Operators

<a name="table-6-i"></a>
[cols=",",options="header",]
|===============================================================================
|CQL Operator |ELM Equivalent
|<span class="id">Combine</span> |Combine
|<span class="sym">+</span>, <span class="sym">&</span> |Concatenate (when & is used, a Coalesce(X, ‘’) is applied to each operand
|<span class="id">EndsWith</span> |EndsWith
|<span class="sym">[]</span> |Indexer
|<span class="id">*LastPositionOf*</span> |LastPositionOf
|<span class="id">Length</span> |Length
|<span class="id">Lower</span> |Lower
|<span class="id">Matches</span> |Matches
|<span class="id">PositionOf</span> |PositionOf
|<span class="id">ReplaceMatches</span> |ReplaceMatches
|<span class="id">Split</span> |Split
|<span class="id">StartsWith</span> |StartsWith
|<span class="id">Substring</span> |Substring
|<span class="id">Upper</span> |Upper
|===============================================================================

Table 6‑I - The ELM equivalent for each CQL <span class="kw">String</span> operator

{: #datetime-operators-1}
#### Date and Time Operators

<a name="table-6-j"></a>
[cols=",",options="header",]
|=======================================
|CQL Operator |ELM Equivalent
|<span class="sym">+</span> |Add
|<span class="kw">after</span> |After
|<span class="kw">before</span> |Before
|<span class="id">Date</span> |Date
|<span class="id">DateTime</span> |DateTime
|*_component_* <span class="kw">from</span> |DateTimeComponentFrom
|<span class="kw">difference</span>..<span class="kw">between</span> |DifferenceBetween
|<span class="kw">duration</span>..<span class="kw">between</span> |DurationBetween
|<span class="id">Now</span> |Now
|<span class="kw">same as</span> |SameAs
|<span class="kw">same or after</span> |SameOrAfter
|<span class="kw">same or before</span> |SameOrBefore
|<span class="sym">-</span> |Subtract
|<span class="id">Time</span> |Time
|<span class="id">TimeOfDay</span> |TimeOfDay
|<span class="id">Today</span> |Today
|=======================================

Table 6‑J - The ELM equivalent for each CQL <span class="kw">Date</span> and <span class="kw">Time</span> operator

{: #interval-operators-2}
#### Interval Operators

<a name="table-6-k"></a>
[cols=",",options="header",]
|========================================
|CQL Operator |ELM Equivalent
|<span class="kw">after</span> |After
|<span class="kw">before</span> |Before
|<span class="kw">collapse</span> |Collapse
|<span class="kw">contains</span> |Contains
|<span class="kw">end of</span> |End
|<span class="kw">ends</span> |Ends
|<span class="sym">=</span> |Equal
|<span class="kw">except</span> |Except
|<span class="kw">in</span> |In
|<span class="kw">includes</span> |Includes
|<span class="kw">during</span> |IncludedIn
|<span class="kw">included in</span> |IncludedIn
|<span class="kw">intersect</span> |Intersect
|<span class="sym">~</span> |Equivalent
|<span class="kw">meets</span> |Meets
|<span class="kw">meets after</span> |MeetsAfter
|<span class="kw">meets before</span> |MeetsBefore
|<span class="sym">!=</span> |NotEqual
|<span class="sym">!~</span> |Not of Equivalent
|<span class="kw">overlaps</span> |Overlaps
|<span class="kw">on or after</span> |SameOrAfter
|<span class="kw">on or before</span> |SameOrBefore
|<span class="kw">overlaps after</span> |OverlapsAfter
|<span class="kw">overlaps before</span> |OverlapsBefore
|<span class="kw">point from</span> |PointFrom
|<span class="kw">properly includes</span> |ProperlyIncludes
|<span class="kw">properly included in</span> |ProperlyIncludedIn
|<span class="kw">properly during</span> |ProperlyIncludedIn
|<span class="kw">start of</span> |Start
|<span class="kw">starts</span> |Starts
|<span class="kw">union</span> |Union
|<span class="kw">width of</span> |Width
|========================================

Table 6‑K - The ELM equivalent for each CQL <span class="kw">Interval</span> operator

{: #list-operators-1}
#### List Operators

<a name="table-6-l"></a>
[cols=",",options="header",]
|========================================
|CQL Operator |ELM Equivalent
|<span class="kw">contains</span> |Contains
|<span class="kw">distinct</span> |Distinct
|<span class="sym">=</span> |Equal
|<span class="kw">except</span> |Except
|<span class="kw">exists</span> |Exists
|<span class="kw">flatten</span> |Flatten
|<span class="id">First</span> |First
|<span class="kw">in</span> |In
|<span class="kw">includes</span> |Includes
|<span class="kw">included in</span> |IncludedIn
|<span class="sym">[]</span> |Indexer
|<span class="id">IndexOf</span> |IndexOf
|<span class="kw">intersect</span> |Intersect
|<span class="id">Last</span> |Last
|<span class="id">Length</span> |Length
|<span class="sym">~</span> |Equivalent
|<span class="sym">!=</span> |NotEqual
|<span class="sym">!~</span> |Not of Equivalent
|<span class="kw">properly includes</span> |ProperlyIncludes
|<span class="kw">properly included in</span> |ProperlyIncludedIn
|<span class="kw">singleton from</span> |SingletonFrom
|<span class="id">Skip(n)</span> |Slice(n, null)
|<span class="id">Tail</span> |Slice(1, null)
|<span class="id">Take(n)</span> |Slice(0, n)
|<span class="kw">union</span> |Union
|========================================

Table 6‑L - The ELM equivalent for each CQL <span class="kw">List</span> operator

{: #aggregate-operators-2}
#### Aggregate Operators

<a name="table-6-m"></a>
[cols=",",options="header",]
|======================================
|CQL Operator |ELM Equivalent
|<span class="id">AllTrue</span> |AllTrue
|<span class="id">AnyTrue</span> |AnyTrue
|<span class="id">Avg</span> |Avg
|<span class="id">Count</span> |Count
|<span class="id">GeometricMean</span> |GeometricMean
|<span class="id">Max</span> |Max
|<span class="id">Min</span> |Min
|<span class="id">Median</span> |Median
|<span class="id">Mode</span> |Mode
|<span class="id">PopulationStdDev</span> |PopulationStdDev
|<span class="id">PopulationVariance</span> |PopulationVariance
|<span class="id">Product</span> |Product
|<span class="id">StdDev</span> |StdDev
|<span class="id">Sum</span> |Sum
|<span class="id">Variance</span> |Variance
|======================================

Table 6‑M - The ELM equivalent for each CQL aggegrate operator

{: #clinical-operators-2}
#### Clinical Operators

<a name="table-6-n"></a>
[cols=",",options="header",]
|==================================================================================
|CQL Operator |ELM Equivalent
|<span class="id">AgeIn</span>*__-precision__* |CalculateAge (with patient birthdate reference supplied)
|<span class="id">AgeIn</span>*__-precision-__*<span class="id">At</span> |CalculateAgeAt (with patient birthdate reference supplied)
|<span class="id">CalculateAgeIn</span>*__-precision__* |CalculateAge
|<span class="id">CalculateAgeIn</span>*__-precision-__*<span class="id">At</span> |CalculateAgeAt
|<span class="sym">=</span> |Equal
|<span class="sym">~</span> |Equivalent
|<span class="kw">in</span> *(Codesystem)* |InCodeSystem
|<span class="kw">in</span> *(Valueset)* |InValueSet
|==================================================================================

Table 6‑N - The ELM equivalent for each CQL clinical operator

{: #phrases}
### Phrases

In general, the various phrases of CQL do not have a direct representation in ELM, but rather result in operator and function invocations which then do have representations. For more information, see the [Timing Phrases](05-languagesemantics.adoc#timing-phrases) section.

{: #queries-3}
### Queries

The CQL query construct has a direct representation in ELM, as shown by the following table:

<a name="table-6-o"></a>
[cols=",",options="header",]
|==========================================
|CQL Construct |ELM Equivalent
|*_query_* |Query
|*_aliased-query-source_* |AliasedQuerySource
|*_let-clause_* |LetClause
|*_with-clause_* |With
|*_without-clause_* |Without
|*_where-clause_* |Query (where element)
|*_return-clause_* |ReturnClause
|*_aggregtate-clause_* |AggregateClause
|*_sort-clause_* |SortClause
|==========================================

Table 6‑O - The ELM equivalent for each CQL construct

Although these elements can be used to directly represent the _query_ construct of CQL, it is also possible to represent queries using a series of equivalent operations that simplify implementation. ELM defines simplified operations specifically for this purpose. See the [Implementing Query Evaluation](05-languagesemantics.adoc#implementing-query-evaluation) section for more information on how to transform any given CQL query into an equivalent representation using these operators.

### Translation Options

There are several points throughout the specification that introduce optionality to support different use cases and implementation goals. This section provides a summary of those options with an explanation of their impact on translation and language features.

> Note that implementations may define other options as appropriate for their translation use cases, but these options all potentially impact whether a given library of CQL can be correctly compiled, and should therefore be used with care. Implementations that make use of these options should provide facilities for ensuring that these options are communicated as part of the resulting ELM output, as well as that the appropriate options are used if the CQL library is re-translated by consuming environments.
{: .note-warning}

#### Disable List Promotion and Demotion

List promotion and demotion are a special case of implicit conversions and enable list-valued expressions to be passed to singleton parameters (by invoking the <span class="kw">singleton from</span> operator) and vice-versa (by invoking the <span class="id">ToList</span> function). These conversions are useful for writing expressions against models with deeply nested hierarchies and variable cardinality elements, but can sometimes result in surprising overload selections and conversion choices. As a result, implementations may choose to enable or disable this language feature using the _disable-list-promotion_ and _disable-list-demotion_ options. For a more detailed discussion, see [List Promotion and Demotion](03-developersguide.html#promotion-and-demotion).

#### Disable List Traversal

In addition to list promotion and demotion, CQL allows for paths to be traversed through list-valued elements. Again, this is useful when writing expressions against models with variable cardinality elements, and can be disabled with the _disable-list-traversal_ option. For a more detailed discussion, see [Path Traversal](03-developersguide.html#path-traversal).

#### Disable Method Invocation

To support FHIRPath as the base expression language for CQL, beginning with 1.3, the option to allow functions to be invoked using method-style invocation was introduced. This feature can be disabled using the _disable-method-invocation_ option. For a more complete discussion, see [Method Invocation](03-developersguide.html#method-invocation).

> Note that with the introduction of [Fluent Functions](03-developersguide.html#fluent-functions) in 1.5, using this option effectively disables fluent functions as well.
{: .note-warning}

#### Require From Keyword

To encourage consistent use of the <span class="kw">from</span> keyword to being queries, implementations may provide support for the _require-from-keyword_ option. See [Query Syntax Options](03-developersguide.html#query-syntax-options) for more discussion.

## ELM-to-CQL

In addition to being able to translate CQL to ELM, any given expression of ELM can be represented in CQL. Support for this direction of translation would be useful for applications that produce ELM from another source, and need to display a human-readable representation of the logic.

This bi-directionality means that a given expression of CQL could be translated to ELM, and then back again. However, because ELM is typically a more primitive representation, this process is not necessarily a “round-trip”. For example, consider the following CQL:

``` cql
A starts within 3 days of start B
```

This will actually result in the following ELM output:

``` xml
<expression xsi:type="In">
  <operand xsi:type="DurationBetween" precision="Day">
    <operand xsi:type="Start">
      <operand xsi:type="ExpressionRef" name="A"/>
    </operand>
    <operand xsi:type="Start">
      <operand xsi:type="ExpressionRef" name="B"/>
    </operand>
  </operand>
  <operand xsi:type="Interval">
    <low xsi:type="Literal" valueType="xs:int" value="-3"/>
    <high xsi:type="Literal" valueType="xs:int" value="3"/>
  </operand>
</expression>
```

The above expression, rendered directly back to CQL would be:

``` cql
days between start of A and start of B in [-3, 3]
```

These expressions are semantically equivalent, but not syntactically the same, as the first is targeted at understandability, while the second is targeted at implementation. To preserve “round-trip” capability, an implementation could emit annotations with the ELM using the extension mechanism of the base _Element_ class to provide the original source CQL.

In general, the mapping from ELM to CQL is simply the opposite of the mapping described in the previous section. However, there are several special-purpose operators that are only defined in ELM which are used to simplify query implementation. For completeness, the mappings from those operators to CQL are described here to ensure that any given ELM document could be translated to CQL.

The examples in the following section will make use of the following expression definitions:

``` xml
<def name="List1">
  <expression xsi:type="List">
    <element xsi:type="Tuple">
      <element name="X">
        <value xsi:type="Literal" valueType="xs:int" value="1"/>
      </element>
    </element>
    <element xsi:type="Tuple">
      <element name="X">
        <value xsi:type="Literal" valueType="xs:int" value="2"/>
      </element>
    </element>
    <element xsi:type="Tuple">
      <element name="X">
        <value xsi:type="Literal" valueType="xs:int" value="3"/>
      </element>
    </element>
  </expression>
</def>
<def name="List2">
  <expression xsi:type="List">
    <element xsi:type="Tuple">
      <element name="Y">
        <value xsi:type="Literal" valueType="xs:int" value="1"/>
      </element>
    </element>
    <element xsi:type="Tuple">
      <element name="Y">
        <value xsi:type="Literal" valueType="xs:int" value="2"/>
      </element>
    </element>
    <element xsi:type="Tuple">
      <element name="Y">
        <value xsi:type="Literal" valueType="xs:int" value="3"/>
      </element>
    </element>
  </expression>
</def>
```

### ForEach

The _ForEach_ operator in ELM takes an argument of type list and returns a list with an element for each source element that is the result of evaluating the _element_ expression. For example:

``` xml
<expression xsi:type="ForEach">
  <source xsi:type="ExpressionRef" name="List1"/>
  <element xsi:type="Property" path="X"/>
</expression>
```

This expression returns the list of integers from the List1 expression. Although there is no direct counterpart in CQL, this expression can be represented using the _query_ construct. The source for the _ForEach_ is used as the primary query source, and the _element_ expression is represented using the _return-clause_:

``` cql
List1 A return A.X
```

### Times

The _Times_ operator in ELM computes the Cartesian-product of two lists. Again, although there is no direct counterpart in CQL, the _query_ construct can be used to produce an equivalent result:

``` xml
<expression xsi:type="Times">
  <source xsi:type="ExpressionRef" name="List1"/>
  <source xsi:type="ExpressionRef" name="List2"/>
</expression>
```

Assuming List1 and List2 are defined as specified above, the equivalent CQL is a multi-source query with a source for each operand in the _Times_, and a return clause that builds the resulting tuples:

``` cql
from List1 A, List2 B
  return { X: A.X, Y: B.Y }
```

### Filter

The _Filter_ operator in ELM filters the contents of a list, returning only those elements that satisfy the expression defined in the _condition_ element. For example:

``` xml
<expression xsi:type="Filter">
  <source xsi:type="ExpressionRef" name="List1"/>
  <condition xsi:type="Equal">
    <operand xsi:type="Property" path="X">
    <operand xsi:type="Literal" valueType="xs:int" value="1"/>
  </condition>
</expression>
```

Again, although no direct counterpart in CQL exists, the _where_ clause of the _query_ construct provides the equivalent functionality:

``` cql
List1 A where A.X = 1
```

{: #sort-1}
### Sort

The _Sort_ operator in ELM sorts the contents of a list. For example:

``` xml
<expression xsi:type="Sort">
  <source xsi:type="ExpressionRef" name="List1"/>
  <by xsi:type="ByColumn" path="X" direction="desc"/>
</expression>
```

Again, the CQL query construct provides the equivalent functionality:

``` cql
List1 A sort by X desc
```
