= Clinical Quality Language (CQL)
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

[.note-info]
____
This specification is normative, except where identified as informative or trial-use content.

For a complete description of the changes to this version, please review the version history linked below.
____

|===
|link:title.html[Title Page] |link:license.html[License] |http://cql.hl7.org/history.html[Version History] |link:00-executivesummary.html[Executive Summary]
|===

[[getting-started]]
== Getting Started

Welcome to the HL7 Clinical Quality Language (CQL) specification!

CQL has matured into a capable and flexible specification for representing clinically-focused logic, and is being used in a broad variety of applications from cohort definition and quality measurement, to clinical decision and cognitive support, computable guidelines, and public health reporting. See the link:examples.html[Examples] page for examples of these various usages, and be sure to visit the link:10-c-referenceimplementations.html[Reference Implementations] page for a description of the available tooling and resources, as well as a link to community projects.

To join the active and growing community of CQL authors and implementers, subscribe to the link:https://chat.fhir.org/#narrow/stream/179220-cql[CQL stream] on the FHIR Zulip. As with any HL7 specification, we welcome continued feedback and are constantly striving to improve. If you have comments or suggestions, or even just notice a typo, please let us know by submitting an issue via the link:http://jira.hl7.org[HL7 JIRA], just set the "Project" to FHIR and the "Specification" to "Clinical Quality Language" in the issue you submit.

[[organization-of-this-specification]]
== Organization of this Specification

The organization of this specification follows the outline of the perspectives discussed in the Approach section—conceptual, logical, and physical. Below is a listing of the chapters with a short summary of the content of each.

link:01-introduction.html[Chapter 1, role="anchor"] – Introduction provides introductory and background material for the specification.

link:02-authorsguide.html[Chapter 2] – Author’s Guide provides a high-level discussion of the Clinical Quality Language syntax. This discussion is a self-contained introduction to the language targeted at clinical quality authors.

link:03-developersguide.html[Chapter 3] – Developer’s Guide provides a more in-depth look at the Clinical Quality Language targeted at developers familiar with typical development languages such as Java, C#, and SQL.

link:04-logicalspecification.html[Chapter 4] – Logical Specification provides a complete description of the elements that can be used to represent quality logic. Note that Chapters 2 and 3 describe the same functional capabilities of the language, and that anything that can be expressed in one mechanism can be equivalently expressed in the other.

link:05-languagesemantics.html[Chapter 5] – Language Semantics describes the intended semantics of the language, covering topics such as data layer integration and expected run-time behavior.

link:06-translationsemantics.html[Chapter 6] – Translation Semantics describes the mapping between CQL and ELM, as well as outlines for how to perform translation from CQL to ELM, and vice versa.

link:07-physicalrepresentation.html[Chapter 7] – Physical Representation is reference documentation for the XML schema used to persist ELM.

link:08-a-cqlsyntax.html[Appendix A] – CQL Syntax Formal Specification discusses the ANTLR4 grammar for the Clinical Quality Language.

link:09-b-cqlreference.html[Appendix B] – CQL Reference provides a complete reference for the types and operators available in CQL, and is intended to be used by authors and developers alike.

link:10-c-referenceimplementations.html[Appendix C] – Reference Implementations provides information about where to find reference implementations for a CQL-ELM translator, a CQL Execution Framework for JavaScript, and other related tooling.

link:11-d-references.html[Appendix D] – References

link:12-e-acronyms.html[Appendix E] – Acronyms

link:13-f-glossary.html[Appendix F] – Glossary

link:14-g-formattingconventions.html[Appendix G] – Conventions

link:15-h-timeintervalcalculations.html[Appendix H] – Timing Interval Calculation Examples

link:16-i-fhirpathtranslation.html[Appendix I] – FHIRPath Function Translation

link:17-j-listoftables.html[Appendix J] – List Of Tables

link:18-k-listoffigures.html[Appendix K] – List Of Figures

link:19-l-cqlsyntaxdiagrams.html[Appendix L] - CQL Syntax Diagrams
