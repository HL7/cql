
This page contains the http://www.antlr.org/[Antlr 4.0] grammar for Clinical Quality Language.

For a visual representation of the syntax of CQL, refer to [Appendix L - CQL Syntax Diagrams](19-l-cqlsyntaxdiagrams.html).

{: #cql}
[Raw CQL grammar](cql/cql.g4)

```antlr4
{% include_relative cql/cql.g4 %}
```

> NOTE: CQL extends from the FHIRPath grammar, and so uses the core production rules defined there. The FHIRPath grammar is included here for reference only, the FHIRPath grammar below is part of the FHIRPath specification.
{: .note-info}

{: #fhirpath}
[Raw FHIRPath grammar,id=fhirpath](cql/fhirpath.g4)

```antlr4
{% include_relative cql/fhirpath.g4 %}
```
