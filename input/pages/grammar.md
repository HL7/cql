= Clinical Quality Language Grammar
:page-layout: dev
:backend: xhtml
:page-standards-status: normative

This page contains the http://www.antlr.org/[Antlr 4.0] grammar for Clinical Quality Language.

For a visual representation of the syntax of CQL, refer to [Appendix L - CQL Syntax Diagrams](19-l-cqlsyntaxdiagrams.html).

[Raw CQL grammar,id=cql](cql/cql.g4)

[source]
----
include::cql/cql.g4[]
----

[.note-info]
____
NOTE: CQL extends from the FHIRPath grammar, and so uses the core production rules defined there. The FHIRPath grammar is included here for reference only, the FHIRPath grammar below is part of the FHIRPath specification.
____

[Raw FHIRPath grammar,id=fhirpath](cql/fhirpath.g4)

[source]
----
include::cql/fhirpath.g4[]
----
