# Railroad Diagrams for CQL

Content in this folder was generated using the rrantlr4 generator:

https://github.com/bkiers/rrd-antlr4.git

To regenerate content, use the command:

```
java -jar rrd-antlr4-0.1.2.jar cql.g4
```

Note that the CQL grammar file included here has the following modifications:

1. The FHIRPath grammar is included directly, rather than imported to get a full generation
2. The grammar has been rearranged in to smaller chunks so that the generated diagrams are more bite-sized

Consider the following RR diagramming tool:
https://github.com/GuntherRademacher/rr

