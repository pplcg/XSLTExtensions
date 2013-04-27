<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 1                                 -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/FOPRunXSLTExt        -->
<!--                                                               -->
<!-- Requires Saxon 9.4 or later and FOP 1.0                       -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:runfop="http://org.w3c.ppl.xslt/saxon-extension"
    exclude-result-prefixes="xs runfop">

<!-- Common templates for formatting FOPRunXSLTExt examples -->
<xsl:import href="formatting.xsl" />

<!-- Where to write the output files. -->
<xsl:param name="dest_dir" select="out" as="xs:string"/>
<xsl:param name="area_tree_filename" />

<!-- Initial template -->
<xsl:template name="main">
  <!-- Save the FO tree in a variable. -->
  <xsl:variable name="fo_tree">
    <xsl:apply-templates select="/" />
  </xsl:variable>

  <xsl:variable name="area_tree_file"
		select="concat($dest_dir, '/', $area_tree_filename)" />

  <xsl:message>Area tree filename = <xsl:value-of select="$area_tree_file" /></xsl:message>

  <url>
    <xsl:value-of select="runfop:area-tree-url($fo_tree, $area_tree_file)"/>
  </url>

</xsl:template>

</xsl:stylesheet>