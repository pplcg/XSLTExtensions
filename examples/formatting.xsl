<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- Common templates for formatting FOPRunXSLTExt examples        -->
<!--                                                               -->
<!-- See http://www.w3.org/community/ppl/wiki/FOPRunXSLTExt        -->
<!--                                                               -->
<!-- Requires Saxon 9.4 or later and FOP 1.0 or AHF 6.1            -->
<!--                                                               -->
<!-- Produced by the Print and Page Layout Community Group @ W3C   -->
<!-- ============================================================= -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">

<!-- ============================================================= -->
<!-- KEYS                                                          -->
<!-- ============================================================= -->

<xsl:key name="overrides" match="override" use="@id" />


<!-- ============================================================= -->
<!-- STYLESHEET PARAMETERS                                         -->
<!-- ============================================================= -->

<!-- Page height, if not using FO processor's default. -->
<xsl:param name="page-height" select="()" as="xs:string?" />

<!-- Page width, if not using FO processor's default. -->
<xsl:param name="page-width" select="()" as="xs:string?" />


<!-- ============================================================= -->
<!-- STYLESHEET VARIABLES                                          -->
<!-- ============================================================= -->

<xsl:variable name="overrides">
  <no-overrides/>
</xsl:variable>

<xsl:template match="/">
  <fo:root font-family="verdana, sans-serif" font-size="12pt">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="test-page">
	<xsl:if test="exists($page-height)">
	  <xsl:attribute name="page-height" select="$page-height"/>
	</xsl:if>
	<xsl:if test="exists($page-width)">
	  <xsl:attribute name="page-width" select="$page-width"/>
	</xsl:if>
	<fo:region-body margin="1in"/>
      </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="test-page">
      <fo:flow flow-name="xsl-region-body">
	<xsl:apply-templates/>
      </fo:flow>
    </fo:page-sequence>
  </fo:root>
</xsl:template>

<xsl:template match="header">
  <fo:block font-size="14pt" color="red"
	    space-before="5mm" space-after="5mm">
   <xsl:apply-templates />
  </fo:block>
</xsl:template>

<xsl:template match="box">
  <xsl:param name="overrides" select="$overrides" as="document-node()" tunnel="yes"/>

  <!--
  <xsl:message select="key('overrides', @id, $overrides)"/>
  -->

  <fo:block-container role="{local-name()}" border="medium solid black"
	    width="{@width}" height="{@height}" padding="12pt"
	    id="{@id}">
    <xsl:if test="key('overrides', @id, $overrides)/@rotate = 'yes'">
      <xsl:attribute name="reference-orientation" select="'270'" />
    </xsl:if>
    <xsl:if test="key('overrides', @id, $overrides)/@font-size">
      <xsl:attribute name="font-size"
                     select="concat(key('overrides', @id, $overrides)/@font-size, 'pt')" />
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block-container>
</xsl:template>

<xsl:template match="paragraph">
  <fo:block id="{@id}" text-align="justify" space-before="3pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="svg">
  <fo:instream-foreign-object id="{@id}">
    <xsl:copy-of select="document(@href)"/>
  </fo:instream-foreign-object>
</xsl:template>

<xsl:template match="list">
  <xsl:param name="overrides" select="$overrides" as="document-node()" tunnel="yes"/>
  <fo:list-block
      provisional-distance-between-starts="{if (@label-width = 'narrow')
                                              then '10mm'
                                            else '35mm'}"
      provisional-label-separation="4pt"
      space-after="3pt"
      id="{@id}">
    <!-- If we know the exact label width, set the provisional
         distance between starts to the width plus the label
         separation. -->
    <xsl:if test="exists(key('overrides', @id, $overrides))">
      <xsl:attribute
          name="provisional-distance-between-starts"
          select="concat(key('overrides', @id, $overrides)/@label-width, ' + 4pt')" />
    </xsl:if>
    <xsl:apply-templates/>
  </fo:list-block>
</xsl:template>

<xsl:template match="item">
  <fo:list-item space-before="3pt">
    <fo:list-item-label end-indent="label-end()">
      <fo:block color="red">
        <xsl:apply-templates select="@label"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

</xsl:stylesheet>
