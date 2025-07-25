
Unit tests for Clinical Quality Language functionality are maintained as part of a test suite alongside tooling and reference implementations in the following repository:

[CQL Tests](https://github.com/cqframework/cql-tests)

These tests were initially published as part of the specification with the intent to informatively demonstrate exhaustive behavior of the specification. Since December of 2023, as part of the [Digital Quality Implementers Community](https://www.ncqa.org/digital-quality-implementers-community/), these tests have been the focus of an industry-wide effort to demonstrate consistency of CQL engines by providing a test runner as well as a forum for testing and discussion of results.

The test runner is a simple Node application that makes use of the Using CQL With FHIR implementation guide's $cql operation to support evaluating the tests against any engine that surfaces functionality as a CQL Evaluation Service:

[CQL Tests Runner](https://github.com/cqframework/cql-tests-runner)

The tests are expressed in a simple XML format describing the expression and its expected outcome.

Some tests cover functionality related to calculation and string representation of times, and are built to be run with an _evaluation request timestamp_ in UTC, to avoid introducing any location dependence to the tests.

Note that this is the same test format used by the FHIRPath specification.

The tests cover the following sections of the specification:

* Aggregate Functions
* Aggregate Operator
* Arithmetic Functions
* Comparison Operators
* Conditional Operators
* Date/Time Operators
* Errors And Messaging Operators
* Interval Operators
* List Operators
* Logical Operators
* Nullological Operators
* String Operators
* Type Operators
* Types
* Value Literals and Selectors

> The tests defined here are informative, not normative aspects of the specification. If there is a discrepancy between the behavior of a test and the specification, the specification should be considered the source of truth.
{: .note-info}