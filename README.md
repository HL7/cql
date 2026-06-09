# CQL

This repository contains the source for the Health Level Seven International Clinical Quality Language (CQL)  Specification. The specification is stewarded by the HL7 [Clinical Decision Support](http://www.hl7.org/Special/committees/dss/index.cfm) (CDS) Work Group with co-sponsorship from the [Clinical Quality Information](https://www.hl7.org/Special/committees/cqi/index.cfm) Work Group. Changes to the specification are made through the [HL7 balloting process](https://confluence.hl7.org/spaces/HL7/pages/19136726/HL7+Balloting).

The specification is published by Health Level Seven International at the following location: http://cql.hl7.org

## Repository Organization

This repository is structured as a standard FHIR implementation guide so that the IGPublisher can be used to build the specification, with some additional content specific to this specification:

- root - IG Publisher content and settings, especially `ig.ini` and publishing scripts
    - input
        - images
            - assets
            - cql - CQL grammar specification, in G4 (Antlr4 grammar specification)
            - elm - ELM model and schema specifications
            - examples - CQL and ELM XML and JSON examples
        - includes
        - pages
        - vocabulary
    - tests

## Web Build

Commits to this repository will trigger the continuous-integration (CI) build, published here:

http://build.fhir.org/ig/HL7/cql/

Build log is available here:

[http://ig-build.fhir.org.s3-website-us-east-1.amazonaws.com/logs/HL7/cql](http://ig-build.fhir.org.s3-website-us-east-1.amazonaws.com/logs/HL7/cql)

Full debugging information is available here:

[http://build.fhir.org/ig/HL7/cql/debug.tgz](http://build.fhir.org/ig/HL7/cql/debug.tgz)

## Local Build

To initially build locally, clone the repository and run the following commands in order below in the root command:

  1. **_updatePublisher[.bat | .sh]** - <i>Process retrieves the current version of the IG publisher and stores it within the input-cache folder. The IG publisher is updated on a regular basis but this process does not have to be executed for every instance of the publication process.</i>

  2. **_genonce[.bat | .sh]** - <i>This initiates the publication process. Launching the .bat file (Windows) or .sh file (Unix/Mac) will launch HL7's IGPublisher program and build/publish the IG one time.</i>

Documentation on how to install and use the FHIR IG publisher is available at [IG Publisher Documentation](https://confluence.hl7.org/spaces/FHIR/pages/35718627/IG+Publisher+Documentation).

