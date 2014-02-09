<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt Saxon example 5                                 -->
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
    xmlns:ppl="http://www.w3.org/community/ppl/ns/"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSL/AreaTree"
    exclude-result-prefixes="ppl xs ahf">

<!-- Print and Page Layout Community Group extensions. -->
<xsl:import href="ppl-extensions.xsl" />

<!-- Common templates for formatting FOPRunXSLTExt examples -->
<xsl:import href="formatting.xsl" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- All 'box' elements in source. -->
<xsl:key name="boxes" match="box" use="true()" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Initial font size. -->
<xsl:param name="font-size" select="12" as="xs:double" />

<!-- Allowed difference in height between outer box and formatted
     paragraph text to be able to say paragraph fits within box and
     stop further iterations. -->
<xsl:param name="tolerance" select="1" as="xs:double" />

<!-- Difference between font-size.minimum and font-size.maximum below
     which it's not worth continuing. -->
<xsl:param name="font-size-tolerance" select="0.01" as="xs:double" />


<!-- ============================================================= -->
<!-- INITIAL TEMPLATE                                              -->
<!-- ============================================================= -->

<xsl:template name="main">
  <xsl:message select="concat('tolerance: ', $tolerance)" />
  <xsl:message select="concat('font-size-tolerance: ', $font-size-tolerance)" />

  <xsl:call-template name="do-box">
    <xsl:with-param name="font-size" select="$font-size" as="xs:double" />
    <xsl:with-param
        name="font-size.minimum" select="$font-size" as="xs:double" tunnel="yes" />
    <xsl:with-param
        name="font-size.maximum" select="$font-size * 10" as="xs:double" tunnel="yes" />
    <xsl:with-param name="iteration" select="1" as="xs:integer" />
    <xsl:with-param name="iteration-max" select="30" as="xs:integer" tunnel="yes" />
    <xsl:with-param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />
    <xsl:with-param name="font-size-tolerance" select="$font-size-tolerance" as="xs:double" tunnel="yes" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="do-box">
  <xsl:param name="font-size" as="xs:double" />
  <xsl:param name="font-size.minimum" as="xs:double" tunnel="yes" />
  <xsl:param name="font-size.maximum" as="xs:double" tunnel="yes" />
  <xsl:param name="iteration" select="1" as="xs:integer" />
  <xsl:param name="iteration-max" select="5" as="xs:integer" tunnel="yes" />
  <xsl:param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />
  <xsl:param name="font-size-tolerance" select="$font-size-tolerance" as="xs:double" tunnel="yes" />

  <xsl:message>iteration = <xsl:value-of select="$iteration" /></xsl:message>
  <xsl:message>font-size = <xsl:value-of select="$font-size" /></xsl:message>
  <xsl:message>font-size.minimum = <xsl:value-of select="$font-size.minimum" /></xsl:message>
  <xsl:message>font-size.maximum = <xsl:value-of select="$font-size.maximum" /></xsl:message>

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
      name="area-tree"
      select="ppl:area-tree($fo_tree)"
      as="document-node()?" />

  <xsl:variable
      name="block"
      select="ppl:block($area-tree, key('boxes', true())[1]/@id)"
      as="element()" />

  <xsl:variable
      name="bpd"
      select="($block/block/@bpd,
	       xs:double(substring-before($block/*/ahf:BlockArea/@height, 'pt')) * 1000)[1]"
      as="xs:double" />

  <xsl:variable
      name="target-height"
      select="xs:double(substring-before(key('boxes', true())[1]/@height, 'pt'))"
      as="xs:double" />

  <xsl:message select="concat('bpd: ', $bpd)" />
  <xsl:message select="concat('target-height: ', $target-height)" />
  <xsl:choose>
    <xsl:when test="$target-height - ($bpd div 1000) > 0 and
                    $target-height - ($bpd div 1000) &lt; $tolerance">
      <xsl:message>It fits.  Using <xsl:value-of select="$font-size" />.</xsl:message>
      <xsl:apply-templates select="/">
        <xsl:with-param
            name="overrides"
            select="$overrides"
            as="document-node()"
            tunnel="yes" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$font-size.maximum - $font-size.minimum &lt; $font-size-tolerance">
      <xsl:message>Font size difference less than $font-size-tolerance.  Using <xsl:value-of select="$font-size" />.</xsl:message>
      <xsl:apply-templates select="/">
        <xsl:with-param
            name="overrides"
            select="$overrides"
            as="document-node()"
            tunnel="yes" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$iteration eq $iteration-max">
      <xsl:message>Maximum iterations.  Using <xsl:value-of select="$font-size" />.</xsl:message>
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
    <xsl:otherwise>
      <xsl:call-template name="do-box">
        <xsl:with-param
            name="font-size"
            select="($font-size + $font-size.maximum) div 2"
            as="xs:double" />
        <xsl:with-param
            name="font-size.minimum"
            select="$font-size"
            as="xs:double"
            tunnel="yes" />
        <xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
