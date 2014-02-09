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
    xmlns:se="http://org.w3c.ppl.xslt/saxon-extension"
    xmlns:runfop="runfop"
    xmlns:runahf="runahf"
    xmlns:ahf="http://www.antennahouse.com/names/XSL/AreaTree"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ppl se ahf xalan runahf runfop xs">

<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- Blocks in area tree.  Different formatters have different
     representatioons in area tree. -->
<!-- FOP -->
<xsl:key name="blocks"
	 match="block[@prod-id]"
	 use="@prod-id" />
<!-- Antenna House -->
<xsl:key name="blocks"
	 match="ahf:BlockViewportArea[@id]"
	 use="@id" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Formatter to run.  Used when selecting which extension function
     to run. -->
<!-- Seems that you can't use namespaced parameters on the Xalan
     command line, otherwise could have been ppl:formatter. -->
<xsl:param name="ppl-formatter" select="'fop'" />


<!-- ============================================================= -->
<!-- XALAN EXTENSION FUNCTION DEFINITIONS                          -->
<!-- ============================================================= -->

<xalan:component prefix="runfop" functions="areaTree" elements="">
  <xalan:script lang="javaclass"
		src="xalan://org.w3c.ppl.xslt.ext.fop.xalan" />
</xalan:component>

<xalan:component prefix="runahf" functions="areaTree" elements="">
  <xalan:script lang="javaclass"
		src="xalan://org.w3c.ppl.xslt.ext.ahf.xalan" />
</xalan:component>


<!-- ============================================================= -->
<!-- XSLT 1.0-COMPATIBLE NAMED TEMPLATE                            -->
<!-- ============================================================= -->

<!-- Named template for use with XSLT 1.0 processors such as
     Xalan. -->
<xsl:template name="ppl:area-tree">
  <xsl:param name="fo-tree"/>

  <xsl:choose>
    <xsl:when test="contains(system-property('xsl:vendor-url'),
		             'xalan-j')">
      <xsl:choose>
	<xsl:when test="$ppl-formatter = 'ahf'">
	  <xsl:copy-of
	      select="runahf:RunAHFXalan.areaTree($fo-tree)"
	      use-when="function-available('runahf:RunAHFXalan.areaTree')" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:copy-of
	      select="runfop:RunFOPXalan.areaTree($fo-tree)"
	      use-when="function-available('runahf:RunFOPXalan.areaTree')" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="system-property('xsl:product-name') = 'SAXON'">
      <xsl:sequence select="se:area-tree($fo-tree)"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- ============================================================= -->
<!-- XSLT 2.0-COMPATIBLE FUNCTIONS                                 -->
<!-- ============================================================= -->

<!-- Function for use with XSLT 2.0 processors such as
     Saxon. -->
<xsl:function name="ppl:area-tree" as="document-node()">
  <xsl:param name="fo-tree" as="node()" />

  <xsl:sequence select="se:area-tree($fo-tree)"/>
</xsl:function>

<xsl:function name="ppl:block" as="node()?">
  <xsl:param name="area-tree" as="document-node()" />
  <xsl:param name="id" as="xs:string" />

  <xsl:sequence select="key('blocks', $id, $area-tree)[1]" />
</xsl:function>

</xsl:stylesheet>