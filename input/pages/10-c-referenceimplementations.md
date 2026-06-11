
As part of the Clinical Quality Framework effort, reference implementations of a CQL-to-ELM translator, a native ELM execution engine, and other CQL-related tools are maintained. This appendix provides a brief overview of where to find more information on these reference implementations.

### CQL-ELM Translator Reference Implementation

The CQL-to-ELM Translator is a reference implementation for the translation of text-based CQL library documents into an XML or JSON representation using the ELM. In addition to being developed and used as part of CQF pilots, the translator has been integrated into production authoring environments for both Clinical Decision Support and Clinical Quality Measurement. The implementation can also be used as the first step in a process to enable distribution, translation, execution, and integration of CQL-based quality artifacts.

The CQL-to-ELM Translator is licensed under the open source [Apache Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) license, and available as part of the clinical_quality_language project on GitHub: https://github.com/cqframework/clinical_quality_language, as well as a [Maven Package](https://search.maven.org/search?q=g:org.cqframework).

### CQL Execution Framework Reference Implementation

A reference implementation for executing CQL is available in JavaScript. In addition to being used in multiple CQF pilots and connectathon testing initiatives, this reference implementation has been integrated into production dQM authoring and testing tools.

The CQL execution framework is licensed under the open source Apache Version 2.0 license, and available on GitHub: https://github.com/cqframework/cql-execution.

### Other CQL-related Tools

Other CQL-related tools including [CQL Language Support for for Visual Studio Code](https://github.com/cqframework/vscode-cql) are also available. The Clinical Quality Framework Initiative maintains a list of known Community Projects tooling and content projects on the CQL Github Wiki:

https://github.com/cqframework/clinical_quality_language/wiki/Community-Projects

#### CQL-to-ELM Translator and Engine (in Kotlin, targeting Kotlin Multi-platform (KMP))

* https://github.com/cqframework/clinical_quality_language: CQL-to-ELM Translator

#### JavaScript Execution Engine

* https://github.com/cqframework/cql-execution: Java-Script Execution Engine
* https://github.com/cqframework/cql-exec-fhir: A FHIR data source provider for the CQL Execution framework
* https://github.com/cqframework/cql-exec-vsac: A VSAC-enabled value set provider for the CQL Execution framework
* https://github.com/cqframework/cql-exec-examples: Simple examples demonstrating how to use cql-execution, cql-exec-fhir, and cql-exec-vsac

#### CQL Translation Service

* https://github.com/cqframework/cql-translation-service: RESTful service for translating CQL to ELM

#### CQL Studio

* [https://cqlstudio.com/](https://cqlstudio.com/): Integrated Development Environment for CQL-based knowledge artifact development
* [https://studio.quality.hl7.org/](https://studio.quality.hl7.org/): HL7 Foundry entry for CQL Studio

#### VSCode Plugin

* [https://github.com/cqframework/vscode-cql](https://github.com/cqframework/vscode-cql)

#### CDS Connect

* https://cds.ahrq.gov/: Repository of CDS including CQL-based artifacts
* https://cds.ahrq.gov/authoring/: CDS Authoring Tool capable of exporting FHIR-based CQL logic
* https://github.com/AHRQ-CDS/AHRQ-CDS-Connect-Authoring-Tool: CDS Authoring Tool Source Code

#### CQL Testing

* https://github.com/AHRQ-CDS/CQL-Testing-Framework

#### CQL Server-side Functionality

* https://github.com/samply/blaze: A FHIR® server with internal, fast CQL Evaluation Engine
* https://github.com/dbcg/cqf-ruler: HAPI FHIR server plugin to enable CQL evaluation and Clinical Reasoning functionality
* https://github.com/PheMA/cql-on-omop: Translates CQL (ELM) to OMOP for evaluation against an OHDSI repository

#### CQL Tooling

* https://github.com/cqframework/cqf-tooling: Tooling to support CQL library tooling and other handy utilities related to CQL-based FHIR content

### Shared Content

Because of the flexibility and broad applicability of CQL, it necessarily covers a breadth of topics. The Clinical Quality Framework Initiative provides recommendations, guidance, and resources to ensure consistent and appropriate use of CQL in the following wiki, including Cooking with CQL examples:

* https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Formatting-and-Usage-Topics

#### Common Libraries

As adoption and use of Clinical Quality Language continues to grow, especially as a mechansim for expressing computable logic in FHIR applications, patterns and practices have emerged and been standardized in the following FHIR implementation guides:

* [Using CQL With FHIR](https://hl7.org/fhir/uv/cql) - Latest version of FHIRHelpers, FHIR-ModelInfo, FHIRCommon, and FHIR-based authoring guidance
* [CQL US Common](https://hl7.org/fhir/us/cql) - USCoreCommon, USCoreElements, and US-specific authoring patterns

In addition, the CQFramework initiative maintains a list of known community content projects at the following location:

https://github.com/cqframework/clinical_quality_language/wiki/Community-Projects#content
