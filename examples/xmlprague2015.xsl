<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- FOPRunXSLTExt XML Prague 2015 example                         -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/XSLTExtensions       -->
<!--                                                               -->
<!-- Requires Saxon 9.5 or later and FOP 1.0 or AHF 6.1            -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!-- http://www.w3.org/community/ppl/                              -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:ppl="http://www.w3.org/community/ppl/ns/"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ppl xs">

<!-- ============================================================= -->
<!-- IMPORTS                                                       -->
<!-- ============================================================= -->

<!-- Print and Page Layout Community Group extensions. -->
<xsl:import href="ppl-extensions.xsl" />


<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<!-- All 'box' elements in source. -->
<xsl:key name="boxes" match="box" use="true()" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Initial font size. -->
<xsl:param name="font-size" select="20" as="xs:double" />

<!-- Number of beers. -->
<xsl:param name="beers" select="4" as="xs:integer" />

<!-- Allowed difference in height between outer box and formatted
     paragraph text to be able to say paragraph fits within box and
     stop further iterations. -->
<xsl:param name="tolerance" select="1" as="xs:double" />

<!-- Difference between beers.minimum and beers.maximum below
     which it's not worth continuing. -->
<xsl:param name="beers-tolerance" select="1" as="xs:integer" />

<!-- Page height, if not using FO processor's default. -->
<xsl:param name="page-height" select="'4in'" as="xs:string?" />

<!-- Page width, if not using FO processor's default. -->
<xsl:param name="page-width" select="'4in'" as="xs:string?" />


<!-- ============================================================= -->
<!-- INITIAL TEMPLATE                                              -->
<!-- ============================================================= -->

<xsl:template name="main">
  <xsl:message select="concat('tolerance: ', $tolerance)" />
  <xsl:message select="concat('beers-tolerance: ', $beers-tolerance)" />

  <!-- 'do-box' templates recursively calls itself until: the
       formatted area fits within the box within $tolerance; the
       change in $beers between successive runs is less than
       $beers-tolerance; or $iteration-max iterations is
       reached. -->
  <xsl:call-template name="do-box">
    <xsl:with-param name="font-size" select="$font-size" as="xs:double" />
    <xsl:with-param
        name="beers.minimum" select="$beers" as="xs:integer" tunnel="yes" />
    <xsl:with-param
        name="beers.maximum" select="$beers * 15" as="xs:integer" tunnel="yes" />
    <xsl:with-param name="iteration" select="1" as="xs:integer" />
    <xsl:with-param name="beers" select="$beers" as="xs:integer" />
    <xsl:with-param name="iteration-max" select="30" as="xs:integer" tunnel="yes" />
    <xsl:with-param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />
    <xsl:with-param name="beers-tolerance" select="$beers-tolerance" as="xs:integer" tunnel="yes" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="do-box">
  <xsl:param name="font-size" select="$font-size" as="xs:double" />
  <xsl:param name="beers.minimum" as="xs:integer" tunnel="yes" />
  <xsl:param name="beers.maximum" as="xs:integer" tunnel="yes" />
  <xsl:param name="iteration" select="1" as="xs:integer" />
  <xsl:param name="beers" select="1" as="xs:integer" />
  <xsl:param name="iteration-max" select="5" as="xs:integer" tunnel="yes" />
  <xsl:param name="tolerance" select="$tolerance" as="xs:double" tunnel="yes" />
  <xsl:param name="beers-tolerance" select="$beers-tolerance" as="xs:integer" tunnel="yes" />

  <xsl:message>iteration = <xsl:value-of select="$iteration" /></xsl:message>
  <xsl:message>beers = <xsl:value-of select="$beers" /></xsl:message>
  <xsl:message>beers.minimum = <xsl:value-of select="$beers.minimum" /></xsl:message>
  <xsl:message>beers.maximum = <xsl:value-of select="$beers.maximum" /></xsl:message>

  <xsl:variable name="overrides">
    <overrides>
      <!-- Set the font size. -->
      <xsl:for-each select="key('boxes', true())">
	<xsl:variable name="id" select="@id" as="xs:string" />
	<override id="{$id}" font-size="{$font-size}" />
      </xsl:for-each>
    </overrides>
  </xsl:variable>

  <xsl:variable name="font-weights"
		select="'100', '500', '700', '900'"
		as="xs:string+" />

  <xsl:variable name="fo">
    <fo:root font-family="Calluna Sans" font-size="{$font-size}pt">
      <fo:layout-master-set>
	<fo:simple-page-master master-name="test-page">
	  <xsl:if test="exists($page-height)">
	    <xsl:attribute name="page-height" select="$page-height"/>
	  </xsl:if>
	  <xsl:if test="exists($page-width)">
	    <xsl:attribute name="page-width" select="$page-width"/>
	  </xsl:if>
	  <fo:region-body margin="0.5in" border="thin solid black" />
	</fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="test-page">
	<fo:flow flow-name="xsl-region-body">
	  <fo:block-container width="100%" height="100%" id="xmlprague" overflow="visible">
	    <fo:block display-align="center" text-align="center">
	      <!-- Generate the beers. -->
	      <xsl:for-each select="1 to $beers">
		<xsl:variable name="number" select="." as="xs:integer" />
		<xsl:if test="xs:integer(.) != 1">
		  <xsl:text> </xsl:text>
		</xsl:if>
		<fo:inline
		    font-weight="{$font-weights[($number - 1) mod 4 + 1]}">beer</fo:inline>
	      </xsl:for-each>
	    </fo:block>
	  </fo:block-container>
	</fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:variable>
  <!--<xsl:message select="$fo" />-->

  <xsl:variable
      name="area-tree"
      select="ppl:area-tree($fo)"
      as="document-node()?" />
  <!--<xsl:message select="$area-tree" />-->
  <xsl:variable
      name="block"
      select="ppl:block-by-id($area-tree, 'xmlprague')"
      as="element()" />

  <xsl:variable
      name="bpd"
      select="ppl:block-bpd($block)"
      as="xs:double" />

  <xsl:variable
      name="target-height"
      select="3 * 72"
      as="xs:double" />

  <xsl:message select="concat('bpd: ', $bpd)" />
  <xsl:message select="concat('target-height: ', $target-height)" />
  <xsl:choose>
    <xsl:when test="$target-height - $bpd > 0 and
                    $target-height - $bpd &lt; $tolerance">
      <xsl:message>It fits.  Using <xsl:value-of select="$beers" />.</xsl:message>
      <xsl:copy-of select="$fo" />
    </xsl:when>
    <xsl:when test="$beers.maximum - $beers.minimum &lt; $beers-tolerance">
      <xsl:message>Beers difference less than $beers-tolerance.  Using <xsl:value-of select="$beers" />.</xsl:message>
      <xsl:copy-of select="$fo" />
    </xsl:when>
    <xsl:when test="$iteration eq $iteration-max">
      <xsl:message>Maximum iterations.  Using <xsl:value-of select="$beers" />.</xsl:message>
      <xsl:copy-of select="$fo" />
    </xsl:when>
    <xsl:when test="$bpd > $target-height">
      <xsl:call-template name="do-box">
        <xsl:with-param
            name="beers"
            select="($beers + $beers.minimum) idiv 2"
            as="xs:integer" />
        <xsl:with-param
            name="beers.maximum"
            select="$beers"
            as="xs:integer"
            tunnel="yes" />
        <xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="do-box">
        <xsl:with-param
            name="beers"
            select="($beers + $beers.maximum) idiv 2"
            as="xs:integer" />
        <xsl:with-param
            name="beers.minimum"
            select="$beers"
            as="xs:integer"
            tunnel="yes" />
        <xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
