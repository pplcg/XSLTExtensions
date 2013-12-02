<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 5                                 -->
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

<xsl:key name="boxes" match="box" use="true()" />

<xsl:key name="blocks" match="block[exists(@prod-id)]" use="@prod-id" />

<xsl:param name="font-size" select="12" as="xs:double" />

<!-- Where to write the output files. -->
<xsl:param name="dest_dir" select="out" as="xs:string"/>
<xsl:param name="area_tree_filename" />

<xsl:param name="tolerance" select="1" as="xs:double" />

<!-- Initial template -->
<xsl:template name="main">
  <xsl:call-template name="do-box">
    <xsl:with-param name="font-size" select="$font-size" as="xs:double" />
    <xsl:with-param
        name="font-size.minimum" select="$font-size" as="xs:double" tunnel="yes" />
    <xsl:with-param
        name="font-size.maximum" select="$font-size * 10" as="xs:double" tunnel="yes" />
    <xsl:with-param name="iteration" select="1" as="xs:integer" />
    <xsl:with-param name="iteration-max" select="30" as="xs:integer" tunnel="yes" />
    <xsl:with-param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="do-box">
  <xsl:param name="font-size" as="xs:double" />
  <xsl:param name="font-size.minimum" as="xs:double" tunnel="yes" />
  <xsl:param name="font-size.maximum" as="xs:double" tunnel="yes" />
  <xsl:param name="iteration" select="1" as="xs:integer" />
  <xsl:param name="iteration-max" select="5" as="xs:integer" tunnel="yes" />
  <xsl:param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />

  <xsl:variable name="area_tree_filename_basename"
                select="replace($area_tree_filename, '\.[^.]+$', '')"
                as="xs:string" />
  <xsl:variable name="area_tree_filename_suffix"
                select="tokenize($area_tree_filename, '\.')[last()]"
                as="xs:string" />
  <xsl:variable name="area_tree_file"
		select="concat($dest_dir,
                               '/',
                               $area_tree_filename_basename,
                               '-',
                               $iteration,
                               '.',
                               $area_tree_filename_suffix)"
                as="xs:string" />

  <xsl:message>iteration = <xsl:value-of select="$iteration" /></xsl:message>
  <xsl:message>font-size = <xsl:value-of select="$font-size" /></xsl:message>
  <xsl:message>font-size.minimum = <xsl:value-of select="$font-size.minimum" /></xsl:message>
  <xsl:message>font-size.maximum = <xsl:value-of select="$font-size.maximum" /></xsl:message>
  <xsl:message>Area tree filename = <xsl:value-of select="$area_tree_file" /></xsl:message>

  <xsl:variable name="overrides">
    <overrides>
      <!-- Set the font size. -->
      <xsl:for-each select="key('boxes', true())">
	<xsl:variable name="id" select="@id" as="xs:string" />
	<override id="{$id}" font-size="{$font-size}" />
      </xsl:for-each>
    </overrides>
  </xsl:variable>

  <!-- Save the FO tree in a variable. -->
  <xsl:variable name="fo_tree">
    <xsl:apply-templates select="/">
      <xsl:with-param name="overrides" select="$overrides" as="document-node()" tunnel="yes" />
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable
      name="url"
      select="runfop:area-tree-url($fo_tree, $area_tree_file)"
      as="xs:string" />

  <xsl:variable
      name="area-tree"
      select="document($url)"
      as="document-node()?" />

  <xsl:variable
      name="bpd"
      select="key('blocks', key('boxes', true())[1]/@id, $area-tree)[1]/block/@bpd"
      as="xs:integer" />

  <xsl:variable
      name="target-height"
      select="xs:double(substring-before(key('boxes', true())[1]/@height, 'pt'))"
      as="xs:double" />

  <xsl:choose>
    <xsl:when test="$iteration eq $iteration-max">
      <xsl:message>Maximum iterations.</xsl:message>
      <xsl:apply-templates select="/">
        <xsl:with-param
            name="overrides"
            select="$overrides"
            as="document-node()"
            tunnel="yes" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$bpd div 1000 > $target-height">
      <xsl:call-template name="do-box">
        <xsl:with-param
            name="font-size"
            select="($font-size + $font-size.minimum) div 2"
            as="xs:double" />
        <xsl:with-param
            name="font-size.maximum"
            select="$font-size"
            as="xs:double"
            tunnel="yes" />
        <xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$target-height - ($bpd div 1000) &lt;
                    $target-height * $tolerance div $target-height">
      <xsl:message>It fits.</xsl:message>
      <xsl:apply-templates select="/">
        <xsl:with-param
            name="overrides"
            select="$overrides"
            as="document-node()"
            tunnel="yes" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="do-box">
        <xsl:with-param
            name="font-size"
            select="($font-size + $font-size.maximum) div 2"
            as="xs:double" />
        <xsl:with-param
            name="font-size.mimimum"
            select="$font-size"
            as="xs:double"
            tunnel="yes" />
        <xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
