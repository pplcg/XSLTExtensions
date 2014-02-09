<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- ppl-extensions.xsl                                            -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/XSLTExtensions       -->
<!--                                                               -->
<!-- Requires Xalan 2.7 or later or Saxon 9.5 or later and         -->
<!-- FOP 1.0 or later or Antenna House AHF 6.1 or later.           -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!--                                                               -->
<!-- License: W3C license                                          -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:ppl="http://www.w3.org/community/ppl/ns/"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:runfop="runfop"
    xmlns:runahf="runahf"
    exclude-result-prefixes="ppl xalan runahf runfop">

<!-- Formatter to run.  Used when selecting which extension function
     to run. -->
<!-- Seems that you can't use namespaced parameters on the Xalan
     command line, otherwise would have been ppl:formatter. -->
<xsl:param name="ppl-formatter" select="'fop'" />

<xalan:component prefix="runfop" functions="areaTree" elements="">
  <xalan:script lang="javaclass"
		src="xalan://org.w3c.ppl.xslt.ext.fop.xalan" />
</xalan:component>

<xalan:component prefix="runahf" functions="areaTree" elements="">
  <xalan:script lang="javaclass"
		src="xalan://org.w3c.ppl.xslt.ext.ahf.xalan" />
</xalan:component>

<xsl:template name="ppl:area-tree">
  <xsl:param name="fo-tree"/>

  <xsl:choose>
    <xsl:when test="$ppl-formatter = 'ahf'">
      <xsl:copy-of select="runahf:RunAHFXalan.areaTree($fo-tree)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="runfop:RunFOPXalan.areaTree($fo-tree)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>