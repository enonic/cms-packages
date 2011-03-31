<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  
  <xsl:variable name="meta-generator" select="util:get-scoped-parameter('meta-generator', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="meta-author" select="util:get-scoped-parameter('meta-author', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="meta-description">
    <xsl:choose>
      <xsl:when test="/result/contents/content/contentdata/meta-description != ''">
        <xsl:value-of select="/result/contents/content/contentdata/meta-description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$current-resource/description"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="meta-keywords">
    <xsl:choose>
      <xsl:when test="/result/contents/content/contentdata/meta-keywords != ''">
        <xsl:value-of select="/result/contents/content/contentdata/meta-keywords"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$current-resource/keywords"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:template name="meta.meta-tags">
    <meta name="robots" content="all"/>
    <xsl:if test="$meta-generator != ''">
      <meta name="generator" content="{$meta-generator}"/>
    </xsl:if>
    <meta http-equiv="content-language" content="{$language}"/>
    <xsl:if test="$meta-author != ''">
      <meta name="author" content="{$meta-author}"/>
    </xsl:if>
    <xsl:if test="$meta-description != ''">
      <meta name="description" content="{$meta-description}"/>
    </xsl:if>
    <xsl:if test="$meta-keywords != ''">
      <meta name="keywords" content="{$meta-keywords}"/>
    </xsl:if>
    <xsl:if test="$google-verify != ''">
      <meta content="{$google-verify}" name="google-site-verification"/>
    </xsl:if> 
  </xsl:template>
  
  <xsl:template name="meta.mobile-tags">
    <meta content="minimum-scale=1.0, width=device-width, user-scalable=yes" name="viewport"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <xsl:if test="$meta-generator != ''">
      <meta name="generator" content="{$meta-generator}"/>
    </xsl:if>
    <meta http-equiv="content-language" content="{$language}"/>
    <xsl:if test="$meta-author != ''">
      <meta name="author" content="{$meta-author}"/>
    </xsl:if>
    <xsl:if test="$google-verify != ''">
      <meta content="{$google-verify}" name="google-site-verification"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
