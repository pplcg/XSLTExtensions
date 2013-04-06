<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:runfop="http://org.w3c.ppl.xslt/saxon-extension">

<xsl:param name="dest_dir" />
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

<xsl:variable name="area_tree_file" select="concat($dest_dir, '/', $area_tree_filename)" />

<xsl:message>Area tree filename = <xsl:value-of select="$area_tree_file" /></xsl:message>

<url>
  <xsl:value-of select="runfop:area-tree-url($fo_tree, $area_tree_file)"/>
  </url>

</xsl:template>


<xsl:template match="header">
  <fo:block font-size="14pt" font-family="verdana" color="red"
  space-before="5mm" space-after="5mm">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<xsl:template match="paragraph">
  <fo:block text-indent="5mm" font-family="verdana" font-size="12pt">
    <xsl:attribute name="id">
      <xsl:value-of select="@id" />
    </xsl:attribute>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>