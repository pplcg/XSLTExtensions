<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- Common templates for formatting FOPRunXSLTExt examples        -->
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
    exclude-result-prefixes="xs">

<xsl:template match="/">
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
</xsl:template>

<xsl:template match="header">
  <fo:block font-size="14pt" font-family="verdana, sans-serif"
	    color="red" space-before="5mm" space-after="5mm">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="paragraph">
  <fo:block id="{@id}" text-indent="5mm"
	    font-family="verdana, sans-serif" font-size="12pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="svg">
  <fo:instream-foreign-object id="{@id}">
    <xsl:copy-of select="document(@href)"/>
  </fo:instream-foreign-object>
</xsl:template>

</xsl:stylesheet>