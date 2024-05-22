[[appendix-i-fhirpath-function-translation]]
# Appendix I – FHIRPath Function Translation
:page-layout: dev
:backend: xhtml
:sectnums:
:sectanchors:
:toc:
:page-standards-status: normative

This appendix provides detailed mappings for each FHIRPath function in terms of the ELM output produced.

[[aggregate]]
## .aggregate()

[source,cql]
----
X.aggregate(<iteration>, <init>) === Aggregate(<iteration>, <init>)
----

[[abs]]
## .abs()

[source,cql]
----
X.abs() === Abs(X)
----

[[all]]
## .all()

[source,cql]
----
X.all(<condition>) === AllTrue(X $this let a: <condition> where a return a)
----

[[allfalse]]
## .allFalse()

[source,cql]
----
X.allFalse() === AllTrue(X A return not A)
----

[[alltrue-1]]
## .allTrue()

[source,cql]
----
X.allTrue() === AllTrue(X)
----

[[anyfalse]]
## .anyFalse()

[source,cql]
----
X.anyFalse() === AnyTrue(X A return not A)
----

[[anytrue-1]]
## .anyTrue()

[source,cql]
----
X.anyTrue() === AnyTrue(X)
----

[[as]]
## .as()

[source,cql]
----
X.as(T) === X as T
----

Note that the type argument T is expected to be a literal string and must resolve to the name of a type.

[[ceiling]]
## .ceiling()

[source,cql]
----
X.ceiling() === Ceiling(X)
----

[[children-1]]
## .children()

[source,cql]
----
.children(X) === Children(X)
----

[[combine-1]]
## .combine()

[source,cql]
----
X.combine(Y) === Flatten(\{ X, Y })
----

[[conformsto]]
## .conformsTo()

[source,cql]
----
X.conformsTo(Y) === FHIRSupport.ConformsTo(Y)
----

Note that this mapping relies on an external library, FHIRSupport to provide conformance validation checking.

[[contains-2]]
## .contains()

[source,cql]
----
X.contains(Y) === PositionOf(Y, X) >= 0
----

[[convertstoboolean]]
## .convertsToBoolean()

[source,cql]
----
X.convertsToBoolean() === ConvertsToBoolean(X)
----

[[convertstodate]]
## .convertsToDate()

[source,cql]
----
X.convertsToDate() === ConvertsToDate(X)
----

[[convertstodatetime]]
## .convertsToDateTime()

[source,cql]
----
X.convertsToDateTime() === ConvertsToDateTime(X)
----

[[convertstodecimal]]
## .convertsToDecimal()

[source,cql]
----
X.convertsToDecimal() === ConvertsToDecimal(X)
----

[[convertstointeger]]
## .convertsToInteger()

[source,cql]
----
X.convertsToInteger() === ConvertsToInteger(X)
----

[[convertstoquantity]]
## .convertsToQuantity()

[source,cql]
----
X.convertsToQuantity() === ConvertsToQuantity(X)
----

[[convertstotime]]
## .convertsToTime()

[source,cql]
----
X.convertsToTime() === ConvertsToTime(X)
----

[[count-1]]
## .count()

[source,cql]
----
X.count() === Count(X)
----

[[descendents-1]]
## .descendents()

[source,cql]
----
.descendents(X) === Descendents(X)
----

[[distinct-1]]
## .distinct()

[source,cql]
----
X.distinct() === distinct X
----

[[empty]]
## .empty()

[source,cql]
----
X.empty() === not exists X
----

[[endswith-1]]
## .endsWith()

[source,cql]
----
X.endsWith(Y) === EndsWith(X, Y)
----

[[exclude]]
## .exclude()

[source,cql]
----
X.exclude(Y) === X except Y
----

[[exists-1]]
## .exists()

[source,cql]
----
X.exists() === exists X

X.exists(<condition>) === exists (X $this where <condition>)
----

[[exp]]
## .exp()

[source,cql]
----
X.exp() === Exp(X)
----

[[first-1]]
## .first()

[source,cql]
----
X.first() === First(X)
----

[[floor]]
## .floor()

[source,cql]
----
X.floor() === Floor(X)
----

[[hasvalue]]
## .hasValue()

[source,cql]
----
X.hasValue() === X is not null
----

[[iif]]
## .iif()

[source,cql]
----
iif(X, Y) === if X then Y else null

iif(X, Y, Z) === if X then Y else Z
----

[[indexof-1]]
## .indexOf()

[source,cql]
----
X.indexOf(Y) === PositionOf(Y, X) // Note carefully the order of arguments here, it’s the opposite of IndexOf
----

[[intersect]]
## .intersect()

[source,cql]
----
X.intersect(Y) === X intersect Y
----

[[is]]
## .is()

[source,cql]
----
X.is(T) === X is T
----

Note that the argument T is expected to be a literal string and must resolve to the name of a type.

[[isdistinct]]
## .isDistinct()

[source,cql]
----
X.isDistinct() === Count(X) = Count(distinct X)
----

[[last-1]]
## .last()

[source,cql]
----
X.last() === Last(X)
----

[[lastindexof]]
## .lastIndexOf()

[source,cql]
----
X.lastIndexOf(Y) === LastPositionOf(Y, X) // Note carefully the order of arguments here, it’s the opposite of lastIndexOf.
----

[[length-2]]
## .length()

[source,cql]
----
X.length() === Length(X)
----

[[ln]]
## .ln()

[source,cql]
----
X.ln() === Ln(X)
----

[[log]]
## .log()

[source,cql]
----
X.log(B) === Log(X, B)
----

[[lower]]
## .lower()

[source,cql]
----
X.lower() === Lower(X)
----

[[matches-1]]
## .matches()

[source,cql]
----
X.matches(Y) === Matches(X, Y)
----

[[memberof]]
## .memberOf()

[source,cql]
----
X.memberOf(Y) === InValueSet(X, Y) // where Y is required to be a ValueSetRef
----

[[oftype]]
## .ofType()

[source,cql]
----
X.ofType(T) === X $this where $this is T return $this as T
----

Note that the argument T is required to be a literal string, and is interpreted as the name of a type. For non-named-types, type specifier syntax applies.

[[not-1]]
## .not()

[source,cql]
----
X.not() === not X
----

[[now-1]]
## .now()

[source,cql]
----
now() === Now()
----

[[power]]
## .power()

[source,cql]
----
X.power(Y) === Power(X, Y)
----

[[repeat]]
## .repeat()

[source,cql]
----
X.repeat(<element>) === Repeat(X, <element>)
----

The type of X.repeat(<element>) is inferred as the type of:

[source,cql]
----
X.select(<element>).select(<element>)
----

[[replace]]
## .replace()

[source,cql]
----
X.replace(Y, Z) === Replace(X, Y, Z)
----

[[replacematches-1]]
## .replaceMatches()

[source,cql]
----
X.replaceMatches(Y, Z) === ReplaceMatches(X, Y, Z)
----

[[round]]
## .round()

[source,cql]
----
X.round() === Round(X)
X.round(Y) === Round(X, Y)
----

[[select]]
## .select()

If the result type of <element> is not list-valued:

[source,cql]
----
X.select(<element>) === X $this let a: <element> where a is not null return a
----

If the result type of <element> is list-valued:

[source,cql]
----
X.select(<element>) === Flatten(X $this let a: <element> where a is not null return a)
----

[[single]]
## .single()

[source,cql]
----
X.single() === singleton from X
----

[[skip-1]]
## .skip()

[source,cql]
----
X.skip(Y) === Slice(X, Y, null)
----

[[sqrt]]
## .sqrt()

[source,cql]
----
X.sqrt() === Power(X, 0.5)
----

[[startswith-1]]
## .startsWith()

[source,cql]
----
X.startsWith(Y) === StartsWith(X, Y)
----

[[subsetof]]
## .subsetOf()

[source,cql]
----
X.subsetOf(Y) === X included in Y
----

[[substring-1]]
## .substring()

[source,cql]
----
X.substring(Y) === SubString(X, Y)

X.substring(Y, Z) === SubString(X, Y, Z)
----

[[subsumes]]
## .subsumes()

[source,cql]
----
X.subsumes(Y) === Subsumes(X, Y)
----

[[subsumedby]]
## .subsumedBy()

[source,cql]
----
X.subsumedBy(Y) === SubsumedBy(X, Y)
----

[[supersetof]]
## .supersetOf()

[source,cql]
----
X.supersetOf(Y) === X includes Y
----

[[tail-1]]
## .tail()

[source,cql]
----
X.tail() === Slice(X, 1, null)
----

[[take-1]]
## .take()

[source,cql]
----
X.take(Y) === Slice(X, 0, Coalesce(Y, 0))
----

[[timeofday]]
## .timeOfDay()

[source,cql]
----
timeOfDay() === TimeOfDay()
----

[[toboolean-1]]
## .toBoolean()

[source,cql]
----
X.toBoolean() === ToBoolean(X)
----

[[tochars]]
## .toChars()

[source,cql]
----
X.toChars() === ToChars(X)
----

[[todate-1]]
## .toDate()

[source,cql]
----
X.toDate() === ToDate(X)
----

[[todatetime-1]]
## .toDateTime()

[source,cql]
----
X.toDateTime() === ToDateTime(X)
----

[[today-1]]
## .today()

[source,cql]
----
today() === Today()
----

[[todecimal-1]]
## .toDecimal()

[source,cql]
----
X.toDecimal() === ToDecimal(X)
----

[[tointeger-1]]
## .toInteger()

[source,cql]
----
X.toInteger() === ToInteger(X)
----

[[toquantity]]
## .toQuantity()

[source,cql]
----
X.toQuantity() === ToQuantity(X)
----

[[tostring-1]]
## .toString()

[source,cql]
----
X.toString() === ToString(X)
----

[[totime-1]]
## .toTime()

[source,cql]
----
X.toTime() === ToTime(X)
----

[[trace]]
## .trace()

[source,cql]
----
X.trace(Y) === Message(X, true, Y, 'Trace', ToString(X)))
----

[[truncate]]
## .truncate()

[source,cql]
----
X.truncate() === Truncate(X)
----

[[upper]]
## .upper()

[source,cql]
----
X.upper() === Upper(X)
----

[[where]]
## .where()

[source,cql]
----
X.where(<condition>) === X $this where <condition>
----
