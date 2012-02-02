<?xml version="1.0" encoding="UTF-8"?>

<!--
    **************************************************
    
    text.xsl
    version: ###VERSION-NUMBER-IS-INSERTED-HERE###
    
    **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <!-- Crops text -->
    <xsl:function name="util:text.crop" as="xs:string">
        <xsl:param name="source-text" as="xs:string"/>
        <xsl:param name="num-characters" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="string-length($source-text) gt $num-characters">
                <xsl:value-of disable-output-escaping="yes" select="concat(string-join(tokenize(substring($source-text, 1, $num-characters - 3), '\s')[position() != last()], ' '), '...')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="$source-text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Capitalizes the first character of a string -->
    <xsl:function name="util:text.capitalize" as="xs:string"> 
        <xsl:param name="string" as="xs:string"/> 
        <xsl:value-of select="concat(upper-case(substring($string, 1, 1)), substring($string, 2))"/>
    </xsl:function>

</xsl:stylesheet>
