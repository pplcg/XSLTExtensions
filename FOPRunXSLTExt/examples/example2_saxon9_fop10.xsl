<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 2                                 -->
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

<xsl:template match="/">
  <xsl:variable name="fo_tree">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="test-page">
          <fo:region-body margin="1in"/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="test-page">
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="example" />
	</fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:variable>

  <xsl:variable name="area_tree_file"
		select="concat($dest_dir, '/', $area_tree_filename)" />

  <xsl:message>Area tree filename = <xsl:value-of select="$area_tree_file" /></xsl:message>
  <xsl:message select="$fo_tree" />
  <url>
    <xsl:value-of select="runfop:area-tree-url($fo_tree, $area_tree_file)"/>
  </url>

</xsl:template>

</xsl:stylesheet>