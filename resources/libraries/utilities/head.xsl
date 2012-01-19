<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fw="http://www.enonic.com/cms/xslt/framework"
   xmlns:portal="http://www.enonic.com/cms/xslt/portal" 
   xmlns:util="http://www.enonic.com/cms/xslt/utilities">
  
   <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
   <xsl:import href="/libraries/utilities/system.xsl"/>

   <!-- Metadata -->
   <xsl:variable name="meta-generator" select="util:system.get-config-param('meta-generator', $fw:path)" as="element()?"/>
   <xsl:variable name="meta-author" select="util:system.get-config-param('meta-author', $fw:path)" as="element()?"/>
   <xsl:variable name="meta-description">
      <xsl:choose>
         <xsl:when test="/result/contents/content/contentdata/meta-description != ''">
            <xsl:value-of select="/result/contents/content/contentdata/meta-description"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$fw:current-resource/description"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="meta-keywords">
      <xsl:choose>
         <xsl:when test="/result/contents/content/contentdata/meta-keywords != ''">
            <xsl:value-of select="/result/contents/content/contentdata/meta-keywords"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$fw:current-resource/keywords"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="meta-content-key">
      <xsl:value-of select="/result/context/resource[@type = 'content']/@key"/>
   </xsl:variable>
   <xsl:variable name="meta-content-type">
      <xsl:value-of select="/result/context/resource[@type = 'content']/type"/>
   </xsl:variable>

   
   <!-- Metadata common template -->
   <!-- Renders standard metadata based on config.xml -->
   <xsl:template name="head.meta-common">
      <meta name="robots" content="all"/>
      <xsl:if test="$meta-generator != ''">
         <meta name="generator" content="{$meta-generator}"/>
      </xsl:if>
      
      <xsl:if test="$meta-author != ''">
         <meta name="author" content="{$meta-author}"/>
      </xsl:if>
      <xsl:if test="$meta-description != ''">
         <meta name="description" content="{$meta-description}"/>
      </xsl:if>
      <xsl:if test="$meta-keywords != ''">
         <meta name="keywords" content="{$meta-keywords}"/>
      </xsl:if>
      <!--<xsl:if test="$google-verify != ''">
         <meta content="{$google-verify}" name="google-site-verification"/>
      </xsl:if>-->
      <xsl:if test="$meta-content-key != ''">
         <meta name="_key" content="{$meta-content-key}"/>
      </xsl:if>
      <xsl:if test="$meta-content-type != ''">
         <meta name="_cty" content="{$meta-content-type}"/>
      </xsl:if>
   </xsl:template>
   
   

   <!-- Css common template -->
   <!-- Renders all CSS files and creates CSS for the regions defined in config.xml  -->
   <xsl:template name="head.css-common">
      <xsl:for-each select="$fw:theme-device-class/styles/style[not(@condition != '')]">
         <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css">
            <xsl:if test="@media = 'print'">
               <xsl:attribute name="media">print</xsl:attribute>
            </xsl:if>
         </link>
      </xsl:for-each>

      <xsl:if test="$fw:theme-device-class/styles/style[@condition != '']">
         <xsl:text disable-output-escaping="yes">&lt;!--[if </xsl:text>
         <xsl:for-each-group select="$fw:theme-device-class/styles/style[@condition != '']" group-by="@condition">
            <xsl:value-of select="@condition"/>
            <xsl:text disable-output-escaping="yes">]&gt;</xsl:text>
            <xsl:for-each select="$fw:theme-device-class/styles/style[@condition = current()/@condition]">
               <xsl:text disable-output-escaping="yes">&lt;link rel="stylesheet" type="text/css" href="</xsl:text>
               <xsl:value-of select="portal:createResourceUrl(.)"/>
               <xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
         </xsl:for-each-group>
      </xsl:if>
   </xsl:template>
   
   

   <!-- Script common template -->
   <!-- Renders all javascripts for current device as defined in config.xml -->
   <xsl:template name="head.script-common">
      <xsl:for-each select="$fw:theme-device-class/scripts/script">
         <script type="text/javascript" src="{portal:createResourceUrl(current())}"/>
      </xsl:for-each>
   </xsl:template>
   

</xsl:stylesheet>
