> Messages were introduced in CQL 2.0, and are trial-use
{: .note-info}

Index of messages, warnings, or errors that can be raised as part of processing libraries of CQL.

### Characteristics

Messages in Clinical Quality Language have the following characteristics:

* Code: A unique identifier for the message
* Description: A brief description of the issue (this is a static string associated directly with the code)
* Message: The specific message, this may be simply the description, but it is often parameterized with the context for the issue (e.g. unknown identifier X)
* Category: The language area, possible values are codes in the [CQL Message Category Codes](CodeSystem-cql-message-category-codes.html) code system
* Severity: Severity of the issue, possible values are codes in the [CQL Message Severity Codes](CodeSystem-cql-message-severity-codes.html) code system
* Source: The source of the issue, providing information about where the issue is originating and how it might be addressed, possible values are codes in the [CQL Message Source Codes](CodeSystem-cql-message-source-codes.html) code system.

// Severity
Info, Warning, Error, Fatal

// Where the issue is associated
Content, Application, System, Environment

### Messages

Throughout this specification, message codes are documented as follows:

<!-- This comment must appear before each table documenting codes so that editors can maintain the code system whenever new codes are documented in the specification -->
<!-- MESSAGE -->
| Code | Description | Category | Severity | Source | Example Message | Notes |
|----|----|----|----|----|----|----|
| 000-00000 | Compile-Time | Internal translator error | compile-time | error | system | Internal translator error | This message code typically indicates an unexpected error was encountered while attempting to compile CQL. |
| 001-00000 | Lexical | Lexical error | lexical | error | content | Lexical error | This is a general message code for lexical errors encountered while processing CQL. The actual message will typically contain more detailed information about the issue and how to address it. |
| 002-00000 | Syntax | Syntax error | syntax | error | content | Syntax error | This is a general message code for syntax errors encountered while processing CQL. The actual message will typically contain more detailed information about the issue and how to address it. |
| 003-00000 | Semantic | Semantic error | semantic | error | content | Semantic error | This is a general message code for semantic errors encountered while processing CQL. The actual message will typically contain more detailed information about the issue and how to address it. |
| 100-00000 | Run-time | Run-time error | run-time | error | content | Run-time error | This is a general message code for run-time errors encountered while attempting to evaluate CQL. The actual message will typically contain more detailed information about the issue and how to address it. |
{: .grid .table .table-striped}

For a complete index of messages defined in this specification, see the [CQL Message Codes](CodeSystem-cql-message-codes.html) code system.

### Suppressing Messages

Some compile-time messages can be suppressed, as they indicate situations that should be considered, but don't necessarily indicate errors. To suppress a message, authors can use the `@suppressMessage` tag:

```cql
/*
@suppressMessage: 003-10000 - The getList function intentionally returns a choice of Boolean or List
*/
define function getList(list List<Integer>):
  if Count(list) = 0 then
    false
  else
    list
```

The tag has the form:

```
@suppressMessage: <code> [- <reason>]
```

Where `<code>` is the code of the message to be suppressed, and `<reason>` is an optional rationale that authors can provide for suppressing the message. When a message is suppressed, best-practice is to explain the reason for the suppression to ensure that subsequent readers of the logic understand why the message was suppressed.

Note that only information and warning messages can be suppressed.

Also note that if the @suppressMessage tag is used when the message being suppressed is not present, systems should provide a warning that the suppressMessage tag is unnecessary.
