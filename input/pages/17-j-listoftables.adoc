[[appendix-j-list-of-tables]]
= Appendix J - List Of Tables
:page-layout: dev
:backend: xhtml
:sectnums:
:sectanchors:
:toc:
:page-standards-status: informative

[[introduction]]
== Introduction

1.  <<01-introduction.adoc#table-1-a,Table 1-A>> : Relationship of the current specifications to each component

2.  <<01-introduction.adoc#table-1-b,Table 1-B>> : Major roles that this specification was written for

[[authors-guide]]
== Author's Guide

1.  <<02-authorsguide.adoc#table-2-a,Table 2-A>> : Constructs that CQL libraries can contain

2.  <<02-authorsguide.adoc#table-2-b,Table 2-B>> : Elements that define a parameter

3.  <<02-authorsguide.adoc#table-2-c,Table 2-C>> : Typical contexts for CQL

4.  <<02-authorsguide.adoc#table-2-d,Table 2-D>> : Four main clauses for a query construct

5.  <<02-authorsguide.adoc#table-2-e,Table 2-E>> : Types of simple values that CQL supports

6.  <<02-authorsguide.adoc#table-2-f,Table 2-F>> : Elements that make up a [.kw]#code# type

7.  <<02-authorsguide.adoc#table-2-g,Table 2-G>> : Elements that make up a [.kw]#Concept# type

8.  <<02-authorsguide.adoc#table-2-h,Table 2-H>> : The built-in comparison operators that CQL provides

9.  <<02-authorsguide.adoc#table-2-i,Table 2-I>> : Logical operations that CQL provides

10.  <<02-authorsguide.adoc#table-2-j,Table 2-J>> : Arithmetic operations that CQL provides

11.  <<02-authorsguide.adoc#table-2-k,Table 2-K>> : The arguments that the [.kw]#DateTime# operator takes

12.  <<02-authorsguide.adoc#table-2-l,Table 2-L>> : The arguments that the [.kw]#Time# operator takes

13.  <<02-authorsguide.adoc#table-2-m,Table 2-M>> : The operators that CQL supports for retrieving the current date and time

14.  <<02-authorsguide.adoc#table-2-n,Table 2-N>> : The precision-based comparison operators for [.kw]#Date# and [.kw]#Time# comparisons

15.  <<02-authorsguide.adoc#table-2-o,Table 2-O>> : The valid extraction components for extracting [.kw]#Date# and [.kw]#Time# components

16.  <<02-authorsguide.adoc#table-2-p,Table 2-P>> : The ISO8601 calendar semantics that should be used for calculations involving [.kw]#Date# and [.kw]#Time#

17.  <<02-authorsguide.adoc#table-2-q,Table 2-Q>> : Comparison of two interval values using a complete set of operations

18.  <<02-authorsguide.adoc#table-2-r,Table 2-R>> : The operators that can be used to construct timing phrases

19.  <<02-authorsguide.adoc#table-2-s,Table 2-S>> : The operators that can be used for list comparisons

20.  <<02-authorsguide.adoc#table-2-t,Table 2-T>> : The aggregate operators available in CQL

21.  <<02-authorsguide.adoc#table-2-u,Table 2-U>> : The age related operators available in CQL

22.  <<02-authorsguide.adoc#table-2-v,Table 2-V>> : QDM Data elements and their mapping to QUICK data structures

[[developers-guide]]
== Developer's Guide

1.  <<03-developersguide.adoc#table-3-a,Table 3-A>> : The basic lexical elements defined in CQL

2.  <<03-developersguide.adoc#table-3-b,Table 3-B>> : The types of literals supported in CQL

3.  <<03-developersguide.adoc#table-3-c,Table 3-C>> : The escape sequences for string literals in CQL

4.  <<03-developersguide.adoc#table-3-d,Table 3-D>> : The symbols supported by CQL to provide structure to the grammar and allow symbolic invocation of common operators such as addition

5.  <<03-developersguide.adoc#table-3-e,Table 3-E>> : The escape sequences for identifiers in CQL

6.  <<03-developersguide.adoc#table-3-f,Table 3-F>> : The order of operator precedence in CQL

7.  <<03-developersguide.adoc#table-3-g,Table 3-G>> : The primitive types and their ranges supported in CQL

8.  <<03-developersguide.adoc#table-3-h,Table 3-H>> : The structured types to facilitate representation and manipulation of clinical information

9.  <<03-developersguide.adoc#table-3-i,Table 3-I>> : The defined type conversion operators in CQL

10. <<03-developersguide.adoc#table-3-j,Table 3-J>> : The explicit and implicit conversions supported in CQL

[[logical-specification]]
== Logical Specification

[[language-semantics]]
== Language Semantics

1.  <<05-languagesemantics.adoc#table-5-a,Table 5-A>> : Description of the data defined by each retrieve

2.  <<05-languagesemantics.adoc#table-5-b,Table 5-B>> : The structure of clinical data descriptors

3.  <<05-languagesemantics.adoc#table-5-c,Table 5-C>> : The categories of nodes and the process for determining the type of each category

4.  <<05-languagesemantics.adoc#table-5-d,Table 5-D>> : The required properties for a cacheable item

5.  <<05-languagesemantics.adoc#table-5-e,Table 5-E>> : The general categories of nodes and the process of evaluation for each

6.  <<05-languagesemantics.adoc#table-5-f,Table 5-F>> : The operations within the expression language are defined with a scope, and the stack to represent this scope

7.  <<05-languagesemantics.adoc#table-5-g,Table 5-G>> : Definitions for the terms involved in dealing with [.kw]#Date# and [.kw]#Time# values

8.  <<05-languagesemantics.adoc#table-5-h,Table 5-H>> : The components used to represent [.kw]#Date# and [.kw]#Time# values in CQL

9.  <<05-languagesemantics.adoc#table-5-i,Table 5-I>> : The [.kw]#Quantities# and their precision that can be used for [.kw]#Date# and [.kw]#Time# calculations in CQL

[[translation-semantics]]
== Translation Semantics

1.  <<06-translationsemantics.adoc#table-6-a,Table 6-A>> : The ELM equivalent for each CQL declaration

2.  <<06-translationsemantics.adoc#table-6-b,Table 6-B>> : The ELM equivalent for each CQL type-specifier

3.  <<06-translationsemantics.adoc#table-6-c,Table 6-C>> : The ELM equivalent for each CQL Literal

4.  <<06-translationsemantics.adoc#table-6-d,Table 6-D>> : The ELM equivalent for each CQL logical operator

5.  <<06-translationsemantics.adoc#table-6-e,Table 6-E>> : The ELM equivalent for each CQL type operator

6.  <<06-translationsemantics.adoc#table-6-f,Table 6-F>> : The ELM equivalent for each CQL nullological operator

7.  <<06-translationsemantics.adoc#table-6-g,Table 6-G>> : The ELM equivalent for each CQL comparison operator

8.  <<06-translationsemantics.adoc#table-6-h,Table 6-H>> : The ELM equivalent for each CQL arithmetic operator

9.  <<06-translationsemantics.adoc#table-6-i,Table 6-I>> : The ELM equivalent for each CQL [.kw]#String# operator

10.  <<06-translationsemantics.adoc#table-6-j,Table 6-J>> : The ELM equivalent for each CQL [.kw]#Date# and [.kw]#Time# operator

11.  <<06-translationsemantics.adoc#table-6-k,Table 6-K>> : The ELM equivalent for each CQL [.kw]#Interval# operator

12.  <<06-translationsemantics.adoc#table-6-l,Table 6-L>> : The ELM equivalent for each CQL [.kw]#List# operator

13.  <<06-translationsemantics.adoc#table-6-m,Table 6-M>> : The ELM equivalent for each CQL aggegrate operator

14.  <<06-translationsemantics.adoc#table-6-n,Table 6-N>> : The ELM equivalent for each CQL clinical operator

15.  <<06-translationsemantics.adoc#table-6-o,Table 6-O>> : The ELM equivalent for each CQL construct

[[physical-representation]]
== Physical Representation

1.  <<07-physicalrepresentation.adoc#table-7-a,Table 7-A>> : The schemata that defines the ELM physical representation

2.  <<07-physicalrepresentation.adoc#table-7-b,Table 7-B>> : The data model reference required components

3.  <<07-physicalrepresentation.adoc#table-7-c,Table 7-C>> : The required information for each type available in the data model

[[appendix-b-cql-reference]]
== Appendix B - CQL Reference

1.  <<09-b-cqlreference.adoc#table-9-a,Table 9-A>> : The truth table for the [.kw]#And# operator

2.  <<09-b-cqlreference.adoc#table-9-a1,Table 9-A1>> : The truth table for the [.kw]#Implies# operator

3.  <<09-b-cqlreference.adoc#table-9-b,Table 9-B>> : The truth table for the [.kw]#Not# operator

4.  <<09-b-cqlreference.adoc#table-9-c,Table 9-C>> : The truth table for the [.kw]#Or# operator

5.  <<09-b-cqlreference.adoc#table-9-d,Table 9-D>> : The truth table for the [.kw]#Xor# operator

6.  <<09-b-cqlreference.adoc#table-9-e,Table 9-E>> : The conversions supported in CQL

7.  <<09-b-cqlreference.adoc#table-9-f,Table 9-F>> : The string representations that the ToBoolean operator accepts

8.  <<09-b-cqlreference.adoc#table-9-g,Table 9-G>> : The string representations that the ToString operator uses for each data type

[[appendix-e-acronyms]]
== Appendix E - Acronyms

1.  <<12-e-acronyms.adoc#table-12-a,Table 12-A>> : Acronyms used in this specification






































