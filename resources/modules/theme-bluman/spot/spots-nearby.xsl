<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal">

    <xsl:import href="/modules/library-utilities/fw-variables.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:choose>
            
            <!-- At a country or area -->
            <xsl:when test="$fw:current-resource/@type = 'menuitem' and count(/result/related-spots/contents/content) lt 1">
                <h1>
                    <xsl:value-of select="$fw:current-resource/display-name" />
                </h1>
                <p>Showing spots near <xsl:value-of select="$fw:current-resource/display-name" /></p>
            </xsl:when>
            
            <!-- No search results -->
            <xsl:when test="$fw:current-resource/@type = 'menuitem' and count(/result/related-spots/contents/content) gt 1">
                <h1>
                    No result
                </h1>
                <p>We couldn't find any spots related to your search for: <strong><xsl:value-of select="$fw:querystring-parameter[@name = 'tags']"/></strong></p>
                <h4>Have a look at one of theese instead:</h4>
                <ul class="spot nearby list">    
                    <xsl:apply-templates select="/result/related-spots/contents/content" mode="spots-nearby"/>
                </ul>
            </xsl:when>
            
            <!-- At a spot -->
            <xsl:when test="count(/result/spots-nearby/contents/content) gt 1">
                <h4>Spots nearby</h4>
                <ul class="spot nearby list">    
                    <xsl:apply-templates select="/result/spots-nearby/contents/content" mode="spots-nearby"/>
                </ul>
            </xsl:when>
            
            <!-- Spots related to search -->
            <xsl:when test="$fw:querystring-parameter[@name = 'tags'] != '' and count(/result/related-spots/contents/content) gt 0">
                <h4>You might also like</h4>
                <ul class="spot nearby list">    
                    <xsl:apply-templates select="/result/related-spots/contents/content" mode="spots-nearby"/>
                </ul>
            </xsl:when>
            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="content" mode="spots-nearby">
        <xsl:if test="not(current()/@key = $fw:current-resource/@key)">
            <xsl:variable name="spottags" select="$fw:querystring-parameter[@name='spottags']"/>
            <xsl:variable name="locationKey" select="$fw:querystring-parameter[@name='locationKey']"/>
            <xsl:variable name="spotUrl">
                <xsl:value-of select="portal:createContentUrl(@key,('locationKey', $locationKey))"/>
                <xsl:if test="$locationKey and string-length($spottags)>0">
                    <xsl:text>&amp;spottags=</xsl:text>
                    <xsl:value-of select="$spottags"/>
                </xsl:if>
            </xsl:variable>
            
            <li class="spot">
                <xsl:if test="$fw:current-resource/@key=current()/@key">
                    <xsl:attribute name="class">spot active</xsl:attribute>
                </xsl:if>

                <a href="{$spotUrl}">
                    <xsl:choose>
                        <xsl:when test="$fw:device-class = 'mobile'">
                            <img src="{portal:createImageUrl(contentdata/image[1]/image/@key, 'scaleblock(320, 120)')}" height="120" width="320"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <img src="{portal:createImageUrl(contentdata/image[1]/image/@key, 'scaleblock(155, 90)')}" height="90" width="155"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <div class="content">
                    <h3>
                        <a href="{$spotUrl}">
                            <xsl:value-of select="display-name"/>
                        </a>
                    </h3>
                </div>
            </li>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
