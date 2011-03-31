<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities">
   
    <xsl:template name="breadcrumbs.print-crumbs">
        <xsl:param name="path" as="element()*" />
        
        <xsl:variable name="front-page" select="/result/context/site/front-page/resource/@key"/>
        <xsl:variable name="site-name" select="/result/context/site/name"/>    
        <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
        <!-- Breadcrumb trail -->
            <div id="breadcrumb-trail" class="clear screen">
                <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
                <!-- Always start with front page -->
                <xsl:choose>
                    <xsl:when test="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page)]">
                        <a href="{portal:createPageUrl($front-page, ())}">
                            <xsl:value-of select="$site-name"/>
                        </a>
                        <xsl:text> - </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$site-name"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Loop through path -->
                <xsl:for-each select="$path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page)]">
                    <xsl:choose>
                        <xsl:when test="type = 'label' or type = 'section' or (position() = last() and @key = $current-resource/@key)">
                            <xsl:value-of select="util:menuitem-name(.)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <a href="{portal:createPageUrl(@key, ())}">
                                <xsl:value-of select="util:menuitem-name(.)"/>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not(position() = last() and @key = $current-resource/@key)">
                        <xsl:text> - </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last() and @key != $current-resource/@key">
                        <xsl:value-of select="util:menuitem-name($current-resource)"/>
                    </xsl:if>
                </xsl:for-each>
            </div>
    </xsl:template>
    
</xsl:stylesheet>


