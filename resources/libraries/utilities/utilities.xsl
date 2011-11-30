<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">

    <!-- Returns scoped parameter from config as element()?  -->
    <xsl:function name="util:get-scoped-parameter" as="element()?">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="parameter" as="element()*"/>
        <xsl:call-template name="utilities.get-parameter">
            <xsl:with-param name="name" select="$name" tunnel="yes"/>
            <xsl:with-param name="path" select="$path"/>
            <xsl:with-param name="parameter" select="$parameter" tunnel="yes"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="utilities.get-parameter">
        <xsl:param name="name" tunnel="yes" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="parameter" tunnel="yes" as="element()*"/>
        <xsl:choose>
            <xsl:when test="$parameter[@name = $name and @path = $path]">
                <xsl:sequence select="$parameter[@name = $name and @path = $path][1]"/>
            </xsl:when>
            <xsl:when test="$path != ''">
                <xsl:call-template name="utilities.get-parameter">
                    <xsl:with-param name="path" select="substring-before($path, concat('/', tokenize($path, '/')[last()]))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$parameter[@name = $name and @path = '/']">
                <xsl:sequence select="$parameter[@name = $name and @path = '/'][1]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Displays menu item name -->
    <xsl:function name="util:menuitem-name" as="xs:string">
        <xsl:param name="menuitem" as="item()?"/>
        <xsl:value-of select="if ($menuitem/display-name != '') then $menuitem/display-name else if ($menuitem/alternative-name != '') then $menuitem/alternative-name else $menuitem/name"/>
    </xsl:function>

</xsl:stylesheet>
