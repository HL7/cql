
The examples provided here illustrate the use of Clinical Quality Language to express the logic involved in decision support and quality measurement artifacts. The examples are intended for educational and demonstration purposes only and should not be considered endorsed or production ready.

### Chlamydia Screening Examples

These examples illustrate the logic for coordinated decision support and quality measurement artifacts expressed in CQL, as developed in the Author's Guide. The first set illustrates independent logic, and the second set illustrates the same artifacts using a common library to share logic.

#### Independent Artifacts

##### Chlamydia Screening Quality Measure

* [CQL](examples\ChlamydiaScreeningCQM.cql)
* [ELM (XML)](examples\ChlamydiaScreeningCQM.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCQM.json)

##### Chlamydia Screening Decision Support

* [CQL](examples\ChlamydiaScreeningCDS.cql)
* [ELM (XML)](examples\ChlamydiaScreeningCDS.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCDS.json)

ELM Artifacts with Annotations Included:
  
* [ELM (XML)](examples\ChlamydiaScreeningCDSAnnotated.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCDSAnnotated.json)

ELM Artifacts with Debug Information Included:

* [ELM (XML)](examples\ChlamydiaScreeningCDSDebug.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCDSDebug.json)

#### Shared Logic

##### Common Library

* [CQL](examples\ChlamydiaScreeningCommon.cql)
* [ELM (XML)](examples\ChlamydiaScreeningCommon.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCommon.json)

##### Chlamydia Screening Quality Measure Using Common Library

* [CQL](examples\ChlamydiaScreeningCQMUsingCommon.cql)
* [ELM (XML)](examples\ChlamydiaScreeningCQMUsingCommon.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCQMUsingCommon.json)

##### Chlamydia Screening Decision Support Using Common Library

* [CQL](examples\ChlamydiaScreeningCDSUsingCommon.cql)
* [ELM (XML)](examples\ChlamydiaScreeningCDSUsingCommon.xml)
* [ELM (JSON)](examples\ChlamydiaScreeningCDSUsingCommon.json)

### Example Quality Measures

These examples illustrate various quality measures expressed in CQL.

#### CMS26v2

* [CQL](examples\CMS26v2CQM.cql)
* [ELM (XML)](examples\CMS26v2CQM.xml)
* [ELM (JSON)](examples\CMS26v2CQM.json)

#### CMS55v1

Using QUICK:
  
* [CQL](examples\CMS55v1NQF0495.cql)
* [ELM (XML)](examples\CMS55v1NQF0495.xml)
* [ELM (JSON)](examples\CMS55v1NQF0495.json)

Using QDM:
  
* [CQL](examples\CMS55v1QDM.cql)
* [ELM (XML)](examples\CMS55v1QDM.xml)

#### CMS135

* [CQL](examples\CMS135QDM.cql)
* [ELM (XML)](examples\CMS135QDM.xml)
* [ELM (JSON)](examples\CMS135QDM.json)

#### CMS146v2

Using QUICK:
  
* [CQL](examples\CMS146v2CQM.cql)
* [ELM (XML)](examples\CMS146v2CQM.xml)
* [ELM (JSON)](examples\CMS146v2CQM.json)

Using QDM:
  
* [CQL](examples\CMS146v2QDM.cql)
* [ELM (XML)](examples\CMS146v2QDM.xml)
* [ELM (JSON)](examples\CMS146v2QDM.json)

#### CMS154v1

* [CQL](examples\CMS154v1NQF0069.cql)
* [ELM (XML)](examples\CMS154v1NQF0069.xml)
* [ELM (JSON)](examples\CMS154v1NQF0069.json)

#### CMS179v2

Using QUICK:

* [CQL](examples\CMS179v2CQM.cql)
* [ELM (XML)](examples\CMS179v2CQM.xml)
* [ELM (JSON)](examples\CMS179v2CQM.json)
  
Using QDM:
  
* [CQL](examples\CMS179v2QDM.cql)
* [ELM (XML)](examples\CMS179v2QDM.xml)
* [ELM (JSON)](examples\CMS179v2QDM.json)
  
#### Mother Infant Measure

This example illustrates the use of related-context retrieves to access the
mother's record from a measure focused on an infant.

* [CQL](examples\Example.RelatedContextRetrieve-0.1.0.cql)
* [ELM (XML)](examples\Example.RelatedContextRetrieve-0.1.0.xml)
* [ELM (JSON)](examples\Example.RelatedContextRetrieve-0.1.0.json)
