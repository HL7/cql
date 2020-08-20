# CQL

This repository contains the source for the Health Level Seven International Clinical Quality Language (CQL)  Specification. The specification is stewarded by the HL7 [Clinical Decision Support](http://www.hl7.org/Special/committees/dss/index.cfm) (CDS) Work Group. Changes to the specification are made through the HL7 balloting process.

The specification is published by Health Level Seven International at the following location: http://cql.hl7.org

## Repository Organization

This repository is structured as follows:

- root - IG Publisher content and settings
    - resources - IG resource
    - spec - Specification content
    - tests - CQL testing suite
    - txCache - IG Publisher terminology cache

The spec folder contains:

- \_layouts - Publishing layouts for the Jekyll build
- cql - CQL grammar
- dist - HTML assets for the publication
- elm - ELM schema and UML
- examples - Specification examples
- extracted-media - images for the specification
- \_config.yml - Configuration file for the publication
- \*.adoc, \*.md, \*.zip - Specification content

## Local Build

The HL7 IG Publisher is committed to this repository to make building as easy as possible. To build locally, clone the repository and issue the following command in the root:

    java -jar "org.hl7.fhir.igpublisher.jar" -ig ig.json

## Web Build

Commits to this repository will trigger the development build, published here:

http://build.fhir.org/ig/HL7/cql/
