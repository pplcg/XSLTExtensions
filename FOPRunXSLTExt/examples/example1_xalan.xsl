<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Xalan example 1                                 -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/FOPRunXSLTExt        -->
<!--                                                               -->
<!-- Requires Xalan 2.7 or later and FOP 1.0                       -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:ppl="http://www.w3.org/community/ppl/ns/"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="ppl">

<xsl:import href="ppl-extensions.xsl" />

<xsl:param name="dest_dir" />
<xsl:param name="area_tree_filename" />

<xsl:variable name="area_tree_file"
	      select="concat($dest_dir, '/', $area_tree_filename)" />

<xsl:template match="/">
  <!-- Make FO from source document. -->
  <xsl:variable name="foTree">
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

  <xsl:call-template name="ppl:area-tree">
    <xsl:with-param name="fo-tree" select="$foTree"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="header">
  <fo:block font-size="14pt" font-family="verdana" color="red"
	    space-before="5mm" space-after="5mm">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="paragraph">
  <fo:block text-indent="5mm" font-family="verdana" font-size="12pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>