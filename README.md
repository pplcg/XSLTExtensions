# XSLTExtensions

This is an experiment by the Print & Page Layout Community Group (PPLCG) in getting the area tree from an XSL formatter run as the result of calling an XSLT extension function in the same XSLT transform as will produce the "final" FO tree to be output for formatting as human readable pages.

Examples and usage instructions are available at https://www.w3.org/community/ppl/wiki/XSLTExtensions.

This was initially developed in Java by Arved Sandstrom of MagicLamp Software following discussion on the public-ppl@w3.org mailing list. Other XSLT–XSL-FO combinations in Java and DotNet have followed. Further development now happens here at https://github.com/pplcg/XSLTExtensions, with questions and comments happening on the public-ppl@w3.org mailing list.

The extension is available for Java and DotNet and uses either the Apache FOP XSL formatter or Antenna House Formatter (AH Formatter) to produce the area trees.


The single Java jar file covers four combinations of XSLT processor and XSL-FO formatter:

- Saxon 9.5 (and later) and FOP 2.0
- Saxon 9.5 (and later) and AH Formatter
- Xalan and FOP (possibly out-of-date)
- Xalan and AH Formatter (possibly out-of-date)

The DotNet version supports:

- DotNet 4.0 and FOP
- DotNet 4.0 and AH Formatter

Contributions of code for more combinations are more than welcome. 
