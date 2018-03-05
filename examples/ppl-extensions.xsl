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
    xmlns:ppli="http://www.w3.org/community/ppl/ns/internal"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:se="http://org.w3c.ppl.xslt/saxon-extension"
    xmlns:runfop="runfop"
    xmlns:runahf="runahf"
    xmlns:runahfdotnet="pi.ep.ppl.xslt.ext.ahf.dotnet"
    xmlns:runfopdotnet="pi.ep.ppl.xslt.ext.fop.dotnet"
    xmlns:ahf="http://www.antennahouse.com/names/XSL/AreaTree"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ppl ppli se ahf xalan runahf runfop runahfdotnet runfopdotnet xs">

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
    <xsl:when test="contains(system-property('xsl:vendor-url'), 'microsoft')">
      <xsl:choose>
        <xsl:when test="$ppl-formatter = 'ahf'">
			<xsl:copy-of select="runahfdotnet:areaTree($fo-tree)" use-when="function-available('runahfdotnet:areatree')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="runfopdotnet:areaTree($fo-tree)" use-when="function-available('runfopdotnet:areatree')"/>
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
<!-- Functions for use with XSLT 2.0 processors such as
     Saxon 9. -->

<xsl:function name="ppl:area-tree" as="document-node()">
  <xsl:param name="fo-tree" as="node()" />

  <xsl:sequence select="se:area-tree($fo-tree)"/>
</xsl:function>

<xsl:function name="ppl:block-by-id" as="element()?">
  <xsl:param name="area-tree" as="document-node()" />
  <xsl:param name="id" as="xs:string" />

  <xsl:sequence select="key('blocks', $id, $area-tree)[1]" />
</xsl:function>

<xsl:function name="ppl:block-bpd" as="xs:double">
  <xsl:param name="block" as="element()" />

  <xsl:sequence
      select="(ppli:fop-length-to-pt($block/block/@bpd),
	       max((ppl:sum-lengths-to-pt($block/ahf:FlowReferenceArea/*/@height),
	            for $column-area in $block/ahf:MultiColumnReferenceArea/ahf:ColumnReferenceArea
		      return ppl:sum-lengths-to-pt($column-area/ahf:FlowReferenceArea/*/@height))))[1]" />
</xsl:function>

<xsl:function name="ppl:block-ipd" as="xs:double">
  <xsl:param name="block" as="element()" />

  <xsl:sequence
      select="(ppli:fop-length-to-pt($block/block/@ipd),
	       max(for $line-area in $block/ahf:FlowReferenceArea/ahf:BlockArea/ahf:LineArea
	          return ppl:sum-lengths-to-pt($line-area/*/@width)))[1]" />
</xsl:function>

<xsl:function name="ppl:block-available-ipd" as="xs:double">
  <xsl:param name="block" as="element()" />

  <xsl:sequence
      select="(ppli:fop-length-to-pt($block/ancestor::flow/@ipd),
	       ppl:length-to-pt($block/ancestor::ahf:NormalFlowReferenceArea/@width))[1]" />
</xsl:function>

<!-- Currently AHF-only. -->
<xsl:function name="ppl:is-first" as="xs:boolean">
  <xsl:param name="block" as="element()" />

  <xsl:sequence
      select="$block/@is-first = 'true'" />
</xsl:function>

<!-- Currently AHF-only. -->
<xsl:function name="ppl:is-last" as="xs:boolean">
  <xsl:param name="block" as="element()" />

  <xsl:sequence
      select="$block/@is-last = 'true'" />
</xsl:function>

<xsl:variable name="ppl:units" as="element(unit)+">
  <unit name="in" per-inch="1"    per-pt="72" />
  <unit name="pt" per-inch="72"   per-pt="1" />
  <unit name="pc" per-inch="6"    per-pt="{1 div 12}" />
  <unit name="cm" per-inch="2.54" per-pt="{2.54 div 72}" />
  <unit name="mm" per-inch="25.4" per-pt="{25.4 div 72}" />
  <unit name="px" per-inch="96"   per-pt="{96 div 72}" />
</xsl:variable>

<xsl:variable
    name="ppl:units-pattern"
    select="concat('(',
                   string-join($ppl:units/@name, '|'),
                   ')')"
    as="xs:string" />

<xsl:function name="ppl:sum-lengths-to-inches" as="xs:double">
  <xsl:param name="lengths" as="xs:string*" />

  <xsl:sequence select="sum(for $length in $lengths
                              return ppl:length-to-inches($length))" />
</xsl:function>

<xsl:function name="ppl:sum-lengths-to-pt" as="xs:double">
  <xsl:param name="lengths" as="xs:string*" />

  <xsl:sequence select="sum(for $length in $lengths
                              return ppl:length-to-pt($length))" />
</xsl:function>

<xsl:function name="ppl:length-to-inches" as="xs:double">
  <xsl:param name="length" as="xs:string" />

  <xsl:choose>
    <xsl:when test="matches($length, concat('^-?\d+(\.\d*)?', $ppl:units-pattern, '$'))">
      <!--<xsl:message select="$length" />-->
      <xsl:analyze-string
          select="$length"
          regex="{concat('^(-?\d+(\.\d*)?)', $ppl:units-pattern, '$')}">
        <xsl:matching-substring>
          <xsl:sequence select="xs:double(regex-group(1)) div
                                xs:double($ppl:units[@name eq regex-group(3)]/@per-inch)" />
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message select="concat('Unrecognized length: ', $length)" />
      <xsl:sequence select="0" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="ppl:length-to-pt" as="xs:double">
  <xsl:param name="length" as="xs:string" />

  <xsl:choose>
    <xsl:when test="matches($length, concat('^-?\d+(\.\d*)?', $ppl:units-pattern, '$'))">
      <!--<xsl:message select="$length" />-->
      <xsl:analyze-string
          select="$length"
          regex="{concat('^(-?\d+(\.\d*)?)', $ppl:units-pattern, '$')}">
        <xsl:matching-substring>
          <xsl:sequence
              select="xs:double(regex-group(1)) div
                      xs:double($ppl:units[@name eq regex-group(3)]/@per-pt)" />
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message select="concat('Unrecognized length: ', $length)" />
      <xsl:sequence select="0" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- FOP area tree dimensions are in 'millipoints'. -->
<xsl:function name="ppli:fop-length-to-pt" as="xs:double?">
  <xsl:param name="length" as="xs:string?" />

  <xsl:sequence select="xs:double($length) div 1000" />
</xsl:function>

</xsl:stylesheet>