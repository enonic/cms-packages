<?xml version="1.0" encoding="UTF-8"?>

<!--
    **************************************************
    
    system.xsl
    version: ###VERSION-NUMBER-IS-INSERTED-HERE###
    
    **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <xsl:function name="util:system.get-config-param" as="element()?">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$fw:config-parameter[@name = $name and @path = $path]">
                <xsl:sequence select="$fw:config-parameter[@name = $name and @path = $path][1]"/>
            </xsl:when>
            <xsl:when test="$path != ''">
                <xsl:copy-of select="util:system.get-config-param($name, substring-before($path, concat('/', tokenize($path, '/')[last()])))"/>
            </xsl:when>
            <xsl:when test="$fw:config-parameter[@name = $name and @path = '/']">
                <xsl:sequence select="$fw:config-parameter[@name = $name and @path = '/'][1]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Displays menu item name -->
    <xsl:function name="util:menuitem-name" as="xs:string">
        <xsl:param name="menuitem" as="item()?"/>
        <xsl:value-of select="if ($menuitem/display-name != '') then $menuitem/display-name else if ($menuitem/alternative-name != '') then $menuitem/alternative-name else $menuitem/name"/>
    </xsl:function>

</xsl:stylesheet>
