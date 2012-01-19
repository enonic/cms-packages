<?xml version="1.0" encoding="UTF-8"?>

<!--
    **************************************************
    
    file.xsl
    version: ###VERSION-NUMBER-IS-INSERTED-HERE###
    
    **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <!-- Formats bytes -->
    <xsl:function name="util:file.format-bytes" as="xs:string">
        <xsl:param name="bytes" as="xs:integer"/>
        <xsl:value-of select="if ($bytes > 1073741824) then concat(format-number($bytes div 1073741824, '0.#'), ' GB') else if ($bytes > 1048576) then concat(format-number($bytes div 1048576, '0.#'), ' MB') else if ($bytes > 1024) then concat(format-number($bytes div 1024, '0'), ' KB') else concat($bytes, ' B')"/>
    </xsl:function>
    
    <!-- Displays icon image -->
    <xsl:template name="util:file.icon-image">
        <xsl:param name="file-name" as="xs:string"/>
        <xsl:param name="icon-folder-path" as="xs:string"/>
        <xsl:param name="icon-image-prefix" as="xs:string" select="'icon-'"/>
        <xsl:param name="icon-image-file-extension" as="xs:string" select="'png'"/>
        <xsl:param name="icon-class" as="xs:string?" select="'icon text'"/>
        <xsl:variable name="file-extension" select="lower-case(tokenize($file-name, '\.')[last()])"/>
        <xsl:variable name="image-url">
            <xsl:value-of select="$icon-folder-path"/>
            <xsl:if test="not(ends-with($icon-folder-path, '/'))">/</xsl:if>
            <xsl:value-of select="$icon-image-prefix"/>
            <xsl:choose>
                <xsl:when test="contains('htm', $file-extension)">
                    <xsl:text>htm</xsl:text>
                </xsl:when>
                <xsl:when test="contains('ppt|pps', $file-extension)">
                    <xsl:text>ppt</xsl:text>
                </xsl:when>
                <xsl:when test="contains('gif|jpg|tif|psd', $file-extension)">
                    <xsl:text>img</xsl:text>
                </xsl:when>
                <xsl:when test="contains('doc|dot', $file-extension)">
                    <xsl:text>doc</xsl:text>
                </xsl:when>
                <xsl:when test="contains('pdf', $file-extension)">
                    <xsl:text>pdf</xsl:text>
                </xsl:when>
                <xsl:when test="contains('avi|mpg|wmv', $file-extension)">
                    <xsl:text>vid</xsl:text>
                </xsl:when>
                <xsl:when test="contains('xls|xlt|csv', $file-extension)">
                    <xsl:text>xls</xsl:text>
                </xsl:when>
                <xsl:when test="contains('xml', $file-extension)">
                    <xsl:text>xml</xsl:text>
                </xsl:when>
                <xsl:when test="contains('txt|dat|text', $file-extension)">
                    <xsl:text>txt</xsl:text>
                </xsl:when>
                <xsl:when test="contains('zip|tar|gz|qz|arj', $file-extension)">
                    <xsl:text>zip</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>file</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="not(starts-with($icon-image-file-extension, '.'))">.</xsl:if>
            <xsl:value-of select="$icon-image-file-extension"/>
        </xsl:variable>
        <img src="{portal:createResourceUrl($image-url)}" alt="{concat(util:file.type($file-name), ' ', portal:localize('util.file.icon'))}">
            <xsl:if test="$icon-class != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="$icon-class"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>
    
    <!-- Displays file type -->
    <xsl:function name="util:file.type" as="xs:string">
        <xsl:param name="file-name" as="xs:string"/>
        <xsl:variable name="file-extension" select="lower-case(tokenize($file-name, '\.')[last()])"/>
        <xsl:choose>
            <xsl:when test="contains('htm', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.html')"/>
            </xsl:when>
            <xsl:when test="contains('ppt|pps', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.powerpoint')"/>
            </xsl:when>
            <xsl:when test="contains('gif|jpg|tif|psd', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.image')"/>
            </xsl:when>
            <xsl:when test="contains('doc|dot', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.document')"/>
            </xsl:when>
            <xsl:when test="contains('pdf', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.pdf')"/>
            </xsl:when>
            <xsl:when test="contains('avi|mpg|wmv', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.video')"/>
            </xsl:when>
            <xsl:when test="contains('xls|xlt|csv', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.excel')"/>
            </xsl:when>
            <xsl:when test="contains('xml', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.xml')"/>
            </xsl:when>
            <xsl:when test="contains('txt|dat|text', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.text')"/>
            </xsl:when>
            <xsl:when test="contains('zip|tar|gz|qz|arj', $file-extension)">
                <xsl:value-of select="portal:localize('util.file.zip')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="portal:localize('util.file.file')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
