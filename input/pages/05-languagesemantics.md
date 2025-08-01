{::options toc_levels="1..6"/}

This section contains more detailed information relating to the intended semantics of the Clinical Quality Language. These topics are specifically relevant for readers interested in building translation, semantic validation, or evaluation applications for CQL.

Note that the semantics are described here with reference to the representation defined by the ELM, but because CQL syntax is equivalent to ELM, the semantics apply to CQL as well.

### Clinical Data Retrieval in Quality Artifacts

This section discusses the problem of clinical data retrieval in the clinical quality space in general, and how the problem is addressed in the CQL specification.

#### Defining Clinical Data

The problem of determining what data is required in the evaluation of an artifact containing arbitrary queries against the data model is equivalent to the problem of query containment from database theory. This problem is known to be undecidable for arbitrary queries of the relational algebra, but is also shown to be both decidable and equivalent to the problem of query evaluation for the restricted class of conjunctive queries (Foundations of Databases, Abiteboul, Hull, Vianu).

In the health quality domains of measurement and improvement, this problem is further complicated by the problem of terminology mapping. The meaning of a particular clinical statement is represented with a vocabulary consisting of codes which determine the type of statement being represented. For example, a diagnosis clinical statement may be classified using the ICD-10 vocabulary, identifying the specific diagnosis represented.

In order for health quality artifacts to operate correctly, the meaning of each clinical statement, as identified by the vocabularies involved, must be preserved. However, this meaning is often represented in different vocabularies in different systems. A mapping between the vocabularies is therefore required in order to facilitate expression and evaluation of the artifact.

In addition, clinical data is represented in differing schemas across various clinical data sources, and must therefore be mapped structurally into the clinical data model used by an artifact.

These problems collectively constitute what is referred to as the “curly braces problem” in the Arden space. This problem arises because of the difficulty in defining the structural and semantic aspects of the data involved.

The solution to this problem proposed by the CQL specification is to create a well-defined and relatively simple interface between the clinical data provided by data sources, and the usage of that data within the artifact.

First, all clinical data within a CQL artifact is represented using a common, standard data model. This allows content to be authored without regard to the specific data models used by various clinical data sources.

Second, all references to clinical data within a quality artifact are represented using a specific type of expression that only allows a well-defined set of clinically relevant criteria to be used to reference the data. The purpose of this restriction is two-fold: First, it allows the data required for evaluation to be determined solely by inspection of the artifact. And second, it allows for easy and reliable implementation of the interface between the evaluation engine and the clinical data source, because the criteria used to request information from the clinical data source are simple and well-defined.

Third, by using standard terminologies within this data interface, the CQL specification can guarantee that any given clinical statement referenced in an artifact has the same meaning as the data that is provided to the artifact from the clinical data source. At a high level, this is the terminology problem; ensuring that the vocabularies used within the artifact are accurately mapped to the vocabularies used by the clinical data source.

These three motivating factors inform the design of the _retrieve_ expression (_Retrieve_ element in ELM) used within the CQL specification.

#### Conformance Levels

Even though CQL and ELM are intended to be used with a standard data model, there are many possibilities for variance in the way that data is provided, even within a particular model. This problem leads to the potential for artifacts to reference properties within the model that may or not be provided within a given specific instance of clinical data. To address this potential problem, the retrieve elements within ELM specify not only the type of the data (meaning the specific model type being retrieved), but optionally a template, or profile identifier that further constrains the data that is expected in a given retrieve. If a template identifier is provided, then the retrieve expression is expected to return only data that matches the constraints in the given template.

For example, consider the following retrieve element:

```xml
<operand xsi:type="Retrieve"
  dataType="quick:Condition"
  templateId="qicore-condition"
  codeProperty="code">
  <codes xsi:type="ValueSetRef" name="Other Female Reproductive Conditions"/>
</operand>
```

In this example, the data type is specified as "<span class="id">quick:Condition</span>", indicating that the result of the retrieve is a list of Condition instances. In addition, each instance must conform to the profile defined by the identifier "<span class="id">qicore-condition</span>".

To help communicate validity of an artifact for a specific use, this specification defines two conformance levels related to this use of templates:

##### Strict Conformance

A quality artifact can be said to be strictly conforming if all references to clinical statement model properties (elements and attributes of model types) within the artifact are explicitly constrained by the templates used in the retrieves.

##### Loose Conformance

A quality artifact can be said to be loosely conforming if the artifact references properties that are not explicitly constrained by the templates used in the retrieves. This is not to say that the artifact is necessarily invalid, just that the instances of clinical data provided to the retrieve may or may not contain the elements referenced by properties within the artifact.

##### Language Capabilities

Because of the scope of CQL, and the various implementation options for different features of the language, implementations may find it useful to advertise the language capabilities they support. The following list is a summary of language capabilities of CQL:

* Data Model and Type Support
    * Decimal precision and scale
    * Datetime precision and scale
    * UCUM unit conversion support
    * Regex dialect
    * Supported data models
* Compatibility Level
    * 1.3
        * System.Ratio
        * System.Date
        * Expand operator
        * FHIRPath Support
    * 1.4
        * Precision operators for Decimal and Date/Time types
        * Model-defined contexts
        * Library namespaces
        * Related-context retrieves
        * Unit conversion support
    * 1.5
        * Modular arithmetic for quantities
        * Expand a single interval
        * Aggregate clause
        * Include retrieves
        * Searchpath retrieves
        * Id retrieves
        * System.Long
        * System.Vocabulary
        * System.CodeSystem
        * System.ValueSet
* System Data Types
* Operators
    * Logical Operators
    * Type Operators
    * Nullological Operators
    * Comparison Operators
    * Arithmetic Operators
    * String Operators
    * Date and Time Operators
    * Interval Operators
    * List Operators
    * Aggregate Functions
    * Clinical Operators
    * Diagnostic Operators
* Queries
    * Single source
    * Relationships
    * Let clause
    * Where clause
    * Return clause
    * Aggregate clause
    * Multi source
* Retrieve
    * Unfiltered context
    * Terminology-based retrieve
    * Valueset terminology target
    * CodeSystem terminology target
    * Code terminology target
    * Searchpath retrieve
    * Include retrieve
    * Related-context retrieve
    * Profile-based retrieve

Using these capabilities to advertise support, and enabling implementations to declare usage of these features within CQL, will allow authors and implementers to understand run-time implications of the CQL they are creating and using.

##### Version Differences

To help implementers correctly support version differences and backwards (and to the extent possible, forwards) compatibility, the following sections describe version-specific behavior differences in CQL operators, functions, and language constructs.

> This is not an exhaustive list of changes to the specification, it is a summary of behavior changes between versions to help implementers deal with version-specific implementation issues. For a complete listing of changes to the specification, refer to the version history and version-specific change logs.
{: .note-warning}

###### Context Support

In the initial version of CQL, the name <span class="id">Population</span> was used to describe an unspecified, or unfiltered context. Beginning in 1.4, the context name was changed to <span class="id">Unfiltered</span>. Note that the ballot version was <span class="id">Unspecified</span>. As a result, implementations may choose to support all three names as synonyms for the Unfiltered context.

###### CalculateAge Functions

With the introduction of the <span class="id">Date</span> type in 1.3, <span class="id">Date</span> overloads of the CalculateAge and CalculateAgeAt operators were introduced.

###### Comparisons

In 1.3, <span class="id">Date</span>, <span class="id">Time</span>, and <span class="id">DateTime</span> comparison operator semantics were changed to return null only if the comparands have different precisions and the comparison cannot be resolved within the precision specified for both comparands.

###### Conversions

In 1.3, the implicit conversion from <span class="kw">List</span><span class="sym">&lt;</span><span class="id">Code</span><span class="sym">></span> to <span class="id">Concept</span> was changed to be explicit.

In 1.3, implicit conversions from <span class="id">Integer</span> and <span class="id">Decimal</span> to <span class="id">Quantity</span> were added.

In 1.3, <span class="id">Date</span> and <span class="id">Ratio</span> overloads of <span class="id">ToString</span> were added.

In 1.4, unit conversion was added for quantities.

In 1.4, the <span class="id">ToDateTime</span>(<span class="id">Date</span>) function was changed to leave the time components unspecified in the resulting <span class="id">DateTime</span> value, rather than setting the time components to zero.

In 1.4, a <span class="id">Ratio</span> overload of <span class="id">ToQuantity</span> was added.

In 1.4, the <span class="id">ConvertQuantity</span> operator now throws an exception if the requested unit conversion is not supported by the implementation.

In 1.5, a <span class="id">Long</span> overload of <span class="id">ToString</span> was added

###### Collapse and Expand Operators

In 1.3, a <span class="kw">per</span> clause was added to the <span class="id">Collapse</span> operator.

In 1.5, an <span class="id">Interval</span> overload was added to the <span class="id">Expand</span> operator

###### Equality Semantics

In 1.3, <span class="id">Tuple</span> equality semantics were changed to return <span class="kw">null</span> only if the comparands have different elements specified.

In 1.3, <span class="id">Date</span>, <span class="id">Time</span>, and <span class="id">DateTime</span> equality semantics were changed to return null only if the comparands have different precisions and equality cannot be resolved within the precision specified for both comparands.

###### Equivalence Semantics

In 1.3, a <span class="id">Concept</span> overload was added to the <span class="id">Equivalence</span> operator (<span class="kw">~</span>).

###### Exists Operator

In 1.3, the <span class="kw">exists</span> operator was changed to ignore <span class="kw">null</span> elements in the input (i.e. a list with only <span class="kw">null</span> elements is considered empty).

###### List Membership and Duplicate Detection

In 1.3, List membership (i.e. <span class="kw">in</span> and <span class="kw">contains</span>) and duplicate detection (e.g. via the <span class="kw">distinct</span> operator) were changed to use equality semantics, rather than equivalence semantics.

In 1.3, a <span class="id">List</span><span class="sym">&lt;</span><span class="id">Code</span><span class="sym">></span> overload was added to the <span class="kw">in</span> operator.

In 1.3, singleton overloads were added for the <span class="kw">includes</span> and <span class="kw">included in</span> operators.

In 1.4, List operators were changed to treat <span class="kw">null</span> elements as equal for the purposes of membership determination.

###### Media Types

In 1.5, media types for CQL identifiers (<span class="id">text/cql-identifier</span>) and expressions (<span class="id">text/cql-expression</span>) were added. Note that these were introduced as <span class="id">text/cql.identifier</span> and <span class="id">text/cql.expression</span> in the ballot, so implementations may choose to accept both forms as valid to support backwards compatibility with the ballot specifiers. However, only the dash versions are officially registered IANA media types.

###### Query Construct

In 1.5, an <span class="kw">aggregate</span> clause was introduced into the query construct.

###### Quantity Arithmetic

In 1.4, <span class="id">Quantity</span> overloads of the <span class="kw">div</span> and <span class="kw">mod</span> operators were added.

###### Timezone Keyword

In 1.4, the <span class="kw">timezone</span> keyword was changed to <span class="kw">timezoneoffset</span> and the <span class="kw">timezone</span> element was removed from the <span class="id">Time</span> type. However, to ensure backwards-compatibility of ELM, the <span class="kw">timezone</span> element was retained in the ELM schema, allowing implementations to simultaneously support 1.4 and 1.3 ELM.

###### Vocabulary Types

In 1.5, a <span class="id">Vocabulary</span> abstract type with two subtypes, <span class="id">CodeSystem</span> and <span class="id">ValueSet</span>, were introduced to support run-time representation of vocabulary references. In addition, the result type of a reference to a value set declaration was changed from <span class="id">List</span><span class="sym">&lt;</span><span class="id">Code</span><span class="sym">></span> to <span class="id">ValueSet</span>. To ensure this is not a backwards-incompatible change, 1.5 also introduced an <span class="id">ExpandValueSet</span> function to support explicit expansion of value sets, and an implicit conversion from <span class="id">ValueSet</span> to <span class="id">List</span><span class="sym">&lt;</span><span class="id">Code</span><span class="sym">></span>. In the ELM, the <span class="id">preserve</span> attribute was added to the <span class="id">ValueSetRef</span> node to enable implementations to support both 1.4 and 1.5 ELM by detecting whether a <span class="id">ValueSetRef</span> should be expanded or not.

#### Artifact Data Requirements

Because of the way data access is modeled within CQL, the data requirements of a particular artifact can be clearly and accurately defined by inspecting only the _Retrieve_ expressions defined within the artifact. The following table broadly describes the data defined by each retrieve:

<a name="table-5-a"></a>

|Item |Description
|----|----
|**Clinical Data Type** |The type of clinical data to be retrieved. This includes both the data type and the template identifier.
|**Context** |The context type and value. Only clinical data matching the context (based on the context path) will be retrieved.
|**Id** |Optionally, the id of the data to be retrieved (based on the id path).
|**Codes** |The set of codes defining the clinical data. Only clinical data with matching codes (based on the code path of the retrieve, and the operation specified by the comparator) in the set will be retrieved. If no codes are specified, clinical data with any code will be retrieved. If a value set property is specified, it refers to a property of the clinical data that identifies a value set, and only clinical data matching the value set for the retrieve will be retrieved.
|**Date Range** |The date range for clinical data. Only data within the specified date range (based on the date range path of the retrieve) will be retrieved. If no date range is specified, clinical data of any date will be retrieved.
|**Includes** |Include elements for the clinical data. For data models that define relationships between data types, this element allows data matching the include relationships to be returned as part of the retrieve as well. Implementations that support this capability must ensure that included data returned is accessible via the related retrieve statements.
{: .grid .table .table-striped}

Table 5‑A - Description of the data defined by each retrieve

These criteria are designed to allow the implementation environment to communicate the data requirements for an artifact, or group of artifacts, to a consumer to allow the consumer to gather all and only the relevant clinical information for transport to the evaluation environment. This supports the near-real-time clinical decision support scenario where the evaluation environment is potentially separate from the medical records system environment.

To support further reducing the overall size of data required to be transported, the following steps can be taken to combine retrieve descriptors that deal with the same type of clinical data.

First, create a retrieve context for each unique type of retrieve using the retrieve data type (and context type, template identifier, code path, and date path) for each retrieve. Note that if the determination here involves dynamic information, the retrieve is not considered “initial” and could result in additional data being requested by the engine in order to complete the evaluation. An implementation environment may opt to restrict artifacts to only those that contain statically determined data requirements.

Next, for each retrieve, add the codes to the matching retrieve context (by data type), recording the associated date range, if any, for each code. Note that the empty set of codes should be represented as the single code “ALL” for the purposes of this method. As date ranges are recorded, they must be merged so that for each code in each retrieve context, no two date range intervals overlap or meet. If the retrieve has any includes, they are added to the retrieve context.

Once the date ranges for each code within each unique retrieve context are determined, the unique set of date ranges for all codes is calculated, accumulating the set of associated codes. Each unique date range for the context then results in a final descriptor. As part of this process, the “ALL” placeholder code is replaced with the empty set of codes.

This process produces a set of clinical data descriptors with the following structure:

<a name="table-5-b"></a>

|Property |Description
|----|----
|**Clinical Data Type** |The type of clinical data required (including context type, template identifier, code path and date path)
|**Codes** |The set of applicable codes, possibly empty (meaning all codes)
|**Date Range** |The applicable date range, possibly empty (meaning all dates)
|**Includes** |Any includes, specifying additional related data to be retrieved
{: .grid .table .table-striped}

Table 5‑B - The structure of clinical data descriptors

Collectively, these descriptors then represent the minimum initial data requirements for the artifact, with any overlapping requests for the same type of data collapsed into a single request descriptor.

Note that for the purposes of this method, the notion of the Clinical Data Type must be inclusive of the attributes used for filtering the codes and date ranges. For example, a retrieve of _Condition_ data filtered by _code_ must be considered separately from a retrieve of _Condition_ data filtered by _severity_.

In addition to being used to describe the initial data requirements, this same process can be used to collapse additional data retrieves that are encountered as part of further evaluation of the artifact.

##### Retrieve Paths
The retrieve construct includes several paths to the elements of the clinical data:

* **id**: The "key" element, an element that provides a unique identifier for the data
* **code**: The "code" element, a terminology-valued element
* **date**: A date-valued element
* **context**: The "context key" element, an element that identifies the relationship to the context

Each of these paths can be specified in terms of a _property_, meaning the actual name of the element, or a _path_, meaning the name of a search path, such as an index, that can be used to access the data. Both mechanisms are allowed to ensure that data models that define search paths using indexes that do not necessarily match the data elements can be supported.

For example, consider a data model that defines an `Observation`:

```cql
Observation
{
  id: string,
  code: Concept,
  value: Quantity,
  component: List<ObservationComponent>
}

ObservationComponent
{
  code: Concept,
  value: Quantity
}
```

To allow searching by component codes, consider further that this data model defines a search path, called `component-code` that allows searching for observations that have a component with a given code. In this case, `component-code` is not an element of Observation, or of ObservationComponent, so it's insufficient to specify a code property. To support this capability, the `codeSearch` element of the retrieve is used:

```xml
<operand xsi:type="Retrieve"
  dataType="fhir:Observation"
  codeSearch="component-code">
  <codes xsi:type="ValueSetRef" name="Urine Drug Screening"/>
</operand>
```

### Expression Language Semantics

In order to completely specify the semantics of the expression logic defined by CQL, the intended execution model for expressions must be clearly defined. The following sections discuss the conceptual components of the expression language, and how these components are defined to operate.

{: #data-model-1}
#### Data Model

The data model for CQL provides the overall structure and definition for the types of operations and capabilities that can be represented within the language. Note that the schema itself is layered into a core expression schema, and a more specific, clinical expression schema. The expression schema deals with defining the core operations that are available without respect to any specific model. The clinical expression schema then extends those operations to include references to clinical data.

Note that although the expression language deals with various categories of types, these are only conceptually defined within the expression language schema. There is no expectation within the core expression language that any particular data model be used, only that whatever concrete data model is actually used can be concretely mapped to the type categories defined within CQL. Because these type categories are extremely broad, this allows the CQL expression language component to be used with a large class of concrete data models without modifying the underlying specification.

{: #values-1}
##### Values

A _value_ within CQL represents some piece of data. All values are of some _type_, which designates what operations can be performed on the value. There are four categories of types within CQL:

1.  Simple types – Types representing simple values such as strings, integers, dates, and decimals
2.  Structured types – Types representing composite values consisting of sets of named properties, each of which has a declared type, that may or may not have a current value of that type.
3.  Collection types – Types representing lists of values of some declared type
4.  Interval types – Types representing an interval of some declared type, called the _point_ type
5.  Choice types - Types representing values from a set of possible types

##### Simple Types

Simple types allow for the representation of simple, atomic types, such as integers and strings. For example, the value **5** is a value of type _Integer_, meaning that it can be used in operations that require integer-valued input such as addition or comparison.

Note that because CQL defines a set of basic supported types, an implementation must map these types to the equivalent types in the selected data model. Ideally, this mapping would occur as part of the data access layer to isolate the mapping and minimize complexity.

##### Structured Types

Structured types allow for the representation of composite values. Typically, these types correspond to the model types defined in the clinical data model used for the artifact. Structured types are defined as containing a set of named properties, each of which are of some type, and may have a value of that type.

As with simple types, the core expression layer does not define any structured types, it only provides facilities for constructing values of structured types and for operating on structured values.

##### Collection Types

Collection types allow for the representation of lists and sets of values of any type. All the values within a collection are expected to be of the same type.

Collections may be empty, and are defined to be 0-based for indexing purposes.

##### Interval Types

Interval types allow for the representation of ranges over some point type. For example, an interval of integers allows the expression of the interval 1 to 5. Intervals can be open or closed at the beginning and/or end of the interval, and the beginning or end of the interval can be unspecified.

The core expression layer does not define any interval types, it only provides facilities for constructing values of interval types, and for operating on intervals.

##### Choice Types

Choice types allow for the representation of elements that may be any of a possible list of types. A given value at run-time will always be of a specific type, so a choice type is only a compile-time construct that allows for data models that contain elements with multiple possible types, or for the results of expressions where the result may be any of a possible set of types (e.g. a union of different types).

#### Language Elements

The expression language represented by the ELM is defined as an Abstract Syntax Tree. Whereas a traditional language would have syntax and require lexical analysis and parsing, using the ELM exclusively allows expressions to be represented directly as trees. This removes potential ambiguities such as operator order precedence, and makes analysis and processing of the expressions in the language much easier.

Concretely, this is accomplished by defining the language elements as classes in a UML model. Each language element is represented by a type in the UML model. For example, the _Literal_ class represents the appearance of a literal expression, and has attributes for specifying the type of the literal, as well as its actual value.

Arguments to operations are represented naturally using the hierarchical structure of the model. For example, the _Add_ operator is represented as a _BinaryExpression_ descendant, indicating that the operation takes two arguments, each of which is itself an expression.

This general structure allows expressions of arbitrary complexity to be built up using the language elements defined in the schema. Essentially, the language consists of only two kinds of elements: 1) Expressions, and 2) Expression Definitions (including Functions).

Each expression returns a value of some type, and an expression or function definition allows a given expression to be defined with an identifier so that it can be referenced in other expressions.

These expressions and expression definitions are then used throughout the CQL specification wherever logic needs to be defined within an artifact.

#### Semantic Validation

Semantic Validation of an expression within CQL is the process of verifying that the meaning of the expression is valid. This involves determining the type of each expression, and verifying that the arguments to each operation have the correct type.

This process proceeds as follows:

The graph of the expression being validated is traversed to determine the result type of each node. If the node has children (operands) the type of each child is determined in order to determine the type of the node. The following table defines the categories of nodes and the process for determining the type of each category:

<a name="table-5-c"></a>

|Node Category |Type Determination
|----|----
|**Literal** |The type of the node is the type of the literal being represented.
|**Property** |The type of the node is the declared type of the property being referenced.
|**ParameterRef** |The type of the node is the parameterType of the parameter being referenced.
|**ExpressionRef** |The type of the node is the type of the expression being referenced.
|**Retrieve** |The type of the node is a list of the type of the data being requested.
|**FunctionRef/**<br/>**Operator** |Generally, the type of the node is determined by resolving the type of each operand, and then using that signature to determine the resulting type of the operator.
|**ValueSetRef** |The type of the node is a list of codes.
|**Query** |If the query has a return clause, the result is a list of the type of the return expression. If the query has an aggregate clause, the result is the type of the aggregate expression. Otherwise, the result type is determined by the source of the query.
|**AliasRef** |The type of the node is the element type of the type of the query source referenced by the alias.
|**QueryLetRef** |The type of the node is the type of the referenced expression defined within the query scope.
{: .grid .table .table-striped}

Table 5‑C - The categories of nodes and the process for determining the type of each category

During validation, the implementation must maintain a stack of symbols that track the types of the objects currently in scope. This allows the type of scope-sensitive operators such as Current and Property to be determined. Refer to the [Execution Model](#execution-model) (5.2.4) section for a description of the evaluation-time stack.

Details for the specifics of type determination for each operator are provided with the documentation for those operators.

#### Execution Model

All logic in CQL is represented as _expressions_. The language is pure functional, meaning no operations are allowed to have side effects of any kind. An expression may consist of any number of other expressions and operations, so long as they are all combined according to the semantic rules for each operation as described in the [Semantic Validation](#semantic-validation) (5.2.3) section.

Because the language is pure functional, every expression and operator is defined to return the same value on every evaluation within the same artifact evaluation. In particular this means:

1.  All clinical data returned by request expressions within the artifact must return the same set on every evaluation. An implementation would likely use a snapshot of the required clinical data in order to achieve this behavior.
2.  Invocations of non-deterministic operations such as Now() and Today() are defined to return the timestamp associated with the evaluation request, rather than the clock of the engine performing the evaluation.

Once an expression has been semantically validated, its return type is known. This means that the expression is guaranteed to return either a value of that type, or a _null_, indicating the evaluation did not result in a value.

In general, operations are defined to result in null if any of their arguments are null. For example, the result of evaluating 2 <span class="sym">+</span> null is null. In this way, missing information results in an unknown result. There are exceptions to this rule, notably the logical operators, and the null-handling operators. The behavior for these operators (and others that do not follow this rule) are described in detail in the documentation for each operator.

Evaluation takes place within an execution model that provides access to the data and parameters provided to the evaluation. Data is provided to the evaluation as a set of lists of structured values representing the clinical information. In order to be represented in this data set, a given structured value must be a _cacheable_ item. A cacheable item must have the following:

<a name="table-5-d"></a>

|Property |Description
|----|----
|**Identifier** |A property or set of properties that uniquely identify the item
|**Codes** |A code or list of codes that identify the associated clinical codes for the item
|**Date** |A date time defining the clinically relevant date and/or time of the item
{: .grid .table .table-striped}

Table 5‑D - The required properties for a cacheable item

Note that the "must have" here is referring to the fact that structures to be tracked in this way must have these elements, not that the instances of those structures must have values for them.

Note that the _context_ associated with each ExpressionDef is important here, as it provides a filter on the set of data returned as described by the model. For example, in the `Patient` context, only data for a specific patient should be returned, and the unique id of that patient must be provided by the evaluation environment. This means in particular that the relationship of data elements in the model to the context must be understood and managed by the implementation so that only data related to the current context is provided through the data access layer.

Evaluation consists of two phases, a _pre-processing_ phase, and an _evaluation_ phase. The pre-processing phase is used to determine the initial data requirements for a rule. During this phase any retrieve expressions in the rule are analyzed to determine what data must be provided to the evaluation in order to successfully complete a rule evaluation. This set of data descriptors is produced using the method described in the [Artifact Data Requirements](#artifact-data-requirements) (5.1.3) section. This means in particular that only retrieves whose Codes and DateRange expressions are compile-time evaluable should be considered to determine initial data requirements. This means that these expressions may not reference any clinical information, though they are allowed to reference parameter values.

During the evaluation phase, the result of the expression is determined. Conceptually, evaluation proceeds as follows:

The graph of the expression being evaluated is traversed and the result of each node is calculated. If the node has children (operands), the result of each child is evaluated before the result of the node can be determined. The following table describes the general categories of nodes and the process of evaluation for each:

<a name="table-5-e"></a>

|Node Category |Evaluation
|----|----
|**Literal** |The result of the node is the value of the literal represented.
|**FunctionRef/Operation** |The result of the node is the result of the operation described by the node given the results of the operand nodes of the expression.
|**Retrieve** |The result of the node is the result of retrieving the data represented by the retrieve—i.e., a list of structured values of the type defined in the retrieve representing the clinical information being retrieved.
|**ExpressionRef** |The result of the node is the result of evaluating the referenced expression.
|**ParameterRef** |The result of the node is the value of the referenced parameter.
|**ValueSetRef** |The result of the node is the expansion set of the referenced value set definition. Note that in the case of the InValueSet operator specifically, the expansion set need not be materialized; the membership test can be passed to a terminology service using only the valueset definition information.
{: .grid .table .table-striped}

Table 5‑E - The general categories of nodes and the process of evaluation for each

During evaluation, the implementation must maintain a stack that is used to represent the value that is currently in scope. Certain operations within the expression language are defined with a scope, and these operations use the stack to represent this scope. The following table details these operations:

<a name="table-5-f"></a>

|Operation |Stack Effect
|----|----
|**Query** |Query evaluation is discussed in detail below.
|**Filter** |For each item in the _source_ operand, the item is pushed on to the stack, the _condition_ expression is evaluated, and the item is popped off of the stack.
|**ForEach** |For each item in the _source_ operand, the item is pushed on to the stack, the _element_ expression is evaluated, and the item is popped off of the stack.
|**Aggregate** |For each item in the _source_ operand, the item is pushed on to the stack, the _expression_ is evaluated, and the item is popped off of the stack.
{: .grid .table .table-striped}

Table 5‑F - The operations within the expression language are defined with a scope, and the stack to represent this scope

The _scope_ attribute of these operators provides an optional name for the item being pushed on to the stack. This name can be used within the **Current** and **Property** expressions to determine which element on the stack is being accessed. If no scope is provided, the top of the stack is assumed.

Details for the evaluation behavior of each specific operator are provided as part of the documentation for each operator.

### Query Evaluation

In general, query evaluation can be performed in many different ways, especially when queries involve large numbers of sources. Rather than address the many ways queries could be evaluated, the intent of this section is to describe the expected semantics for query evaluation, regardless of how the underlying implementation actually executes any given query.

The outline of the process is:

* Evaluate the sources
* For each item in the source
    * evaluate any let clauses within the query
    * evaluate each with or without clause in the query
    * evaluate the where clause, if present
    * evaluate the return clause, if present
    * evaluate the aggregate clause, if present, storing the result as an accumulator available for reference in the next iteration
* Sort the results if a sort clause is present

The following sections discuss each of these steps in more detail.

#### Evaluate Sources

The first step in evaluation of a given query is to establish the query sources. Conceptually, this step involves generating the cartesian product of all the sources involved. In a single-source query, this is simply the source. But for a multi-source query, the evaluation needs to be performed for every possible combination of the sources involved.

How this actually occurs is up to the specific implementation, but note that the evaluation must still be able to reference components originating from each individual source using the alias for the source defined in the query. A simple solution to allowing this is to define the query source internally as a list of tuples, each with an element for each source whose value is the tuple from that source. This list is then simply populated with the cartesian product of all sources, and alias access within the rest of the query can be implemented as tuple-element access.

Note that although this discussion generally treats sources as lists, query sources in general may be singleton values as well.

#### Iteration

Once the source for the query has been established, the iterative clauses must be evaluated for each element of the source, in order, as described in the following sections.

##### Let Clause

The let clause, if present, allows a CQL author to introduce expression definitions scoped to the query scope. For each definition specified in the let clause, the result of the expression is evaluated and made available within the query scope such that subsequent clauses can access the value. Note that an implementation may opt for lazy evaluation, saving the cost of evaluating an expression that is never actually referenced.

##### With Clause

Each with clause present in the query acts as a filter to remove items from the result if they do not satisfy the conditions of the with clause. Evaluation proceeds by introducing the related source into the query scope and evaluating the “such that” condition of the with clause for each element of the introduced source. If no element of the introduced source satisfies the such that condition, the current row of the query source is filtered out of the result.

Note that because this is a positive existence condition, the test can stop after the first positive result. Only in the case of a negative result would all the elements of the introduced source need to be processed.

##### Without Clause

Each without clause present in the query acts as a filter to remove items from the result if they satisfy the conditions of the without clause. This is the opposite of the with clause. Evaluation proceeds the same way as a with clause, except that an element from the query source will only pass the filter if there a no rows from the introduced source that satisfy the conditions of the without clause.

##### Where Clause

The where clause, if present simply determines whether each element should be included in the result. If the condition evaluates to true, the element is included. Otherwise, the element is excluded from the result.

##### Return Clause

The return clause, if present, defines the final shape of each element produced by the query, as well as whether or not to eliminate duplicates from the result. If distinct is specified as part of the return clause, any duplicates must not appear in the result set. The expression defined in the return clause is evaluated and the result is added to the output. If neither all or distinct is specified, distinct is the default behavior.

##### Aggregate Clause
The aggregate clause, if present, defines the final result of the query in terms of an expression that is evaluated for each item. If distinct is specified, it is applied to the items in the query prior to aggregation. For aggregation, an accumulator tracking the result of the aggregation is created, and named according to the identifier element of the aggregate clause. If a starting expression is specified, the accumulator is initialized to the result of evaluating the starting expression. For each item in the query, the aggregation expression is evaluated, and the result replaces the current value of the accumulator. Once the iteration is complete, the accumulator is returned as the result of the query.

#### Sort

After the iterative clauses are executed for each element of the query source, the sort clause, if present, specifies a sort order for the final output. This step simply involves sorting the output of the iterative steps by the conditions defined in the sort clause. This may involve sorting by a particular element of the result tuples, or it may simply involve sorting the resulting list by the defined comparison for the data type (for example, if the result of the query is simply a list of integers).

#### Implementing Query Evaluation

It is worth noting that the implementation of query evaluation can be simplified by decomposing the query into a set of more primitive operations. For example, the following operations are sufficient to evaluate any query of CQL:

* ForEach
* Aggregate
* Times
* Filter
* Distinct
* Sort

The following sketch details an implementation plan for any query using these primitives:

1.  For each query source beyond the first, use a Times operation to produce a result with a tuple for each combination, named the same as the alias used to introduce the source in the query.
2.  If the let clause is present, use a ForEach operation to introduce a tuple element for each defined expression.
3.  For each with clause, use a Filter and express the with in terms of an Exists in the condition of the Filter.
4.  For each without clause, use a Filter and express the without in terms of a Not Exists in the condition of the Filter.
5.  If the return clause is specified, use a ForEach to produce the result of the return. If the return clause specifies Distinct, also attach a Distinct operation to the result.
6.  If the aggregate clause is specified, use an Aggregate to produce the result of the aggregation.
7.  If the sort clause is specified, use a Sort operation to produce the final sorted output.

Using this sketch, the evaluation of a query can be performed by pipelining the query into a series of more primitive operations that can be implemented more easily. This approach also lends itself to translation and/or optimization if necessary.

### Timing Calculations

This section discusses the precise semantics for the representation of date and time values within CQL, as well as the calculation of date and time arithmetic. The discussion in this section assumes fully-specified date time values. The next section will discuss the implications of partially-specified date and time values.

#### Definitions

This section provides precise definitions for the terms involved in dealing with date and time values. These definitions are based on the ISO 8601:2004 standard for the representation of date and time values.

<a name="table-5-g"></a>

|Term |Definition |Notes
|----|----|----
|**Date interval** |Part of the time axis bounded by two Date values. |A Date interval comprises all Date values between the two boundary Dates and, unless otherwise stated, the boundary Date values themselves.
|**DateTime interval** |Part of the time axis bounded by two DateTime values. |A DateTime interval comprises all DateTime values between the two boundary DateTimes and, unless otherwise stated, the boundary DateTime values themselves.
|**Duration** |Quantity attributed to a DateTime interval, the value of which is equal to the difference between the time points of the final instant and the initial instants of the time interval. |In case of discontinuities in the time scale, such as a leap second or the change from winter time to summer time and back, the computation of the duration requires the subtraction or addition of the change of duration of the discontinuity.
|**Nominal duration** |Duration expressed in years, months, or days. |The duration of a calendar year, a calendar month, or a calendar day depends on its position in the calendar. Therefore, the exact duration of a nominal duration can only be evaluated if the duration of the calendar years, calendar months, or calendar days used is known.
|**Second** |Base unit of measurement of time in the SI as defined by the International Committee of Weights and Measures. |
|**Millisecond** |Unit of time equal to 0.001 seconds. |
|**Minute** |Unit of time equal to 60 seconds. |
|**Hour** |Unit of time equal to 60 minutes. |
|**Day** |Unit of time equal to 24 hours. |
|**Calendar day** |Time interval starting at midnight and ending at the next midnight, the latter being also the starting instant of the next calendar day. |A calendar day is often also referred to as a day.<br/>The duration of a calendar day is 24 hours, except if modified by:<br/>* The insertion or deletion of leap seconds, by decision of the International Earth Rotation Service (IERS), or<br/>* The insertion or deletion of other time intervals, as may be prescribed by local authorities to alter the time scale of local time.
|**Day** |Duration of a calendar day. |The term “day” applies also to the duration of any time interval which starts at a certain time of day at a certain calendar day and ends at the same time of day at the next calendar day.
|**Calendar month** |Time interval resulting from the division of a calendar year into 12 time intervals, each with a specific name and containing a specific number of calendar days. |A calendar month is often referred to as a month.
|**Month** |Duration of 28, 29, 30, or 31 calendar days, depending on the start and/or the end of the corresponding time interval within the specific calendar month. |The term “month” applies also to the duration of any time interval which starts at a certain time of day at a certain calendar day of the calendar month and ends at the same time of day at the same calendar day of the next calendar month, if it exists. In other cases, the ending calendar day has to be agreed on.
|**Calendar year** |Cyclic time interval in a calendar which is required for one revolution of the Earth around the Sun and approximated to an integral number of calendar days. |A calendar year is also referred to as a year.<br/>Unless otherwise specified, the term designates a calendar year in the Gregorian calendar.
|**Year** |Duration of 365 or 366 calendar days depending on the start and/or the end of the corresponding time interval within the specific calendar year. |The term “year” applies also to the duration of any time interval which starts at a certain time of day at a certain calendar date of the calendar year and ends at the same time of day at the same calendar date of the next calendar year, if it exists. In other cases, the ending calendar day has to be agreed on.
|**Common year** |Calendar year in the Gregorian calendar that has 365 calendar days. |
|**Leap year** |Calendar year in the Gregorian calendar that has 366 calendar days. |
{: .grid .table .table-striped}

Table 5‑G - Definitions for the terms involved in dealing with <span class="kw">Date</span> and <span class="kw">Time</span> values

ISO 8601 postulates that duration can be expressed by a combination of components with accurate duration (hour, minute, and second) and components with nominal duration (year, month, week, and day). The standard allows for the omission of lower-level components for “reduced accuracy” applications. Following this guidance, CQL represents date and time values using the following components:

<a name="table-5-h"></a>

|Component |Type |Range |Notes
|----|----|----|----
|**Year** |Integer |[0001, 9999] |A CQL environment must be able to represent the minimum year of 0001, and a maximum year of 9999. Environments may represent dates in years before or after these years, the range specified here is the minimum required.
|**Month** |Integer |[1, 12] |Months are specified by their ordinal position (i.e. January = 1, February = 2, etc.)
|**Day** |Integer |[1, 31] |If the day specified is not present in the month (i.e. February 30<sup>th</sup>), the day value is reduced by the number of days in the given month, and the month is incremented by 1.
|**Hour** |Integer |[0, 23] |
|**Minute** |Integer |[0, 59] |
|**Second** |Integer |[0, 59] |
|**Millisecond** |Integer |[0, 999] |999 milliseconds is the maximum required precision. Note that many operations require the ability to compute the “next” or “prior” instant, and these semantics depend on the step-size of 1 millisecond, so systems that support more than millisecond precision will need to quantize to the millisecond to achieve these semantics.
|**Timezone Offset** |Real |[-13.00, 14.00] |The timezone offset is represented as a real with two digits of precision to account for timezones with partial hour differences. Note that the timezone offset is a decimal representation of the time offset, so an offset of +2:30 would be represented as +2.50.
{: .grid .table .table-striped}

Table 5‑H - The components used to represent <span class="kw">Date</span> and <span class="kw">Time</span> values in CQL

{: #datetime-arithmetic-1}
#### Date and Time Arithmetic

CQL allows time durations, represented as Quantities, to be added to or subtracted from date or time values. The result of these operations take the calendar into account when determining the correct answer. In general, when the addition of a quantity exceeds the limit for that precision, it results in a corresponding increase to the most precise field specified. The following table describes these operations for each precision:

<a name="table-5-i"></a>

|Precision |Type |Range |Semantics
|----|----|----|----
|**Year** |Integer |[0001, 9999] |The year, positive or negative, is added to the year component of the date or time value. If the resulting year is out of range, an error is thrown. If the month and day of the date or time value is not a valid date in the resulting year, the last day of the calendar month is used. For example, DateTime(2012, 2, 29, 0, 0) + 1 year = DateTime(2013, 2, 28, 0, 0). The resulting date or time value will have the same time components.
|**Month** |Integer |[1, 12] |The month, positive or negative is divided by 12, and the integer portion of the result is added to the year component. The remaining portion of months is added to the month component. If the resulting date is not a valid date in the resulting year, the last day of the resulting calendar month is used. The resulting date or time value will have the same time components.
|**Week** |Integer |[1, 52] |The week, positive or negative, is multiplied by 7, and the resulting value is added to the day component, respecting calendar month and calendar year lengths. The resulting date or time value will have the same time components.
|**Day** |Integer |[1, 31] |The days, positive or negative, are added to the day component, respecting calendar month and calendar year lengths. The resulting date or time value will have the same time components.
|**Hour** |Integer |[0, 23] |The hours, positive or negative, are added to the hour component, with each 24 hour block counting as a calendar day, and respecting calendar month and calendar year lengths.
|**Minute** |Integer |[0, 59] |The minutes, positive or negative, are added to the minute component, with each 60 minute block counting as an hour, and respecting calendar month and calendar year lengths.
|**Second** |Integer |[0, 59] |The seconds, positive or negative, are added to the second component, with each 60 second block counting as a minute, and respecting calendar month and calendar year lengths.
|**Millisecond** |Integer |[0, 999] |The milliseconds, positive or negative, are added to the millisecond component, with each 1000 millisecond block counting as a second, and respecting calendar month and calendar year lengths.
{: .grid .table .table-striped}

Table 5‑I - The <span class="kw">Quantities</span> and their precision that can be used for <span class="kw">Date</span> and <span class="kw">Time</span> calculations in CQL

### Precision-Based Timing

One of the most complex aspects of quality expression logic is dealing with timing relationships in the presence of partially-specified date and time values. This section discusses the precise semantics used by CQL to help mitigate this complexity and allow measure and decision support authors to express temporal logic intuitively and accurately, even in the presence of uncertain date and time data.

The core issue being addressed is the proper handling of temporal comparisons in the presence of varying degrees of certainty about the time at which events occur. For example, a measure is looking for the occurrence of a particular procedure within two years of the measurement start date, but an EHR records that a qualifying procedure occurred in a given year, not the month or day of the occurrence. In this scenario, the EHR must be allowed to provide as much information as it accurately has, but must not be required to provide information that is not known. This requirement means that the record will contain a date and time value, but specified only to the year precision. If the semantics for timing comparison do not take this possibility into account, the resulting comparisons may yield incorrect results.

In general, the approach taken by CQL formally defines the notion of _uncertainty_ to specify the semantics for date and time comparisons, and all the operations that rely on them. In particular, the approach described here applies to operators defined for the <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> types, the only difference between them being the precisions that must be considered. Note that the concept of uncertainty is not exposed directly in CQL or in ELM, but is defined as an implementation detail. This approach is deliberate and is taken to achieve the intuitively correct semantics without exposing the complexity involved to CQL authors and developers.

The discussion here begins by formally defining uncertainty and the semantics of operations involving uncertainty. The calculation of duration between imprecise dates is then discussed in terms of uncertainty, and then the CQL timing phrases are all defined in terms of either date and time comparison, or duration calculation. The discussion concludes with some notes on implementation of these semantics within an engine or translated environment.

#### Uncertainty

Formally, an _uncertainty_ is a closed interval over a given point type, with specific semantics defined for comparison operators. For simplicity, we use the point type Integer in the discussion that follows.

Intuitively, an uncertainty between X and Y means _some value between X and Y_. For example:

uncertainty[1, 10]

This uncertainty means _some value between 1 and 10_. Note that this representation of uncertainty assumes a continuous probability distribution along the range. In other words, the assumption is that there is no information about how likely the value is to be any particular value within the range.

Note that the special case of an uncertainty of width zero:

uncertainty[1, 1]

Must be treated as equivalent to the point value, 1 in this case.

{: #comparison-operators-2}
##### Comparison Operators

Comparison semantics for uncertainty are defined to result in the intuitively expected behavior. For example, when comparing two uncertainties for equality:

```cql
uncertainty[1, 10] = uncertainty[1, 10]
```

The above expression results in _null_, because the meaning of the statement is actually:

Is _some value between 1 and 10_ equal to _some value between 1 and 10_?

And the intuitively correct answer to that question is, _I don’t know_. However, for cases where there is no overlap between the uncertainties, the result is _false_:

```cql
uncertainty[1, 10] = uncertainty[21, 30]
```

Again, the intended semantics of this statement are:

Is _some value between 1 and 10_ equal to _some value between 21 and 30_?

And the correct answer is, _No_, because there is no possible value in either uncertainty range that could evaluate to _true_.

In the special case of equality comparisons of two uncertainties of width zero, the result is true:

```cql
uncertainty[2, 2] = uncertainty[2, 2]
```

This expression can be read:

Is _some value between 2 and 2_ equal to _some value between 2 and 2_?

And the correct answer is, _Yes_.

More precisely, given an uncertainty _A_ with range _A<sub>low</sub>_ to _A<sub>high</sub>_, and uncertainty _B_ with range _B<sub>low</sub>_ to _B<sub>high</sub>_, the comparison:

```cql
A = B
```

Is equivalent to:

```cql
if A.low <= B.high and A.high >= B.low
  then if A.low = A.high and B.low = B.high
    then true
    else null
  else false
```

For relative comparisons, again, the semantics are defined to give the intuitively correct answer given the intended meaning of uncertainty. For example:

```cql
uncertainty[30, 40] < uncertainty[50, 60]
```

This expression can be read:

_Is some value between 30 and 40 less than some value between 50 and 60?_

And the correct answer is, _Yes_. If the ranges overlap:

```cql
uncertainty[30, 40] < uncertainty[35, 45]
```

Then the result is _null_, with one exception having to do with boundaries. Consider the following:

```cql
uncertainty[30, 40] < uncertainty[20, 30]
```

This expression can be read:

_Is some value between 30 and 40 less than some value between 20 and 30?_

And the correct answer is, _No_, because even though the ranges overlap (by width one at the lower boundary of the left-hand value), the result would still be false because 30 is not less than 30.

More precisely, given an uncertainty _A_ with range _A<sub>low</sub>_ to _A<sub>high</sub>_, and uncertainty _B_ with range _B<sub>low</sub>_ to _B<sub>high</sub>_, the comparison:

```cql
A < B
```

Is equivalent to:

```cql
case
  when A.high < B.low then true
  when A.low >= B.high then false
  else null
end
```

And finally, for relative comparisons involving equality, consider the following:

```cql
uncertainty[30, 40] <= uncertainty[40, 50]
```

This expression can be read:

_Is some value between 30 and 40 less than or equal to some value between 40 and 50?_

And the correct answer is, _Yes_, because every possible value between 30 and 40 inclusive is either less than or equal to every possible value between 40 and 50 inclusive.

More precisely, given an uncertainty _A_ with range _A<sub>low</sub>_ to _A<sub>high</sub>_, and uncertainty _B_ with range _B<sub>low</sub>_ to _B<sub>high</sub>_, the comparison:

```cql
A <= B
```

Is equivalent to:

```cql
case
  when A.high <= B.low then true
  when A.low > B.high then false
  else null
end
```

Note carefully that these semantics introduce some asymmetries into the comparison operators. In particular, *A <span class="sym">=</span> B or A <span class="sym">&lt;</span> B* is *not* equivalent to *A <span class="sym">\<=</span> B* because of the uncertainty.

{: #arithmetic-operators-2}
##### Arithmetic Operators

In addition to comparison operators, the basic arithmetic operators are defined for uncertainty, again based on the intuitively expected semantics. For example:

```cql
uncertainty[17, 44] + uncertainty[5, 10] // returns uncertainty[22, 54]
```

The above expression can be read:

_some value between 17 and 44_ <span class="sym">+</span> _some value between 5 and 10_

The result of this calculation simply adds the respective boundaries to determine what the range of possible values of this calculation would be, in this case _some value between 22 and 54_.

Similarly for multiplication:

```cql
uncertainty[17, 44] * uncertainty[2, 4] // returns uncertainty[34, 176]
```

The result of this calculation multiplies the boundaries of the uncertainties to determine the range of possible values for the result, in this case _some value between 34 and 176_.

##### Implicit Conversion

An important step to achieving the intended semantics for precision-based timing comparisons in CQL is to allow for implicit conversion between uncertainties and point-values. This means that anywhere an uncertainty is involved in an operation with a point-value, the point-value will be implicitly converted to an uncertainty of width zero and the uncertainty semantics defined above are then used to perform the calculation. For example:

```cql
uncertainty[17, 44] > 2
```

The point-value of _2_ in this example is implicitly converted to an uncertainty of width zero:

```cql
uncertainty[17, 44] > uncertainty[2, 2]
```

This implicit conversion means that in general, the notion of uncertainty will not be visible in the resulting syntax of CQL. For example:

```cql
days between Date(2014, 1, 15) and Date(2014, 2) > 2
```

Even though determining the correct answer to this question involves the use of uncertainty, it is implicit in the way the operations are defined, and does not surface to the CQL authors.

#### Determining Difference and Duration

To determine the duration between two date or time values, CQL supports a _between_ operator for each date and time component. For example:

```cql
days between A and B
```

This expression returns the number of whole days between A and B. If A is before B, the result will be a positive integer. If A is after B, the result will be a negative integer. And if A is the same day as B, the result will be zero.

However, to support the case where one or the other comparand in the duration operation does not specify components to the level of precision being determined, the between operator does not return a strict integer, it returns an _uncertainty_, which is defined as a range of values, similar to an interval. For example:

```cql
days between Date(2014, 1, 15) and Date(2014, 2)
```

The number of days between these two dates cannot be determined reliably, but a definite range of possible values can be determined. The lower bound of that range is found by determining the duration between the maximum possible value of the first comparand and the minimum possible value of the second comparand; and the upper bound is determined using the minimum possible value of the first comparand and the maximum possible value of the second:

```cql
days between Date(2014, 1, 15) and Date(2014, 2, 1) // 17 days
days between Date(2014, 1, 15) and Date(2014, 2, 28) // 44 days
```

Intuitively, what this means is that the number of days between January 15<sup>th</sup>, 2014 and some date in February, 2014, is no less than 17 days, but no more than 44. By incorporating this information into an uncertainty, CQL can support the intuitively expected semantics when performing timing comparisons. For example:

```cql
days between Date(2014, 1, 15) and Date(2014, 2) > 2
```

This comparison returns true, because the lower bound of the uncertainty, 17, is greater than 2, so no matter what the actual date of the second comparand, it would always be at least 17 days. By contrast:

```cql
days between Date(2014, 1, 15) and Date(2014, 2) > 50
```

This comparison returns false, because the upper bound of the uncertainty, 44, is less than 50, so no matter what the actual date of the second comparand, it would always be at most 44 days. And finally:

```cql
days between Date(2014, 1, 15) and Date(2014, 2) > 20
```

This comparison returns unknown (null), because the value being compared, 20, falls within the uncertainty, so no determination can be reliably made.

As another example, consider the case when a duration is being computed between DateTime values of different precisions:

```cql
days between @2017-08-07T17:00 and @2017-08-14T // [6, 7]
```

This duration results in an uncertainty because the starting datetime value is specified to the minute, `17:00`, while the second value is only specified to the day. The resulting uncertainty interval is between 6 and 7 days, and so `[6,7]` is returned.

Uncertainties may also result when calculating duration for a finer precision than what is specified in the input values. For example:

```cql
days between @2012-01 and @2012-02

// Results in an uncertainty from the shortest possible duration, to the longest possible duration
// [days between @2012-01-31 and @2012-02-01, days between @2012-01-01 and @2012-02-29]
```

Because the datetime values are both only specified to the month (from January of 2012 to February of 2012), the result is an uncertainty interval beginning with the number of days between the 31st of January, 2012 and the 1st of February, 2012 (the shortest possible duration), and ending with the number of days between the 1st of January, 2012 and the 29th of February, 2012 (the longest possible duration).

CQL also supports a difference in operator which, rather than calculating the number of calendar periods between two dates, calculates the number of boundaries crossed between the two dates. As with the duration operator, difference is defined to take imprecision in date and time values into account by returning an uncertainty.

Note that uncertainty calculations, just like date and time comparison calculations, consider seconds and milliseconds as a single combined precision with decimal semantics. For example:

```cql
hours between @2012-01-01T01:00:00 and @2012-01-01T02:00:00.0
```

The above example results in <span class="sym">1</span>, even though the second argument is specified to milliseconds and the first argument is only specified to seconds.

#### Timing Phrases

Using the foundational elements described in the previous sections, the semantics for the various CQL timing phrases can now be described in detail. The general approach for each timing phrase is to transform it to an equivalent representation in terms of either a direct comparison, or a comparison involving a duration calculation.

##### Same As

The _same as_ timing phrase is simply defined to be equivalent to a _same as_ comparison of the date and time values involved:

```cql
A starts same day as start B
```

This expression is equivalent to:

```cql
start of A same day as start of B
```

Similarly for the _or after_ and _or before_ comparisons:

```cql
A starts same day or after start B
A starts same day or before start B
```

These expressions are equivalent to:

```cql
start of A same day or after start of B
start of A same day or before start of B
```

##### Before/After

The basic _before_ and _after_ timing phrases are defined to be equivalent to a _before_ or _after_ comparison of the date and time values involved:

```cql
A starts before start B
A starts after start B
```

These expressions are equivalent to:

```cql
start of A before start of B
start of A after start of B
```

If the phrase involves a duration offset, the duration offset is applied as a date and time arithmetic calculation:

```cql
A starts 3 days before start B
A starts 3 days after start B
```

These expressions are equivalent to:

```cql
start of A same as start of B – 3 days
start of A same as start of B + 3 days
```

Note that these calculations use date/time arithmetic, applying _duration_, not _difference_ semantics for the comparison.

For timing phrases involving relative comparison, the prefixes _less than_ and _more than_, as well as the suffixes _or more_ and _or less_ can be used:

```cql
A starts 3 days or more before start B
A starts more than 3 days before start B
A starts 3 days or less after start B
A starts less than 3 days after start B
```

These expressions are equivalent to:

```cql
start of A same or before start of B - 3 days
start of A before start of B - 3 days
start of A in (start of B, start of B + 3 days] and B is not null
start of A in (start of B, start of B + 3 days) and B is not null
```

Note the addition of the null test in the case that an interval is constructed from the point B. This is necessary because if B is null and the constructed interval has inclusive boundaries, the null boundary of the resulting interval will be interpreted as continuing to the beginning or end of time (depending on whether the null appears as the starting or ending boundary of the interval).

##### Within

The _within_ timing phrase is defined in terms of an interval membership test:

```cql
A starts within 3 days of start B
```

This expression is equivalent to:

```cql
start of A in [start of B - 3 days, start of B + 3 days] and B is not null
```

Note that as with the before and after transformations, a null test is required here because if B is null, then the constructed interval would be incorrectly interpreted as continuing to the beginning or end of time (depending on whether the null appears as the starting or ending boundary of the interval).

{: #interval-operators-1}
##### Interval Operators

In general, interval comparisons are already defined in terms of the fundamental comparison operators (<span class="sym">=</span>, <span class="sym">></span>, <span class="sym">&lt;</span>, <span class="sym">>=</span>, <span class="sym">\<=</span>, and the precision-based counterparts) so the semantics of the interval comparisons follow directly from these extended semantics.

Note that open null boundaries of intervals are treaterd as uncertainties for the purposes of interval computation. For example:

```cql
intersect Interval[1, 10] intersect Interval[5, null)
```

This results in an interval that begins at 5, and ends at some value between 5 and 10. Implementations can accomplish this by normalizing open intervals to closed intervals with uncertain boundaries:

```pseudo-code
  if interval.low is null then interval.low = Uncertainty(minimumValue, interval.high)
  if interval.high is null then interval.high = Uncertainty(interval.low, maximumValue)
```

#### Implementing Precision-Based Timing with Uncertainty

Implementation of these semantics can be simplified by recognizing that all the date and time comparisons can be expressed in terms of a difference calculation and a comparison of the resulting (potentially uncertain) values against 0. Combined with the timing phrase translations, this means that the implementation for precision-based timing can be isolated to:

* Support for run-time operations on integer-based uncertainties, including:
    * <span class="sym">=</span>, <span class="sym">&lt;</span>, <span class="sym">></span>, <span class="sym">\<=</span>, <span class="sym">>=</span>, <span class="sym">+</span>, <span class="sym">-</span>, <span class="sym">unary +/-</span>, <span class="sym">*</span>, <span class="sym">/</span>
    * implicit conversion between integer point values and uncertainties
* Precision-based duration and difference between dates and times

All the other operations and semantics can be achieved using only these primitives. For example, given _A_ and _B_, both datetime values, the comparison:

```cql
A > B
```

Can be evaluated as:

```cql
difference in milliseconds between A and B > 0
```

Similarly:

```cql
A same day as B
```

Can be evaluated as:

```cql
difference in days between A and B = 0
```

Because the difference operation will return an uncertainty when imprecise date and time values are involved, the correct semantics will be applied to the comparison to the point value, 0 in this case. By structuring the evaluation engine such that all operations involving dates and times are performed in terms of these primitives, correct semantics can be achieved with a comparatively straightforward implementation.

Note also that a compile-time implicit conversion to uncertainty may also simplify the implementation, avoiding the need for integer-valued primitives to determine at run-time whether they are operating on an uncertainty.

Note that with an increased burden on implementation, uncertainty resolution could likely be more robust. For example, consider the following statement:

DateTime(2014) + 364 days

In the above example, it is almost certainly the case that the result of the addition would result in some date in DateTime(2015). However, CQL currently would return a DateTime(2014) because the addition does not result in a whole calendar period for the specified precision. An argument could be made that uncertainty resolution could be more robust as DateTime(2014) is an undefined DateTime occurring sometime during 2014, which can be represented as the following interval:

[@2014-01-01T00:00:00.000, @2014-12-31T23:59:59.999]

Therefore, it is relevant to consider that the above addition could be added to the interval above resulting in the following:

[@2014-12-31T00:00:00.000, @2015-12-30T23:59:59.999]

However, this behavior would potentially result in a significant implementation burden and represent a significant misalignment with FHIRPath if CQL were to adopt this behavior.
