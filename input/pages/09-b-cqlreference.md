{::options toc_levels="1..6"/}

This appendix provides a reference for all the system-defined types, operators, and functions that can be used within CQL. It is intended to provide complete semantics for each available type and operator as a companion to the Author’s and Developer’s Guides. The reference is organized by operator category.

For each type, the definition and semantics are provided. Note that because CQL does not define a type declaration syntax, the definitions are expressed in a pseudo-syntax.

For each operator or function, the signature, semantics, and usually an example are provided. Note that for built-in operators, the signature is expressed in a pseudo-syntax intended to clearly define the operator and its parameters. Although the symbolic operators may in general be prefix, infix, or postfix operators, the signatures for each operator are defined using function definition syntax for consistency and ease of representation. For example, the signature for the <span class="kw">and</span> operator is given as:

```cql
and(left Boolean, right Boolean) Boolean
```

Even though <span class="kw">and</span> is an infix operator and would be invoked as in the following expression:

```cql
InDemographic and NeedsScreening
```

{: #formatting-strings}
In addition, formatting strings are used throughout the reference to describe possible string formats for operators such as ToDateTime that convert a string to a DateTime value. The following symbols are used to describe format strings:

* **0** - Any digit must appear at this location in the format string
* **#** - Any digit may appear at this location in the format string
* **?** - The immediately preceding pattern is optional
* **( )** - Used to group patterns
* **\|** - Used to combine choices of patterns (e.g. **+\|-** means a **+** or **-** may appear at this location)

Any other character in a format string indicates that that character must appear at that location (or may appear if it is modified by the optional indicator, or part of a group that is modified by the optional indicator), with the exception of the following patterns used when describing date and time format strings:

* **YYYY** - A full four digit year (0001..9999), padded with leading zeroes if necessary
* **MM** - A full two digit month value (01..12), padded with leading zeroes if necessary
* **DD** - A full two digit day value (01..31), padded with leading zeroes if necessary
* **hh** - A full two digit hour value (00..24), padded with leading zeroes if necessary
* **mm** - A full two digit minute value (00..59), padded with leading zeroes if necessary
* **ss** - A full two digit second value (00..59), padded with leading zeroes if necessary
* **fff** - A fractional millisecond value (0..999)

These formatting patterns are set in bold to distinguish them typographically from literals or code and to make clear that they are not intended to be formally interpreted as regex patterns.

{: #types-2}
### Types

#### Any

**Definition:**

```cql
simple type Any
```

**Description:**

The <span class="id">Any</span> type is the maximal supertype in the CQL type system, meaning that all types derive from <span class="id">Any</span>, including list, interval, and structured types. In addition, the type of a <span class="kw">null</span> result is <span class="id">Any</span>.

{: #boolean-1}
#### Boolean

**Definition:**

```cql
simple type Boolean
```

**Description:**

The <span class="id">Boolean</span> type represents the logical boolean values <span class="kw">true</span> and <span class="kw">false</span>. The result of logical operations within CQL use the <span class="id">Boolean</span> type, and constructs within the language that expect a conditional result, such as a where clause or conditional expression, expect results of the <span class="id">Boolean</span> type.

For more information, see the [Logical Operators](#logical-operators) section.

{: #code-1}
#### Code

**Definition:**

```cql
structured type Code
{
  code String,
  display String,
  system String,
  version String
}
```

**Description:**

The <span class="id">Code</span> type represents single terminology codes within CQL.

#### CodeSystem

> The CodeSystem type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Definition:**

```cql
structured type CodeSystem : Vocabulary
{
  id String, // inherited
  version String, // inherited
  name String // inherited
}
```

**Description:**

The <span class="id">CodeSystem</span> type represents code system references within CQL. The CodeSystem type in CQL is _not_ the definition of a code system, it is a reference to an externally defined code system via a globally unique identifier (the <span class="id">id</span> element, typically a URL) and an optional version (the <span class="id">version</span> element, an opaque string, typically a version identifier as specified by the code system).

The <span class="id">name</span> element is provided to support additional run-time information for Vocabulary types, it is _not_ intended to participate in the identification or resolution of a terminology reference; only to provide additional user-friendly information at run-time for users.

{: #concept-1}
#### Concept

**Definition:**

```cql
structured type Concept
{
  codes List<Code>,
  display String
}
```

**Description:**

The <span class="id">Concept</span> type represents a single terminological concept within CQL.

The <span class="id">codes<span> element may be an empty list, or it may be <span class="kw">null</span>. 

The <span class="id">display</span> element may be <span class="kw">null</span> or an empty string.

#### Date

**Definition:**

```cql
simple type Date
```

**Description:**

The <span class="id">Date</span> type represents date values with potential uncertainty within CQL.

CQL supports date values in the range @0001-01-01 to @9999-12-31 with a 1 day step size.

CQL also supports partial date values. For example, the date <span class="lit">@2014</span> represents some day in the year 2014.

#### DateTime

**Definition:**

```cql
simple type DateTime
```

**Description:**

The <span class="id">DateTime</span> type represents date and time values with potential uncertainty within CQL.

CQL supports date and time values in the range <span class="lit">@0001-01-01T00:00:00.0</span> to <span class="lit">@9999-12-31T23:59:59.999</span> with a 1 millisecond step size. Note that DateTime values may also optionally indicate an offset. If no timezone offset is specified, the timezone offset of the evaluation request timestamp is assumed. See the [Constructing Date and Time Values](02-authorsguide.html#constructing-datetime-values) section for more information.

CQL also supports partial datetime values. For example, the datetime <span class="lit">@2014-01-01T03</span> represents some instant during the hour of 3:00 on January 1st, 2014.

Although the milliseconds are specified with a separate component, seconds and milliseconds are combined and represented as a <span class="id">Decimal</span> for the purposes of comparison, duration, and difference calculation. When milliseconds are <span class="kw">null</span>, they are combined as <span class="sym">.0</span>. In other words, if milliseconds are not specified, calculations for precisions above milliseconds are performed as though milliseconds had been specified as <span class="lit">0</span>. This is true of all comparison operations for date and time values, whether explicit (such as <span class="sym">=, !=, \<, \<=, >, >=</span>) or implicit (such as <span class="kw">same as, before, after, same or before, same or after</span>), or when comparison is performed as part of other operations such as interval <span class="kw">meets</span> and <span class="kw">overlaps</span>.

{: #decimal-1}
#### Decimal

**Definition:**

```cql
simple type Decimal
```


> Note that implementations must support at least the 28 digits of precision and 8 digits of scale, but may support more precise values.
{: .note-warning}

**Description:**

The <span class="id">Decimal</span> type represents real values within CQL.

CQL supports positive and negative decimal values with a _precision_ (meaning total number of possible digits) of 28 and a _scale_ (meaning number of possible digits to the right of the decimal) of 8. In other words, decimal values in the range (-10<sup>28</sup> + 1)/10<sup>8</sup> to (10<sup>28</sup>-1)/10<sup>-8</sup> with a step size of 10<sup>-8</sup>.


{: #long-1}
#### Long

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Definition:**

```cql
simple type Long
```

**Description:**

The <span class="id">Long</span> type represents large whole number values within CQL.

CQL supports long values in the range -2<sup>63</sup> to 2<sup>63</sup>-1 with a step size of 1.

{: #integer-1}
#### Integer

**Definition:**

```cql
simple type Integer
```

**Description:**

The <span class="id">Integer</span> type represents whole number values within CQL.

CQL supports integer values in the range -2<sup>31</sup> to 2<sup>31</sup>-1 with a step size of 1.

#### Quantity

**Definition:**

```cql
structured type Quantity
{
  value Decimal
  unit String
}
```

**Description:**

The <span class="id">Quantity</span> type represents quantities with a specified unit within CQL. The unit must be a valid UCUM unit or CQL temporal keyword. UCUM units in CQL use the case-sensitive (c/s) form. When a quantity value has no unit specified, operations are performed with the default UCUM unit ('1'). The value element of a Quantity must be present.

Systems shall not implicitly convert units other than when performing calculations. For example, the value `1 '[in_i]'` must be preserved as `'[in_i]'`, not converted to common or preferred units such as `2.54 'cm'`.

#### Ratio

**Definition:**

```cql
structured type Ratio
{
  numerator Quantity
  denominator Quantity
}
```

**Description:**

The <span class="id">Ratio</span> type represents a relationship between two quantities, such as a titre (e.g. 1:128), or a concentration (e.g. 5 'mg':10'mL'). The numerator and denominator elements must be present (i.e. can not be null).

{: #string-1}
#### String

**Definition:**

```cql
simple type String
```

**Description:**

The <span class="id">String</span> type represents string values within CQL.

CQL supports string values up to 2<sup>31</sup>-1 characters in length.

For string literals, CQL uses standard escape sequences:


|Escape |Character
|----|----
|\\' |Single-quote
|\\" |Double-quote
|\r |Carriage Return
|\n |Line Feed
|\t |Tab
|\f |Form Feed
|\\\\ |Backslash
|\uXXXX |Unicode character, where XXXX is the hexadecimal representation of the character
{: .grid .table .table-striped}

#### Time

**Definition:**

```cql
simple type Time
```

**Description:**

The <span class="id">Time</span> type represents time-of-day values within CQL.

CQL supports time values in the range <span class="lit">@T00:00:00.0</span> to <span class="lit">@T23:59:59.999</span> with a step size of 1 millisecond.

CQL also supports partial time values. For example, the time <span class="lit">@T03</span> represents some instant during the hour of 3:00.

Although the milliseconds are specified with a separate component, seconds and milliseconds are combined and represented as a <span class="id">Decimal</span> for the purposes of comparison, duration, and difference calculation. When milliseconds are <span class="kw">null</span>, they are combined as <span class="sym">.0</span>. In other words, if milliseconds are not specified, calculations for precisions above milliseconds are performed as though milliseconds had been specified as <span class="lit">0</span>. This is true of all comparison operations for time values, whether explicit (such as <span class="sym">=, !=, \<, \<=, >, >=</span>) or implicit (such as <span class="kw">same as, before, after, same or before, same or after</span>), or when comparison is performed as part of other operations such as interval <span class="kw">meets</span> and <span class="kw">overlaps</span>.

#### ValueSet

> The ValueSet type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Definition:**

```cql
structured type ValueSet : Vocabulary
{
  id String, // inherited
  version String, // inherited
  name String, // inherited
  codesystems List<CodeSystem>
}
```

**Description:**

The <span class="id">ValueSet</span> type represents value set references within CQL. The ValueSet type is _not_ the definition of a value set, it is a reference to an externally defined value set via a globally unique identifier (the <span class="id">id</span> element, typically a URL) and an optional version (the <span class="id">version</span> element, an opaque string, typically a version identifier as specified by the publishing authority).

The <span class="id">name</span> element is provided to support additional run-time information for Vocabulary types, it is _not_ intended to participate in the identification or resolution of a terminology reference; only to provide additional user-friendly information at run-time for users.

The <span class="id">codesystems</span> element is used to capture code system version overrides as can be specified in a CQL ValueSet declaration. Any codesystem may be listed, but the codesystem is expected to be a codesystem used as part of the definition of the valueset being referenced. If a codesystem override is provided for a code system that is not used by the value set definition, it has no effect and will be ignored.

#### Vocabulary

> The Vocabulary type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Definition:**

```cql
structured type Vocabulary
{
  id String,
  version String,
  name String
}
```

**Description:**

The <span class="id">Vocabulary</span> type is the abstract base type for the CodeSystem and ValueSet types. It is intended to support the definition of operations that could be performed against a ValueSet or a CodeSystem.

The <span class="id">Vocabulary</span> type is _not_ a definitional type, it is a reference type that supports references to externally defined code systems and value sets through a globally unique identifier (the <span class="id">id</span> element, typically a URL) and an optional version (the <span class="id">version</span> element, an opaque string, typically a version identifier as specified by the publishing authority).

The <span class="id">name</span> element is provided to support additional run-time information for Vocabulary types, it is _not_ intended to participate in the identification or resolution of a terminology reference; only to provide additional user-friendly information at run-time for users.

{: #logical-operators-3}
### Logical Operators

#### And

**Signature:**

```cql
and (left Boolean, right Boolean) Boolean
```

**Description:**

The <span class="kw">and</span> operator returns true if both its arguments are true. If either argument is false, the result is false. Otherwise, the result is null.

The following table defines the truth table for this operator:

<a name="table-9-a"></a>

| |TRUE |FALSE |NULL
|----|----|----|----
|**TRUE**  |TRUE |FALSE |NULL
|**FALSE** |FALSE |FALSE |FALSE
|**NULL**  |NULL |FALSE |NULL
{: .grid .table .table-striped}

Table 9‑A - The truth table for the <span class="kw">And</span> operator

**Example:**

The following examples illustrate the behavior of the <span class="kw">and</span> operator:

```cql
define "IsTrue": true and true
define "IsFalse": true and false
define "IsAlsoFalse": false and null
define "IsNull": true and null
```

Note that CQL does not prescribe short-circuit evaluation of logical operators.

#### Implies

**Signature:**

```cql
implies (left Boolean, right Boolean) Boolean
```

**Description:**

The <span class="kw">implies</span> operator returns the logical implication of its arguments. This means that if the left operand evaluates to true, this operator returns the boolean evaluation of the right operand. If the left operand evaluates to false, this operator returns true. Otherwise, this operator returns true if the right operand evaluates to true, and null otherwise.

Note that implies may use short-circuit evaluation in the case that the first operand evaluates to false.

The following table defines the truth table for this operator:

<a name="table-9-a1"></a>

| |TRUE |FALSE |NULL
|----|----|----|----
|**TRUE** |**TRUE** |**FALSE** |**NULL**
|**FALSE** |**TRUE** |**TRUE** |**TRUE**
|**NULL** |**TRUE** |**NULL** |**NULL**
{: .grid .table .table-striped}

Table 9‑A1 - The truth table for the <span class="kw">Implies</span> operator

**Example:**

The following examples illustrate the behavior of the <span class="kw">implies</span> operator:

```cql
define "IsTrue": false implies false
define "IsAlsoTrue": false implies null
define "IsFalse": true implies false
define "IsNull": true implies null
```

#### Not

**Signature:**

```cql
not (argument Boolean) Boolean
```

**Description:**

The <span class="kw">not</span> operator returns true if the argument is false and false if the argument is true. Otherwise, the result is null.

The following table defines the truth table for this operator:

<a name="table-9-b"></a>

|  |NOT
|----|----
|**TRUE** |**FALSE**
|**FALSE** |**TRUE**
|**NULL** |**NULL**
{: .grid .table .table-striped}

Table 9‑B - The truth table for the <span class="kw">Not</span> operator

The following examples illustrate the behavior of the <span class="kw">not</span> operator:

```cql
define "IsTrue": not false
define "IsFalse": not true
define "IsNull": not null
```

#### Or

**Signature:**

```cql
or (left Boolean, right Boolean) Boolean
```

**Description:**

The <span class="kw">or</span> operator returns true if either of its arguments are true. If both arguments are false, the result is false. Otherwise, the result is null.

The following table defines the truth table for this operator:

<a name="table-9-c"></a>

| |TRUE |FALSE |NULL
|----|----|----|----
|**TRUE** |**TRUE** |**TRUE** |**TRUE**
|**FALSE** |**TRUE** |**FALSE** |**NULL**
|**NULL** |**TRUE** |**NULL** |**NULL**
{: .grid .table .table-striped}

Table 9‑C - The truth table for the <span class="kw">Or</span> operator

**Example:**

The following examples illustrate the behavior of the <span class="kw">or</span> operator:

```cql
define "IsTrue": true or false
define "IsAlsoTrue": true or null
define "IsFalse": false or false
define "IsNull": false or null
```

Note that CQL does not prescribe short-circuit evaluation of logical operators.

#### Xor

**Signature:**

```cql
xor (left Boolean, right Boolean) Boolean
```

**Description:**

The <span class="kw">xor</span> (exclusive or) operator returns true if one argument is true and the other is false. If both arguments are true or both arguments are false, the result is false. Otherwise, the result is null.

The following table defines the truth table for this operator:

<a name="table-9-d"></a>

| |TRUE |FALSE |NULL
|----|----|----|----
|**TRUE** |**FALSE** |**TRUE** |**NULL**
|**FALSE** |**TRUE** |**FALSE** |**NULL**
|**NULL** |**NULL** |**NULL** |**NULL**
{: .grid .table .table-striped}

Table 9‑D - The truth table for the <span class="kw">Xor</span> operator

The following examples illustrate the behavior of the <span class="kw">xor</span> operator:

```cql
define "IsTrue": true xor false
define "IsAlsoTrue": false xor true
define "IsFalse": true xor true
define "IsNull": true xor null
```

{: #type-operators-1}
### Type Operators

#### As

**Signature:**

```cql
as<T>(argument Any) T
cast as<T>(argument Any) T
```

**Description:**

The <span class="kw">as</span> operator allows the result of an expression to be cast as a given target type. This allows expressions to be written that are statically typed against the expected run-time type of the argument.

If the argument is not of the specified type at run-time the result is <span class="kw">null</span>.

The <span class="kw">cast</span> prefix indicates that if the argument is not of the specified type at run-time then an exception is thrown.

**Example:**

The following examples illustrate the use of the <span class="kw">as</span> operator.

```cql
define "AllProcedures": [Procedure]

define "ImagingProcedures":
  AllProcedures P
    where P is ImagingProcedure
    return P as ImagingProcedure

define "RuntimeError":
  ImagingProcedures P
    return cast P as Observation
```

#### Children

**Signature:**

```cql
Children(argument Any) List<Any>
```

**Description:**

For structured types, the <span class="id">Children</span> operator returns a list of all the values of the elements of the type. List-valued elements are expanded and added to the result individually, rather than as a single list.

For list types, the result is the same as invoking <span class="id">Children</span> on each element in the list and flattening the resulting lists into a single result.

If the source is null, the result is null.

#### Convert

**Signature:**

```cql
convert to<T>(argument Any) T
```

**Description:**

The <span class="kw">convert</span> operator converts a value to a specific type. The result of the operator is the value of the argument converted to the target type, if possible. If there is no valid conversion from the actual value to the target type, the result is null.

For simplicity, if no conversion is required, the convert operator simply returns the input value.

The following table lists the conversions supported in CQL:

<a name="table-9-e"></a>

|From\To   |Boolean |Integer |Long |Decimal |Quantity |Ratio |String |Date |DateTime |Time |Code |Concept |List\<Code>
|----|----|----|----|----|----|----|----|----|----|----|----|----
|**Boolean** |N/A |Explicit |Explicit |Explicit |- |- |Explicit |- |- |- |- |- |-
|**Integer** |Explicit |N/A |Implicit |Implicit |Implicit |- |Explicit |- |- |- |- |- |-
|**Long** |Explicit |Explicit |N/A |Implicit |Implicit |- |Explicit |- |- |- |- |- |-
|**Decimal** |Explicit |- |- |N/A |Implicit |- |Explicit |- |- |- |- |- |-
|**Quantity** |- |- |- |- |N/A |- |Explicit |- |- |- |- |- |-
|**Ratio** |- |- |- |- |- |N/A |Explicit |- |- |- |- |- |-
|**String** |Explicit |Explicit |Explicit |Explicit |Explicit |Explicit |N/A |Explicit |Explicit |Explicit |- |- |-
|**Date** |- |- |- |- |- |- |Explicit |N/A |Implicit |- |- |- |-
|**DateTime** |- |- |- |- |- |- |Explicit |Explicit |N/A |- |- |- |-
|**Time** |- |- |- |- |- |- |Explicit |- |- |N/A |- |- |-
|**Code** |- |- |- |- |- |- |- |- |- |- |N/A |Implicit |-
|**Concept** |- |- |- |- |- |- |- |- |- |- |- |N/A |Explicit
|**List\<Code>** |- |- |- |- |- |- |- |- |- |- |- |Explicit |N/A
{: .grid .table .table-striped}

Table 9‑E - The conversions supported in CQL

For conversions between dates, times, and string values, ISO-8601 standard format is used:

**YYYY-MM-DDThh:mm:ss.fff(Z\|((+\|-)hh:mm))**

For example, the following are valid string representations for date and time values:

```cql
'2014-01-01T14:30:00.0Z' // January 1st, 2014, 2:30PM UTC
'2014-01-01T14:30:00.0-07:00' // January 1st, 2014, 2:30PM Mountain Standard (GMT-7:00)
'T14:30:00.0Z' // 2:30PM UTC
'T14:30:00.0-07:00' // 2:30PM Mountain Standard (GMT-7:00)
```

For specific semantics for each conversion, refer to the [explicit conversion](03-developersguide.html#explicit-conversion) operator documentation.

#### Descendants

**Signature:**

```cql
Descendants(argument Any) List<Any>
```

**Description:**

For structured types, the <span class="id">Descendants</span> operator returns a list of all the values of the elements of the type, recursively. List-valued elements are expanded and added to the result individually, rather than as a single list.

For list types, the result is the same as invoking <span class="id">Descendants</span> on each element in the list and flattening the resulting lists into a single result.

If the source is null, the result is null.

#### Is

**Signature:**

```cql
is<T>(argument Any) Boolean
```

**Description:**

The <span class="kw">is</span> operator allows the type of a result to be tested. If the run-time type of the argument is the same as or derived from the type being tested, the result of the operator is <span class="kw">true</span>; otherwise, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">is</span> operator:

```cql
define "IsTrue": 5 is Integer
define "IsFalse": '5' is Integer
```

For more information, see the [Type Testing](03-developersguide.html#type-testing) topic in the Developer's Guide.

#### CanConvertQuantity

**Signature:**

```cql
CanConvertQuantity(argument Quantity, unit String)
```

**Description:**

The CanConvertQuantity operator returns true if the Quantity is or can be converted to an equivalent Quantity with the given Unit. Otherwise, the result is false.

> Note that implementations are not required to support quantity conversion, and so may return false, even if the conversion is valid. Implementations that do support unit conversion shall do so according to the conversion specified by UCUM.
{: .note-warning}

If either argument is null, the result is null.

#### ConvertQuantity

**Signature:**

```cql
convert <quantity> to <unit>
ConvertQuantity(argument Quantity, unit String)
```

The ConvertQuantity operator converts a Quantity to an equivalent Quantity with the given unit. If the unit of the input quantity is or can be converted to the target unit, the result is an equivalent Quantity with the target unit. Otherwise, the result is null.

> Note that implementations are not required to support quantity conversion. Implementations that do support unit conversion shall do so according to the conversion specified by UCUM. Implementations that do not support unit conversion shall throw an error if an unsupported unit conversion is requested with this operation.
{: .note-warning}

If either argument is null, the result is null.

```cql
define "ConvertQuantity": ConvertQuantity(5 'mg', 'g')
define "ConvertSyntax": convert 5 'mg' to 'g'
```

#### ConvertsToBoolean

**Signature:**

```cql
ConvertsToBoolean(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToBoolean</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Boolean</span> value. See the <span class="id">[ToBoolean](#toboolean)</span> operator for a description of the supported conversions.

If the input cannot be interpreted as a valid <span class="id">Boolean</span> value, the result is <span class="kw">false</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToDate

**Signature:**

```cql
ConvertsToDate(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToDate</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Date</span> value. See the <span class="id">[ToDate](#todate)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or does not represent a valid date value, the result is <span class="kw">false</span>.

As with date literals, date values may be specified to any precision.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToDateTime

**Signature:**

```cql
ConvertsToDateTime(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToDateTime</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">DateTime</span> value. See the <span class="id">[ToDateTime](#todatetime)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or does not represent a valid DateTime value, the result is <span class="kw">false</span>.

As with date and time literals, DateTime values may be specified to any precision. If no timezone offset is supplied, the timezone offset of the evaluation request timestamp is assumed.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToDecimal

**Signature:**

```cql
ConvertsToDecimal(argument Any) Boolean
```

**Description:**

The <span class="id">ToDecimal</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Decimal</span> value. See the <span class="id">[ToDecimal](#todecimal)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Decimal</span> value, the result is <span class="kw">false</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToLong

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Signature:**

```cql
ConvertsToLong(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToLong</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Long</span> value. See the <span class="id">[ToLong](#tolong)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Long</span> value, the result is <span class="kw">false</span>.

#### ConvertsToInteger

**Signature:**

```cql
ConvertsToInteger(argument Any) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">ConvertsToInteger</span> operator returns <span class="kw">true</span> if its argument is or can be converted to an <span class="id">Integer</span> value. See the <span class="id">[ToInteger](#tointeger)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Integer</span> value, the result is <span class="kw">false</span>.

If the input is a <span class="id">Long</span> value, the result is <span class="kw">true</span> if the value is within the range of an <span class="id">Integer</span>, otherwise, the result is <span class="kw">false</span>.

#### ConvertsToQuantity

**Signature:**

```cql
ConvertsToQuantity(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToQuantity</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Quantity</span> value. See the <span class="id">[ToQuantity](#toquantity)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Quantity</span> value, the result is <span class="kw">false</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

##### ConvertsToRatio

**Signature:**

```cql
ConvertsToRatio(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToRatio</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Ratio</span> value. See the <span class="id">[ToRatio](#toratio)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Ratio</span> value, the result is <span class="kw">false</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToString

**Signature:**

```cql
ConvertsToString(argument Any) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">ConvertsToString</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">String</span> value. See the <span class="id">[ToString](#tostring)</span> operator for a description of the supported conversions.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ConvertsToTime

**Signature:**

```cql
ConvertsToTime(argument Any) Boolean
```

**Description:**

The <span class="id">ConvertsToTime</span> operator returns <span class="kw">true</span> if its argument is or can be converted to a <span class="id">Time</span> value. See the <span class="id">[ToTime](#totime)</span> operator for a description of the supported conversions.

If the input string is not formatted correctly, or does not represent a valid time-of-day value, the result is <span class="kw">false</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ToBoolean

**Signature:**

```cql
ToBoolean(argument Decimal) Boolean
ToBoolean(argument Long) Boolean
ToBoolean(argument Integer) Boolean
ToBoolean(argument String) Boolean
```

**Description:**

The <span class="id">ToBoolean</span> operator converts the value of its argument to a <span class="id">Boolean</span> value. The operator accepts the following string representations, ignoring case:

<a name="table-9-f"></a>

|String Representation |Boolean Value
|----|----
|<span class="id">true t yes y 1</span> |<span class="kw">true</span>
|<span class="id">false f no n 0</span> |<span class="kw">false</span>
{: .grid .table .table-striped}

Table 9‑F - The string representations that the ToBoolean operator accepts

Note that the operator will ignore case when interpreting the string as a <span class="id">Boolean</span> value.

If the input cannot be interpreted as a valid <span class="id">Boolean</span> value, the result is <span class="kw">null</span>.

If the input is an Integer or Long, the result is true if the integer is 1, false if the integer is 0.

If the input is a Decimal, the result is true if the decimal is 1.0, false if the decimal is 0.0.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToBoolean</span> operator:

```cql
define "IsTrue": ToBoolean('y')
define "IsFalse": ToBoolean('0')
define "IsNull": ToBoolean('falsetto')
```

#### ToConcept

**Signature:**

```cql
ToConcept(argument Code) Concept
ToConcept(argument List<Code>) Concept
```

**Description:**

The <span class="id">ToConcept</span> operator converts a value of type <span class="id">Code</span> to a <span class="id">Concept</span> value with the given <span class="id">Code</span> as its primary and only <span class="id">Code</span>. If the <span class="id">Code</span> has a <span class="id">display</span> value, the resulting <span class="id">Concept</span> will have the same <span class="id">display</span> value.

If the input is a list of <span class="id">Code</span> values, the resulting <span class="id">Concept</span> will have all the input <span class="id">Code</span> values, and will not have a <span class="id">display</span> value.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToConcept</span> operator:

```cql
define "IsValid": ToConcept(Code { system: 'http://loinc.org', code: '8480-6' }) // Concept { codes: { Code { system: 'http://loinc.org', code: '8480-6' } } }
define "IsNull": ToConcept(null as Code)
```

#### ToDate

**Signature:**

```cql
ToDate(argument DateTime) Date
ToDate(argument String) Date
```

**Description:**

The <span class="id">ToDate</span> operator converts the value of its argument to a <span class="id">Date</span> value.

For the <span class="id">DateTime</span> overload, the operator is equivalent to invoking <span class="kw">date from</span> on the DateTime value.

For the <span class="id">String</span> overload, the operator expects the string to be formatted using the ISO-8601 date representation:

**YYYY-MM-DD**

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

In addition, the string must be interpretable as a valid date value.

Note that the operator can take datetime formatted strings and will ignore the time portions.

For example, the following are valid string representations for date values:

```cql
'2014-01' // January, 2014
'2014-01-01' // January 1st, 2014
'2014-01-01T12:30:00' // Still January 1st, 2014, time portion will be ignored
```

If the input string is not formatted correctly, or does not represent a valid date value, the result is <span class="kw">null</span>.

As with date literals, date values may be specified to any precision.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ToDateTime

**Signature:**

```cql
ToDateTime(argument Date) DateTime
ToDateTime(argument String) DateTime
```

**Description:**

The <span class="id">ToDateTime</span> operator converts the value of its argument to a <span class="id">DateTime</span> value.

For the <span class="id">String</span> overload, the operator expects the string to be formatted using the ISO-8601 datetime representation:

**YYYY-MM-DDThh:mm:ss.fff(Z\|((+\|-)hh:mm))**

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

In addition, the string must be interpretable as a valid DateTime value.

For example, the following are valid string representations for DateTime values:

```cql
'2014-01-01' // January 1st, 2014
'2014-01-01T14:30:00.0Z' // January 1st, 2014, 2:30PM UTC
'2014-01-01T14:30:00.0-07:00' // January 1st, 2014, 2:30PM Mountain Standard (GMT-7:00)
```

If the input string is not formatted correctly, or does not represent a valid DateTime value, the result is <span class="kw">null</span>.

As with Date and Time literals, DateTime values may be specified to any precision. If no timezone offset is supplied, the timezone offset of the evaluation request timestamp is assumed.

For the <span class="id">Date</span> overload, the result will be a <span class="id">DateTime</span> with the time components unspecified, except for the timezone offset, which will be set to the timezone offset of the evaluation request timestamp.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### ToDecimal

**Signature:**

```cql
ToDecimal(argument Boolean) Decimal
ToDecimal(argument String) Decimal
```

**Description:**

The <span class="id">ToDecimal</span> operator converts the value of its argument to a <span class="id">Decimal</span> value. The operator accepts strings using the following format:

**(+\|-)?\#0(.0#)?**

Meaning an optional polarity indicator, followed by any number of digits (including none), followed by at least one digit, followed optionally by a decimal point, at least one digit, and any number of additional digits (including none).

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

Note that the <span class="id">Decimal</span> value returned by this operator will be limited in precision and scale to the maximum precision and scale representable by the implementation (at least 28 digits of precision, and 8 digits of scale).

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Decimal</span> value, the result is <span class="kw">null</span>.

If the input is Boolean, true will result in 1.0, false will result in 0.0.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToDecimal</span> operator:

```cql
define "IsValid": ToDecimal('-0.1')
define "IsNull": ToDecimal('+-0.1')
```

#### ToLong

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Signature:**

```cql
ToLong(argument Boolean) Long
ToLong(argument Integer) Long
ToLong(argument String) Long
```

**Description:**

The <span class="id">ToLong</span> operator converts the value of its argument to a <span class="id">Long</span> value. The operator accepts strings using the following format:

**(+\|-)?#0**

Meaning an optional polarity indicator, followed by any number of digits (including none), followed by at least one digit.

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

Note that the long value returned by this operator must be a valid value in the range representable for <span class="id">Long</span> values in CQL.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Long</span> value, the result is <span class="kw">null</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToLong</span> operator:

```cql
define "IsValid": ToLong('-1')
define "IsNull": ToLong('one')
```

#### ToInteger

**Signature:**

```cql
ToInteger(argument Boolean) Integer
ToInteger(argument String) Integer
ToInteger(argument Long) Integer
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">ToInteger</span> operator converts the value of its argument to an <span class="id">Integer</span> value. The operator accepts strings using the following format:

**(+\|-)?#0**

Meaning an optional polarity indicator, followed by any number of digits (including none), followed by at least one digit.

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

Note that the integer value returned by this operator must be a valid value in the range representable for <span class="id">Integer</span> values in CQL.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Integer</span> value, the result is <span class="kw">null</span>.

If the input is a <span class="id">Long</span> value that can be represented within the range of <span class="id">Integer</span> values, the result is the <span class="id">Integer</span> value; otherwise, the result is <span class="kw">null</span>.

If the input is Boolean, true will result in 1, false will result in 0.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToInteger</span> operator:

```cql
define "IsValid": ToInteger('-1')
define "IsNull": ToInteger('one')
```

#### ToQuantity

**Signature:**

```cql
ToQuantity(argument Decimal) Quantity
ToQuantity(argument Integer) Quantity
ToQuantity(argument Long) Quantity
ToQuantity(argument Ratio) Quantity
ToQuantity(argument String) Quantity
```

**Description:**

The <span class="id">ToQuantity</span> operator converts the value of its argument to a <span class="id">Quantity</span> value. The operation does not perform any unit conversion, that capability is supported by the [ConvertQuantity](#convertquantity) operator.

For the <span class="id">String</span> overload, the operator accepts strings using the following format:

**(+\|-)?\#0(.0#)?('\<unit>')?**

Meaning an optional polarity indicator, followed by any number of digits (including none) followed by at least one digit, optionally followed by a decimal point, at least one digit, and any number of additional digits, all optionally followed by a unit designator as a string literal specifying a valid, case-sensitive UCUM unit of measure or calendar duration keyword, singular or plural. Spaces are allowed between the quantity value and the unit designator.

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

Note that the decimal value of the quantity returned by this operator must be a valid value in the range representable for <span class="id">Decimal</span> values in CQL.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Quantity</span> value, the result is <span class="kw">null</span>.

For the <span class="id">Integer</span>, <span class="id">Long</span>, and <span class="id">Decimal</span> overloads, the operator returns a quantity with the value of the argument and a unit of <span class="lit">'1'</span> (the default unit).

For the <span class="id">Ratio</span> overload, the operator is equivalent to dividing the numerator of the ratio by the denominator.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToQuantity</span> operator:

```cql
define "DecimalOverload": ToQuantity(0.1) // 0.1 '1'
define "IntegerOverload": ToQuantity(13) // 13 '1'
define "LongOverload": ToQuantity(13L) // 13 '1'
define "StringOverload": ToQuantity('-0.1 \'mg\'') // -0.1 'mg'
define "IsNull": ToQuantity('444 \'cm')
```

##### ToRatio

**Signature:**

```cql
ToRatio(argument String) Ratio
```

**Description:**

The <span class="id">ToRatio</span> operator converts the value of its argument to a <span class="id">Ratio</span> value. The operator accepts strings using the following format:

**\<quantity>:\<quantity>**

where \<quantity> is the format used to by the <span class="id">ToQuantity</span> operator.

If the input string is not formatted correctly, or cannot be interpreted as a valid <span class="id">Ratio</span> value, the result is <span class="kw">null</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToRatio</span> operator:

```cql
define "IsValid": ToRatio('1.0 \'mg\':2.0 \'mg\'')
define "IsNull": ToRatio('1.0 \'mg\';2.0 \'mg\'')
```

#### ToString

**Signature:**

```cql
ToString(argument Boolean) String
ToString(argument Integer) String
ToString(argument Long) String
ToString(argument Decimal) String
ToString(argument Quantity) String
ToString(argument Ratio) String
ToString(argument Date) String
ToString(argument DateTime) String
ToString(argument Time) String
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">ToString</span> operator converts the value of its argument to a <span class="id">String</span> value. The operator uses the following string representations for each type

<a name="table-9-g"></a>

|Type |String Representation
|----|----
|<span class="id">Boolean</span> |**true\|false**
|<span class="id">Integer</span> |**(-)?#0**
|<span class="id">Long</span> |**(-)?#0**
|<span class="id">Decimal</span> |**(-)?\#0.0#**
|<span class="id">Quantity</span> |**(-)?\#0.0# (('\<unit>')\|(\<unit>))**
|<span class="id">Ratio</span> |**\<quantity>:\<quantity>**
|<span class="id">Date</span> |**YYYY-MM-DD**
|<span class="id">DateTime</span> |**YYYY-MM-DDThh:mm:ss.fff(+\|-)hh:mm**
|<span class="id">Time</span> |**hh:mm:ss.fff**
{: .grid .table .table-striped}

Table 9‑G - The string representations that the ToString operator uses for each data type

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

The result of any ToString must be round-trippable back to the source value. In particular, `ToString(4 days)` results in the string value `4 days` (i.e. not `4 'd'`).

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">ToString</span> operator:

```cql
define "BooleanOverload": ToString(true)
define "IntegerOverload": ToString(13)
define "LongOverload": ToString(10000L)
define "DecimalOverload": ToString(0.1)
define "QuantityOverload": ToString(-0.1 'mg')
define "RatioOverload": ToString(-0.1 'mg':0.1 'mg')
define "DateOverload": ToString(@2012-01-01)
define "DateTimeOverload": ToString(@2012-01-01T12:30:00.000-05:00)
define "TimeOverload": ToString(@T12:30:00.000)
define "IsNull": ToString(null as Integer)
```

#### ToTime

**Signature:**

```cql
ToTime(argument String) Time
```

**Description:**

The <span class="id">ToTime</span> operator converts the value of its argument to a <span class="id">Time</span> value. The operator expects the string to be formatted using ISO-8601 time representation

**hh:mm:ss.fff**

See [Formatting Strings](#formatting-strings) for a description of the formatting strings used in this specification.

In addition, the string must be interpretable as a valid time-of-day value.

For example, the following are valid string representations for time-of-day values:

```cql
'14:30:00.0' // 2:30PM
```

If the input string is not formatted correctly, or does not represent a valid time-of-day value, the result is <span class="kw">null</span>.

As with time-of-day literals, time-of-day values may be specified to any precision.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

{: #nullological-operators-3}
### Nullological Operators

#### Coalesce

**Signature:**

```cql
Coalesce<T>(argument1 T, argument2 T) T
Coalesce<T>(argument1 T, argument2 T, argument3 T) T
Coalesce<T>(argument1 T, argument2 T, argument3 T, argument4 T) T
Coalesce<T>(argument1 T, argument2 T, argument3 T, argument4 T, argument5 T) T
Coalesce<T>(arguments List<T>) T
```

**Description:**

The <span class="id">Coalesce</span> operator returns the first non-null result in a list of arguments. If all arguments evaluate to <span class="kw">null</span>, the result is <span class="kw">null</span>.

The static type of the first argument determines the type of the result, and all subsequent arguments must be of that same type.

The following examples illustrate the behavior of the <span class="id">Coalesce</span> operator:

```cql
define "Coalesce15": Coalesce(null, 15, null)
define "IsNull": Coalesce({ null, null, null })
define "CoalesceError": Coalesce(null, 15, null, null, null, null) // more than 5 inputs must be represented as list
```

#### IsNull

**Signature:**

```cql
is null(argument Any) Boolean
```

**Description:**

The <span class="kw">is null</span> operator determines whether or not its argument evaluates to <span class="kw">null</span>. If the argument evaluates to <span class="kw">null</span>, the result is <span class="kw">true</span>; otherwise, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">is null</span> operator:

```cql
define "IsTrue": null is null
define "IsFalse": true is null
```

#### IsFalse

**Signature:**

```cql
is false(argument Boolean) Boolean
```

**Description:**

The <span class="kw">is false</span> operator determines whether or not its argument evaluates to <span class="kw">false</span>. If the argument evaluates to <span class="kw">false</span>, the result is <span class="kw">true</span>; otherwise, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">is false</span> operator:

```cql
define "IsFalseIsTrue": false is false
define "IsFalseIsFalse": null is false
```

#### IsTrue

**Signature:**

```cql
is true(argument Boolean) Boolean
```

**Description:**

The <span class="kw">is true</span> operator determines whether or not its argument evaluates to <span class="kw">true</span>. If the argument evaluates to <span class="kw">true</span>, the result is <span class="kw">true</span>; otherwise, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">is true</span> operator:

```cql
define "IsTrueIsTrue": true is true
define "IsTrueIsFalse": false is true
```

{: #comparison-operators-4}
### Comparison Operators

#### Between

**Signature:**

```cql
between(argument Integer, low Integer, high Integer) Boolean
between(argument Long, low Long, high Long) Boolean
between(argument Decimal, low Decimal, high Decimal) Boolean
between(argument Quantity, low Quantity, high Quantity) Boolean
between(argument Date, low Date, high Date) Boolean
between(argument DateTime, low DateTime, high DateTime) Boolean
between(argument Time, low Time, high Time) Boolean
between(argument String, low String, high String) Boolean
between(argument Interval<T>, low T, high T) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The between operator determines whether the first argument is within a given range, inclusive. If the first argument is greater than or equal to the low argument, and less than or equal to the high argument, the result is <span class="kw">true</span>, otherwise, the result is <span class="kw">false</span>.

For comparisons involving quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>.

For comparisons involving Date, DateTime, or Time values with imprecision, note that the result of the comparison may be <span class="kw">null</span>, depending on whether the values involved are specified to the level of precision used for the comparison. For example:

```cql
define "DateTimeBetweenIsNull": @2012-01-01 between @2012-01-01T12 and @2012-01-02T12
```

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

For integer and decimal values, standard ordinal semantics apply.

String comparisons are strictly lexical based on the Unicode value of the individual characters in the string.

When the first argument to a between is an interval, the operator is a synonym for the [during (or included in)](#included-in) operator, using the first argument and an inclusive interval constructed from the second and third arguments. For example:

```cql
define "Retinal Exam in Measurement Period or Year Prior":
  ["Physical Exam, Performed": "Retinal or Dilated Eye Exam"] RetinalExam
    where RetinalExam.relevantPeriod between start of "Measurement Period" - 1 year and end of "Measurement Period"
```

is equivalent to:

```cql
define "Retinal Exam in Measurement Period or Year Prior":
  ["Physical Exam, Performed": "Retinal or Dilated Eye Exam"] RetinalExam
    where RetinalExam.relevantPeriod during Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"]
```

If any argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">between</span> operator:

```cql
define "IntegerBetweenIsTrue": 4 between 2 and 6
define "LongBetweenIsTrue": 4L between 2L and 6L
define "DecimalBetweenIsFalse": 3.5 between 3.6 and 4.8
define "QuantityBetweenIsNull": 3.5 'cm2' between 3.0 'cm' and 4.8 'cm'
```

#### Equal

**Signature:**

```cql
=<T>(left T, right T) Boolean
```

**Description:**

The _equal_ (<span class="sym">=</span>) operator returns <span class="kw">true</span> if the arguments are equal; <span class="kw">false</span> if the arguments are known unequal, and <span class="kw">null</span> otherwise. Equality semantics are defined to be value-based.

For simple types, this means that equality returns <span class="kw">true</span> if and only if the result of each argument evaluates to the same value.

For string values, equality is strictly lexical based on the Unicode values for the individual characters in the strings.

For decimal values, trailing zeroes are ignored.

For quantities, this means that the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

For time-valued quantities, UCUM definite-time duration quantities above days (and weeks) are not comparable to calendar duration quantities above days (and weeks). Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics:

```cql
1 year = 12 months
1 week = 7 days
1 day = 24 hours
1 hour = 60 minutes
1 minute = 60 seconds
1 second = 1000 milliseconds
```

In particular, unit conversion between variable length calendar durations (i.e. years and months) and definite-time durations (i.e. days or below) results in <span class="kw">null</span>.

For ratios, this means that the numerator and denominator must be the same, using quantity equality semantics.

For tuple types, this means that equality returns <span class="kw">true</span> if and only if the tuples are of the same type, and the values for all elements that have values, by name, are equal, defined as a conjunction of equality comparisons.

For list types, this means that equality returns <span class="kw">true</span> if and only if the lists contain elements of the same type, have the same number of elements, and for each element in the lists, in order, the elements are equal using equality semantics, with the exception that null elements are considered equal.

For interval types, equality returns <span class="kw">true</span> if and only if the intervals are over the same point type, and they have the same value for the starting and ending points of the interval as determined by the <span class="id">Start</span> and <span class="id">End</span> operators.

For Date, DateTime, and Time values, the comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the values are different, the comparison stops and the result is <span class="kw">false</span>. If one input has a value for the precision and the other does not, the comparison stops and the result is <span class="kw">null</span>; if neither input has a value for the precision, or the last precision has been reached, the comparison stops and the result is <span class="kw">true</span>. For the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal equality semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _equal_ operator:

```cql
define "IntegerEqualIsTrue": 4 = (2 + 2)
define "LongEqualIsTrue": 4L = (2L + 2L)
define "DecimalEqualIsFalse": 3.5 = (3.5 - 0.1)
define "StringEqualIsFalse": 'John Doe' = 'john doe'
define "QuantityEqualIsNull": 3.5 'cm2' = 3.5 'cm'
define "RatioEqualIsTrue": 1:8 = 1:8
define "RatioEqualIsFalse": 1:8 = 2:16
define "ListEqualIsTrue": { null, 1, 2, 3 } = { null, 1, 2, 3 }
define "DateTimeEqualIsNull": @2012-01-01 = @2012-01-01T12
define "DateTimeWithMillisecondsEqualIsTrue": @2024-11-15T12:30:00.0 = @2024-11-15T12:30:00 // true, RHS interpreted as 00.0
define "DateTimeWithMillisecondsEqualIsFalse": @2024-11-15T12:30:00.5 = @2024-11-15T12:30:00 // false, RHS interpreted as 00.0
define "DateTimeWithMillisecondsEqualIsNull": @2024-11-15T12:30:00.5 = @2024-11-14T12:30 // null, RHS has uncertain seconds + milliseconds
define "NullEqualIsNull": null = null
define "TupleEqualBothNullTrue": { x: 1, y: null } = { x: 1, y: null }
define "TupleEqualBothNullFalse": { x: 1, y: null } = { x: 2, y: null }
define "TupleEqualMixedNullNull": { x: 1, y: 1 } = { x: null, y: 1 }
define "TupleEqualMixedNullFalse": { x: 1, y: 1 } = { x: null, y: 2 }
```

#### Equivalent

**Signature:**

```cql
~<T>(left T, right T) Boolean
```

**Description:**

The _equivalent_ (<span class="sym">~</span>) operator returns <span class="kw">true</span> if the arguments are equivalent in value, or if they are both <span class="kw">null</span>; and <span class="kw">false</span> otherwise.

With the exception of null behavior and the semantics for specific types defined below, equivalence is the same as equality.

For string values, equivalence returns true if the strings are the same value while ignoring case and locale, and normalizing whitespace. Normalizing whitespace means that all whitespace characters are treated as equivalent, with whitespace characters as defined in the whitespace lexical category. Note that <span class="kw">null</span> is not equivalent to the empty string (<span class="lit">''</span>).

For decimals, equivalent means the values are the same with the comparison done on values rounded to the precision of the least precise operand; trailing zeroes after the decimal are ignored in determining precision for equivalent comparison.

For quantities, equivalent means the values are the same quantity when considering unit conversion (e.g. 100 'cm' ~ 1 'm') and using decimal equivalent semantics for the value. Note that implementations are not required to support unit conversion and so are allowed to return false for equivalence of quantities with different units.

For time-valued quantities, UCUM definite-time duration quantities above days (and weeks) are considered equivalent to their calendar duration counterparts:

```cql
1 year ~ 1 'a'
1 month ~ 1 'mo'
1 week = 1 'wk' // and 1 week ~ 1 'wk'
1 day = 1 'd' // and 1 day ~ 1 'd'
1 hour = 1 'h' // and 1 hour ~ 1 'h'
1 minute = 1 'min' // and 1 minute ~ 1 'min'
1 second = 1 's' // and 1 second ~ 1 's'
1 millisecond = 1 'ms' // and 1 millsecond ~ 1 'ms'
```

Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics:

```cql
1 year ~ 12 months
1 year ~ 365 days
1 month ~ 30 days
1 week = 7 days
1 day = 24 hours
1 hour = 60 minutes
1 minute = 60 seconds
1 second = 1000 milliseconds
```

For ratios, equivalent means that the numerator and denominator represent the same ratio (e.g. `1:100 ~ 10:1000`).

For tuple types, this means that two tuple values are equivalent if and only if the tuples are of the same type, and the values for all elements by name are equivalent.

For list types, this means that two list values are equivalent if and only if the lists contain elements of the same type, have the same number of elements, and for each element in the lists, in order, the elements are equivalent.

For interval types, this means that two intervals are equivalent if and only if the intervals are over the same point type, and the starting and ending points of the intervals as determined by the <span class="id">Start</span> and <span class="id">End</span> operators are equivalent.

For Date, DateTime, and Time values, the comparison is performed in the same way as it is for equality, except that if one input has a value for a given precision and the other does not, the comparison stops and the result is <span class="kw">false</span>, rather than <span class="kw">null</span>. As with equality, the second and millisecond precisions are combined as a single precision using a decimal, with decimal equivalence semantics.

For <span class="id">Code</span> values, equivalence is defined based on the code and system elements only. The version and display elements are ignored for the purposes of determining <span class="id">Code</span> equivalence.

For <span class="id">Concept</span> values, equivalence is defined as a non-empty intersection of the codes in each <span class="id">Concept</span>.

Note that this operator will always return <span class="kw">true</span> or <span class="kw">false</span>, even if either or both of its arguments are <span class="kw">null</span>, or contain <span class="kw">null</span> components.

The following examples illustrate the behavior of the _equivalent_ operator:

```cql
define "IntegerEquivalentIsTrue": 4 ~ (2 + 2)
define "LongEquivalentIsTrue": 4L ~ (2L + 2L)
define "DecimalEquivalentIsFalse": 3.5 ~ (3.5 - 0.1)
define "StringEquivalentIsTrue": 'John Doe' ~ 'john doe'
define "QuantityEquivalentIsFalse": 3.5 'cm2' ~ 3.5 'cm'
define "RatioEquivalentIsTrue": 1:8 ~ 2:16
define "ListEquivalentIsTrue": { null, 1, 2, 3 } ~ { null, 1, 2, 3 }
define "DateTimeEquivalentIsFalse": @2012-01-01 ~ @2012-01-01T12
define "NullEquivalentIsTrue": null ~ null
```

#### Greater

**Signature:**

```cql
>(left Integer, right Integer) Boolean
>(left Long, right Long) Boolean
>(left Decimal, right Decimal) Boolean
>(left Quantity, right Quantity) Boolean
>(left Date, right Date) Boolean
>(left DateTime, right DateTime) Boolean
>(left Time, right Time) Boolean
>(left String, right String) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _greater_ (<span class="sym">></span>) operator returns <span class="kw">true</span> if the first argument is greater than the second argument.

String comparisons are strictly lexical based on the Unicode value of the individual characters in the string.

For comparisons involving quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

For time-valued quantities, the UCUM definite-quantity durations above days (and weeks) are not comparable to calendar durations. Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics. In particular, unit conversion between variable length calendar durations (i.e. years and months) and definite-time durations (i.e. days or below) results in <span class="kw">null</span>.

For Date, DateTime, and Time values, the comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is greater than the second, the result is <span class="kw">true</span>; if the first value is less than the second, the result is <span class="kw">false</span>; if one input has a value for the precision and the other does not, the comparison stops and the result is <span class="kw">null</span>; if neither input has a value for the precision or the last precision has been reached, the comparison stops and the result is <span class="kw">false</span>. For example:

```cql
define "DateTimeGreaterIsNull": @2012-01-01 > @2012-01-01T12
```

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

For integer and decimal values, standard ordinal semantics apply.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _greater_ operator:

```cql
define "IntegerGreaterIsTrue": 4 > 3
define "LongGreaterIsTrue": 4L > 3L
define "DecimalGreaterIsFalse": 3.5 > 3.5
define "QuantityGreaterIsNull": 3.6 'cm2' > 3.5 'cm'
define "NullGreaterIsNull": null > 5
define "DateTimeWithMillisecondsGreaterIsFalse": @2024-11-15T12:30:00.0 > @2024-11-15T12:30:00 // false, RHS interpreted as 00.0
define "DateTimeWithMillisecondsGreaterIsTrue": @2024-11-15T12:30:00.5 > @2024-11-15T12:30:00 // true, RHS interpreted as 00.0
define "DateTimeWithMillisecondsGreaterIsNull": @2024-11-15T12:30:00.5 > @2024-11-14T12:30 // null, RHS has uncertain seconds + milliseconds
```

> Note that relative ratio comparisons are not directly supported due to the variance of uses within healthcare. See the discussion in [Ratio Operators](02-authorsguide.html#ratio-operators) for more information.
{: .note-info}


#### Greater Or Equal

**Signature:**

```cql
>=(left Integer, right Integer) Boolean
>=(left Long, right Long) Boolean
>=(left Decimal, right Decimal) Boolean
>=(left Quantity, right Quantity) Boolean
>=(left Date, right Date) Boolean
>=(left DateTime, right DateTime) Boolean
>=(left Time, right Time) Boolean
>=(left String, right String) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _greater or equal_ (<span class="sym">>=</span>) operator returns <span class="kw">true</span> if the first argument is greater than or equal to the second argument.

String comparisons are strictly lexical based on the Unicode value of the individual characters in the string.

For comparisons involving quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

For time-valued quantities, the UCUM definite-quantity durations above days (and weeks) are not comparable to calendar durations. Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics. In particular, unit conversion between variable length calendar durations (i.e. years and months) and definite-time durations (i.e. days or below) results in <span class="kw">null</span>.

For Date, DateTime, and Time values, the comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is greater than the second, the result is <span class="kw">true</span>; if the first value is less than the second, the result is <span class="kw">false</span>; if one input has a value for the precision and the other does not, the comparison stops and the result is <span class="kw">null</span>; if neither input has a value for the precision or the last precision has been reached, the comparison stops and the result is <span class="kw">true</span>. For example:

```cql
define "DateTimeGreaterOrEqualIsNull": @2012-01-01 >= @2012-01-01T12
```

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _greater or equal_ operator:

```cql
define "IntegerGreaterOrEqualIsTrue": 4 >= (2 + 2)
define "LongGreaterOrEqualIsTrue": 4L >= (2L + 2L)
define "DecimalGreaterOrEqualIsFalse": 3.5 >= (3.5 + 0.1)
define "QuantityGreaterOrEqualIsNull": 3.6 'cm2' >= 3.5 'cm'
define "NullGreaterOrEqualIsNull": null >= 5
```

> Note that relative ratio comparisons are not directly supported due to the variance of uses within healthcare. See the discussion in [Ratio Operators](02-authorsguide.html#ratio-operators) for more information.
{: .note-info}

#### Less

**Signature:**

```cql
<(left Integer, right Integer) Boolean
<(left Long, right Long) Boolean
<(left Decimal, right Decimal) Boolean
<(left Quantity, right Quantity) Boolean
<(left Date, right Date) Boolean
<(left DateTime, right DateTime) Boolean
<(left Time, right Time) Boolean
<(left String, right String) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _less_ (<span class="sym">&lt;</span>) operator returns <span class="kw">true</span> if the first argument is less than the second argument.

String comparisons are strictly lexical based on the Unicode value of the individual characters in the string.

For comparisons involving quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

For time-valued quantities, the UCUM definite-quantity durations above days (and weeks) are not comparable to calendar durations. Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics. In particular, unit conversion between variable length calendar durations (i.e. years and months) and definite-time durations (i.e. days or below) results in <span class="kw">null</span>.

For Date, DateTime, and Time values, the comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is less than the second, the result is <span class="kw">true</span>; if the first value is greater than the second, the result is <span class="kw">false</span>; if one input has a value for the precision and the other does not, the comparison stops and the result is <span class="kw">null</span>; if neither input has a value for the precision or the last precision has been reached, the comparison stops and the result is <span class="kw">false</span>. For example:

```cql
define "DateTimeLessIsNull": @2012-01-01 < @2012-01-01T12
```

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _less_ operator:

```cql
define "IntegerLessIsTrue": 4 < (2 + 2 + 2)
define "LongLessIsTrue": 4L < (2L + 2L + 2L)
define "DecimalLessIsFalse": 3.5 < 3.5
define "QuantityLessIsNull": 3.6 'cm2' < 3.5 'cm'
define "DateTimeLessIsNull": @2012-01-01 < @2012-01-01T12
define "NullLessIsNull": null < 5
```

> Note that relative ratio comparisons are not directly supported due to the variance of uses within healthcare. See the discussion in [Ratio Operators](02-authorsguide.html#ratio-operators) for more information.
{: .note-info}

#### Less Or Equal

**Signature:**

```cql
<=(left Integer, right Integer) Boolean
<=(left Long, right Long) Boolean
<=(left Decimal, right Decimal) Boolean
<=(left Quantity, right Quantity) Boolean
<=(left Date, right Date) Boolean
<=(left DateTime, right DateTime) Boolean
<=(left Time, right Time) Boolean
<=(left String, right String) Boolean
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _less or equal_ (<span class="sym">\<=</span>) operator returns <span class="kw">true</span> if the first argument is less than or equal to the second argument.

String comparisons are strictly lexical based on the Unicode value of the individual characters in the string.

For comparisons involving quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> are comparable, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> are not. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

For time-valued quantities, the UCUM definite-quantity durations above days (and weeks) are not comparable to calendar durations. Definite-time duration unit conversions shall be performed as specified in ISO-8601, while calendar-time duration unit conversions shall be performed according to calendar duration semantics. In particular, unit conversion between variable length calendar durations (i.e. years and months) and definite-time durations (i.e. days or below) results in <span class="kw">null</span>.

For Date, DateTime, and Time values, the comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is less than the second, the result is <span class="kw">true</span>; if the first value is greater than the second, the result is <span class="kw">false</span>; if one input has a value for the precision and the other does not, the comparison stops and the result is <span class="kw">null</span>; if neither input has a value for the precision or the last precision has been reached, the comparison stops and the result is <span class="kw">true</span>. For example:

```cql
define "DateTimeLessOrEqualIsNull": @2012-01-01 <= @2012-01-01T12
```

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _less or equal_ operator:

```cql
define "IntegerLessOrEqualIsTrue": 4 <= (2 + 2)
define "LongLessOrEqualIsTrue": 4L <= (2L + 2L)
define "DecimalLessOrEqualIsFalse": 3.5 <= (3.5 - 0.1)
define "QuantityLessOrEqualIsNull": 3.6 'cm2' <= 3.6 'cm'
define "NullLessOrEqualIsNull": null <= 5
```

> Note that relative ratio comparisons are not directly supported due to the variance of uses within healthcare. See the discussion in [Ratio Operators](02-authorsguide.html#ratio-operators) for more information.
{: .note-info}

#### Not Equal

**Signature:**

```cql
!=<T>(left T, right T) Boolean
```

**Description:**

The _not equal_ (<span class="sym">!=</span>) operator returns <span class="kw">true</span> if its arguments are not the same value.

The _not equal_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equal_ operator.

The following examples illustrate the behavior of the _not equal_ operator:

```cql
define "IntegerNotEqualIsFalse": 4 != (2 + 2)
define "LongNotEqualIsFalse": 4L != (2L + 2L)
define "DecimalNotEqualIsTrue": 3.5 != (3.5 - 0.1)
define "StringNotEqualIsTrue": 'John Doe' != 'john doe'
define "QuantityNotEqualIsNull": 3.5 'cm2' != 3.5 'cm'
define "ListNotEqualIsNull": { null, 1, 2, 3 } != { null, 1, 2, 3 }
define "DateTimeNotEqualIsNull": @2012-01-01 != @2012-01-01T12
define "NullNotEqualIsNull": null != null
```

#### Not Equivalent

**Signature:**

```cql
!~<T>(left T, right T) Boolean
```

**Description:**

The _not equivalent_ (<span class="sym">!~</span>) operator returns <span class="kw">true</span> if its arguments are not equivalent.

The _not equivalent_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equivalent_ operator.

The following examples illustrate the behavior of the _not equivalent_ operator:

```cql
define "IntegerNotEquivalentIsFalse": 4 !~ (2 + 2)
define "LongNotEquivalentIsFalse": 4L !~ (2L + 2L)
define "DecimalNotEquivalentIsTrue": 3.5 !~ (3.5 - 0.1)
define "StringNotEquivalentIsFalse": 'John Doe' !~ 'john doe'
define "QuantityNotEquivalentIsTrue": 3.5 'cm2' !~ 3.5 'cm'
define "ListNotEquivalentIsFalse": { null, 1, 2, 3 } !~ { null, 1, 2, 3 }
define "DateTimeNotEquivalentIsTrue": @2012-01-01 !~ @2012-01-01T12
define "NullNotEquivalentIsFalse": null !~ null
```

{: #arithmetic-operators-4}
### Arithmetic Operators

The arithmetic operators provide a complete set of operations for performing arithmetic calculations in CQL. In general, operations that cause arithmetic overflow or underflow, or otherwise cannot be performed (such as division by 0) will result in null, rather than a run-time error.

#### Abs

**Signature:**

```cql
Abs(argument Integer) Integer
Abs(argument Long) Long
Abs(argument Decimal) Decimal
Abs(argument Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">Abs</span> operator returns the absolute value of its argument.

When taking the absolute value of a quantity, the unit is unchanged.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of taking the absolute value of the input cannot be represented (e.g. `Abs(minimum Integer)`), the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Abs</span> operator:

```cql
define "IntegerAbs": Abs(-5) // 5
define "IntegerAbsIsNull": Abs(null as Integer)
define "LongAbs": Abs(-5000000L) // 5000000L
define "DecimalAbs": Abs(-5.5) // 5.5
define "QuantityAbs": Abs(-5.5 'mg') // 5.5 'mg'
```

#### Add

**Signature:**

```cql
+(left Integer, right Integer) Integer
+(left Long, right Long) Long
+(left Decimal, right Decimal) Decimal
+(left Quantity, right Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _add_ (<span class="sym">+</span>) operator performs numeric addition of its arguments.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span>, the <span class="id">Long</span> argument will be implicitly converted to <span class="id">Decimal</span>.

When invoked with mixed <span class="id">Decimal</span> and <span class="id">Quantity</span> arguments, the <span class="id">Decimal</span> argument will be implicitly converted to <span class="id">Quantity</span>.

When adding quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> can be added, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> cannot. The unit of the result will be the most granular unit of either input. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the addition cannot be represented (i.e. arithmetic overflow), the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _add_ operator:

```cql
define "IntegerAdd": 2 + 2 // 4
define "IntegerAddIsNull": 2 + null
define "LongAdd": 25L + 5 // 30L
define "DecimalAdd": 2.5 + 5 // 7.5
define "QuantityAdd": -5.5 'mg' + 2 'mg' // -3.5 'mg'
define "QuantityAddIsNull": -5.5 'cm' + 2 'cm2'
```

#### Ceiling

**Signature:**

```cql
Ceiling(argument Decimal) Integer
```

**Description:**

The <span class="id">Ceiling</span> operator returns the first integer greater than or equal to the argument.

When invoked with an <span class="id">Integer</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Ceiling</span> operator:

```cql
define "IntegerCeiling": Ceiling(1) // 1
define "DecimalCeiling": Ceiling(1.1) // 2
define "QuantityCeilingIsNull": Ceiling(null as Decimal)
```

#### Divide

**Signature:**

```cql
/(left Decimal, right Decimal) Decimal
/(left Quantity, right Quantity) Quantity
```

**Description:**

The _divide_ (<span class="sym">/</span>) operator performs numeric division of its arguments. Note that this operator is <span class="id">Decimal</span> division; for <span class="id">Integer</span> division, use the _truncated divide_ (<span class="kw">div</span>) operator.

When invoked with <span class="id">Integer</span> or <span class="id">Long</span> arguments, the arguments will be implicitly converted to <span class="id">Decimal</span>.

When invoked with a mixture of <span class="id">Decimal</span> and <span class="id">Quantity</span> arguments, the <span class="id">Decimal</span> arguments will be implicitly converted to <span class="id">Quantity</span>.

For division operations involving quantities, the resulting quantity will have the appropriate unit. For example:

```cql
12 'cm2' / 3 'cm'
```

In this example, the result will have a unit of <span class="lit">'cm'</span>. Note that when performing division of quantities with the same units, the result will have the default UCUM unit (<span class="lit">'1'</span>). When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the division cannot be represented, or the right argument is 0, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _divide_ operator:

```cql
define "IntegerDivide": 4.0 / 2 // 2.0
define "LongDivide": 4.0 / 2L // 2.0
define "DecimalDivide": 9.9 / 3.0 // 3.3
define "DecimalDivideIsNull": 2.2 / null
define "DecimalDivideByZeroIsNull": 2.2 / 0 // null
define "QuantityDivide": -5.5 'mg' / 2.0 'mg' // -2.75
```

#### Floor

**Signature:**

```cql
Floor(argument Decimal) Integer
```

**Description:**

The <span class="id">Floor</span> operator returns the first integer less than or equal to the argument.

When invoked with an <span class="id">Integer</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Floor</span> operator:

```cql
define "IntegerFloor": Floor(1) // 1
define "DecimalFloor": Floor(2.1) // 2
define "QuantityFloorIsNull": Floor(null as Decimal)
```

#### Exp

**Signature:**

```cql
Exp(argument Decimal) Decimal
```

**Description:**

The <span class="id">Exp</span> operator raises _e_ to the power of its argument.

When invoked with an <span class="id">Integer</span> or <span class="id">Long</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Exp</span> operator:

```cql
define "IntegerExp": Exp(0) // 1.0
define "LongExp": Exp(0L) // 1.0
define "DecimalExp": Exp(-0.0) // 1.0
define "QuantityExpIsNull": Exp(null as Decimal)
```

#### HighBoundary

**Signature:**

```cql
HighBoundary(input Decimal, precision Integer) Decimal
HighBoundary(input Date, precision Integer) Date
HighBoundary(input DateTime, precision Integer) DateTime
HighBoundary(input Time, precision Integer) Time
```

**Description:**

The <span class="id">HighBoundary</span> function returns the greatest possible value of the input to the specified precision.

If no precision is specified, the greatest precision of the type of the input value is used (i.e. at least 8 for Decimal, 4 for Date, at least 17 for DateTime, and at least 9 for Time).

If the precision is greater than the maximum possible precision of the implementation, the result is null.

The function can be used with Decimal, Date, DateTime, and Time values.

```cql
HighBoundary(1.587) // 1.58750000
HighBoundary(1.587, 6) // 1.587500
HighBoundary(1.587, 2) // 1.59
HighBoundary(1.587, 0) // 2
HighBoundary(-1.587) == -1.58650000
HighBoundary(-1.587, 6) == -1.586500
HighBoundary(-1.587, 2) == -1.58
HighBoundary(-1.587, 0) == 1
HighBoundary(@2014, 6) // @2014-12
HighBoundary(@2014-01-01T08, 17) // @2014-01-01T08:59:59.999
HighBoundary(@T10:30, 9) // @T10:30:59.999
```

If the input value is null, the result is null.

#### Log

**Signature:**

```cql
Log(argument Decimal, base Decimal) Decimal
```

**Description:**

The <span class="id">Log</span> operator computes the logarithm of its first argument, using the second argument as the base.

When invoked with <span class="id">Integer</span> or <span class="id">Long</span> arguments, the arguments will be implicitly converted to <span class="id">Decimal</span>.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Log</span> operator:

```cql
define "IntegerLog": Log(16, 2) // 4.0
define "LongLog": Log(16L, 2L) // 4.0
define "DecimalLog": Log(100.0, 10.0) // 2.0
define "QuantityLogIsNull": Log(null, 10.0)
```

#### LowBoundary

**Signature:**

```cql
LowBoundary(input Decimal, precision Integer) Decimal
LowBoundary(input Date, precision Integer) Date
LowBoundary(input DateTime, precision Integer) DateTime
LowBoundary(input Time, precision Integer) Time
```

**Description:**

The <span class="id">LowBoundary</span> function returns the least possible value of the input to the specified precision.

If no precision is specified, the greatest precision of the type of the input value is used (i.e. at least 8 for Decimal, 4 for Date, at least 17 for DateTime, and at least 9 for Time).

If the precision is greater than the maximum possible precision of the implementation, the result is null.

The function can be used with Decimal, Date, DateTime, and Time values.

```cql
LowBoundary(1.587, 8) // 1.58650000
LowBoundary(1.587, 6) // 1.586500
LowBoundary(1.587, 2) // 1.58
LowBoundary(1.587, 0) // 1
LowBoundary(-1.587) // -1.58750000
LowBoundary(-1.587, 6) // -1.587500
LowBoundary(-1.587, 2) // -1.59
LowBoundary(-1.587, 0) // -2
LowBoundary(@2014, 6) // @2014-01
LowBoundary(@2014-01-01T08, 17) // @2014-01-01T08:00:00.000
LowBoundary(@T10:30, 9) // @T10:30:00.000
```

If the input value is null, the result is null.

#### Ln

**Signature:**

```cql
Ln(argument Decimal) Decimal
```

**Description:**

The <span class="id">Ln</span> operator computes the natural logarithm of its argument.

When invoked with an <span class="id">Integer</span> or <span class="id">Long</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Ln</span> operator:

```cql
define "IntegerLn": Ln(1) // 0.0
define "LongLn": Ln(1L) // 0.0
define "DecimalLn": Ln(1.0) // 0.0
define "QuantityLnIsNull": Ln(null as Decimal)
```

#### Maximum

**Signature:**

```cql
maximum<T>() T
```

**Description:**

The <span class="kw">maximum</span> operator returns the maximum representable value for the given type.

The <span class="kw">maximum</span> operator is defined for the <span class="id">Integer</span>, <span class="id">Long</span>, <span class="id">Decimal</span>, <span class="id">Quantity</span>, <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> types.

For <span class="id">Integer</span>, <span class="kw">maximum</span> returns the maximum signed 32-bit integer, 2<sup>31</sup> - 1.

For <span class="id">Long</span>, <span class="kw">maximum</span> returns the maximum signed 64-bit long, 2<sup>63</sup> - 1.

For <span class="id">Decimal</span>, <span class="kw">maximum</span> returns the maximum representable decimal value, (10<sup>28</sup> – 1) / 10<sup>8</sup> (99999999999999999999.99999999).

For <span class="id">Quantity</span>, <span class="kw">maximum</span> returns the maximum representable quantity, i.e. the maximum representable decimal value with a default unit (<span class="sym">1</span>).

For <span class="id">Date</span>, <span class="kw">maximum</span> returns the maximum representable date value, <span class="id">Date</span>(<span class="lit">9999</span>, <span class="lit">12</span>, <span class="lit">31</span>).

For <span class="id">DateTime</span>, <span class="kw">maximum</span> returns the maximum representable datetime value, <span class="id">DateTime</span>(<span class="lit">9999</span>, <span class="lit">12</span>, <span class="lit">31</span>, <span class="lit">23</span>, <span class="lit">59</span>, <span class="lit">59</span>, <span class="lit">999</span>).

For <span class="id">Time</span>, <span class="kw">maximum</span> returns the maximum representable time value, <span class="id">Time</span>(<span class="lit">23</span>, <span class="lit">59</span>, <span class="it">59</span>, <span class="lit">999</span>).

For any other type, attempting to invoke <span class="kw">maximum</span> results in an error.

> Note that implementations may choose to represent the maximum DateTime value using a constant offset such as UTC.
{: .note-warning}

> Note that if implementations support larger and/or more precise values than the minimum required precision and scale for Decimal, DateTime, and Time values, they will return the maximum representable decimal for the implementation.
{: .note-warning}

The following examples illustrate the behavior of the <span class="kw">maximum</span> operator:

```cql
define "IntegerMaximum": maximum Integer // 2147483647
define "LongMaximum": maximum Long // 9223372036854775807
define "DateTimeMaximum": maximum DateTime // @9999-12-31T23:59:59.999
define "ErrorMaximum": maximum Quantity
```

#### Minimum

**Signature:**

```cql
minimum<T>() T
```

**Description:**

The <span class="kw">minimum</span> operator returns the minimum representable value for the given type.

The <span class="kw">minimum</span> operator is defined for the <span class="id">Integer</span>, <span class="id">Long</span>, <span class="id">Decimal</span>, <span class="id">Quantity</span>, <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> types.

For <span class="id">Integer</span>, <span class="kw">minimum</span> returns the minimum signed 32-bit integer, -2<sup>31</sup>.

For <span class="id">Long</span>, <span class="kw">minimum</span> returns the minimum signed 64-bit long, -2<sup>63</sup>.

For <span class="id">Decimal</span>, <span class="kw">minimum</span> returns the minimum representable decimal value, (-10<sup>28</sup> + 1) / 10<sup>8</sup> (-99999999999999999999.99999999).

For <span class="id">Quantity</span>, <span class="kw">minimum</span> returns the minimum representable quantity, i.e. the minimum representable decimal value with a default unit (<span class="sym">1</span>).

For <span class="id">Date</span>, <span class="kw">minimum</span> returns the minimum representable date value, <span class="id">DateTime</span>(<span class="lit">1</span>, <span class="lit">1</span>, <span class="lit">1</span>).

For <span class="id">DateTime</span>, <span class="kw">minimum</span> returns the minimum representable datetime value, <span class="id">DateTime</span>(<span class="lit">1</span>, <span class="lit">1</span>, <span class="lit">1</span>, <span class="lit">0</span>, <span class="lit">0</span>, <span class="lit">0</span>, <span class="lit">0</span>).

For <span class="id">Time</span>, <span class="kw">minimum</span> returns the minimum representable time value, <span class="id">Time</span>(<span class="lit">0</span>, <span class="lit">0</span>, <span class="lit">0</span>, <span class="lit">0</span>).

For any other type, attempting to invoke <span class="kw">minimum</span> results in an error.

> Note that implementations may choose to represent the minimum DateTime value using a constant offset such as UTC.
{: .note-warning}

> Note that if implementations support larger and/or more precise values than the minimum required precision and scale for Decimal, DateTime, and Time values, they will return the minimum representable decimal for the implementation.
{: .note-warning}

The following examples illustrate the behavior of the <span class="kw">minimum</span> operator:

```cql
define "IntegerMinimum": minimum Integer // -2147483648
define "LongMinimum": minimum Long // -9223372036854775808
define "DateTimeMinimum": minimum DateTime // @0001-01-01T00:00:00.000
define "ErrorMinimum": minimum Quantity
```

#### Modulo

**Signature:**

```cql
mod(left Integer, right Integer) Integer
mod(left Long, right Long) Long
mod(left Decimal, right Decimal) Decimal
mod(left Quantity, right Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
> The Quantity overload for this operator was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="kw">mod</span> operator computes the remainder of the division of its arguments.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span> arguments, the <span class="id">Long</span> argument will be implicitly convert to <span class="id">Decimal</span>.

When invoked with mixed <span class="id">Integer</span> or <span class="id">Decimal</span>, and <span class="id">Quantity</span> arguments, the <span class="id">Integer</span> or <span class="id">Decimal</span> argument will be implicitly converted to <span class="id">Quantity</span>.

For modulo operations involving quantities, the resulting quantity will have the appropriate unit.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the modulo cannot be represented, or the right argument is 0, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">mod</span> operator:

```cql
define "IntegerModulo": 3 mod 2 // 1
define "LongModulo": 3L mod 2 // 1L
define "DecimalModulo": 2.5 mod 2 // 0.5
define "ModuloIsNull": 2.5 mod null
```

#### Multiply

**Signature:**

```cql
*(left Integer, right Integer) Integer
*(left Long, right Long) Long
*(left Decimal, right Decimal) Decimal
*(left Quantity, right Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _multiply_ (<span class="sym">*</span>) operator performs numeric multiplication of its arguments.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span> arguments, the <span class="id">Long</span> argument will be implicitly converted to <span class="id">Decimal</span>.

When invoked with mixed <span class="id">Decimal</span> and <span class="id">Quantity</span> arguments, the <span class="id">Decimal</span> argument will be implicitly converted to <span class="id">Quantity</span>.

For multiplication operations involving quantities, the resulting quantity will have the appropriate unit. For example:

```cql
12 'cm' * 3 'cm'
3 'cm' * 12 'cm2'
```

In this example, the first result will have a unit of <span class="lit">'cm2'</span>, and the second result will have a unit of <span class="lit">'cm3'</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

#### Negate

**Signature:**

```cql
-(argument Integer) Integer
-(argument Long) Long
-(argument Decimal) Decimal
-(argument Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _negate_ (<span class="sym">-</span>) operator returns the negative of its argument.

When negating quantities, the unit is unchanged.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of negating the argument cannot be represented (e.g. `-(minimum Integer)`), the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _negate_ operator:

```cql
define "IntegerNegate": -3 // -3
define "LongNegate": -3L // -3L
define "DecimalNegate": -(-3.3) // 3.3
define "QuantityNegate": -3.3 'mg' // -3.3 'mg'
define "NegateIsNull": -(null as Integer)
```

#### Precision

**Signature:**

```cql
Precision(argument Decimal) Integer
Precision(argument Date) Integer
Precision(argument DateTime) Integer
Precision(argument Time) Integer
```

**Description:**

The Precision function returns the number of digits of precision in the input value.

The function can be used with Decimal, Date, DateTime, and Time values.

For Decimal values, the function returns the number of digits of precision after the decimal place in the input value.

```cql
Precision(1.58700) // 5
```

For Date and DateTime values, the function returns the number of digits of precision in the input value.

```cql
Precision(@2014) // 4
Precision(@2014-01-05T10:30:00.000) // 17
Precision(@T10:30) // 4
Precision(@T10:30:00.000) // 9
```

If the argument is null, the result is null.

#### Predecessor

**Signature:**

```cql
predecessor of<T>(argument T) T
```

**Description:**

The <span class="kw">predecessor</span> operator returns the predecessor of the argument. For example, the predecessor of 2 is 1. If the argument is already the minimum value for the type, a <span class="kw">null</span> is returned.

The <span class="kw">predecessor</span> operator is defined for the <span class="id">Integer</span>, <span class="id">Long</span>, <span class="id">Decimal</span>, <span class="id">Quantity</span>, <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> types.

For <span class="id">Integer</span>, <span class="kw">predecessor</span> is equivalent to subtracting 1.

For <span class="id">Long</span>, <span class="kw">predecessor</span> is equivalent to subtracting 1L.

For <span class="id">Decimal</span>, <span class="kw">predecessor</span> is equivalent to subtracting 1 * the precision of the argument.

For <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> values, <span class="kw">predecessor</span> is equivalent to subtracting a time-unit quantity for the lowest specified precision of the value. For example, if the <span class="id">DateTime</span> is fully specified, <span class="kw">predecessor</span> is equivalent to subtracting 1 * the precision of the combined seconds and milliseconds, represented as a Decimal; if the <span class="id">DateTime</span> is specified to the second, <span class="kw">predecessor</span> is equivalent to subtracting one second, etc.

For <span class="id">Quantity</span> values, the <span class="kw">predecessor</span> is equivalent to subtracting 1 * the precision of the quantity value. The units are unchanged.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented (i.e. would result in an underflow), the result is <span class="kw">null</span>.

> Note that implementations that support more precise values than the minimum required precision and scale for Decimal, DateTime, and Time values, the predecessor will reflect the minimum representable step size for the implementation.
{: .note-warning}

The following examples illustrate the behavior of the <span class="kw">predecessor</span> operator:

```cql
define "IntegerPredecessor": predecessor of 100 // 99
define "LongPredecessor": predecessor of 100L // 99L
define "DecimalPredecessor": predecessor of 1.0 // 0.9
define "DecimalHundredthsPredecessor": predecessor of 1.01 // 1.00
define "DecimalMostPrecisePredecessor": predecessor of 1.00000000 // 0.99999999
define "DatePredecessor": predecessor of @2014-01-01 // @2013-12-31
define "DateTimeMillisecondsPredecessor": predecessor of @2014-01-01T08:30:00.0 // @2014-01-01T08:29:59.9
define "QuantityPredecessor": predecessor of 2.54 'cm' // 2.53 'cm'
define "PredecessorIsNull": predecessor of (null as Quantity)
```

#### Power

**Signature:**

```cql
^(argument Integer, exponent Integer) Integer
^(argument Long, exponent Long) Long
^(argument Decimal, exponent Decimal) Decimal
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _power_ (<span class="sym">^</span>) operator raises the first argument to the power given by the second argument.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span> arguments, the <span class="id">Long</span> argument will. be implicitly converted to <span class="id">Decimal</span>.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _power_ operator:

```cql
define "IntegerPower": 2^3 // 8
define "IntegerPowerFun": Power(2, 3) // 8
define "LongPower": 2L^3L // 8L
define "DecimalPower": 2.5^2.0 // 6.25
define "NegateIsNull": 2.5^null
```

#### Round

**Signature:**

```cql
Round(argument Decimal) Decimal
Round(argument Decimal, precision Integer) Decimal
Round(argument Quantity) Quantity
Round(argument Quantity, precision Integer) Quantity
```

> The Quantity overloads of the Round function were introduced in CQL 2.0, and have trial-use status.
{: .note-info}

**Description:**

The <span class="id">Round</span> operator returns the nearest whole number to its argument. The semantics of round are defined as a traditional round (i.e. to the nearest whole number), meaning that a decimal value greater than or equal to 0.5 and less than 1.0 will round to 1, and a decimal value less than or equal to -0.5 and greater than -1.0 will round to -1.

When invoked with an <span class="id">Integer</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

When invoked with a <span class="id">Quantity</span> argument, units are not impacted (i.e. the result has the same units as the input).

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Precision determines the decimal place at which the rounding will occur. If precision is not specified or <span class="kw">null</span>, 0 is assumed.

The following examples illustrate the behavior of the <span class="id">Round</span> operator:

```cql
define "IntegerRound": Round(1) // 1
define "DecimalRound": Round(3.14159, 3) // 3.142
define "RoundIsNull": Round(null) // null
define "RoundPointFive": Round(0.5) // 1
define "RoundNegativePointFive": Round(-0.5) // -1
define "QuantityRound": Round(2.54 'cm') // 2 'cm'
```

#### Subtract

**Signature:**

```cql
-(left Integer, right Integer) Integer
-(left Long, right Long) Long
-(left Decimal, right Decimal) Decimal
-(left Quantity, right Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The _subtract_ (<span class="sym">-</span>) operator performs numeric subtraction of its arguments.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span> arguments, the <span class="id">Long</span> argument will be implicitly converted to <span class="id">Decimal</span>.

When subtracting quantities, the dimensions of each quantity must be the same, but not necessarily the unit. For example, units of <span class="lit">'cm'</span> and <span class="lit">'m'</span> can be subtracted, but units of <span class="lit">'cm2'</span> and <span class="lit">'cm'</span> cannot. The unit of the result will be the most granular unit of either input. Attempting to operate on quantities with invalid units will result in a <span class="kw">null</span>. When a quantity has no units specified, it is treated as a quantity with the default unit (<span class="lit">'1'</span>).

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _subtract_ operator:

```cql
define "IntegerSubtract": 2 - 1 // 1
define "LongSubtract": 2L - 1L // 1L
define "DecimalSubtract": 3.14 - 3.12 // 0.02
define "QuantitySubtract": 3.14 'mg' - 3.12 'mg' // 0.02 'mg'
define "QuantitySubtractError": 3.14 'cm' - 3.12 'cm2'
define "SubtractIsNull": 3 - null
```

#### Successor

**Signature:**

```cql
successor of<T>(argument T) T
```

**Description:**

The <span class="kw">successor</span> operator returns the successor of the argument. For example, the successor of 1 is 2. If the argument is already the maximum value for the type, a <span class="kw">null</span> is returned.

The <span class="kw">successor</span> operator is defined for the <span class="id">Integer</span>, <span class="id">Long</span>, <span class="id">Quantity</span>, <span class="id">Decimal</span>, <span class="id">Date</span>, <span class="id">DateTime</span>, and <span class="id">Time</span> types.

For <span class="id">Integer</span>, <span class="kw">successor</span> is equivalent to adding 1.

For <span class="id">Long</span>, <span class="kw">successor</span> is equivalent to adding 1L.

For <span class="id">Decimal</span>, <span class="kw">successor</span> is equivalent to adding 1 * the precision of the argument.

For <span class="id">Date</span>, <span class="id">DateTime</span> and <span class="id">Time</span> values, <span class="kw">successor</span> is equivalent to adding a time-unit quantity for the lowest specified precision of the value. For example, if the <span class="id">DateTime</span> is fully specified, <span class="kw">successor</span> is equivalent to adding 1 * the precision of the combined seconds and milliseconds, represented as a Decimal; if the <span class="id">DateTime</span> is specified to the second, <span class="kw">successor</span> is equivalent to adding one second, etc.

For <span class="id">Quantity</span> values, the <span class="kw">successor</span> is equivalent to adding 1 * the precision of the quantity value. The units are unchanged.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented (i.e. would result in an overflow), the result is <span class="kw">null</span>.

> Note that for implementations that support more precise values than the minimum required precision and scale for Decimal, DateTime, and Time values, the successor may reflect the minimum representable step size for the implementation.
{: .note-warning}

The following examples illustrate the behavior of the <span class="kw">successor</span> operator:

```cql
define "IntegerSuccessor": successor of 100 // 101
define "LongSuccessor": successor of 100L // 101L
define "DecimalSuccessor": successor of 1.0 // 1.1
define "DecimalHundredthsSuccessor": successor of 1.01 // 1.02
define "DecimalMostPreciseSuccessor": successor of 1.00000000 // 1.00000001
define "DateSuccessor": successor of @2014-01-01 // @2014-01-02
define "DateTimeMillisecondsSuccessor": successor of @2014-01-01T08:30:00.0 // @2014-01-01T08:30:00.1
define "QuantitySuccessor": successor of 2.54 'cm' // 2.55 'cm'
define "SuccessorIsNull": successor of (null as Quantity)
```

#### Truncate

**Signature:**

```cql
Truncate(argument Decimal) Integer
```

**Description:**

The <span class="id">Truncate</span> operator returns the integer component of its argument.

When invoked with an <span class="id">Integer</span> argument, the argument will be implicitly converted to <span class="id">Decimal</span>.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Truncate</span> operator:

```cql
define "IntegerTruncate": Truncate(101) // 101
define "DecimalTruncate": Truncate(1.00000001) // 1
define "TruncateIsNull": Truncate(null)
```

#### Truncated Divide

**Signature:**

```cql
div(left Integer, right Integer) Integer
div(left Decimal, right Decimal) Decimal
div(left Long, right Long) Long
div(left Quantity, right Quantity) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
> The Quantity overload for this operator was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="kw">div</span> operator performs truncated division of its arguments.

When invoked with mixed <span class="id">Integer</span> and <span class="id">Decimal</span> or <span class="id">Long</span> arguments, the <span class="id">Integer</span> argument will be implicitly converted to <span class="id">Decimal</span> or <span class="id">Long</span>.

When invoked with mixed <span class="id">Long</span> and <span class="id">Decimal</span> arguments, the <span class="id">Long</span> argument will be implicitly converted to <span class="id">Decimal</span>

When invoked with mixed <span class="id">Integer</span> or <span class="id">Decimal</span> and <span class="id">Quantity</span> arguments, the <span class="id">Integer</span> or <span class="id">Decimal</span> argument will be implicitly converted to <span class="id">Quantity</span>.

For division operations involving quantities, the resulting quantity will have the appropriate unit.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the result of the operation cannot be represented, or the right argument is 0, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">div</span> operator:

```cql
define "IntegerTruncatedDivide": 4 div 2 // 2
define "LongTruncatedDivide": 4L div 2L // 2L
define "DecimalTruncatedDivide": 4.14 div 2.06 // 2
define "TruncatedDivideIsNull": 3 div null
```

{: #string-operators-3}
### String Operators

#### Combine

**Signature:**

```cql
Combine(source List<String>) String
Combine(source List<String>, separator String) String
```

**Description:**

The <span class="id">Combine</span> operator combines a list of strings, optionally separating each string with the given separator.

If the source argument is <span class="kw">null</span>, or the source list is empty, the result is <span class="kw">null</span>.

If the separator argument is <span class="kw">null</span>, it is ignored.

For consistency with aggregate operator behavior, <span class="kw">null</span> elements in the input list are ignored.

The following examples illustrate the behavior of the <span class="id">Combine</span> operator:

```cql
define "CombineList": Combine({ 'A', 'B', 'C' }) // 'ABC'
define "CombineWithSeparator": Combine({ 'A', 'B', 'C' }, ' ') // 'A B C'
define "CombineWithNulls": Combine({ 'A', 'B', 'C', null }) // 'ABC'
```

#### Concatenate

**Signature:**

```cql
+(left String, right String) String
&(left String, right String) String
```

**Description:**

The _concatenate_ (<span class="sym">+</span> or <span class="sym">&</span>) operator performs string concatenation of its arguments.

When using <span class="sym">+</span>, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

When using <span class="sym">&</span>, <span class="kw">null</span> arguments are treated as an empty string (<span class="sym">''</span>).

The following examples illustrate the behavior of the _concatenate_ operator:

```cql
define "ConcatenatePlus": 'John' + ' Doe' // 'John Doe'
define "ConcatenateAnd": 'John' & null & ' Doe' // 'John Doe'
define "ConcatenateFunction": Concatenate('John', ' Doe') // 'John Doe'
define "ConcatenateIsNull": 'John' + null + 'Doe' // null
```

#### EndsWith

**Signature:**

```cql
EndsWith(argument String, suffix String) Boolean
```

**Description:**

The <span class="id">EndsWith</span> operator returns true if the given string ends with the given suffix.

If the suffix is the empty string, the result is true.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">EndsWith</span> operator:

```cql
define "EndsWithIsTrue": EndsWith('ABC', 'C') // true
define "EndsWithIsFalse": EndsWith('ABC', 'Z') // false
define "EndsWithIsNull": EndsWith('ABC', null) // null
```

#### Indexer

**Signature:**

```cql
[](argument String, index Integer) String
```

**Description:**

The _indexer_ (<span class="sym">[]</span>) operator returns the character at the indexth position in a string.

Indexes in strings are defined to be 0-based.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the index is greater than the length of the string being indexed, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _indexer_ operator:

```cql
define "Indexer2": 'ABCDE'[2] // 'C'
define "IndexerIsNull": 'ABCDE'[14] // null
define "IndexerIsAlsoNull": 'ABCDE'[null] // null
```

#### LastPositionOf

**Signature:**

```cql
LastPositionOf(pattern String, argument String) Integer
```

**Description:**

The <span class="id">LastPositionOf</span> operator returns the 0-based index of the last appearance of the given pattern in the given string.

If the pattern is not found, the result is -1.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">LastPositionOf</span> operator:

```cql
define "LastPositionOfFound": LastPositionOf('B', 'ABCDEDCBA') // 7
define "LastPositionOfNotFound": LastPositionOf('XYZ', 'ABCDE') // -1
define "LastPositionOfIsNull": LastPositionOf(null, 'ABCDE') // null
```

#### Length

**Signature:**

```cql
Length(argument String) Integer
```

**Description:**

The <span class="id">Length</span> operator returns the number of characters in a string.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Length</span> operator:

```cql
define "Length14": Length('ABCDE') // 5
define "LengthIsNull": Length(null as String) // null
```

#### Lower

**Signature:**

```cql
Lower(argument String) String
```

**Description:**

The <span class="id">Lower</span> operator returns the given string with all characters converted to their lower case equivalents.

> Note that the definition of _lowercase_ for a given character is a locale-dependent determination, and is not specified by CQL. Implementations are expected to provide appropriate and consistent handling of locale for their environment.
{: .note-warning}

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Lower</span> operator:

```cql
define "LowerCQL": Lower('ABCDE') // 'abcde'
define "LowerIsNull": Lower(null) // null
```

#### Matches

**Signature:**

```cql
Matches(argument String, pattern String) Boolean
```

**Description:**

The <span class="id">Matches</span> operator returns true if the given string matches the given regular expression pattern. Regular expressions should function consistently, regardless of any culture- and locale-specific settings in the environment, should be case-sensitive, use partial matching, use single line mode, and allow Unicode characters. The start/end of line markers <span class="sym">^</span> and <span class="sym">$</span> can be used to match the entire string.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

> Platforms will typically use native regular expression implementations. These are typically fairly similar, but there will always be small differences. As such, CQL does not prescribe a particular dialect, but recommends the use of the [PCRE](http://www.pcre.org) dialect.
{: .note-warning}

The following examples illustrate the behavior of the <span class="id">Matches</span> operator:

```cql
define "MatchesTrue": Matches('1,2three', '\\d,\\d\\w+')
define "MatchesFalse": Matches('1,2three', '^\\w+$')
define "MatchesIsNull": Matches('12three', null)
define "MatchesTrue2": Matches('http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1', 'Library')
```

#### MatchesFull

> The MatchesFull function was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
MatchesFull(argument String, pattern String) Boolean
```

**Description:**

The <span class="id">MatchesFull</span> operator returns true when the value completely matches the given regular expression (implying that the start/end of line markers `^`, `$` are always surrounding the regex expression provided).

Regular expressions should function consistently, regardless of any culture- and locale-specific settings in the environment, should be case-sensitive, use partial matching, use single line mode, and allow Unicode characters. The start/end of line markers <span class="sym">^</span> and <span class="sym">$</span> can be used to match the entire string.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

> Platforms will typically use native regular expression implementations. These are typically fairly similar, but there will always be small differences. As such, CQL does not prescribe a particular dialect, but recommends the use of the [PCRE](http://www.pcre.org) dialect.
{: .note-warning}

The following examples illustrate the behavior of the <span class="id">MatchesFull</span> operator:

```cql
define MatchesFullFalse: 'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Library') // returns false
define MatchesFullAlsoFalse: 'N8000123123'.matchesFull('N[0-9]{8}') // returns false as the string is not an 8 char number (it has 10)
define MatchesFullTrue: 'N8000123123'.matchesFull('N[0-9]{10}') // returns true as the string has an 10 number sequence in it starting with `N`
```

#### PositionOf

**Signature:**

```cql
PositionOf(pattern String, argument String) Integer
```

**Description:**

The <span class="id">PositionOf</span> operator returns the 0-based index of the given pattern in the given string.

If the pattern is not found, the result is -1.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">PositionOf</span> operator:

```cql
define "PositionOfFound": PositionOf('B', 'ABCDEDCBA') // 1
define "PositionOfNotFound": PositionOf('Z', 'ABCDE') // -1
define "PositionOfIsNull": PositionOf(null, 'ABCDE') // null
```

#### ReplaceMatches

**Signature:**

```cql
Matches(argument String, pattern String, substitution String) String
```

**Description:**

The <span class="id">ReplaceMatches</span> operator matches the given string using the given regular expression pattern, replacing each match with the given substitution. The substitution string may refer to identified match groups in the regular expression. Regular expressions should function consistently, regardless of any culture- and locale-specific settings in the environment, should be case-sensitive, use partial matching, use single line mode, and allow Unicode characters. The start and end of line markers <span class="sym">^</span>, <span class="sym">$</span> can be used to match the entire string.

If any argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

> Platforms will typically use native regular expression implementations. These are typically fairly similar, but there will always be small differences. As such, CQL does not prescribe a particular dialect, but recommends the use of the [PCRE](http://www.pcre.org) dialect.
{: .note-warning}

The following examples illustrate the behavior of the <span class="id">ReplaceMatches</span> operator:

```cql
define "ReplaceMatchesFound": ReplaceMatches('ABCDE', 'C', 'XYZ') // 'ABXYZDE'
define "ReplaceMatchesNotFound": ReplaceMatches('ABCDE', 'XYZ', '123') // 'ABCDE'
define "ReplaceMatchesIsNull": ReplaceMatches('ABCDE', 'C', null) // null
```

#### Split

**Signature:**

```cql
Split(stringToSplit String, separator String) List<String>
```

**Description:**

The <span class="id">Split</span> operator splits a string into a list of strings using a separator.

If the <span class="id">stringToSplit</span> argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the <span class="id">stringToSplit</span> argument does not contain any appearances of the separator, the result is a list of strings containing one element that is the value of the <span class="id">stringToSplit</span> argument.

The following examples illustrate the behavior of the <span class="id">Split</span> operator:

```cql
define "SplitFound": Split('A B C', ' ') // { 'A', 'B', 'C' }
define "SplitNotFound": Split('A B C', ',') // { 'A B C' }
define "SplitIsNull": Split(null, ' ') // null
```

#### SplitOnMatches

**Signature:**

```cql
SplitOnMatches(stringToSplit String, separatorPattern String) List<String>
```

**Description:**

The <span class="id">SplitOnMatches</span> operator splits a string into a list of strings using a separator that is defined by a regular expression pattern.

If the <span class="id">stringToSplit</span> argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The <span class="id">separatorPattern</span> argument is interpreted with the same regular expression semantics as defined for the <span class="id">Matches</span> operator.

If the <span class="id">stringToSplit</span> argument does not contain any matches for the <span class="id">separatorPattern</span>, the result is a list of strings containing one element that is the value of the <span class="id">stringToSplit</span> argument.

#### StartsWith

**Signature:**

```cql
StartsWith(argument String, prefix String) Boolean
```

**Description:**

The <span class="id">StartsWith</span> operator returns true if the given string starts with the given prefix.

If the prefix is the empty string, the result is true.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">StartsWith</span> operator:

```cql
define "StartsWithIsTrue": StartsWith('ABCDE', 'ABC') // true
define "StartsWithIsFalse": StartsWith('ABCDE', 'XYZ') // false
define "StartsWithIsNull": StartsWith('ABCDE', null) // null
```

#### Substring

**Signature:**

```cql
Substring(stringToSub String, startIndex Integer) String
Substring(stringToSub String, startIndex Integer, length Integer) String
```

**Description:**

The <span class="id">Substring</span> operator returns the string within <span class="id">stringToSub</span>, starting at the 0-based index <span class="id">startIndex</span>, and consisting of <span class="id">length</span> characters.

If <span class="id">length</span> is omitted, the substring returned starts at <span class="id">startIndex</span> and continues to the end of <span class="id">stringToSub</span>.

If <span class="id">stringToSub</span> or <span class="id">startIndex</span> is <span class="kw">null</span>, or <span class="id">startIndex</span> is out of range, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Substring</span> operator:

```cql
define "SubstringWithoutLength": Substring('ABCDE', 2) // 'CDE'
define "SubstringWithLength": Substring('ABCDE', 2, 1) // 'C'
define "SubstringIsNull": Substring('ABCDE', null) // null
define "SubstringIsAlsoNull": Substring('ABCDE', 14) // null
```

#### Upper

**Signature:**

```cql
Upper(argument String) String
```

**Description:**

The <span class="id">Upper</span> operator returns the given string with all characters converted to their upper case equivalents.

> Note that the definition of _uppercase_ for a given character is a locale-dependent determination, and is not specified by CQL. Implementations are expected to provide appropriate and consistent handling of locale for their environment.
{: .note-info}

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Upper</span> operator:

```cql
define "UpperCQL": Upper('abcde') // 'ABCDE'
define "UpperIsNull": Upper(null) // null
```

{: #datetime-operators-2}
### Date and Time Operators

{: #add-1}
#### Add

**Signature:**

```cql
+(left Date, right Quantity) Date
+(left DateTime, right Quantity) DateTime
+(left Time, right Quantity) Time
```

**Description:**

The _add_ (<span class="sym">+</span>) operator returns the value of the first argument, incremented by the time-valued quantity, respecting variable length periods for calendar years and months.

For <span class="id">Date</span> values, the quantity unit must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, or <span class="kw">days</span>.

For <span class="id">DateTime</span> values, the quantity unit must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, <span class="kw">days</span>, <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

For <span class="id">Time</span> values, the quantity unit must be one of: <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

As `Time` is cyclic, the result of overflowing the time value will be wrapped around the beginning of the day, so that adding 1 hour to `@T23:30:00` will result in `@T00:30:00` of the previous day, which is consistent with the behaviour of `DateTime` values:

```cql
@T23:30:00 + 1 hour // @T00:30:00
```

Note that the quantity units may be specified in singular, plural, or UCUM form. However, to avoid the potential confusion of calendar-based date and time arithmetic with definite-duration date and time arithmetic, it is an error to attempt to add a definite-duration time-valued unit above days (and weeks), a calendar duration must be used.

For precisions above seconds, any decimal portion of the time-valued quantity is ignored, since date/time arithmetic above seconds is performed with calendar duration semantics.

For partial date/time values where the time-valued quantity is more precise than the partial date/time, the operation is performed by converting the time-based quantity to the most precise value specified in first argument (truncating any resulting decimal portion) and then adding it to the first argument. For example, the following addition:

<span class="id">DateTime(2014)</span> <span class="sym">+</span> <span class="lit">24</span> <span class="id">months</span>

This example results in the value <span class="id">DateTime(2016)</span> even though the DateTime value is not specified to the level of precision of the time-valued quantity.

Note also that this means that if decimals appear in the time-valued quantities, the fractional component will be ignored. For example, the following addition:

<span class="id">DateTime(2014)</span> <span class="sym">+</span> <span class="lit">18</span> <span class="id">months</span>

This example results in the value <span class="id">DateTime(2015)</span>

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

#### After

**Signature:**

```cql
after _precision_ of(left Date, right Date) Boolean
after _precision_ of(left DateTime, right DateTime) Boolean
after _precision_ of(left Time, right Time) Boolean
```

**Description:**

The <span class="kw">after</span>_-precision-_<span class="kw">of</span> operator compares two Date, DateTime, or Time values to the specified precision to determine whether the first argument is the after the second argument. The comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is greater than the second, the result is <span class="kw">true</span>; if the first value is less than the second, the result is <span class="kw">false</span>; if either input has no value for the precision, the comparison stops and the result is <span class="kw">null</span>; if the specified precision has been reached, the comparison stops and the result is <span class="kw">false</span>.

If no precision is specified, the comparison is performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> values as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">after</span>_-precision-_<span class="kw">of</span> operator:

```cql
define "AfterIsTrue": @2012-02-01 after month of @2012-01-01
define "AfterIsFalse": @2012-01-01 after month of @2012-01-01
define "AfterUncertainIsNull": @2012-01-01 after month of @2012
define "AfterIsNull": @2012-01-01 after month of null
```

This operator is also defined for intervals, see the [After (Intervals)](#after-1) operator for more information.

#### Before

**Signature:**

```cql
before _precision_ of(left Date, right Date) Boolean
before _precision_ of(left DateTime, right DateTime) Boolean
before _precision_ of(left Time, right Time) Boolean
```

**Description:**

The <span class="kw">before</span>_-precision-_<span class="kw">of</span> operator compares two Date, DateTime, or Time values to the specified precision to determine whether the first argument is the before the second argument. The comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is less than the second, the result is <span class="kw">true</span>; if the first value is greater than the second, the result is <span class="kw">false</span>; if either input has no value for the precision, the comparison stops and the result is <span class="kw">null</span>; if the specified precision has been reached, the comparison stops and the result is <span class="kw">false</span>.

If no precision is specified, the comparison is performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> values as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">before</span>_-precision-_<span class="kw">of</span> operator:

```cql
define "BeforeIsTrue": @2012-01-01 before month of @2012-02-01
define "BeforeIsFalse": @2012-01-01 before month of @2012-01-01
define "BeforeUncertainIsNull": @2012 before month of @2012-02-01
define "BeforeIsNull": @2012-01-01 before month of null
```

This operator is also defined for intervals, see the [Before (Intervals)](#before-1) operator for more information.

{: #date-1}
#### Date

**Signature:**

```cql
Date(year Integer) Date
Date(year Integer, month Integer) Date
Date(year Integer, month Integer, day Integer) Date
```

**Description:**

The <span class="id">Date</span> operator constructs a date value from the given components.

At least one component must be specified, and no component may be specified at a precision below an unspecified precision. For example, <span class="id">month</span> may be <span class="kw">null</span>, but if it is, <span class="id">day</span> must be <span class="kw">null</span> as well.

The following examples illustrate the behavior of the <span class="id">Date</span> operator:

```cql
define "DateValid": Date(2012, 1, 1)
define "DateInvalid": Date(2012, null, 1)
```

{: #datetime-1}
#### DateTime

**Signature:**

```cql
DateTime(year Integer) DateTime
DateTime(year Integer, month Integer) DateTime
DateTime(year Integer, month Integer, day Integer) DateTime
DateTime(year Integer, month Integer, day Integer,
  hour Integer) DateTime
DateTime(year Integer, month Integer, day Integer,
  hour Integer, minute Integer) DateTime
DateTime(year Integer, month Integer, day Integer,
  hour Integer, minute Integer, second Integer) DateTime
DateTime(year Integer, month Integer, day Integer,
  hour Integer, minute Integer, second Integer, millisecond Integer) DateTime
DateTime(year Integer, month Integer, day Integer,
  hour Integer, minute Integer, second Integer, millisecond Integer,
  timezoneOffset Decimal) DateTime
```

**Description:**

The <span class="id">DateTime</span> operator constructs a DateTime value from the given components.

At least one component other than <span class="id">timezoneOffset</span> must be specified, and no component may be specified at a precision below an unspecified precision. For example, <span class="id">hour</span> may be <span class="kw">null</span>, but if it is, <span class="id">minute</span>, <span class="id">second</span>, and <span class="id">millisecond</span> must all be <span class="kw">null</span> as well.

If all the arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>, as opposed to a <span class="id">DateTime</span> with no components specified.

Although the milliseconds are specified with a separate component, seconds and milliseconds are combined and represented as a <span class="id">Decimal</span> for the purposes of comparison.

If <span class="id">timezoneOffset</span> is not specified, it is defaulted to the timezone offset of the evaluation request.

The following examples illustrate the behavior of the <span class="id">DateTime</span> operator:

```cql
define "DateValid": DateTime(2012, 1, 1, 12, 30, 0, 0, -7)
define "DateInvalid": DateTime(2012, 1, 1, 12, null, 0, 0, -7)
```

{: #datetime-component-from}
#### Date and Time Component From

**Signature:**

```cql
_precision_ from(argument Date) Integer
_precision_ from(argument DateTime) Integer
_precision_ from(argument Time) Integer
timezoneoffset from(argument DateTime) Decimal
date from(argument DateTime) Date
time from(argument DateTime) Time
```

**Description:**

The _component_-<span class="kw">from</span> operator returns the specified component of the argument.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, extraction of a week component is not supported.

When extracting the Date or Time from a <span class="id">DateTime</span> value, the value is normalized to the timezone offset of the evaluation request timestamp.

If the argument is <span class="kw">null</span>, or is not specified to the level of precision being extracted, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _component_-<span class="kw">from</span> operator:

```cql
define "MonthFrom": month from DateTime(2012, 1, 1, 12, 30, 0, 0, -7) // 1
define "TimeZoneOffsetFrom": timezoneoffset from DateTime(2012, 1, 1, 12, 30, 0, 0, -7) // -7.0
define "DateFrom": date from DateTime(2012, 1, 1, 12, 30, 0, 0, -7) // @2012-01-01
define "TimeFrom": time from DateTime(2012, 1, 1, 12, 30, 0, 0, -7) // @T12:30:00.000-07:00
define "MonthFromIsNull": month from DateTime(2012)
```

#### Difference

**Signature:**

```cql
difference in _precision_ between(low Date, high Date) Integer
difference in _precision_ between(low DateTime, high DateTime) Integer
difference in _precision_ between(low Time, high Time) Integer
```

**Description:**

The _difference-_<span class="kw">between</span> operator returns the number of boundaries crossed for the specified precision between the first and second arguments. If the first argument is after the second argument, the result is negative. The result of this operation is always an integer; any fractional boundaries are dropped.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, or <span class="kw">days</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, <span class="kw">days</span>, <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

For calculations involving weeks, Sunday is considered to be the first day of the week for the purposes of determining the number of boundaries crossed.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When computing the difference between DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that when calculating difference, just like date and time comparison calculations, seconds and milliseconds are considered a single precision with decimal semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _difference-_<span class="kw">between</span> operator:

```cql
define "DifferenceInMonths": difference in months between @2012-01-01 and @2012-02-01 // 1
define "UncertainDifferenceInMonths": difference in months between @2012-01-02 and @2012 // [0, 11]
define "DifferenceIsNull": difference in months between @2012-01-01 and null
```

#### Duration

**Signature:**

```cql
_duration_ between(low Date, high Date) Integer
_duration_ between(low DateTime, high DateTime) Integer
_duration_ between(low Time, high Time) Integer
```

**Description:**

The _duration-_<span class="kw">between</span> operator returns the number of whole calendar periods for the specified precision between the first and second arguments. If the first argument is after the second argument, the result is negative. The result of this operation is always an integer; any fractional periods are dropped.

For <span class="id">Date</span> values, _duration_ must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, or <span class="kw">days</span>.

For <span class="id">DateTime</span> values, _duration_ must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, <span class="kw">days</span>, <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

For <span class="id">Time</span> values, _duration_ must be one of: <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When computing the duration between DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that when calculating duration, just like date and time comparison calculations, seconds and milliseconds are considered a single precision with decimal semantics.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _duration-_<span class="kw">between</span> operator:

```cql
define "DurationInMonths": months between @2012-01-01 and @2012-02-01 // 1
define "UncertainDurationInMonths": months between @2012-01-02 and @2012 // [0, 10]
define "DurationIsNull": months between @2012-01-01 and null
```

#### Now

**Signature:**

```cql
Now() DateTime
```

**Description:**

The <span class="id">Now</span> operator returns the date and time of the start timestamp associated with the evaluation request. <span class="id">Now</span> is defined in this way for two reasons:

1.  The operation will always return the same value within any given evaluation, ensuring that the result of an expression containing Now will always return the same result.
2.  The operation will return the timestamp associated with the evaluation request, allowing the evaluation to be performed with the same timezone offset information as the data delivered with the evaluation request.

{: #on-or-after-1}
#### On Or After

**Signature:**

```cql
on or after _precision_ (left Date, right Date) Boolean
on or after _precision_ (left DateTime, right DateTime) Boolean
on or after _precision_ (left Time, right Time) Boolean
```

**Description:**

The <span class="kw">on or after</span> operator for Date, DateTime, and Time values is a synonym for the <span class="kw">same or after</span> operator and is supported to enable natural phrasing. See the description of the [Same Or After (Date, DateTime, or Time)](#same-or-after-1) operator.

Note that this operator can be invoked using either the <span class="kw">on or after</span> or the <span class="kw">after or on</span> syntax.

In timing phrases, the keyword <span class="kw">same</span> is a synonym for <span class="kw">on</span>.

{: #on-or-before-1}
#### On Or Before

**Signature:**

```cql
on or before _precision_ (left Date, right Date) Boolean
on or before _precision_ (left DateTime, right DateTime) Boolean
on or before _precision_ (left Time, right Time) Boolean
```

**Description:**

The <span class="kw">on or before</span> operator for Date, DateTime, and Time values is a synonym for the <span class="kw">same or before</span> operator and is supported to enable natural phrasing. See the description of the [Same Or Before (Date, DateTime, or Time)](#same-or-before-1) operator.

Note that this operator can be invoked using either the <span class="kw">on or before</span> or the <span class="kw">before or on</span> syntax.

In timing phrases, the keyword <span class="kw">same</span> is a synonym for <span class="kw">on</span>.

{: #same-as-1}
#### Same As

**Signature:**

```cql
same _precision_ as(left Date, right Date) Boolean
same _precision_ as(left DateTime, right DateTime) Boolean
same _precision_ as(left Time, right Time) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">as</span> operator compares two Date, DateTime, or Time values to the specified precision for equality. The comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the values are different, the comparison stops and the result is <span class="kw">false</span>; if either input has no value for the precision, the comparison stops and the result is <span class="kw">null</span>; if the specified precision has been reached, the comparison stops and the result is <span class="kw">true</span>.

If no precision is specified, the comparison is performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mxiture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">same</span>_-precision-_<span class="kw">as</span> operator:

```cql
define "SameAsTrue": @2012-01-01 same day as @2012-01-01
define "SameAsFalse": @2012-01-01 same day as @2012-01-02
define "UncertainSameAsIsNull": @2012-01-01 same day as @2012-01
define "SameAsIsNull": @2012-01-01 same day as null
```

This operator is also defined for intervals, see the [Same As (Intervals)](#same-as-2) operator for more information.

{: #same-or-after-1}
#### Same Or After

**Signature:**

```cql
same _precision_ or after(left Date, right Date) Boolean
same _precision_ or after(left DateTime, right DateTime) Boolean
same _precision_ or after(left Time, right Time) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">or after</span> operator compares two Date, DateTime, or Time values to the specified precision to determine whether the first argument is the same or after the second argument. The comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is greater than the second, the result is <span class="kw">true</span>; if the first value is less than the second, the result is <span class="kw">false</span>; if either input has no value for the precision, the comparison stops and the result is <span class="kw">null</span>; if the specified precision has been reached, the comparison stops and the result is <span class="kw">true</span>.

If no precision is specified, the comparison is performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that in timing phrases, the keyword <span class="kw">on</span> may be used as a synonym for <span class="kw">same</span> for this operator.

The following examples illustrate the behavior of the <span class="kw">same</span>_-precision-_<span class="kw">or after</span> operator:

```cql
define "SameOrAfterTrue": @2012-01-02 same day or after @2012-01-01
define "SameOrAfterFalse": @2012-01-01 same day or after @2012-01-02
define "UncertainSameOrAfterIsNull": @2012-01-02 same day or after @2012-01
define "SameOrAfterIsNull": @2012-01-01 same day or after null
```

This operator is also defined for intervals, see the [Same Or After (Intervals)](#same-or-after-2) operator for more information.

{: #same-or-before-1}
#### Same Or Before

**Signature:**

```cql
same _precision_ or before(left Date, right Date) Boolean
same _precision_ or before(left DateTime, right DateTime) Boolean
same _precision_ or before(left Time, right Time) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">or before</span> operator compares two Date, DateTime, or Time values to the specified precision to determine whether the first argument is the same or before the second argument. The comparison is performed by considering each precision in order, beginning with years (or hours for time values). If the values are the same, comparison proceeds to the next precision; if the first value is less than the second, the result is <span class="kw">true</span>; if the first value is greater than the second, the result is <span class="kw">false</span>; if either input has no value for the precision, the comparison stops and the result is <span class="kw">null</span>; if the specified precision has been reached, the comparison stops and the result is <span class="kw">true</span>.

If no precision is specified, the comparison is performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span> values, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span> values, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span> and <span class="id">DateTime</span> inputs, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Note that for the purposes of comparison, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics.

If either or both arguments are <span class="kw">null</span>, the result is null.

Note that in timing phrases, the keyword <span class="kw">on</span> may be used as a synonym for <span class="kw">same</span> for this operator.

The following examples illustrate the behavior of the <span class="kw">same</span>_-precision-_<span class="kw">or before</span> operator:

```cql
define "SameOrBeforeTrue": @2012-01-01 same day or before @2012-01-02
define "SameOrBeforeFalse": @2012-01-02 same day or before @2012-01-01
define "UncertainSameOrBeforeIsNull": @2012-01-02 same day or before @2012-01
define "SameOrBeforeIsNull": @2012-01-01 same day or before null
```

This operator is also defined for intervals, see the [Same Or Before (Intervals)](#same-or-before-2) operator for more information.

{: #subtract-1}
#### Subtract

**Signature:**

```cql
-(left Date, right Quantity) Date
-(left DateTime, right Quantity) DateTime
-(left Time, right Quantity) Time
```

**Description:**

The _subtract_ (<span class="sym">-</span>) operator returns the value of the given Date, DateTime, or Time, decremented by the time-valued quantity, respecting variable length periods for calendar years and months.

For <span class="id">Date</span> values, the quantity unit must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, or <span class="kw">days</span>.

For <span class="id">DateTime</span> values, the quantity unit must be one of: <span class="kw">years</span>, <span class="kw">months</span>, <span class="kw">weeks</span>, <span class="kw">days</span>, <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

For <span class="id">Time</span> values, the quantity unit must be one of: <span class="kw">hours</span>, <span class="kw">minutes</span>, <span class="kw">seconds</span>, or <span class="kw">milliseconds</span>.

As `Time` is cyclic, the result of overflowing the time value will be wrapped around the beginning of the day, so that subtracting 1 hour from `@T00:30:00` will result in `@T23:30:00` of the previous day, which is consistent with the behaviour of `DateTime` values.

```cql
@T00:30:00 - 1 hour // @T23:30:00
@T01:00:00 - 2 hours // @T23:00:00
```

Note that the quantity units may be specified in singular, plural or UCUM form. However, to avoid the potential confusion of calendar-based date and time arithmetic with definite-duration date and time arithmetic, it is an error to attempt to subtract a definite-duration time-valued unit above days (and weeks), a calendar duration must be used.

For precisions above seconds, any decimal portion of the time-valued quantity is ignored, since date/time arithmetic above seconds is performed with calendar duration semantics.

For partial date/time values where the time-valued quantity is more precise than the partial date/time, the operation is performed by converting the time-based quantity to the most precise value specified in the first argument (truncating any resulting decimal portion) and then subtracting it from the first argument. For example, the following subtraction:

<span class="id">DateTime(2014)</span> <span class="sym">-</span> <span class="lit">24</span> <span class="id">months</span>

This example results in the value <span class="id">DateTime(2012)</span> even though the DateTime value is not specified to the level of precision of the time-valued quantity.

Note also that this means that if decimals appear in the time-valued quantities, the fractional component will be ignored.  For example, the following subtraction:

<span class="id">DateTime(2014)</span> <span class="sym">-</span> <span class="lit">18</span> <span class="id">months</span>

This example results in the value <span class="id">DateTime(2013)</span>

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

{: #time-1}
#### Time

**Signature:**

```cql
Time(hour Integer) Time
Time(hour Integer, minute Integer) Time
Time(hour Integer, minute Integer, second Integer) Time
Time(hour Integer, minute Integer, second Integer, millisecond Integer) Time
```

**Description:**

The <span class="id">Time</span> operator constructs a time value from the given components.

At least one component must be specified, and no component may be specified at a precision below an unspecified precision. For example, <span class="id">minute</span> may be <span class="kw">null</span>, but if it is, <span class="id">second</span>, and <span class="id">millisecond</span> must all be <span class="kw">null</span> as well.

Although the milliseconds are specified with a separate component, seconds and milliseconds are combined and represented as a <span class="id">Decimal</span> for the purposes of comparison.

The following examples illustrate the behavior of the <span class="id">Time</span> operator:

```cql
define "TimeValid": Time(12, 30, 0, 0)
define "TimeInvalid": Time(12, null, 0, 0)
```

#### TimeOfDay

**Signature:**

```cql
TimeOfDay() Time
```

**Description:**

The <span class="id">TimeOfDay</span> operator returns the time of day of the start timestamp associated with the evaluation request. See the <span class="id">[Now](#now)</span> operator for more information on the rationale for defining the <span class="id">TimeOfDay</span> operator in this way.

#### Today

**Signature:**

```cql
Today() Date
```

**Description:**

The <span class="id">Today</span> operator returns the date of the start timestamp associated with the evaluation request. See the <span class="id">[Now](#now)</span> operator for more information on the rationale for defining the <span class="id">Today</span> operator in this way.

{: #interval-operators-3}
### Interval Operators

{: #after-1}
#### After

**Signature:**

```cql
after _precision_ (left Interval<T>, right Interval<T>) Boolean
after _precision_ (left T, right Interval<T>) Boolean
after _precision_ (left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">after</span> operator for intervals returns <span class="kw">true</span> if the first interval starts after the second one ends. In other words, if the starting point of the first interval is greater than the ending point of the second interval.

For the point-interval overload, the operator returns <span class="kw">true</span> if the given point is greater than the end of the interval.

For the interval-point overload, the operator returns <span class="kw">true</span> if the given interval starts after the given point.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">after</span> operator:

```cql
define "AfterIsTrue": 5 after Interval[1, 4]
define "AfterIsFalse": Interval[1, 4] after 5
define "AfterIsNull": Interval[1, 4] after null
```

{: #before-1}
#### Before

**Signature:**

```cql
before _precision_ (left Interval<T>, right Interval<T>) Boolean
before _precision_ (left T, right Interval<T>) Boolean
before _precision_ (left interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">before</span> operator for intervals returns <span class="kw">true</span> if the first interval ends before the second one starts. In other words, if the ending point of the first interval is less than the starting point of the second interval.

For the point-interval overload, the operator returns <span class="kw">true</span> if the given point is less than the start of the interval.

For the interval-point overload, the operator returns <span class="kw">true</span> if the given interval ends before the given point.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">before</span> operator:

```cql
define "BeforeIsTrue": 0 before Interval[1, 4]
define "BeforeIsFalse": Interval[1, 4] before 0
define "BeforeIsNull": Interval[1, 4] before null
```

#### Collapse

**Signature:**

```cql
collapse(argument List<Interval<T>>) List<Interval<T>>
collapse(argument List<Interval<T>>, per Quantity) List<Interval<T>>
```

**Description:**

The <span class="kw">collapse</span> operator returns the unique set of intervals that completely covers the ranges present in the given list of intervals. In other words, adjacent intervals within a sorted list are merged if they either overlap or meet.

Note that because the semantics for overlaps and meets are themselves defined in terms of the interval successor and predecessor operators, sets of Date-, DateTime-, or Time-based intervals that are only defined to a particular precision will calculate meets and overlaps at that precision. For example, a list of DateTime-based intervals where the boundaries are all specified to the hour will collapse at the hour precision, unless the collapse precision is overridden with the per argument.

Conceptually, the per argument to the collapse operator partitions the value-space for the operation into units of size 'per', and the intervals will be collapsed aligning with those partitions. Note that the 'per' partitions start from the starting boundary of the first input interval, ordered.

The per argument determines the precision at which the collapse is computed and must be a quantity-valued expression compatible with the interval point type. For numeric intervals, this means a quantity with the default unit <span class="lit">'1'</span> (not to be confused with the quantity value, which may be any valid positive decimal). For Date-, DateTime-, and Time-valued intervals, this means a quantity with a temporal unit (e.g., 'year', 'month', etc).

If the per argument is <span class="kw">null</span>, a per value will be constructed based on the coarsest precision of the boundaries of the intervals in the input set. For example, a list of DateTime-based intervals where the boundaries are a mixture of hours and minutes will collapse at the hour precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If the list of intervals is empty, the result is empty. If the list of intervals contains a single interval, the result is a list with that interval. If the list of intervals contains nulls, they will be excluded from the resulting list.

If the list argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">collapse</span> operator:

```cql
define "Collapse1To9": collapse { Interval[1, 4], Interval[4, 8], Interval[7, 9] } // { Interval[1, 9] }
define "CollapseIsNull": collapse null
```

Informatively, the following pseudo-code illustrates a potential approach to implementation of the collapse operator with a per argument aligned to the starting boundary of the first input interval:

```java
anchor = start of i[0]
for (n = 0; n < i.size; n++) {
  if (start of i[n] < anchor) {
    s1 = anchor;
  }
  else {
    w1 = ((start of i[n] - anchor) div per); // Use duration of precision
    if (w1 < start of i[n]) {
      w1 += 1;
    }
    s1 = anchor + w1 * per;
  }

  w1 = ((end of i[n] - s1) div per);
  e1 = s1 + w1 * per;

  overlap and meets on computed boundaries [s1, e1]

  anchor = e1
}
```

#### Contains

**Signature:**

```cql
contains _precision_ (argument Interval<T>, point T) Boolean
```

**Description:**

The <span class="kw">contains</span> operator for intervals returns <span class="kw">true</span> if the given point is equal to the starting or ending point of the interval, or greater than the starting point and less than the ending point. For open interval boundaries, exclusive comparison operators are used. For closed interval boundaries, if the interval boundary is <span class="kw">null</span>, the result of the boundary comparison is considered <span class="kw">true</span>.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">false</span>. If the second argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">contains</span> operator:

```cql
define "ContainsIsTrue": Interval[1, 5] contains 4
define "ContainsIsFalse": Interval[1, 5] contains 6
define "ContainsIsNull": Interval[1, 5] contains null
```

#### End

**Signature:**

```cql
end of(argument Interval<T>) T
```

**Description:**

The <span class="id">End</span> operator returns the ending point of an interval.

If the high boundary of the interval is open, this operator returns the <span class="kw">predecessor</span> of the high value of the interval. Note that if the high value of the interval is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the high boundary of the interval is closed and the high value of the interval is not null, this operator returns the high value of the interval. Otherwise, the result is the maximum value of the point type of the interval.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">End</span> operator:

```cql
define "EndOfInterval": end of Interval[1, 5] // 5
define "EndIsNull": end of (null as Interval<Integer>)
```

#### Ends

**Signature:**

```cql
ends _precision_ (left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">ends</span> operator returns <span class="kw">true</span> if the first interval ends the second. More precisely, if the starting point of the first interval is greater than or equal to the starting point of the second, and the ending point of the first interval is equal to the ending point of the second.

This operator uses the semantics described in the <span class="kw">[start](#start)</span> and <span class="kw">[end](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">ends</span> operator:

```cql
define "EndsIsTrue": Interval[0, 5] ends Interval[-1, 5]
define "EndsIsFalse": Interval[-1, 7] ends Interval[0, 7]
define "EndsIsNull": Interval[1, 5] ends null
```

{: #equal-1}
#### Equal

**Signature:**

```cql
=(left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The _equal_ (<span class="sym">=</span>) operator for intervals returns <span class="kw">true</span> if and only if the intervals are over the same point type, and they have the same value for the starting and ending points of the intervals as determined by the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _equal_ operator:

```cql
define "EqualIsTrue": Interval[0, 5] = Interval[0, 5]
define "EqualIsFalse": Interval[-1, 7] = Interval[0, 7]
define "EqualIsNull": Interval[1, 5] = null
```

{: #equivalent-1}
#### Equivalent

**Signature:**

```cql
~(left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The _equivalent_ (<span class="sym">~</span>) operator for intervals returns <span class="kw">true</span> if and only if the intervals are over the same point type, and the starting and ending points of the intervals as determined by the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators are equivalent.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

The following examples illustrate the behavior of the _equivalent_ operator:

```cql
define "EquivalentIsTrue": Interval[0, 5] ~ Interval[0, 5]
define "EquivalentIsAlsoTrue": Interval[1, null] ~ Interval[1, null]
define "EquivalentIsFalse": Interval[-1, 7] ~ Interval[0, 7]
```

#### Except

**Signature:**

```cql
except(left Interval<T>, right Interval<T>) Interval<T>
```

**Description:**

The <span class="kw">except</span> operator for intervals returns the set difference of two intervals. More precisely, this operator returns the portion of the first interval that does not overlap with the second. Note that to avoid returning an improper interval, if the second argument is properly contained within the first and does not start or end it, this operator returns <span class="kw">null</span>.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">except</span> operator:

```cql
define "Except": Interval[0, 5] except Interval[3, 7] // Interval[0, 2]
define "ExceptIsNull": null except Interval[-1, 7]
```

#### Expand

**Signature:**

```cql
expand(argument List<Interval<T>>, per Quantity) List<Interval<T>>
expand(argument Interval<T>, per Quantity) List<T>
```

> The Interval<T> overload for expand was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="kw">expand</span> operator returns the set of intervals of size per for all the intervals in the input, or the list of points covering the range of the given interval, if invoked on a single interval.

The per argument determines the size of the resulting intervals and must be a quantity-valued expression compatible with the interval point type. For numeric intervals, this means a quantity with the default unit '1' (not to be confused with the quantity value, which may be any valid positive decimal).  For Date-, DateTime-, and Time-valued intervals, this means a quantity with a temporal unit (e.g., 'year', 'month', etc).

Conceptually, the per argument to the expand operator partitions the value-space for the operation into units of size 'per', and the intervals will be expanded aligning with those partitions. Note that the 'per' partitions start from the starting boundary of the first input interval, ordered.

If the per argument is <span class="kw">null</span>, a per value will be constructed based on the coarsest precision of the boundaries of the intervals in the input set. For example, a list of DateTime-based intervals where the boundaries are a mixture of hours and minutes will expand at the hour precision.

More precisely, for each interval in the input, contribute all the intervals of size per that start on or after the lower boundary and end on or before the upper boundary, where the lower boundary for each interval contributed is obtained by successively adding the per to the lower boundary of the input interval.

For example:

```cql
expand { Interval[@2018-01-01, @2018-01-04] } per day
expand { Interval[@2018-01-01, @2018-01-04] } per 2 days
```

The following are the results of these examples:

```cql
{ Interval[@2018-01-01, @2018-01-01], Interval[@2018-01-02, @2018-01-02], Interval[@2018-01-03, @2018-01-03], Interval[@2018-01-04, @2018-01-04] }
{ Interval[@2018-01-01, @2018-01-02], Interval[@2018-01-03, @2018-01-04] }
```

If the interval boundaries are more precise than the per quantity, the more precise values will be truncated to the precision specified by the per quantity. In these cases, the resulting list of intervals may be more broad than the input range due to this truncation. For example:

```cql
expand { Interval[@T10:00, @T12:30] } per hour
expand { Interval[10.0, 12.5] } per 1
```

The above examples would result in:

```cql
{ Interval[@T10, @T10], Interval[@T11, @T11], Interval[@T12, @T12] }
{ Interval[10, 10], Interval[11, 11], Interval[12, 12] }
```

If the interval boundaries are less precise than the per quantity, for dates and times where the lack of precision indicates uncertainty, the interval will not contribute any results to the output, because adding the per to the lower boundary of the input interval results in null. For numeric intervals, adding the per to the lower boundary produces a more precise value for the output intervals. For example:

```cql
expand { Interval[@T10, @T10] } per minute
expand { Interval[10, 10] } per 0.1
```

The above examples would result in:

```cql
{ }
{ Interval[10.0, 10.0], Interval[10.1, 10.1], ..., Interval[10.9, 10.9] }
```

For intervals of quantities, the semantics of quantity arithmetic and comparison apply, including unit conversion and compatible unit conversion. As with all unit operations, implementations are required to respect units, but are not required to support unit conversion.

If the input argument is an interval, rather than a list of intervals, the result is a list of points, rather than a list of intervals. In this case, the calculation is performed the same way, but the starting point of each resulting interval is returned, rather than the interval. For example:

```cql
expand Interval[1, 10]
expand Interval[1, 10] per 2
```

The above examples would result in:

```cql
{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
{ 1, 3, 5, 7, 9 }
```

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If the list of intervals is empty, the result is empty. If the list of intervals contains <span class="kw">nulls</span>, they will be excluded from the resulting list.

If the list argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

> For intervals with null boundaries (intervals with an undefined start or end date), if the boundary is open (e.g., Interval[0, null)), the interval will not contribute any results to the output. If the boundary is closed (e.g., Interval[0, null]), in theory the interval would contribute all intervals to the beginning or ending of the domain. In practice, because such an expansion is potentially too expensive to compute, and implementations are allowed to not return results for such an interval.
{: .note-warning}

#### In

**Signature:**

```cql
in _precision_ (point T, argument Interval<T>) Boolean
during _precision_ (point T, argument Interval<T>) Boolean
```

**Description:**

The <span class="kw">in</span> operator (can also be invoked using <span class="kw">during</span>) for intervals returns <span class="kw">true</span> if the given point is equal to the starting or ending point of the interval, or greater than the starting point and less than the ending point. For open interval boundaries, exclusive comparison operators are used. For closed interval boundaries, if the interval boundary is <span class="kw">null</span>, the result of the boundary comparison is considered true.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">null</span>. If the second argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">in</span> operator:

```cql
define "InIsTrue": 3 in Interval[0, 5]
define "DuringIsTrue": @2014-02-03 during Interval[@2014-02-01, @2014-02-08]
define "InIsFalse": -1 in Interval[0, 7]
define "InIsAlsoFalse": 3 in (null as Interval<Integer>)
```

#### Includes

**Signature:**

```cql
includes _precision_ (left Interval<T>, right Interval<T>) Boolean
includes _precision_ (left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">includes</span> operator for intervals returns <span class="kw">true</span> if the first interval completely includes the second. More precisely, if the starting point of the first interval is less than or equal to the starting point of the second interval, and the ending point of the first interval is greater than or equal to the ending point of the second interval.

For the point-interval overload, this operator is a synonym for the <span class="kw">[contains](#contains)</span> operator.

For the interval-interval overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

The following examples illustrate the behavior of the <span class="kw">includes</span> operator:

```cql
define "IncludesIsTrue": Interval[-1, 5] includes Interval[0, 5]
define "IncludesIsFalse": Interval[-1, 5] includes 6
define "IncludesIsNull": Interval[-1, 5] includes null
```

#### Included In

**Signature:**

```cql
included in _precision_ (left Interval<T>, right Interval<T>) Boolean
during _precision_ (left Interval<T>, right Interval<T>) Boolean
included in _precision_ (left T, right Interval<T>) Boolean
during _precision_ (left T, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">included in</span> (or <span class="kw">during</span>) operator for intervals returns <span class="kw">true</span> if the first interval is completely included in the second. More precisely, if the starting point of the first interval is greater than or equal to the starting point of the second interval, and the ending point of the first interval is less than or equal to the ending point of the second interval.

For the point-interval overload, this operator is a synonym for the <span class="kw">[in](#in)</span> operator, and will return <span class="kw">null</span> if the first argument is <span class="kw">null</span>, and <span class="kw">false</span> if the second argument is <span class="kw">null</span>.

For the interval-interval overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

Note that <span class="kw">during</span> is a synonym for included in and may be used to invoke the same operation wherever <span class="kw">included in</span> may appear.

The following examples illustrate the behavior of the <span class="kw">included in</span> operator:

```cql
define "IncludedInIsTrue": Interval[1, 5] included in Interval[0, 5]
define "DuringIsTrue": Interval[@2014-02-02, @2014-02-05] during Interval[@2014-02-01, @2014-02-10]
define "IncludedInIsFalse": -1 included in Interval[0, 7]
define "IncludedInIsNull": 3 included in (null as Interval<Integer>)
```

#### Intersect

**Signature:**

```cql
intersect(left Interval<T>, right Interval<T>) Interval<T>
```

**Description:**

The <span class="kw">intersect</span> operator for intervals returns the intersection of two intervals. More precisely, the operator returns the interval that defines the overlapping portion of both arguments. If the arguments do not overlap, this operator returns <span class="kw">null</span>.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">intersect</span> operator:

```cql
define "Intersect": Interval[1, 5] intersect Interval[3, 7] // Interval[3, 5]
define "IntersectIsNull": Interval[3, 5] intersect (null as Interval<Integer>)
```

#### Meets

**Signature:**

```cql
meets _precision_ (left Interval<T>, right Interval<T>) Boolean
meets before _precision_ (left Interval<T>, right Interval<T>) Boolean
meets after _precision_ (left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">meets</span> operator returns <span class="kw">true</span> if the first interval ends immediately before the second interval starts, or if the first interval starts immediately after the second interval ends. In other words, if the ending point of the first interval is equal to the predecessor of the starting point of the second, or if the starting point of the first interval is equal to the successor of the ending point of the second.

The <span class="kw">meets before</span> operator returns <span class="kw">true</span> if the first interval ends immediately before the second interval starts, while the <span class="kw">meets after</span> operator returns <span class="kw">true</span> if the first interval starts immediately after the second interval ends.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that Date-, DateTime-, or Time-based intervals with partially specified boundaries will "meet" at the precision of the boundaries, not the finest precision for the point type. For example:

```cql
define "MeetsAtHours": Interval[@T03, @T04] meets Interval[@T05, @T06]
```

The <span class="id">MeetsAtHours</span> expression returns true because the meets operation is performed at the hour precision.

The following examples illustrate the behavior of the <span class="kw">meets</span>, <span class="kw">meets before</span>, and <span class="kw">meets after</span> operators:

```cql
define "MeetsIsTrue": Interval[6, 10] meets Interval[0, 5]
define "MeetsBeforeIsTrue": Interval[-5, -1] meets before Interval[0, 5]
define "MeetsAfterIsFalse": Interval[6, 10] meets after Interval[0, 7]
define "MeetsIsNull": Interval[6, 10] meets (null as Interval<Integer>)
```

{: #not-equal-1}
#### Not Equal

**Signature:**

```cql
!=(left Interval<T>, right Interval<T>) : Boolean
```

**Description:**

The _not equal_ (<span class="sym">!=</span>) operator for intervals returns <span class="kw">true</span> if its arguments are not the same value.

The _not equal_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equal_ operator.

The following examples illustrate the behavior of the _not equal_ operator:

```cql
define "NotEqualIsFalse": Interval[0, 5] != Interval[0, 5]
define "NotEqualIsTrue": Interval[-1, 7] != Interval[0, 7]
define "NotEqualIsNull": Interval[1, 5] != null
```

{: #not-equivalent-1}
#### Not Equivalent

**Signature:**

```cql
!~(left Interval<T>, right Interval<T>) : Boolean
```

**Description:**

The _not equivalent_ (<span class="sym">!~</span>) operator for intervals returns <span class="kw">true</span> if its arguments are not equivalent.

The _not equivalent_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equivalent_ operator.

The following examples illustrate the behavior of the _not equivalent_ operator:

```cql
define "NotEquivalentIsFalse": Interval[0, 5] !~ Interval[0, 5]
define "NotEquivalentIsAlsoFalse": Interval[1, null] !~ Interval[1, null]
define "NotEquivalentIsTrue": Interval[-1, 7] !~ Interval[0, 7]
```

{: #on-or-after-2}
#### On Or After

**Signature:**

```cql
on or after _precision_ (left Interval<T>, right Interval<T>) Boolean
on or after _precision_ (left T, right Interval<T>) Boolean
on or after _precision_ (left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">on or after</span> operator for intervals is a synonym for the <span class="kw">same or after</span> operator and is supported to enable natural phrasing. See the description of the [Same Or After (Intervals)](#same-or-after-2) operator.

Note that this operator can be invoked using either the <span class="kw">on or after</span> or the <span class="kw">after or on</span> syntax.

In timing phrases, the keyword <span class="kw">same</span> is a synonym for <span class="kw">on</span>.

{: #on-or-before-2}
#### On Or Before

**Signature:**

```cql
on or before _precision_ (left Interval<T>, right Interval<T>) Boolean
on or before _precision_ (left T, right Interval<T>) Boolean
on or before _precision_ (left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">on or before</span> operator for Date-, DateTime-, or Time-based intervals is a synonym for the <span class="kw">same or before</span> operator and is supported to enable natural phrasing. See the description of the [Same Or Before (Intervals)](#same-or-before-2) operator.

Note that this operator can be invoked using either the <span class="kw">on or before</span> or the <span class="kw">before or on</span> syntax.

In timing phrases, the keyword <span class="kw">same</span> is a synonym for <span class="kw">on</span>.

#### Overlaps

**Signature:**

```cql
overlaps _precision_ (left Interval<T>, right Interval<T>) Boolean
overlaps before _precision_ (left Interval<T>, right Interval<T>) Boolean
overlaps after _precision_ (left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">overlaps</span> operator returns <span class="kw">true</span> if the first interval overlaps the second. More precisely, if the starting or ending point of either interval is in the other, or if the ending point of the first interval is greater than or equal to the starting point of the second interval, and the starting point of the first interval is less than or equal to the ending point of the second interval.

The operator <span class="kw">overlaps before</span> returns <span class="kw">true</span> if the first interval overlaps the second and starts before it, while the <span class="kw">overlaps after</span> operator returns <span class="kw">true</span> if the first interval overlaps the second and ends after it.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">overlaps</span>, <span class="kw">overlaps before</span>, and <span class="kw">overlaps after</span> operators:

```cql
define "OverlapsIsTrue": Interval[0, 4] overlaps Interval[1, 4]
define "OverlapsBeforeIsTrue": Interval[0, 4] overlaps before Interval[1, 4]
define "OverlapsAfterIsFalse": Interval[0, 4] overlaps after Interval[1, 4]
define "OverlapsIsNull": Interval[6, 10] overlaps (null as Interval<Integer>)
```

#### Point From

**Signature:**

```cql
point from(argument Interval<T>) : T
```

**Description:**

The <span class="kw">point from</span> operator extracts the single point from a unit interval. If the argument is not a unit interval, a run-time error is thrown.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">point from</span> operator:

```cql
define "PointFrom": point from Interval[4, 4] // 4
define "PointFromExclusive": point from Interval[4, 5) // 4
define "PointFromError": point from Interval[1, 4] // Error
define "PointFromIsNull": point from (null as Interval<Integer>)
```

Note that the <span class="kw">point from</span> operator may only be used on a _unit interval_, or an interval containing a single point. Attempting to extract a point from an interval with a size greater than one, as in the <span class="id">PointFromError</span> example above, will result in a run-time error.

#### Properly Includes

**Signature:**

```cql
properly includes _precision_ (left Interval<T>, right Interval<T>) Boolean
properly includes _precision_ (left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">properly includes</span> operator for intervals returns <span class="kw">true</span> if the first interval completely includes the second and the first interval is strictly larger than the second. More precisely, if the starting point of the first interval is less than or equal to the starting point of the second interval, and the ending point of the first interval is greater than or equal to the ending point of the second interval, and they are not the same interval.

For the interval-point overload, this operator returns true if the interval contains (i.e. includes) the point, and the interval is not a unit interval containing only the point.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

For the interval-interval overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">properly includes</span> operator:

```cql
define "ProperlyIncludesIsTrue": Interval[-1, 5] properly includes Interval[0, 5]
define "ProperlyIncludesIsFalse": Interval[-1, 5] properly includes Interval[-1, 5]
define "ProperlyIncludesIsNull": Interval[-1, 5] properly includes null
```

#### Properly Included In

**Signature:**

```cql
properly included in _precision_ (left Interval<T>, right Interval<T>) Boolean
properly during _precision_ (left Interval<T>, right Interval<T>) Boolean
properly included in _precision_ (left T, right Interval<T>) Boolean
property during _precision_ (left T, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">properly included in</span> (or <span class="kw">properly during</span>) operator for intervals returns <span class="kw">true</span> if the first interval is completely included in the second and the first interval is strictly smaller than the second. More precisely, if the starting point of the first interval is greater than or equal to the starting point of the second interval, and the ending point of the first interval is less than or equal to the ending point of the second interval, and they are not the same interval.

For the point-interval overload, this operator returns true if the point is in (i.e. included in) the interval, and the interval is not a unit interval containing only the point.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

For the interval-interval overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that <span class="kw">during</span> is a synonym for <span class="kw">included in</span>.

The following examples illustrate the behavior of the <span class="kw">properly included in</span> operator:

```cql
define "ProperlyIncludedInIsTrue": Interval[1, 5] properly included in Interval[0, 5]
define "ProperlyDuringIsTrue": Interval[@2014-02-02, @2014-02-05] properly during Interval[@2014-02-01, @2014-02-05]
define "ProperlyIncludedInIsFalse": Interval[0, 7] properly included in Interval[0, 7]
define "ProperlyIncludedInIsNull": Interval[1, 5] properly included in (null as Interval<Integer>)
```

{: #same-as-2}
#### Same As

**Signature:**

```cql
same _precision_ as(left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">as</span> operator for intervals returns true if the two intervals start and end at the same value, using the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries, and for Date, DateTime, or Time value, performing the comparisons at the specified precision, as described in the <span class="id">[Same As](#same-as)</span> operator for Date, DateTime, or Time values.

If no precision is specified, comparisons are performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span>-based intervals, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span>- and <span class="id">DateTime</span>-based intervals, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> values as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

For comparisons involving date or time values with imprecision, note that the result of the comparison may be <span class="kw">null</span>, depending on whether the values involved are specified to the level of precision used for the comparison.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

{: #same-or-after-2}
#### Same Or After

**Signature:**

```cql
same _precision_ or after(left Interval<T>, right Interval<T>) Boolean
same _precision_ or after(left T, right Interval<T>) Boolean
same _precision_ or after(left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">or after</span> operator for intervals returns true if the first interval starts on or after the second one ends, using the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries, and for Date, DateTime, or Time values, performing the comparisons at the specified precision, as described in the <span class="id">[Same or After (Date, DateTime, or Time)](#same-or-after-1)</span> operator for Date, DateTime, or Time values.

If no precision is specified, comparisons are performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span>-based intervals, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span>-based and <span class="id">DateTime</span>-based intervals, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> values as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When this operator is called with a mixture of point values and intervals, the point values are implicitly converted to an interval starting and ending on the given point value.

For comparisons involving date or time intervals with imprecision, note that the result of the comparison may be <span class="kw">null</span>, depending on whether the values involved are specified to the level of precision used for the comparison.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either or both arguments are <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that in timing phrases, the keyword <span class="kw">on</span> may be used as a synonym for <span class="kw">same</span> for this operator.

{: #same-or-before-2}
#### Same Or Before

**Signature:**

```cql
same _precision_ or before(left Interval<T>, right Interval<T>) Boolean
same _precision_ or before(left T, right Interval<T>) Boolean
same _precision_ or before(left Interval<T>, right T) Boolean
```

**Description:**

The <span class="kw">same</span>_-precision-_<span class="kw">or before</span> operator returns true if the first interval ends on or before the second one starts, using the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries, and for Date, DateTime, or Time values, performing the comparisons at the specified precision, as described in the <span class="id">[Same or Before (Date, DateTime, or Time)](#same-or-before-1)</span> operator for Date, DateTime, or Time values.

If no precision is specified, comparisons are performed beginning with years (or hours for time values) and proceeding to the finest precision specified in either input.

For <span class="id">Date</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, or <span class="kw">day</span>.

For <span class="id">DateTime</span>-based intervals, _precision_ must be one of: <span class="kw">year</span>, <span class="kw">month</span>, <span class="kw">day</span>, <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

For <span class="id">Time</span>-based intervals, _precision_ must be one of: <span class="kw">hour</span>, <span class="kw">minute</span>, <span class="kw">second</span>, or <span class="kw">millisecond</span>.

Note specifically that due to variability in the way week numbers are determined, comparisons involving weeks are not supported.

When this operator is called with a mixture of <span class="id">Date</span>- and <span class="id">DateTime</span>-based intervals, the <span class="id">Date</span> values will be implicitly converted to <span class="id">DateTime</span> values as defined by the <span class="id">[ToDateTime](#todatetime)</span> operator.

When this operator is called with a mixture of point values and intervals, the point values are implicitly converted to an interval starting and ending on the given point value.

For comparisons involving date or time values with imprecision, note that the result of the comparison may be <span class="kw">null</span>, depending on whether the values involved are specified to the level of precision used for the comparison.

When comparing DateTime values with different timezone offsets, the values are normalized to the timezone offset of the evaluation request timestamp, but only when the comparison precision is hours, minutes, seconds, or milliseconds.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either or both arguments are <span class="kw">null</span>, the result is null.

Note that in timing phrases, the keyword <span class="kw">on</span> may be used as a synonym for <span class="kw">same</span> for this operator.

#### Size

**Signature:**

```cql
Size(argument Interval<T>) T
```

**Description:**

The <span class="kw">Size</span> operator returns the size of an interval. The result of this operator is equivalent to invoking: (<span class="kw">end of</span> <span class="id">argument</span> <span class="sym">–</span> <span class="kw">start of</span> <span class="id">argument</span>) + _point-size_, where _point-size_ is determined by <span class="kw">successor of minimum T</span> <span class="sym">-</span> <span class="kw">minimum T</span>.

Note that because CQL defines _duration_ and _difference_ operations for date and time valued intervals, _size_ is not defined for intervals of these types.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Size</span> operator:

```cql
define "SizeTest": Size(Interval[3, 7]) // 5, i.e. the interval contains 5 points
define "SizeTestEquivalent": Size(Interval[3, 8)) // 5, i.e. the interval contains 5 points
define "SizeIsNull": Size(null as Interval<Integer>) // null
```

#### Start

**Signature:**

```cql
start of(argument Interval<T>) T
```

**Description:**

The <span class="id">Start</span> operator returns the starting point of an interval.

If the low boundary of the interval is open, this operator returns the <span class="kw">successor</span> of the low value of the interval. Note that if the low value of the interval is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the low boundary of the interval is closed and the low value of the interval is not null, this operator returns the low value of the interval. Otherwise, the result is the minimum value of the point type of the interval.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Start</span> operator:

```cql
define "StartOfInterval": start of Interval[1, 5] // 1
define "StartIsNull": start of (null as Interval<Integer>)
```

#### Starts

**Signature:**

```cql
starts _precision_ (left Interval<T>, right Interval<T>) Boolean
```

**Description:**

The <span class="kw">starts</span> operator returns <span class="kw">true</span> if the first interval starts the second. More precisely, if the starting point of the first is equal to the starting point of the second interval and the ending point of the first interval is less than or equal to the ending point of the second interval.

This operator uses the semantics described in the <span class="id">[Start](#start)</span> and <span class="id">[End](#end)</span> operators to determine interval boundaries.

If precision is specified and the point type is a Date, DateTime, or Time type, comparisons used in the operation are performed at the specified precision.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">starts</span> operator:

```cql
define "StartsIsTrue": Interval[0, 5] starts Interval[0, 7]
define "StartsIsFalse": Interval[0, 7] starts Interval[0, 6]
define "StartsIsNull": Interval[1, 5] starts null
```

#### Union

**Signature:**

```cql
union(left Interval<T>, right Interval<T>) Interval<T>
```

**Description:**

The <span class="kw">union</span> operator for intervals returns the union of the intervals. More precisely, the operator returns the interval that starts at the earliest starting point in either argument, and ends at the latest starting point in either argument. If the arguments do not overlap or meet, this operator returns <span class="kw">null</span>.

Comparisons of values are performed with the same semantics as specified for comparison of the point type. In particular, for the purposes of comparison of DateTime or Time values, seconds and milliseconds are combined as a single precision using a decimal, with decimal comparison semantics, and this combination is performed before any comparisons used in the operation.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">union</span> operator:

```cql
define "Union": Interval[1, 5] union Interval[3, 7] // Interval[1, 7]
define "UnionIsNull": Interval[3, 5] union (null as Interval<Integer>)
```

#### Width

**Signature:**

```cql
width of(argument Interval<T>) T
```

**Description:**

The <span class="kw">width</span> operator returns the width of an interval. The result of this operator is equivalent to invoking: (<span class="kw">end of</span> <span class="id">argument</span> <span class="sym">–</span> <span class="kw">start of</span> <span class="id">argument</span>).

Note that because CQL defines _duration_ and _difference_ operations for date and time valued intervals, _width_ is not defined for intervals of these types.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">width</span> operator:

```cql
define "Width": width of Interval[3, 7] // 4
define "WidthIsNull": width of (null as Interval<Integer>) // null
define "NullInterval": width of Interval[0, null) //null
```

{: #list-operators-2}
### List Operators

Note that the operators in this section may all be invoked with singleton arguments if the _list promotion_ feature is enabled. See the [Promotion and Demotion](03-developersguide.html#promotion-and-demotion) section for more information.

{: #contains-1}
#### Contains

**Signature:**

```cql
contains(argument List<T>, element T) Boolean
```

**Description:**

The <span class="kw">contains</span> operator for lists returns <span class="kw">true</span> if the given element is in the list using equality semantics, with the exception that <span class="kw">null</span> elements are considered equal.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">false</span>. If the second argument is <span class="kw">null</span>, the result is <span class="kw">true</span> if the list contains any <span class="kw">null</span> elements, and <span class="kw">false</span> otherwise.

The following examples illustrate the behavior of the <span class="kw">contains</span> operator:

```cql
define "ContainsIsTrue": { 1, 3, 5, 7 } contains 5
define "ContainsIsFalse": { 1, 3, 5, 7 } contains 4
define "ContainsIsAlsoFalse": null contains 4
define "ContainsNullIsFalse": { 1, 3, 5, 7 } contains null
```

#### Distinct

**Signature:**

```cql
distinct(argument List<T>) List<T>
```

**Description:**

The <span class="kw">distinct</span> operator returns the given list with duplicates eliminated using equality semantics.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The operator uses equality comparison semantics as defined in the Equal operator, with the exception that nulls are considered equal for the purposes of distinct determination. This means that multiple nulls in the input will result in a single null in the output.

The following examples illustrate the behavior of the <span class="kw">distinct</span> operator:

```cql
define "Distinct": distinct { 1, 3, 3, 5, 5 } // { 1, 3, 5 }
define "DistinctIsNull": distinct null // null
```

{: #equal-2}
#### Equal

**Signature:**

```cql
=(left List<T>, right List<T>) Boolean
```

**Description:**

The _equal_ (<span class="sym">=</span>) operator for lists returns <span class="kw">true</span> if and only if the lists have the same element type, and have the same elements by value, in the same order.

This operation uses equality semantics, with the exception that nulls are considered equal.

If either argument is <span class="kw">null</span>, or contains null elements, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _equal_ operator:

```cql
define "EqualIsTrue": { 1, 3, 5, 7 } = { 1, 3, 5, 7 }
define "EqualIsFalse": { 1, 3, 5, 7 } = { 1, 3, 5 }
define "EqualIsNull": { 1, 3, 5, 7 } = null
```

{: #equivalent-2}
#### Equivalent

**Signature:**

```cql
~(left List<T>, right List<T>) Boolean
```

**Description:**

The _equivalent_ (<span class="sym">~</span>) operator for lists returns <span class="kw">true</span> if and only if the lists contain elements of the same type, have the same number of elements, and for each element in the lists, in order, the elements are equivalent.

The following examples illustrate the behavior of the _equivalent_ operator:

```cql
define "EquivalentIsTrue": { 1, 3, 5, 7 } ~ { 1, 3, 5, 7 }
define "EquivalentIsAlsoTrue": { 1, 3, 5, null } ~ { 1, 3, 5, null }
define "EquivalentIsFalse": { 1, 3, 5, 7 } ~ { 1, 3, 5 }
```

{: #equivalentin}
#### EquivalentIn

> The EquivalentIn operator was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
~in(element T, argument List<T>) Boolean
```

**Description:**

The <span class="kw">~in</span> operator for lists returns <span class="kw">true</span> if the given element is in the given list using equivalent semantics.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">true</span> if the list contains any <span class="kw">null</span> elements, and <span class="kw">false</span> otherwise. If the second argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">~in</span> operator:

```cql
define "EquivalentInIsTrue": 'a' ~in { 'A', 'B', 'C' }
define "EquivalentInIsFalse": 'a' ~in { 'B', 'C' }
define "EquivalentInIsAlsoFalse": 'a' ~in null
define "NullEquivalentInIsTrue": null ~in { 1, 3, 5, null }
```

{: #equivalentcontains}
#### EquivalentContains

> The EquivalentIn operator was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
~contains(argument List<T>, element T) Boolean
```

**Description:**

The <span class="kw">~contains</span> operator for lists returns <span class="kw">true</span> if the given element is in the list using equivalent semantics.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">false</span>. If the second argument is <span class="kw">null</span>, the result is <span class="kw">true</span> if the list contains any <span class="kw">null</span> elements, and <span class="kw">false</span> otherwise.

The following examples illustrate the behavior of the <span class="kw">~contains</span> operator:

```cql
define "EquivalentContainsIsTrue": { 'A', 'B', 'C' } ~contains 'a'
define "EquivalentContainsIsFalse": { 'B', 'C' } ~contains 'a'
define "EquivalentContainsIsAlsoFalse": null ~contains 'a'
define "EquivalentContainsNullIsFalse": { 'A', 'B', 'C' } ~contains null
```

{: #except-1}
#### Except

**Signature:**

```cql
except(left List<T>, right List<T>) List<T>
```

**Description:**

The <span class="kw">except</span> operator returns the set difference of two lists. More precisely, the operator returns a list with the elements that appear in the first operand that do not appear in the second operand.

This operator uses equality semantics to determine whether two elements are the same for the purposes of computing the difference, with the exception that <span class="kw">null</span> elements are considered equal.

The operator is defined with set semantics, meaning that each element will appear in the result at most once, and that there is no expectation that the order of the inputs will be preserved in the results.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">null</span>. If the second argument is <span class="kw">null</span>, the operation is performed as though the second argument was an empty list.

The following examples illustrate the behavior of the <span class="kw">except</span> operator:

```cql
define "Except": { 1, 3, 5, 7 } except { 1, 3 } // { 5, 7 }
define "ExceptLeft": { 1, 3, 5, 7 } except null // { 1, 3, 5, 7 }
define "ExceptWithNull": { 1, 3, 5, 7, null } except { 1, 3, null } // { 5, 7 }
define "ExceptIsNull": null except { 1, 3, 5 }
```

#### Exists

**Signature:**

```cql
exists(argument List<T>) Boolean
```

**Description:**

The <span class="kw">exists</span> operator returns <span class="kw">true</span> if the list contains any non-null elements.

If the argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">exists</span> operator:

```cql
define "ExistsIsTrue": exists { 1, 3, 5, 7 }
define "ExistsIsFalse": exists { }
define "ExistsIsAlsoFalse": exists { null }
define "ExistsIsAlsoAlsoFalse": exists null
```

#### Flatten

**Signature:**

```cql
flatten(argument List<List<T>>) List<T>
```

**Description:**

The <span class="kw">flatten</span> operator flattens a list of lists into a single list.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">flatten</span> operator:

```cql
define "Flatten": flatten { { 1, 2 }, { 3, 4, 5 } } // { 1, 2, 3, 4, 5 }
define "FlattenIsNull": flatten null
```

#### First

**Signature:**

```cql
First(argument List<T>) T
```

**Description:**

The <span class="id">First</span> operator returns the first element in a list. The operator is equivalent to invoking the indexer with an index of 0.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">First</span> operator:

```cql
define "First1": First({ 1, 2, 5 }) // 1
define "FirstIsNull": First(null)
```

{: #in-1}
#### In

**Signature:**

```cql
in(element T, argument List<T>) Boolean
```

**Description:**

The <span class="kw">in</span> operator for lists returns <span class="kw">true</span> if the given element is in the given list using equality semantics, with the exception that <span class="kw">null</span> elements are considered equal.

If the first argument is <span class="kw">null</span>, the result is <span class="kw">true</span> if the list contains any <span class="kw">null</span> elements, and <span class="kw">false</span> otherwise. If the second argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="kw">in</span> operator:

```cql
define "InIsTrue": 5 in { 1, 3, 5, 7 }
define "InIsFalse": 5 in { 1, 3 }
define "InIsAlsoFalse": 5 in null
define "NullInIsTrue": null in { 1, 3, 5, null }
```

{: #includes-1}
#### Includes

**Signature:**

```cql
includes(left List<T>, right List<T>) Boolean
includes(left List<T>, right T) Boolean
```

**Description:**

The <span class="kw">includes</span> operator for lists returns <span class="kw">true</span> if the first list contains every element of the second list using equality semantics, with the exception that <span class="kw">null</span> elements are considered equal.

For the list-singleton overload, this operator is a synonym for the <span class="kw">[contains](#contains-1)</span> operator.

For the list-list overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that the order of elements does not matter for the purposes of determining inclusion.

The following examples illustrate the behavior of the <span class="kw">includes</span> operator:

```cql
define "IncludesIsTrue": { 1, 3, 5, 7 } includes 5
define "IncludesIsNull": { 1, 3, 5, null } includes null
define "IncludesIsFalse": { 1, 3 } includes { 1, 3, 5 }
define "IncludesIsAlsoNull": null includes { 1, 3, 5 }
```

{: #included-in-1}
#### Included In

**Signature:**

```cql
included in(left List<T>, right list<T>) Boolean
included in(left T, right list<T>) Boolean
```

**Description:**

The <span class="kw">included in</span> operator for lists returns <span class="kw">true</span> if every element of the first list is in the second list using equality semantics.

For the singleton-list overload, this operator is a synonym for the <span class="kw">[in](#in-1)</span> operator, and will return <span class="kw">null</span> if the first argument is <span class="kw">null</span>, and <span class="kw">false</span> if the second argument is <span class="kw">null</span>.

For the list-list overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that the order of elements does not matter for the purposes of determining inclusion.

The following examples illustrate the behavior of the <span class="kw">included in</span> operator:

```cql
define "IncludedInIsTrue": 5 included in { 1, 3, 5, 7 }
define "IncludedInIsNull": null included in { 1, 3, 5 }
define "IncludedInIsFalse": { 1, 3, 5 } included in { 1, 3 }
define "IncludedInIsAlsoNull": { 1, 3, 5, null } included in null
```

{: #indexer-1}
#### Indexer

**Signature:**

```cql
[](argument List<T>, index Integer) T
```

**Description:**

The _indexer_ (<span class="sym">[]</span>) operator returns the element at the <span class="id">index</span><sup>th</sup> position in a list.

Indexes in lists are defined to be 0-based.

If the <span class="id">index</span> is less than 0, or greater than the number of elements in the list, the result is <span class="kw">null</span>.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _indexer_ operator:

```cql
define "Indexer": { 1, 3, 5, 7 }[1] // 3
define "IndexerIsNull": { 1, 3, 5 }[-1]
define "IndexerIsAlsoNull": (null as List<Integer>)[0]
```

#### IndexOf

**Signature:**

```cql
IndexOf(argument List<T>, element T) Integer
```

**Description:**

The <span class="id">IndexOf</span> operator returns the 0-based index of the given element in the given source list using equality semantics, with the exception that nulls are considered equal.

If the list is empty, or no element is found, the result is -1.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">IndexOf</span> operator:

```cql
define "IndexOfFound": IndexOf({ 1, 3, 5, 7 }, 5) // 2
define "IndexOfNotFound": IndexOf({ 1, 3, 5, 7 }, 4) // -1
define "IndexOfIsNull": IndexOf(null, 4)
```

{: #intersect-1}
#### Intersect

**Signature:**

```cql
intersect(left List<T>, right List<T>) List<T>
```

**Description:**

The <span class="kw">intersect</span> operator for lists returns the intersection of two lists. More precisely, the operator returns a list containing only the elements that appear in both lists.

This operator uses equality semantics to determine whether or not two elements are the same, with the exception that null elements are considered equal for the purposes of the intersection.

The operator is defined with set semantics, meaning that each element will appear in the result at most once, and that there is no expectation that the order of the inputs will be preserved in the results.

If either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">intersect</span> operator:

```cql
define "Intersect": { 1, 3, 5 } intersect { 3, 5, 7 } // { 3, 5 }
define "IntersectWithNull": { null, 1, 3, 5 } intersect { null, 3, 5, 7 } // { null, 3, 5 }
define "IntersectIsNull": { 1, 3, 5 } intersect null
```

#### Last

**Signature:**

```cql
Last(argument List<T>) T
```

**Description:**

The <span class="id">Last</span> operator returns the last element in a list. In a list of length N, the operator is equivalent to invoking the indexer with an index of N <span class="sym">-</span> 1.

If the argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Last</span> operator:

```cql
define "Last5": Last({ 1, 3, 5 }) // 5
define "LastIsNull": Last(null)
```

{: #length-1}
#### Length

**Signature:**

```cql
Length(argument List<T>) Integer
```

**Description:**

The <span class="id">Length</span> operator returns the number of elements in a list.

If the argument is <span class="kw">null</span>, the result is <span class="kw">0</span>.

The following examples illustrate the behavior of the <span class="id">Length</span> operator:

```cql
define "Length3": Length({ 1, 3, 5 }) // 3
define "Length0": Length(null as List<Integer>)
```

{: #not-equal-2}
#### Not Equal

**Signature:**

```cql
!=(left List<T>, right List<T>) Boolean
```

**Description:**

The _not equal_ (<span class="sym">!=</span>) operator for lists returns <span class="kw">true</span> if its arguments are not the same value.

The _not equal_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equal_ operator.

The following examples illustrate the behavior of the _not equal_ operator:

```cql
define "NotEqualIsFalse": { 1, 3, 5, 7 } != { 1, 3, 5, 7 }
define "NotEqualIsTrue": { 1, 3, 5, 7 } != { 1, 3, 5 }
define "NotEqualIsNull": { 1, 3, 5, 7 } != null
```

{: #not-equivalent-2}
#### Not Equivalent

**Signature:**

```cql
!~(left List<T>, right List<T>) Boolean
```

**Description:**

The _not equivalent_ (<span class="sym">!~</span>) operator for lists returns <span class="kw">true</span> if its arguments are not equivalent.

The _not equivalent_ operator is a shorthand for invocation of logical negation (<span class="kw">not</span>) of the _equivalent_ operator.

The following examples illustrate the behavior of the _not equivalent_ operator:

```cql
define "NotEquivalentIsFalse": { 1, 3, 5, 7 } !~ { 1, 3, 5, 7 }
define "NotEquivalentIsAlsoFalse": { 1, 3, 5, null } !~ { 1, 3, 5, null }
define "NotEquivalentIsTrue": { 1, 3, 5, 7 } !~ { 1, 3, 5 }
```

{: #properly-includes-1}
#### Properly Includes

**Signature:**

```cql
properly includes(left List<T>, right List<T>) Boolean
properly includes(left T, right List<T>) Boolean
```

**Description:**

The <span class="kw">properly includes</span> operator for lists returns <span class="kw">true</span> if the first list contains every element of the second list, and the first list is strictly larger than the second list.

For the singleton-list overload, this operator returns true if the list contains (i.e. includes) the element, and it is not the only element in the list.

This operator uses equality semantics to determine whether or not two elements are the same, with the exception that null elements are considered equal.

For the list-list overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that the order of elements does not matter for the purposes of determining inclusion.

The following examples illustrate the behavior of the <span class="kw">properly includes</span> operator:

```cql
define "ProperlyIncludesIsTrue": { 1, 3, 5, 7 } properly includes { 1, 3, 5 }
define "ProperlyIncludesIsAlsoTrue": { 1, 3, 5, null } properly includes null
define "ProperlyIncludesIsFalse": { 1, 3, 5 } properly includes { 1, 3, 5 }
define "ProperlyIncludesIsAlsoFalse": null properly includes { 1, 3, 5 }
```

{: #properly-included-in-1}
#### Properly Included In

**Signature:**

```cql
properly included in(left List<T>, right list<T>) Boolean
properly included in(left T, right list<T>) Boolean
```

**Description:**

The <span class="kw">properly included in</span> operator for lists returns <span class="kw">true</span> if every element of the first list is in the second list and the first list is strictly smaller than the second list.

For the singleton-list overload, this operator returns true if the element is in (i.e. included in) the list and it is not the only element in the list.

This operator uses equality semantics to determine whether or not two elements are the same, with the exception that null elements are considered equal.

For the list-list overload, if either argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

Note that the order of elements does not matter for the purposes of determining inclusion.

The following examples illustrate the behavior of the <span class="kw">properly included in</span> operator:

```cql
define "ProperlyIncludedInIsTrue": { 1, 3, 5 } properly included in { 1, 3, 5, 7 }
define "ProperlyIncludedInIsAlsoTrue": null properly included in { 1, 3, 5 }
define "ProperlyIncludedInIsFalse": { 1, 3, 5 } properly included in { 1, 3, 5 }
define "ProperlyIncludedInIsAlsoFalse": { 1, 3, 5, null } properly included in null
```

#### Singleton From

**Signature:**

```cql
singleton from(argument List<T>) T
```

**Description:**

The <span class="kw">singleton from</span> operator extracts a single element from the source list. If the source list is empty, the result is <span class="kw">null</span>. If the source list contains one element, that element is returned. If the list contains more than one element, a run-time error is thrown.

If the source list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="kw">singleton from</span> operator:

```cql
define "SingletonFrom": singleton from { 1 } // 1
define "SingletonFromError": singleton from { 1, 3, 5 }
define "SingletonFromIsNull": singleton from (null as List<Integer>)
```

#### Skip

**Signature:**

```cql
Skip(argument List<T>, number Integer) List<T>
```

**Description:**

The <span class="id">Skip</span> operator returns the elements in the list, skipping the first <span class="id">number</span> elements. If the list has less <span class="id">number</span> elements, the result is empty.

If the source list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the number of elements is <span class="kw">null</span>, the result is the entire list, no elements are skipped.

If the number of elements is less than zero, the result is an empty list.

The following examples illustrate the behavior of the <span class="id">Skip</span> operator:

```cql
define "Skip2": Skip({ 1, 2, 3, 4, 5 }, 2) // { 3, 4, 5 }
define "SkipNull": Skip({ 1, 3, 5 }, null) // { 1, 3, 5 }
define "SkipEmpty": Skip({ 1, 3, 5 }, -1) // { }
define "SkipIsNull": Skip(null, 2)
```

#### Slice

> The Slice function was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
Slice(argument List<T>)
Slice(argument List<T>, startIndex Integer)
Slice(argument List<T>, startIndex Integer, endIndex Integer)
```

**Description:**

The <span class="id">Slice</span> operator returns a portion of the elements in a list, beginning at the <span class="id">startIndex</span> and ending just before the <span class="id">endIndex</span> index.

If the source list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If the startIndex is <span class="kw">null</span>, the slice begins at the first element of the list.

If the endIndex is <span class="kw">null</span>, the slice continues to the last element of the list.

A negative index counts back from the end of the list.

If `-list.count <= startIndex < 0`, `startIndex + list.count` is used as the `startIndex`.

If `startIndex < -list.count`, `0` is used as the `startIndex`.

If `startIndex >= list.count`, the result is an empty list.

If `-list.count <= endIndex < 0`, `endIndex + list.count` is used as the `endIndex`.

If `endIndex < -list.count`, `0` is used as the `endIndex`.

If `endIndex >= list.count`, `list.count` is used as the `endIndex`.

If `endIndex <= startIndex`, the result is an empty list.

The following examples illustrate the behavior of the <span class="id">Slice</span> operator:

```cql
define SliceAll: Slice({ 1, 2, 3, 4, 5 }) // { 1, 2, 3, 4, 5 }
define SliceEmpty: Slice({ }) // { }
define SliceNull: Slice(null) // null
define SliceStart: Slice({ 1, 2, 3, 4, 5 }, 1) // { 2, 3, 4, 5 }
define SliceEnd: Slice({ 1, 2, 3, 4, 5 }, 1, 3) // { 2, 3 }
define SliceNegative: Slice({ 1, 2, 3, 4, 5 }, -2) // { 4, 5 }
define SliceStartAndNegative: Slice({ 1, 2, 3, 4, 5 }, 1, -1) // { 2, 3, 4 }
define SlicePast: Slice({ 1, 2, 3, 4, 5 }, 5) // { }
```

#### Tail

**Signature:**

```cql
Tail(argument List<T>) List<T>
```

**Description:**

The <span class="id">Tail</span> operator returns all but the first element from the given list. If the list is empty, the result is empty.

If the source list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Tail</span> operator:

```cql
define "Tail234": Tail({ 1, 2, 3, 4 }) // { 2, 3, 4 }
define "TailEmpty": Tail({ }) // { }
define "TailIsNull": Tail(null)
```

#### Take

**Signature:**

```cql
Take(argument List<T>, number Integer) List<T>
```

**Description:**

The <span class="id">Take</span> operator returns the first <span class="id">number</span> elements from the given list. If the list has less than <span class="id">number</span> elements, the result only contains the elements in the list.

If the source list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

If number is <span class="kw">null</span>, or <span class="lit">0</span> or less, the result is an empty list.

The following examples illustrate the behavior of the <span class="id">Take</span> operator:

```cql
define "Take2": Take({ 1, 2, 3, 4 }, 2) // { 1, 2 }
define "TakeTooMany": Take({ 1, 2 }, 3) // { 1, 2 }
define "TakeEmpty": Take({ 1, 2, 3, 4 }, null) // { }
define "TakeIsNull": Take(null, 2)
```

{: #union-1}
#### Union

**Signature:**

```cql
union(left List<T>, right List<T>) List<T>
```

**Description:**

The <span class="kw">union</span> operator for lists returns a list with all unique elements from both arguments.

The union operator is defined as a set operation, meaning that duplicates are eliminated; if an element appears in both sources, that element will only appear once in the resulting list. In addition, there is no expectation that the order of elements in the inputs will be preserved in the results.

This operator uses equality semantics with the exception that null elements are considered equal.

If either argument is <span class="kw">null</span>, it is considered an empty list for the purposes of evaluating the union.

Note that the union operator can also be invoked with the symbolic operator (<span class="sym">|</span>).

The following examples illustrate the behavior of the <span class="kw">union</span> operator:

```cql
define "Union": { 1, 2, 3 } union { 4, 5 } // { 1, 2, 3, 4, 5 }
define "UnionAlternateSyntax": { 1, 2, 3 } | { 4, 5 } // { 1, 2, 3, 4, 5 }
define "UnionWithNull": null union { 4, 5 } // { 4, 5 }
```

### Aggregate Functions

#### AllTrue

**Signature:**

```cql
AllTrue(argument List<Boolean>) Boolean
```

**Description:**

The <span class="id">AllTrue</span> operator returns <span class="kw">true</span> if all the non-null elements in the source are <span class="kw">true</span>.

If the source contains no non-null elements, <span class="kw">true</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">true</span>.

The following examples illustrate the behavior of the <span class="id">AllTrue</span> operator:

```cql
define "AllTrueIsTrue": AllTrue({ true, null, true })
define "AllTrueIsAlsoTrue": AllTrue({ null, null, null })
define "AllTrueIsTrueWhenNull": AllTrue(null)
define "AllTrueIsFalse": AllTrue({ true, false, null })
```

#### AnyTrue

**Signature:**

```cql
AnyTrue(argument List<Boolean>) Boolean
```

**Description:**

The <span class="id">AnyTrue</span> operator returns <span class="kw">true</span> if any non-null element in the source is <span class="kw">true</span>.

If the source contains no non-null elements, <span class="kw">false</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">false</span>.

The following examples illustrate the behavior of the <span class="id">AnyTrue</span> operator:

```cql
define "AnyTrueIsTrue": AnyTrue({ true, false, null })
define "AnyTrueIsFalse": AnyTrue({ false, false, null })
define "AnyTrueIsAlsoFalse": AnyTrue({ null, null, null })
define "AnyTrueIsFalseWhenNull": AnyTrue(null)
```

#### Avg

**Signature:**

```cql
Avg(argument List<Decimal>) Decimal
Avg(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">Avg</span> operator returns the average of the non-null elements in the source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Avg</span> operator:

```cql
define "DecimalAvg": Avg({ 5.5, 4.7, 4.8 }) // 5.0
define "QuantityAvg": Avg({ 5.5 'cm', 4.7 'cm', 4.8 'cm' }) // 5.0 'cm'
define "AvgIsNull": Avg(null as List<Decimal>)
```

#### Count

**Signature:**

```cql
Count(argument List<T>) Integer
```

**Description:**

The <span class="id">Count</span> operator returns the number of non-null elements in the source. If the list contains no non-null elements, the result is 0. If the list is <span class="kw">null</span>, the result is <span class="lit">0</span>.

The following examples illustrate the behavior of the <span class="id">Count</span> operator:

```cql
define "Count5": Count({ 1, 2, 3, 4, 5 }) // 5
define "Count0": Count({ null, null, null }) // 0
define "CountNull0": Count(null as List<Decimal>) // 0
```

#### GeometricMean

**Signature:**

```cql
GeometricMean(argument List<Decimal>) Decimal
```

**Description:**

The <span class="id">GeometricMean</span> operator returns the geometric mean of the non-null elements in the source. Geometric mean is defined as the N<sup>th</sup> root of the geometric product of the elements. In other words:

```cql
GeometricMean(X) = Power(Product(X), 1 / Count(X))
```

If the source contains no non-null elements, the result is <span class="kw">null</span>.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">GeometricMean</span> operator:

```cql
define "GeometricMean4": GeometricMean({ 2.0, 8.0 }) // 4.0
define "GeometricMeanIsNull": GeometricMean({ null, null, null })
define "GeometricMeanIsAlsoNull": GeometricMean(null as List<Decimal>)
```

#### Max

**Signature:**

```cql
Max(argument List<Integer>) Integer
Max(argument List<Long>) Long
Max(argument List<Decimal>) Decimal
Max(argument List<Quantity>) Quantity
Max(argument List<Date>) Date
Max(argument List<DateTime>) DateTime
Max(argument List<Time>) Time
Max(argument List<String>) String
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">Max</span> operator returns the maximum element in the source. Comparison semantics are defined by the [Comparison Operators](#comparison-operators) for the type of value being aggregated.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Max</span> operator:

```cql
define "IntegerMax": Max({ 2, 4, 8, 6 }) // 8
define "LongMax": Max({ 2L, 4L, 8L, 6L }) // 8L
define "DateMax": Max({ @2012-12-31, @2013-01-01, @2012-01-01 }) // @2013-01-01
define "MaxIsNull": Max({ null as Quantity, null as Quantity, null as Quantity })
define "MaxIsAlsoNull": Max(null as List<Decimal>)
```

#### Min

**Signature:**

```cql
Min(argument List<Integer>) Integer
Min(argument List<Long>) Long
Min(argument List<Decimal>) Decimal
Min(argument List<Quantity>) Quantity
Min(argument List<Date>) Date
Min(argument List<DateTime>) DateTime
Min(argument List<Time>) Time
Min(argument List<String>) String
```

**Description:**

The <span class="id">Min</span> operator returns the minimum element in the source. Comparison semantics are defined by the [Comparison Operators](#comparison-operators) for the type of value being aggregated.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Min</span> operator:

```cql
define "IntegerMin": Min({ 2, 4, 8, 6 }) // 2
define "LongMin": Min({ 2L, 4L, 8L, 6L }) // 2L
define "DateMin": Min({ @2012-12-31, @2013-01-01, @2012-01-01 }) // @2012-01-01
define "MinIsNull": Min({ null as Quantity, null as Quantity, null as Quantity })
define "MinIsAlsoNull": Min(null as List<Decimal>)
```

#### Median

**Signature:**

```cql
Median(argument List<Decimal>) Decimal
Median(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">Median</span> operator returns the median of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Median</span> operator:

```cql
define "DecimalMedian": Median({ 2.0, 4.0, 8.0, 6.0 }) // 5.0
define "QuantityMedian": Median({ 1.0 'mg', 2.0 'mg', 3.0 'mg' }) // 2.0 'mg'
define "MedianIsNull": Median({ null as Quantity, null as Quantity, null as Quantity })
define "MedianIsAlsoNull": Median(null as List<Decimal>)
```

#### Mode

**Signature:**

```cql
Mode(argument List<T>) T
```

**Description:**

The <span class="id">Mode</span> operator returns the statistical mode of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Mode</span> operator:

```cql
define "DecimalMode": Mode({ 2.0, 2.0, 8.0, 6.0, 8.0, 8.0 }) // 8.0
define "QuantityMode": Mode({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 2.0 'mg' }) // 2.0 'mg'
define "ModeIsNull": Mode({ null as Quantity, null as Quantity, null as Quantity })
define "ModeIsAlsoNull": Mode(null as List<Decimal>)
```

#### Population StdDev

**Signature:**

```cql
PopulationStdDev(argument List<Decimal>) Decimal
PopulationStdDev(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">PopulationStdDev</span> operator returns the statistical standard deviation of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">PopulationStdDev</span> operator:

```cql
define "DecimalPopulationStdDev": PopulationStdDev({ 1.0, 2.0, 3.0, 4.0, 5.0 }) // 1.41421356
define "QuantityPopulationStdDev": PopulationStdDev({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg', 5.0 'mg' }) // 1.41421356 'mg'
define "PopulationStdDevIsNull": PopulationStdDev({ null as Quantity, null as Quantity, null as Quantity })
define "PopulationStdDevIsAlsoNull": PopulationStdDev(null as List<Decimal>)
```

#### Population Variance

**Signature:**

```cql
PopulationVariance(argument List<Decimal>) Decimal
PopulationVariance(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">PopulationVariance</span> operator returns the statistical population variance of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">PopulationVariance</span> operator:

```cql
define "DecimalPopulationVariance": PopulationVariance({ 1.0, 2.0, 3.0, 4.0, 5.0 }) // 2.0
define "QuantityPopulationVariance": PopulationVariance({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg', 5.0 'mg' }) // 2.0 'mg'
define "PopulationVarianceIsNull": PopulationVariance({ null as Quantity, null as Quantity, null as Quantity })
define "PopulationVarianceIsAlsoNull": PopulationVariance(null as List<Decimal>)
```

#### Product

**Signature:**

```cql
Product(argument List<Integer>) Integer
Product(argument List<Long>) Long
Product(argument List<Decimal>) Decimal
Product(argument List<Quantity>) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">Product</span> operator returns the geometric product of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Product</span> operator:

```cql
define "DecimalProduct": Product({ 1.0, 2.0, 3.0, 4.0 }) // 24.0
define "QuantityProduct": Product({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg' }) // 24.0 'mg'
define "ProductIsNull": Product({ null as Quantity, null as Quantity, null as Quantity })
define "ProductIsAlsoNull": Product(null as List<Decimal>)
```

#### StdDev

**Signature:**

```cql
StdDev(argument List<Decimal>) Decimal
StdDev(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">StdDev</span> operator returns the statistical standard deviation of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">StdDev</span> operator:

```cql
define "DecimalStdDev": StdDev({ 1.0, 2.0, 3.0, 4.0, 5.0 }) // 1.58113883
define "QuantityStdDev": StdDev({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg', 5.0 'mg' }) // 1.58113883 'mg'
define "StdDevIsNull": StdDev({ null as Quantity, null as Quantity, null as Quantity })
define "StdDevIsAlsoNull": StdDev(null as List<Decimal>)
```

#### Sum

**Signature:**

```cql
Sum(argument List<Integer>) Integer
Sum(argument List<Long>) Long
Sum(argument List<Decimal>) Decimal
Sum(argument List<Quantity>) Quantity
```

> The Long type feature was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Description:**

The <span class="id">Sum</span> operator returns the sum of non-null elements in the source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the list is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Sum</span> operator:

```cql
define "DecimalSum": Sum({ 1.0, 2.0, 3.0, 4.0, 5.0 }) // 15.0
define "QuantitySum": Sum({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg', 5.0 'mg' }) // 15.0 'mg'
define "SumIsNull": Sum({ null as Quantity, null as Quantity, null as Quantity })
define "SumIsAlsoNull": Sum(null as List<Decimal>)
```

#### Variance

**Signature:**

```cql
Variance(argument List<Decimal>) Decimal
Variance(argument List<Quantity>) Quantity
```

**Description:**

The <span class="id">Variance</span> operator returns the statistical variance of the elements in source.

If the source contains no non-null elements, <span class="kw">null</span> is returned.

If the source is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">Variance</span> operator:

```cql
define "DecimalVariance": Variance({ 1.0, 2.0, 3.0, 4.0, 5.0 }) // 2.5
define "QuantityVariance": Variance({ 1.0 'mg', 2.0 'mg', 3.0 'mg', 4.0 'mg', 5.0 'mg' }) // 2.5 'mg'
define "VarianceIsNull": Variance({ null as Quantity, null as Quantity, null as Quantity })
define "VarianceIsAlsoNull": Variance(null as List<Decimal>)
```

{: #clinical-operators-3}
### Clinical Operators

#### Age

**Signature:**

```cql
AgeInYears() Integer
AgeInMonths() Integer
AgeInWeeks() Integer
AgeInDays() Integer
AgeInHours() Integer
AgeInMinutes() Integer
AgeInSeconds() Integer
```

**Description:**

The <span class="id">Age</span> operators calculate the age of the patient as of the current date in the precision named in the operator.

If the patient’s birthdate is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The <span class="id">Age</span> operators are defined in terms of a date or time duration calculation. This means that if the age of the patient is not specified to the level of precision corresponding to the operator being invoked, the result will be an _uncertainty_ over the range of possible values, potentially causing some comparisons to return <span class="kw">null</span>.

Note that for <span class="id">AgeInYears</span> and <span class="id">AgeInMonths</span>, the <span class="id">birthDate</span> is specified as a <span class="id">Date</span> and <span class="id">Today()</span> is used to obtain the current date; whereas with the other precisions, <span class="id">birthDate</span> is specified as a <span class="id">DateTime</span>, and <span class="id">Now()</span> is used to obtain the current DateTime.

These operators are shorthand for the equivalent AgeInXXXAt operator, passing Today() or Now() for the asOf argument.

#### AgeAt

**Signature:**

```cql
AgeInYearsAt(asOf Date) Integer
AgeInYearsAt(asOf DateTime) Integer
AgeInMonthsAt(asOf Date) Integer
AgeInMonthsAt(asOf DateTime) Integer
AgeInWeeksAt(asOf Date) Integer
AgeInWeeksAt(asOf DateTime) Integer
AgeInDaysAt(asOf Date) Integer
AgeInDaysAt(asOf DateTime) Integer
AgeInHoursAt(asOf DateTime) Integer
AgeInMinutesAt(asOf DateTime) Integer
AgeInSecondsAt(asOf DateTime) Integer
```

**Description:**

The <span class="id">AgeAt</span> operators calculate the age of the patient as of a given date and in the precision named in the operator.

If the patient’s birthdate is <span class="kw">null</span>, or the <span class="id">asOf</span> argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The <span class="id">AgeAt</span> operators are defined in terms of a datetime duration calculation. This means that if the age of the patient or the given <span class="id">asOf</span> value are not specified to the level of precision corresponding to the operator being invoked, the will be an _uncertainty_ over the range of possible values, potentially causing some comparisons to return <span class="kw">null</span>.

These operators are shorthand for the equivalent CalculateAgeInXXXAt operator, passing the birth date from the Patient context.

#### CalculateAge

**Signature:**

```cql
CalculateAgeInYears(birthDate Date) Integer
CalculateAgeInYears(birthDate DateTime) Integer
CalculateAgeInMonths(birthDate Date) Integer
CalculateAgeInMonths(birthDate DateTime) Integer
CalculateAgeInWeeks(birthDate Date) Integer
CalculateAgeInWeeks(birthDate DateTime) Integer
CalculateAgeInDays(birthDate Date) Integer
CalculateAgeInDays(birthDate DateTime) Integer
CalculateAgeInHours(birthDate DateTime) Integer
CalculateAgeInMinutes(birthDate DateTime) Integer
CalculateAgeInSeconds(birthDate DateTime) Integer
```

**Description:**

The <span class="id">CalculateAge</span> operators calculate the age of a person born on the given birth date, as of the current date, and in the precision named in the operator.

If the birthdate is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The <span class="id">CalculateAge</span> operators are defined in terms of a datetime duration calculation. This means that if the given <span class="id">birthDate</span> is not specified to the level of precision corresponding to the operator being invoked, the result will be an _uncertainty_ over the range of possible values, potentially causing some comparisons to return <span class="kw">null</span>.

These operators are shorthand for the equivalent CalculateAgeInXXXAt, passing the current date for the asOf argument.

#### CalculateAgeAt

**Signature:**

```cql
CalculateAgeInYearsAt(birthDate Date, asOf Date) Integer
CalculateAgeInYearsAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInMonthsAt(birthDate Date, asOf Date) Integer
CalculateAgeInMonthsAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInWeeksAt(birthDate Date, asOf Date) Integer
CalculateAgeInWeeksAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInDaysAt(birthDate Date, asOf Date) Integer
CalculateAgeInDaysAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInHoursAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInMinutesAt(birthDate DateTime, asOf DateTime) Integer
CalculateAgeInSecondsAt(birthDate DateTime, asOf DateTime) Integer
```

**Description:**

The <span class="id">CalculateAgeAt</span> operators calculate the age of a person born on the given birth date as of the given date, and in the precision named in the operator.

If the <span class="id">birthDate</span> is <span class="kw">null</span> or the <span class="id">asOf</span> argument is <span class="kw">null</span>, the result is <span class="kw">null</span>.

The <span class="id">CalculateAgeAt</span> operators are defined in terms of a datetime duration calculation. This means that if the given <span class="id">birthDate</span> or <span class="id">asOf</span> are not specified to the level of precision corresponding to the operator being invoked, the result will be an _uncertainty_ over the range of possible values, potentially causing some comparisons to return <span class="kw">null</span>.

The following examples illustrate the behavior of the <span class="id">CalculateAgeAt</span> operator:

```cql
define "CalculateAgeAt": CalculateAgeInYearsAt(@2000-01-01, @2015-01-01) // 15
define "CalculateAgeAtIsNull": CalculateAgeInYearsAt(@2000-01-01, null)
```

{: #equal-3}
#### Equal

**Signature:**

```cql
=(left Code, right Code) Boolean
=(left Concept, right Concept) Boolean
```

**Description:**

The _equal_ (<span class="sym">=</span>) operator for Codes and Concepts uses tuple equality semantics. This means that the operator will return <span class="kw">true</span> if and only if the values for each element by name are equal.

If either argument is <span class="kw">null</span>, or has different components specified, the result is <span class="kw">null</span>.

The following examples illustrate the behavior of the _equal_ operator:

```cql
define "Code1": Code { system: 'http://loinc.org', code: '8480-6', version: '1.0', display: 'Systolic blood pressure' }
define "Concept1": Concept { codes: { Code1 }, display: 'Concepts' }
define "Concept2": Concept { codes: { Code1 }, display: 'More Concepts' }
define "EqualIsTrue": Code1 = Code1
define "EqualIsFalse": Concept1 = Concept2
define "EqualIsNull": Code1 = null
```

{: #equivalent-3}
#### Equivalent

**Signature:**

```cql
~(left Code, right Code) Boolean
~(left Concept, right Concept) Boolean
~(left Code, right Concept) Boolean
~(left Concept, right Code) Boolean
```

**Description:**

The _equivalent_ (<span class="sym">~</span>) operator for <span class="id">Code</span> values returns <span class="kw">true</span> if the <span class="id">code</span> and <span class="id">system</span> elements are equivalent. The <span class="id">version</span> and <span class="id">display</span> elements are ignored for the purposes of determining <span class="id">Code</span> equivalence.

For <span class="id">Concept</span> values, equivalence is defined as a non-empty intersection of the codes in each <span class="id">Concept</span> using <span class="id">Code</span> equivalence to determine the intersection. The <span class="id">display</span> element is ignored for the purposes of determining <span class="id">Concept</span> equivalence.

Note that this operator will always return <span class="kw">true</span> or <span class="kw">false</span>, even if either or both of its arguments are <span class="kw">null</span>, or contain <span class="kw">null</span> components. However, <span class="kw">null</span> is not equivalent to an empty list (i.e. an empty concept is not equivalent to a <span class="kw">null</span> concept).

> Note carefully that this notion of _equivalence_ is _not_ the same as the notion of equivalence used in terminology: “these codes represent the same concept.” CQL specifically avoids defining terminological equivalence. The notion of equivalence defined here is used to provide consistent and intuitive semantics when dealing with missing information when determining terminological membership.
{: .note-warning}

The following examples illustrate the behavior of the _equivalent_ operator:

```cql
define "Code1": Code { system: 'http://loinc.org', code: '8480-6', display: 'Systolic blood pressure' }
define "Concept1": Concept { codes: { Code1 }, display: 'Concepts' }
define "Concept2": Concept { codes: { null }, display: 'More Concepts' }
define "EquivalentIsTrue": Code1 ~ Code1
define "EquivalentIsAlsoTrue": Concept2 ~ Concept2
define "EquivalentIsFalse": Concept1 ~ Concept2
```

> Note: Because code declarations in CQL allow the value of the code to be any valid code from the code system, it is possible to define code declarations that use expressions if the code system supports it (_post-coordinated expressions_ in SNOMED, for example). However, using such features of a code system would effectively require a terminology server in order to fully support the capability, and CQL is not prescriptive about such support, and artifacts that make use of these types of features for code equivalence should come with a warning about implementability.
{: .note-warning}

#### Contains (Codesystem)

> The EquivalentContains (`~contains`) operator was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
~contains(codesystem CodeSystem, code String) Boolean
~contains(codesystem CodeSystem, code Code) Boolean
~contains(codesystem CodeSystem, concept Concept) Boolean
~contains(codesystem CodeSystem, codes List<Code>) Boolean
~contains(codesystem CodeSystem, codes List<string>) Boolean
~contains(codesystem CodeSystem, codes List<Concept>) Boolean
```

**Description:**

The <span class="kw">~contains</span> (Codesystem) operators determine whether or not a given code, or any of a list of codes, is in a particular codesystem. Note that these operators can only be invoked by referencing a defined <span class="kw">codesystem</span> or <span class="id">CodeSystem</span>-valued expression.

For the <span class="id">String</span> overload, if the given code system contains a code with an equivalent code element, the result is <span class="kw">true</span>.

For the <span class="id">Code</span> overload, if the given code system contains an equivalent code, the result is <span class="kw">true</span>.

For the <span class="id">Concept</span> overload, if the given code system contains a code equivalent to any code in the given concept, the result is <span class="kw">true</span>.

For the <span class="id">List\<Code></span> overload, if the given code system contains a code equivalent to any code in the given list, the result is <span class="kw">true</span>.

If the <span class="id">code</span> argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

If the <span class="id">code</span> system reference cannot be resolved, a run-time error is thrown.

The following examples illustrate the behavior of the <span class="kw">~contains</span> (Codesystem) operator:

```cql
codesystem "SNOMED:2014": 'http://snomed.info/sct'
define "CodesystemContainsString": "SNOMED:2014" ~contains '12345678'
define "CodesystemContainsCode": "SNOMED:2014" ~contains Code { system: "http://snomed.info/sct", code: '12345678' }
define "CodesystemContainsNullString": "SNOMED:2014" ~contains null as String // false
```

> Note carefully that the use of the string overloads for membership testing in code systems and value sets is potentially problematic and should be used with caution, if at all
{: .note-warning}

#### In (Codesystem)

> The EquivalentIn (`~in`) operator was introduced in CQL 2.0, and has trial-use status. For backwards-compatibility the normative In (`in`) can still be used to test code system membership.
{: .note-info}

**Signature:**

```cql
~in(code String, codesystem CodeSystem) Boolean
~in(code Code, codesystem CodeSystem) Boolean
~in(concept Concept, codesystem CodeSystem) Boolean
~in(codes List<Code>, codesystem CodeSystem) Boolean
~in(codes List<string>, codesystem CodeSystem) Boolean
~in(codes List<Concept>, codesystem CodeSystem) Boolean
```

**Description:**

The <span class="kw">~in</span> (<span class="kw">in</span> in version 1.5) (Codesystem) operators determine whether or not a given code, or any of a list of codes, is in a particular codesystem. Note that these operators can only be invoked by referencing a defined <span class="kw">codesystem</span> or <span class="id">CodeSystem</span>-valued expression.

For the <span class="id">String</span> overload, if the given code system contains a code with an equivalent code element, the result is <span class="kw">true</span>.

For the <span class="id">Code</span> overload, if the given code system contains an equivalent code, the result is <span class="kw">true</span>.

For the <span class="id">Concept</span> overload, if the given code system contains a code equivalent to any code in the given concept, the result is <span class="kw">true</span>.

For the <span class="id">List\<Code></span> overload, if the given code system contains a code equivalent to any code in the given list, the result is <span class="kw">true</span>.

If the <span class="id">code</span> argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

If the <span class="id">code</span> system reference cannot be resolved, a run-time error is thrown.

The following examples illustrate the behavior of the <span class="kw">~in</span> (Codesystem) operator:

```cql
codesystem "SNOMED:2014": 'http://snomed.info/sct'
define "StringInCodesystem": '12345678' ~in "SNOMED:2014"
define "CodeInCodesystem": Code { system: "http://snomed.info/sct", code: '12345678' } ~in "SNOMED:2014"
define "NullStringInCodesystem": null as String ~in "SNOMED:2014" // false
```

> Note carefully that the use of the string overloads for membership testing in code systems and value sets is potentially problematic and should be used with caution, if at all
{: .note-warning}

{: #expandvalueset}
#### ExpandValueSet (ValueSet)

> The ExpandValueSet function was introduced in CQL 1.5, and has trial-use status.
{: .note-info}

**Signature:**
```cql
ExpandValueSet(ValueSet) List<Code>
```

**Description:**

The ExpandValueSet function returns the current expansion for the given value set.

The function expects a single argument of type <span class="id">ValueSet</span>. This may be a static reference to a value set (as shown in the example below), or a <span class="id">ValueSet</span> value to support dynamic value set usage.

The function is used to provide implicit conversion from a <span class="id">ValueSet</span> reference to a <span class="id">List\<Code></span>.

If the argument is null, the result is null.

The following example illustrates use of the ExpandValueSet function:

```cql
valueset "Value Set Reference": 'http://example.org/ValueSet/ExampleValueSet'

define TestExpandValueSet: ExpandValueSet("Value Set Reference")
```

#### Contains (Valueset)

> The EquivalentContains (`~contains`) operator was introduced in CQL 2.0, and has trial-use status.
{: .note-info}

**Signature:**

```cql
~contains(valueset ValueSet, code String) Boolean
~contains(valueset ValueSet, code Code) Boolean
~contains(valueset ValueSet, concept Concept) Boolean
~contains(valueset ValueSet, codes List<Code>) Boolean
~contains(valueset ValueSet, codes List<string>) Boolean
~contains(valueset ValueSet, codes List<Concept>) Boolean
```

**Description:**

The <span class="kw">~contains</span> (Valueset) operators determine whether or not a given code, or any of a list of codes, is in a particular valueset. Note that these operators can only be invoked by referencing a defined <span class="kw">valueset</span> or <span class="id">ValueSet</span>-valued expression.

For the <span class="id">String</span> overload, if the given valueset contains a code with an equivalent code element, the result is <span class="kw">true</span>. Note that for this overload, because the code being tested cannot specify code system information, if the resolved value set contains codes from multiple code systems, a run-time error is thrown because the operation is ambiguous.

For the <span class="id">Code</span> overload, if the given valueset contains an equivalent code, the result is <span class="kw">true</span>.

For the <span class="id">Concept</span> overload, if the given valueset contains a code equivalent to any code in the given concept, the result is <span class="kw">true</span>.

For the <span class="id">List\<Code></span> overload, if the given valueset contains a code equivalent to any code in the given list, the result is <span class="kw">true</span>.

If the code argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

If the value set reference cannot be resolved, a run-time error is thrown.

The following examples illustrate the behavior of the <span class="kw">~contains</span> (Valueset) operator:

```cql
valueset "Acute Pharyngitis": 'http://acute.pharyngitis/valueset'
define "ValuesetContainsString": "Acute Pharyngitis" ~contains '12345678'
define "ValuesetContainsCode": "Acute Pharyngitis" ~contains Code { system: 'http://snomed.info/sct', code: '12345678' }
define "ValuesetContainsNullString": "Acute Pharyngitis" ~contains null as String // false
```

> Note carefully that the use of the string overloads for membership testing in code systems and value sets is potentially problematic and should be used with caution, if at all
{: .note-warning}

#### In (Valueset)

> The EquivalentIn (`~in`) operator was introduced in CQL 2.0, and has trial-use status. For backwards-compatibility the normative In (`in`) can still be used to test code system membership.
{: .note-info}

**Signature:**

```cql
~in(code String, valueset ValueSet) Boolean
~in(code Code, valueset ValueSet) Boolean
~in(concept Concept, valueset ValueSet) Boolean
~in(codes List<Code>, valueset ValueSet) Boolean
~in(codes List<string>, valueset ValueSet) Boolean
~in(codes List<Concept>, valueset ValueSet) Boolean
```

**Description:**

The <span class="kw">~in</span> (<span class="kw">in</span> in 1.5) (Valueset) operators determine whether or not a given code, or any of a list of codes, is in a particular valueset. Note that these operators can only be invoked by referencing a defined <span class="kw">valueset</span> or <span class="id">ValueSet</span>-valued expression.

For the <span class="id">String</span> overload, if the given valueset contains a code with an equivalent code element, the result is <span class="kw">true</span>. Note that for this overload, because the code being tested cannot specify code system information, if the resolved value set contains codes from multiple code systems, a run-time error is thrown because the operation is ambiguous.

For the <span class="id">Code</span> overload, if the given valueset contains an equivalent code, the result is <span class="kw">true</span>.

For the <span class="id">Concept</span> overload, if the given valueset contains a code equivalent to any code in the given concept, the result is <span class="kw">true</span>.

For the <span class="id">List\<Code></span> overload, if the given valueset contains a code equivalent to any code in the given list, the result is <span class="kw">true</span>.

If the code argument is <span class="kw">null</span>, the result is <span class="kw">false</span>.

If the value set reference cannot be resolved, a run-time error is thrown.

The following examples illustrate the behavior of the <span class="kw">in</span> (Valueset) operator:

```cql
valueset "Acute Pharyngitis": 'http://acute.pharyngitis/valueset'
define "StringInValueset": '12345678' ~in "Acute Pharyngitis"
define "CodeInValueset": Code { system: 'http://snomed.info/sct', code: '12345678' } ~in "Acute Pharyngitis"
define "NullStringInValueset": null as String ~in "Acute Pharyngitis" // false
```

> Note carefully that the use of the string overloads for membership testing in code systems and value sets is potentially problematic and should be used with caution, if at all
{: .note-warning}

### Errors and Messaging

#### Message

**Signature:**

```cql
Message(source T, condition Boolean, code String, severity String, message String) T
```

**Description:**

The <span class="id">Message</span> operator provides a run-time mechanism for returning messages, warnings, traces, and errors to the calling environment.

The source operand can be of any type and the result of the operation is the input source; the operation performs no modifications to input. This allows the message operation to appear at any point in any expression of CQL.

The condition is used to determine whether the message is generated and returned to the calling environment. If condition is true, the message is generated. Otherwise, the operation only returns the results and performs no processing at all.

The code provides a coded representation of the error. Note that this is a token (like a string or integer), not a terminology Code.

The severity determines what level of processing should occur for the message that is generated:

* Trace – The operation produces an informational message that is expected to be made available to a tracing mechanism such as a debug log in the calling environment. In addition, some representation of the contents of the source parameter should be made available to the tracing mechanism.
* Message – The operation produces an informational message that is expected to be made available in some way to the calling environment.
* Warning – The operation produces a warning message that is expected to be made conspicuously available to the calling environment, potentially to the end-user of the logic.
* Error – The operation produces a run-time error and return the message to the calling environment. This is the only severity that stops evaluation. All other severities continue evaluation of the expression.

If no severity is supplied, a default severity of Message is assumed.

The message is the content of the actual message that is sent to the calling environment.

> Note that for Trace severity, the implementation should output the contents of the source parameter as part of the trace message. Because the logic may be operating on patient information, the utmost care should be taken to ensure that appropriate safeguards are in place to avoid logging sensitive information. At a minimum, all PHI should be redacted from these trace messages.
{: .note-danger}

The following examples illustrate the behavior of the <span class="id">Message</span> operator:

```cql
parameter Numerator Integer default 1
parameter Denominator Integer default 0
define "ErrorMessage": Message('Divide by zero error!', Denominator = 0, 'Undefined', 'Error', 'The Denominator parameter is zero')
```
