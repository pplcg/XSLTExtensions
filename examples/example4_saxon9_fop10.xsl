<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 4                                 -->
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

<xsl:key name="lists" match="list" use="true()" />

<xsl:key name="blocks" match="block[exists(@prod-id)]" use="@prod-id" />

<!-- Where to write the output files. -->
<xsl:param name="dest_dir" select="out" as="xs:string"/>
<xsl:param name="area_tree_filename" />

<!-- Initial template -->
<xsl:template name="main">
  <!-- Make a test document containing only the list labels.  Re-use
       example markup rather than creating FOs directly just because
       it's convenient. -->
  <xsl:variable name="test-doc">
    <example>
      <xsl:for-each select="key('lists', true())">
        <box id="{@id}" width="3in" height="3in">
          <xsl:for-each select="item/@label">
            <paragraph>
              <xsl:value-of select="."/>
            </paragraph>
          </xsl:for-each>
        </box>
      </xsl:for-each>
    </example>
  </xsl:variable>
  <!-- Save the FO tree from $test-doc in a variable. -->
  <xsl:variable name="fo_tree">
    <xsl:apply-templates select="$test-doc" />
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
      <!-- Find the maximum label width for each list and convert to pt. -->
      <xsl:for-each select="key('lists', true())">
	<xsl:variable name="id" select="@id" as="xs:string" />
	<xsl:variable name="block"
		      select="key('blocks', $id, $area-tree)[1]" />
	<override id="{$id}" label-width="{max($block//text/@ipd) div 1000}pt" />
      </xsl:for-each>
    </overrides>
  </xsl:variable>

  <xsl:apply-templates select="/">
    <xsl:with-param name="overrides" select="$overrides" as="document-node()" tunnel="yes" />
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
