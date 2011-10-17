<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output indent="yes" method="text"/>

    <xsl:template match="/">
        <xsl:for-each select="document(concat(/result/context/site/path-to-home-resources, '/modules/robots-txt/config.xml'))/config/robots/robot">
            <xsl:value-of select="concat('User-Agent: ', @name, '&#10;')"/>
            <xsl:for-each select="rule">
                <xsl:value-of select="if (@name = 'disallow') then 'Disallow' else 'Allow'"/>
                <xsl:value-of select="concat(': ', ., '&#10;')"/>
            </xsl:for-each>
            <xsl:if test="position() != last()">&#10;</xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
