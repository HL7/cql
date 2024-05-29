# Clinical Quality Language (CQL)
:page-layout: dev
:backend: xhtml
:page-standards-status: normative

*HL7 Standard: Clinical Quality Language Specification, Release 1 Mixed Normative/Trial-Use (CQL 1.5)*

*HL7 Mixed Normative/STU Specification*

Clinical Quality Language (CQL) is a high-level, domain-specific language focused on clinical quality and targeted at measure and decision support artifact authors.

In addition, this specification describes a machine-readable canonical representation called Expression Logical Model (ELM) targeted at implementations and designed to enable sharing of clinical knowledge.

image:dist/ansi-approved.gif[]

|===
|Formal Name: |HL7 Cross-Paradigm Specification: Clinical Quality Language, Release 1
|ANSI Designation: |ANSI/HL7 CQLANG, R1-2020
|Date of Approval: |2020-12-01
|===

CQL is an ANSI Normative Standard. ANSI has certificated that the portions of this specification marked Normative have met its requirements for development of a formal standard.

> This specification is normative, except where identified as informative or trial-use content.
>
> For a complete description of the changes to this version, please review the version history linked below.
{: .note-info}

|===
|[Title Page](title.html) |[License](license.html) |http://cql.hl7.org/history.html[Version History] |[Executive Summary](00-executivesummary.html)
|===

## Getting Started

Welcome to the HL7 Clinical Quality Language (CQL) specification!

CQL has matured into a capable and flexible specification for representing clinically-focused logic, and is being used in a broad variety of applications from cohort definition and quality measurement, to clinical decision and cognitive support, computable guidelines, and public health reporting. See the [Examples](examples.html) page for examples of these various usages, and be sure to visit the [Reference Implementations](10-c-referenceimplementations.html) page for a description of the available tooling and resources, as well as a link to community projects.

To join the active and growing community of CQL authors and implementers, subscribe to the [CQL stream](https://chat.fhir.org/#narrow/stream/179220-cql) on the FHIR Zulip. As with any HL7 specification, we welcome continued feedback and are constantly striving to improve. If you have comments or suggestions, or even just notice a typo, please let us know by submitting an issue via the [HL7 JIRA](http://jira.hl7.org), just set the "Project" to FHIR and the "Specification" to "Clinical Quality Language" in the issue you submit.

## Organization of this Specification

The organization of this specification follows the outline of the perspectives discussed in the Approach section—conceptual, logical, and physical. Below is a listing of the chapters with a short summary of the content of each.

[Chapter 1, role="anchor"](01-introduction.html) – Introduction provides introductory and background material for the specification.

[Chapter 2](02-authorsguide.html) – Author’s Guide provides a high-level discussion of the Clinical Quality Language syntax. This discussion is a self-contained introduction to the language targeted at clinical quality authors.

[Chapter 3](03-developersguide.html) – Developer’s Guide provides a more in-depth look at the Clinical Quality Language targeted at developers familiar with typical development languages such as Java, C#, and SQL.

[Chapter 4](04-logicalspecification.html) – Logical Specification provides a complete description of the elements that can be used to represent quality logic. Note that Chapters 2 and 3 describe the same functional capabilities of the language, and that anything that can be expressed in one mechanism can be equivalently expressed in the other.

[Chapter 5](05-languagesemantics.html) – Language Semantics describes the intended semantics of the language, covering topics such as data layer integration and expected run-time behavior.

[Chapter 6](06-translationsemantics.html) – Translation Semantics describes the mapping between CQL and ELM, as well as outlines for how to perform translation from CQL to ELM, and vice versa.

[Chapter 7](07-physicalrepresentation.html) – Physical Representation is reference documentation for the XML schema used to persist ELM.

[Appendix A](08-a-cqlsyntax.html) – CQL Syntax Formal Specification discusses the ANTLR4 grammar for the Clinical Quality Language.

[Appendix B](09-b-cqlreference.html) – CQL Reference provides a complete reference for the types and operators available in CQL, and is intended to be used by authors and developers alike.

[Appendix C](10-c-referenceimplementations.html) – Reference Implementations provides information about where to find reference implementations for a CQL-ELM translator, a CQL Execution Framework for JavaScript, and other related tooling.

[Appendix D](11-d-references.html) – References

[Appendix E](12-e-acronyms.html) – Acronyms

[Appendix F](13-f-glossary.html) – Glossary

[Appendix G](14-g-formattingconventions.html) – Conventions

[Appendix H](15-h-timeintervalcalculations.html) – Timing Interval Calculation Examples

[Appendix I](16-i-fhirpathtranslation.html) – FHIRPath Function Translation

[Appendix J](17-j-listoftables.html) – List Of Tables

[Appendix K](18-k-listoffigures.html) – List Of Figures

[Appendix L](19-l-cqlsyntaxdiagrams.html) - CQL Syntax Diagrams
