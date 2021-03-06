<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
  <!-- 
Ce parseur est destiné a un dictionnaire XML/TEI pour la BIUSanté
https://github.com/biusante/medict-xml
Il traverse tous les éléments et retient des informations méritant d’être insérées dans une base SQL,
sous la forme d’une ligne tsv.
Cette étape intermédiaire pemet le cas échéant de vérifier ce qui est extrait.
Un parseur (php en l’occurrence) traversera toutes ces lignes en ordre séquentiel,
en retenant les événements utiles en cours de contexte, notamment, les sauts de page,
permettant de raccrocher chaque information lexicale à sa page source.
  -->
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:variable name="lf">
    <xsl:text>&#10;</xsl:text>
  </xsl:variable>
  <xsl:variable name="tab">
    <xsl:text>&#9;</xsl:text>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:text>object</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>
    

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:TEI">
    <xsl:text>volume</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@n"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@ana"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:profileDesc/tei:creation/tei:date/@when"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>
  

  <xsl:template match="tei:pb">
    <xsl:value-of select="local-name()"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@n"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@facs"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@corresp"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:entry | tei:entryFree">
    <xsl:text>entry</xsl:text>
    <xsl:value-of select="$tab"/>
    <!-- Vedette -->
    <xsl:for-each select="tei:form/tei:orth">
      <xsl:if test="position() != 1">, </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <!-- pps -->
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="count(.//tei:pb)"/>
    <!-- page2 -->
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="(.//tei:pb)[position() = last()]/@n"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
    <xsl:text>/entry</xsl:text>
    <xsl:value-of select="$lf"/>
  </xsl:template>

  <xsl:template match="tei:orth">
    <xsl:value-of select="local-name()"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:sense[starts-with(., '–') or starts-with(., '=')]/tei:emph[1]">
    <xsl:text>term</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:value-of select="local-name()"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:foreign">
    <xsl:value-of select="local-name()"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="@xml:lang"/>
    <xsl:value-of select="$tab"/>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:value-of select="$lf"/>
    <xsl:apply-templates/>
  </xsl:template>
  

</xsl:transform>