<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 3                                 -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/XSLTExtensions       -->
<!--                                                               -->
<!-- Requires xalan-j or later and FOP 1.0 or AHF 6.1              -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!-- http://www.w3.org/community/ppl/                              -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:ppl="http://www.w3.org/community/ppl/ns/"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ppl xs">

<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Print and Page Layout Community Group extensions. -->
<xsl:import href="ppl-extensions.xsl" />

<!-- Common templates for formatting FOPRunXSLTExt examples -->
<xsl:import href="formatting.xsl" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- All 'box' elements in source. -->
<xsl:key name="boxes" match="box" use="true()" />

<xsl:key name="blocks" match="block[exists(@prod-id)]" use="@prod-id" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Where to write the output files. -->
<xsl:param name="dest_dir" select="out" as="xs:string"/>
<xsl:param name="area_tree_filename" />


<!-- ============================================================= -->
<!-- INITIAL TEMPLATE                                              -->
<!-- ============================================================= -->

<xsl:template name="main">
  <!-- Save the FO tree in a variable. -->
  <xsl:variable name="fo_tree">
    <xsl:apply-templates select="/" />
  </xsl:variable>

  <xsl:variable
      name="area-tree"
      select="ppl:area-tree($fo_tree)"
      as="document-node()?" />

  <xsl:variable
      name="block"
      select="ppl:block-by-id($area-tree, key('boxes', true())[1]/@id)"
      as="element()" />

  <xsl:variable
      name="bpd"
      select="ppl:block-bpd($block)"
      as="xs:double" />

  <xsl:variable name="overrides">
    <overrides>
      <xsl:for-each select="key('boxes', true())">
	<xsl:variable name="id" select="@id" as="xs:string" />
	<xsl:variable name="block"
		      select="key('blocks', $id, $area-tree)[1]" />
	<xsl:if test="$block/@ipd > $block/ancestor::flow/@ipd">
	  <override id="{$id}" rotate="yes" />
	</xsl:if>
      </xsl:for-each>
    </overrides>
  </xsl:variable>

  <xsl:apply-templates select="/">
    <xsl:with-param name="overrides" select="$overrides" as="document-node()" tunnel="yes" />
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>