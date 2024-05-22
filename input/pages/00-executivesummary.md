# Executive Summary
:page-layout: dev
:backend: xhtml
:page-standards-status: informative

In support of the United States’ national objectives for healthcare reform, the Office of the National Coordinator for Health Information Technology (ONC) Standards and Interoperability (S&I) Framework has sponsored the development of harmonized interoperability specifications. These specifications are designed to support national health initiatives and healthcare priorities, including Meaningful Use, the Nationwide Health Information Network, and the ongoing mission to improve population health.

The nation is reaching a critical mass of electronic health record systems (EHRs) that comply with data and vocabulary standards. Providers seeking to meaningfully use EHRs face a variety of challenging tasks. Those tasks include assessing needs, selecting and negotiating with a system vendor or reseller, implementing project management, and instituting workflow changes to improve clinical performance, control costs, and ultimately, improve outcomes. Additionally, many providers face the challenge of integration and interoperation with disparate systems. Many institutions use their own proprietary vocabularies and data models. Though this may offer some internal flexibility, it comes with a high, often hidden, long term maintenance cost.

In support of this wide deployment of EHRs, there is an opportunity to implement a learning health system that includes clinical quality measurement and improvement aspects and provides a broad range of benefits that can contribute towards improved health of individuals and the population as a whole (refer to “Digital Infrastructure for the Learning Health System: The Foundation for Continuous Improvement in Health and Health Care: Workshop Series Summary”).

The S&I Framework Clinical Quality Framework Initiative (CQF) is developing a foundational specification, reusing much of the work currently done in health quality standardization, to enable the structuring and encoding of quality content for use as “knowledge artifacts.” These artifacts can be used in support of many areas of the healthcare system, including quality and utilization measurement, disease outbreak detection, comparative effectiveness analysis, evaluation of drug treatment efficacy, monitoring health trends, and other public health, research, and information sharing across the continuum of care. Although the scope of this project focuses on quality knowledge and decision support, potential uses for CQL are not limited to these areas. For example, the CQL grammar can be used to express formal information extraction and transformation rules for converting and deriving data as it is moved from one representation or use to another.

One key benefit of this proposed approach is the definition of a “lingua franca” for the exchange of quality knowledge and artifacts. Rather than having an unscalable network of point-to-point communication channels, each with its own set of transformations, different organizations will only need to transform their content to a CQF-compatible format to communicate effectively with any other point in the network of providers that comprises today’s healthcare system. If the models and vocabularies are rich enough, some quality vendors may opt to use CQF as an internal specification in the future.

This specification is developed in support of the CQF Artifact Sharing Use Case and is intended to assist implementers in the development of clinical quality knowledge artifacts for both the decision support and quality measurement domains. The approach adopted in this specification is designed to be flexible and reusable, and to provide a baseline for health quality vendors and implementers of systems that create and use knowledge artifacts to improve the health of individuals and the population as a whole.
