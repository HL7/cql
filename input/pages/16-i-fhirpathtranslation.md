
This appendix provides detailed mappings for each FHIRPath function in terms of the ELM output produced.

In addition to the function mappings below, the <span class="kw">$index</span> accessor can be used within the FHIRPath iteration functions (i.e. FHIRPath functions that take an _expression_ as an argument) to access the 0-based index of the current iteration.

### .aggregate()

```cql
X.aggregate(<iteration>, <init>) === Aggregate(<iteration>, <init>)
```

In addition, the <span class="kw">$total</span> accumulator can be used within the iteration and init expressions to access the current value of the accumulator.

### .abs()

```cql
X.abs() === Abs(X)
```

### .all()

```cql
X.all(<condition>) === AllTrue(X $this let a: <condition> where a return a)
```

### .allFalse()

```cql
X.allFalse() === AllTrue(X A return not A)
```

{: #alltrue-1}
### .allTrue()

```cql
X.allTrue() === AllTrue(X)
```

### .anyFalse()

```cql
X.anyFalse() === AnyTrue(X A return not A)
```

{: #anytrue-1}
### .anyTrue()

```cql
X.anyTrue() === AnyTrue(X)
```

### .as()

```cql
X.as(T) === X as T
```

Note that the type argument T is expected to be a literal string and must resolve to the name of a type.

### .ceiling()

```cql
X.ceiling() === Ceiling(X)
```

{: #children-1}
### .children()

```cql
.children(X) === Children(X)
```

{: #combine-1}
### .combine()

```cql
X.combine(Y) === Flatten(\{ X, Y })
```

### .conformsTo()

```cql
X.conformsTo(Y) === FHIRSupport.ConformsTo(Y)
```

Note that this mapping relies on an external library, FHIRSupport to provide conformance validation checking.

{: #contains-2}
### .contains()

```cql
X.contains(Y) === PositionOf(Y, X) >= 0
```

### .convertsToBoolean()

```cql
X.convertsToBoolean() === ConvertsToBoolean(X)
```

### .convertsToDate()

```cql
X.convertsToDate() === ConvertsToDate(X)
```

### .convertsToDateTime()

```cql
X.convertsToDateTime() === ConvertsToDateTime(X)
```

### .convertsToDecimal()

```cql
X.convertsToDecimal() === ConvertsToDecimal(X)
```

### .convertsToInteger()

```cql
X.convertsToInteger() === ConvertsToInteger(X)
```

### .convertsToQuantity()

```cql
X.convertsToQuantity() === ConvertsToQuantity(X)
```

### .convertsToTime()

```cql
X.convertsToTime() === ConvertsToTime(X)
```

{: #count-1}
### .count()

```cql
X.count() === Count(X)
```

### .dateOf()

```cql
X.dateOf() === date from X
```

### .dayOf()

```cql
X.dayOf() === day from X
```

### .decode()

```cql
X.decode(format) === Decode(X, format)
```

{: #descendants-1}
### .descendants()

```cql
.descendants(X) === Descendants(X)
```

{: #distinct-1}
### .distinct()

```cql
X.distinct() === distinct X
```

### .empty()

```cql
X.empty() === not exists X
```

### .encode()

```cql
X.encode(format) === Encode(X, format)
```

{: #endswith-1}
### .endsWith()

```cql
X.endsWith(Y) === EndsWith(X, Y)
```

### .escape()

```cql
X.escape(target) === Escape(X, target)
```

### .exclude()

```cql
X.exclude(Y) === X except Y
```

{: #exists-1}
### .exists()

```cql
X.exists() === exists X

X.exists(<condition>) === exists (X $this where <condition>)
```

### .exp()

```cql
X.exp() === Exp(X)
```

{: #first-1}
### .first()

```cql
X.first() === First(X)
```

### .floor()

```cql
X.floor() === Floor(X)
```

### .hasValue()

```cql
X.hasValue() === X is not null
```

### .highBoundary()

```cql
X.highBoundary(precision) === HighBoundary(X, precision)
```

### .hourOf()

```cql
X.hourOf() === hour from X
```

### .iif()

```cql
iif(X, Y) === if X then Y else null

iif(X, Y, Z) === if X then Y else Z
```

{: #indexof-1}
### .indexOf()

```cql
X.indexOf(Y) === PositionOf(Y, X) // Note carefully the order of arguments here, it’s the opposite of IndexOf
```

### .intersect()

```cql
X.intersect(Y) === X intersect Y
```

### .is()

```cql
X.is(T) === X is T
```

Note that the argument T is expected to be a literal string and must resolve to the name of a type.

### .isDistinct()

```cql
X.isDistinct() === Count(X) = Count(distinct X)
```

### .join()

```cql
X.join(separator) === Combine(X, separator)
```

{: #last-1}
### .last()

```cql
X.last() === Last(X)
```

### .lastIndexOf()

```cql
X.lastIndexOf(Y) === LastPositionOf(Y, X) // Note carefully the order of arguments here, it’s the opposite of lastIndexOf.
```

{: #length-2}
### .length()

```cql
X.length() === Length(X)
```

### .ln()

```cql
X.ln() === Ln(X)
```

### .log()

```cql
X.log(B) === Log(X, B)
```

### .lowBoundary()

```cql
X.lowBoundary(precision) === LowBoundary(X, precision)
```

### .lower()

```cql
X.lower() === Lower(X)
```

{: #matches-1}
### .matches()

```cql
X.matches(Y) === Matches(X, Y)
```

{: #matchesfull}
### .matchesFull()

```cql
X.matchesFull(Y) === Matches(X, '^' + Y + '$')
```

### .memberOf()

```cql
X.memberOf(Y) === InValueSet(X, Y) // where Y is required to be a ValueSetRef
```

### .millisecondOf()

```cql
X.millisecondOf() === millisecond from X
```

### .minuteOf()

```cql
X.minuteOf() === minute from X
```

### .monthOf()

```cql
X.monthOf() === month from X
```

### .ofType()

```cql
X.ofType(T) === X $this where $this is T return $this as T
```

Note that the argument T is required to be a literal string, and is interpreted as the name of a type. For non-named-types, type specifier syntax applies.

{: #not-1}
### .not()

```cql
X.not() === not X
```

{: #now-1}
### .now()

```cql
now() === Now()
```

### .power()

```cql
X.power(Y) === Power(X, Y)
```

### .precision()

```cql
X.precision() === Precision(X)
```

### .repeat()

```cql
X.repeat(<element>) === Repeat(X, <element>)
```

The type of X.repeat(<element>) is inferred as the type of:

```cql
X.select(<element>).select(<element>)
```

### .replace()

```cql
X.replace(Y, Z) === Replace(X, Y, Z)
```

{: #replacematches-1}
### .replaceMatches()

```cql
X.replaceMatches(Y, Z) === ReplaceMatches(X, Y, Z)
```

### .round()

```cql
X.round() === Round(X)
X.round(Y) === Round(X, Y)
```

### .secondOf()

```cql
X.secondOf() === second from X
```

### .select()

If the result type of <element> is not list-valued:

```cql
X.select(<element>) === X $this let a: <element> where a is not null return a
```

If the result type of <element> is list-valued:

```cql
X.select(<element>) === Flatten(X $this let a: <element> where a is not null return a)
```

### .single()

```cql
X.single() === singleton from X
```

{: #skip-1}
### .skip()

```cql
X.skip(Y) === Slice(X, Y, null)
```

### .split()

```cql
X.split(separator) === Split(X, separator)
```

### .sqrt()

```cql
X.sqrt() === Power(X, 0.5)
```

{: #startswith-1}
### .startsWith()

```cql
X.startsWith(Y) === StartsWith(X, Y)
```

### .subsetOf()

```cql
X.subsetOf(Y) === X included in Y
```

{: #substring-1}
### .substring()

```cql
X.substring(Y) === SubString(X, Y)

X.substring(Y, Z) === SubString(X, Y, Z)
```

### .subsumes()

```cql
X.subsumes(Y) === Subsumes(X, Y)
```

### .subsumedBy()

```cql
X.subsumedBy(Y) === SubsumedBy(X, Y)
```

### .supersetOf()

```cql
X.supersetOf(Y) === X includes Y
```

{: #tail-1}
### .tail()

```cql
X.tail() === Slice(X, 1, null)
```

{: #take-1}
### .take()

```cql
X.take(Y) === Slice(X, 0, Coalesce(Y, 0))
```

### .timeOf()

```cql
X.timeOf() === time from X
```

### .timeOfDay()

```cql
timeOfDay() === TimeOfDay()
```

### .timezoneOffsetOf()

```cql
X.timezoneOffsetOf() === timezoneoffset from X
```

{: #toboolean-1}
### .toBoolean()

```cql
X.toBoolean() === ToBoolean(X)
```

### .toChars()

```cql
X.toChars() === ToChars(X)
```

{: #todate-1}
### .toDate()

```cql
X.toDate() === ToDate(X)
```

{: #todatetime-1}
### .toDateTime()

```cql
X.toDateTime() === ToDateTime(X)
```

{: #today-1}
### .today()

```cql
today() === Today()
```

{: #todecimal-1}
### .toDecimal()

```cql
X.toDecimal() === ToDecimal(X)
```

{: #tointeger-1}
### .toInteger()

```cql
X.toInteger() === ToInteger(X)
```

### .toQuantity()

```cql
X.toQuantity() === ToQuantity(X)
```

{: #tostring-1}
### .toString()

```cql
X.toString() === ToString(X)
```

{: #totime-1}
### .toTime()

```cql
X.toTime() === ToTime(X)
```

### .trace()

```cql
X.trace(Y) === Message(X, true, Y, 'Trace', ToString(X)))
```

### .trim()

```cql
X.trim() === Trim(X)
```

### .truncate()

```cql
X.truncate() === Truncate(X)
```

### .unescape()

```cql
X.unescape(target) === Unescape(X, target)
```

### .union() and |

```cql
X.union(Y) === X union Y
X | Y === X union Y
```

### .upper()

```cql
X.upper() === Upper(X)
```

### .where()

```cql
X.where(<condition>) === X $this where <condition>
```

### .yearOf()

```cql
X.yearOf() === year from X
```
