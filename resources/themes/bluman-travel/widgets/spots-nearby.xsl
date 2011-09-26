<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:util="enonic:utilities"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:math="http://exslt.org/math"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>
    <xsl:include href="/libraries/utilities/frame.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:if test="/result/spots-nearby/contents/content">
            <div class="spots-nearby-container">
                <div id="spots-info" class="spots-info default-transparency">
                    <p class="infoText">
                        You<xsl:choose><xsl:when test="/result/context/querystring/parameter[@name='spot']"> searched for spots in </xsl:when><xsl:otherwise> browsed to </xsl:otherwise></xsl:choose>
                        <xsl:choose>
                            <xsl:when test="/result/context/querystring/parameter[@name='spot'] and /result/context/querystring/parameter[@name='country']">
                                <span><xsl:value-of select="/result/context/querystring/parameter[@name='spot']" /></span>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="/result/context/resource/display-name" />
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="/result/context/querystring/parameter[@name='spottag']">
                            <xsl:text> related to </xsl:text>
                            <xsl:variable name="numberOfTags" select="count(/result/context/querystring/parameter[@name='spottag'])" />
                            <xsl:for-each select="/result/context/querystring/parameter[@name='spottag']">
                                <xsl:variable name="spottagId" select="." />
                                <span><xsl:value-of select="/result/tags/contents/content[@contenttype='Spottag' and @key=$spottagId]/name" /></span>
                                <xsl:choose>
                                     <xsl:when test="position()+1=$numberOfTags">
                                        <xsl:text> or </xsl:text>
                                    </xsl:when>
                                    <xsl:when test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text> </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="/result/context/querystring/parameter[@name='spot']">
                            <xsl:text> - we selected a matching spot, but you may also click the additional spots:</xsl:text>
                        </xsl:if>
                    </p>
                </div>
                <div class="spots-nearby">
                    <ul id="sdt_menu" class="sdt_menu">
                        <xsl:apply-templates select="/result/spots-nearby/contents/content" mode="spots-nearby"/>
                    </ul>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="content" mode="spots-nearby">
            <li class="spot-nearby default-transparency" style="background: url({portal:createImageUrl(contentdata/image[1]/image/@key, 'scalewidth(170)')})">
                <a href="{portal:createContentUrl(@key,(''))}">
                    <img class="animated-image" alt="{title}" src="{portal:createImageUrl(contentdata/image[1]/image/@key, 'scalesquare(170);rounded(2)')}" />
                    <span class="sdt_active"></span>
                    <span class="sdt_wrap">
                        <span class="sdt_link low-transparency"><xsl:value-of select="display-name" /></span>
                        <span class="sdt_descr low-transparency"><xsl:value-of select="location/site/contentlocation/@menuitemname" /> </span>
                    </span>
                </a>
            </li>
    </xsl:template>
</xsl:stylesheet>
