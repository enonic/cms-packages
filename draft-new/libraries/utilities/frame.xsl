<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template name="frame.frame">
        <xsl:param name="content"/>
        <xsl:param name="frame-heading" as="xs:string?"/>
        <xsl:param name="frame-id" as="xs:string?"/>
        <xsl:param name="frame-tools" as="xs:string*"/>
        <xsl:param name="frame-icon" as="xs:string?"/>
        <xsl:if test="$content/*">
            <div class="frame clear clearfix">
                <xsl:if test="$frame-id">
                    <xsl:attribute name="id" select="$frame-id"/>
                </xsl:if>
                <xsl:for-each select="$frame-tools">
                    <a href="#" class="tool {.}" title="{portal:localize(concat(upper-case(substring(., 1, 1)), substring(., 2)))}"/>
                </xsl:for-each>
                <xsl:if test="$frame-heading != ''">
                    <h3>
                        <xsl:if test="$frame-icon">
                            <xsl:attribute name="class" select="concat('icon ', $frame-icon)"/>
                        </xsl:if>
                        <xsl:value-of select="$frame-heading"/>
                    </h3>
                </xsl:if>
                <div class="clear clearfix">
                    <xsl:copy-of select="$content"/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
