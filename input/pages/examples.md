{% include styles.html %}

The examples provided here illustrate the use of Clinical Quality Language to express the logic involved in decision support and quality measurement artifacts. The examples are intended for educational and demonstration purposes only and should not be considered endorsed or production ready.

### Chlamydia Screening Examples

These examples illustrate the logic for coordinated decision support and quality measurement artifacts expressed in CQL, as developed in the Author's Guide. The first set illustrates independent logic, and the second set illustrates the same artifacts using a common library to share logic.

#### Independent Artifacts

##### Chlamydia Screening Quality Measure

* [CQL](examples\ChlamydiaScreening_CQM.cql)
* [ELM (XML)](examples\ChlamydiaScreening_CQM.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CQM.json)

##### Chlamydia Screening Decision Support

* [CQL](examples\ChlamydiaScreening_CDS.cql)
* [ELM (XML)](examples\ChlamydiaScreening_CDS.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CDS.json)

ELM Artifacts with Annotations Included:
  
* [ELM (XML)](examples\ChlamydiaScreening_CDS_Annotated.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CDS_Annotated.json)

ELM Artifacts with Debug Information Included:

* [ELM (XML)](examples\ChlamydiaScreening_CDS_Debug.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CDS_Debug.json)

#### Shared Logic

##### Common Library

* [CQL](examples\ChlamydiaScreening_Common.cql)
* [ELM (XML)](examples\ChlamydiaScreening_Common.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_Common.json)

##### Chlamydia Screening Quality Measure Using Common Library

* [CQL](examples\ChlamydiaScreening_CQM_UsingCommon.cql)
* [ELM (XML)](examples\ChlamydiaScreening_CQM_UsingCommon.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CQM_UsingCommon.json)

##### Chlamydia Screening Decision Support Using Common Library

* [CQL](examples\ChlamydiaScreening_CDS_UsingCommon.cql)
* [ELM (XML)](examples\ChlamydiaScreening_CDS_UsingCommon.xml)
* [ELM (JSON)](examples\ChlamydiaScreening_CDS_UsingCommon.json)

### Example Quality Measures

These examples illustrate various quality measures expressed in CQL.

#### CMS26v2

* [CQL](examples\CMS26v2_CQM.cql)
* [ELM (XML)](examples\CMS26v2_CQM.xml)
* [ELM (JSON)](examples\CMS26v2_CQM.json)

#### CMS55v1

Using QUICK:
  
* [CQL](examples\CMS55v1_NQF0495.cql)
* [ELM (XML)](examples\CMS55v1_NQF0495.xml)
* [ELM (JSON)](examples\CMS55v1_NQF0495.json)

Using QDM:
  
* [CQL](examples\CMS55v1_QDM.cql)
* [ELM (XML)](examples\CMS55v1_QDM.xml)
//* [ELM (JSON)](examples\CMS55v1_QDM.json)

#### CMS135

* [CQL](examples\CMS135_QDM.cql)
* [ELM (XML)](examples\CMS135_QDM.xml)
* [ELM (JSON)](examples\CMS135_QDM.json)

#### CMS146v2

Using QUICK:
  
* [CQL](examples\CMS146v2_CQM.cql)
* [ELM (XML)](examples\CMS146v2_CQM.xml)
* [ELM (JSON)](examples\CMS146v2_CQM.json)

Using QDM:
  
* [CQL](examples\CMS146v2_QDM.cql)
* [ELM (XML)](examples\CMS146v2_QDM.xml)
* [ELM (JSON)](examples\CMS146v2_QDM.json)

#### CMS154v1

* [CQL](examples\CMS154v1_NQF0069.cql)
* [ELM (XML)](examples\CMS154v1_NQF0069.xml)
* [ELM (JSON)](examples\CMS154v1_NQF0069.json)

#### CMS179v2

Using QUICK:

* [CQL](examples\CMS179v2_CQM.cql)
* [ELM (XML)](examples\CMS179v2_CQM.xml)
* [ELM (JSON)](examples\CMS179v2_CQM.json)
  
Using QDM:
  
* [CQL](examples\CMS179v2_QDM.cql)
* [ELM (XML)](examples\CMS179v2_QDM.xml)
* [ELM (JSON)](examples\CMS179v2_QDM.json)
  
#### Mother Infant Measure

This example illustrates the use of related-context retrieves to access the
mother's record from a measure focused on an infant.

* [CQL](examples\Example.RelatedContextRetrieve-0.1.0.cql)
* [ELM (XML)](examples\Example.RelatedContextRetrieve-0.1.0.xml)
* [ELM (JSON)](examples\Example.RelatedContextRetrieve-0.1.0.json)
