<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 3                                 -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/FOPRunXSLTExt        -->
<!--                                                               -->
<!-- Requires Saxon 9.5 or later and FOP 1.0                       -->
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

<xsl:key name="boxes" match="box" use="true()" />

<xsl:key name="blocks" match="block[exists(@prod-id)]" use="@prod-id" />

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

  <xsl:variable
      name="url"
      select="runfop:area-tree-url($fo_tree, $area_tree_file)"
      as="xs:string" />

  <xsl:variable
      name="area-tree"
      select="document($url)"
      as="document-node()?" />

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