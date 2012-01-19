<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">    
    
    <xsl:import href="/libraries/utilities/fw-variables.xsl"/>
    <xsl:import href="/libraries/utilities/html.xsl"/>
    <xsl:import href="/libraries/utilities/file.xsl"/>
    <xsl:import href="/libraries/utilities/text.xsl"/>
    <xsl:import href="/libraries/utilities/time.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/result/contents/content">
                <div id="event" class="clear append-bottom">
                    <xsl:apply-templates select="/result/contents/content"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p class="clear">
                    <xsl:value-of select="portal:localize('No-event')"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="content">
        <xsl:variable name="start-date" select="contentdata/start-date"/>
        <xsl:variable name="start-time" select="contentdata/start-time"/>
        <xsl:variable name="end-date" select="contentdata/end-date"/>
        <xsl:variable name="end-time" select="contentdata/end-time"/>
        <div class="date">
            <span class="day">
                <xsl:value-of select="day-from-date(xs:date($start-date))"/>
            </span>
            <span class="month">
                <xsl:value-of select="format-date(xs:date($start-date), '[MN,*-3]', $fw:language, (), ())"/>
            </span>
        </div>
        <h1>
            <xsl:value-of select="title"/>
        </h1>
        <p class="preface clear" id="time-location">
            <strong>
                <xsl:value-of select="concat(portal:localize('When'), ': ')"/>
            </strong>
            <xsl:variable name="date">
                <xsl:value-of select="$start-date"/>
                <xsl:if test="$start-time != ''">
                    <xsl:value-of select="concat(' ', $start-time)"/>
                </xsl:if>
            </xsl:variable>
            <xsl:value-of select="util:time.format-date($date, $fw:language, (), true())"/>
            <xsl:if test="$end-date &gt; $start-date or $end-time != ''">
                <xsl:text> -</xsl:text>
                <xsl:if test="$end-date &gt; $start-date">
                    <xsl:value-of select="concat(' ', util:time.format-date($end-date, $fw:language, (), ()))"/>
                </xsl:if>
                <xsl:if test="$end-time != ''">
                    <xsl:value-of select="concat(' ', util:time.format-time($end-time, $fw:language))"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="contentdata/location != ''">
                <br/>
                <strong>
                    <xsl:value-of select="concat(' ', portal:localize('Where'), ': ')"/>
                </strong>
                <xsl:value-of select="contentdata/location"/>
            </xsl:if>
        </p>
        <xsl:choose>
            <xsl:when test="$fw:device-class = 'mobile'">
                <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]">
                    <div class="related">
                        <div class="image">
                            <xsl:call-template name="util:image.display">
                                <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image[1]/image/@key]"/>
                                <xsl:with-param name="size" select="'full'"/>
                            </xsl:call-template>
                            <xsl:value-of select="contentdata/image[position() = 1 and image/@key = /result/contents/relatedcontents/content/@key]/image_text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="related-content">
                    <xsl:with-param name="size" select="'regular'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="contentdata/preface">
            <p class="preface">
                <xsl:value-of disable-output-escaping="yes" select="replace(contentdata/preface, '\n', '&lt;br /&gt;')"/>
            </p>
        </xsl:if>
        <xsl:call-template name="util:html.process">
            <xsl:with-param name="document" select="contentdata/text"/>
            <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
        </xsl:call-template>
        <xsl:if test="$fw:device-class = 'mobile'">
            <xsl:call-template name="related-content">
                <xsl:with-param name="size" select="'full'"/>
                <xsl:with-param name="start" select="2"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="related-content">
        <xsl:param name="size"/>
        <xsl:param name="start" select="1"/>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[position() &gt;= $start]/image/@key] or contentdata/link/url != '' or /result/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key] or /result/contents/relatedcontents/content[@key = current()/contentdata/file/file/file/@key] or /result/contents/relatedcontents/content[@key = current()/contentdata/events/content/@key]">
            <div class="related">
                <xsl:if test="not($fw:device-class = 'mobile')">
                    <xsl:attribute name="style">
                        <xsl:value-of select="concat('width: ', floor($fw:region-width * $fw:config-imagesize[@name = $size]/width), 'px;')"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image[position() &gt;= $start]/image/@key]">
                    <xsl:for-each select="contentdata/image[position() &gt;= $start and image/@key = /result/contents/relatedcontents/content/@key]">
                        <div class="image">
                            <xsl:call-template name="util:image.display">
                                <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/image/@key]"/>
                                <xsl:with-param name="size" select="$size"/>
                            </xsl:call-template>
                            <xsl:value-of select="image_text"/>
                        </div>
                        <xsl:call-template name="util:image.generate-url">
                            <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/image/@key]"/>
                        </xsl:call-template> 
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="contentdata/link/url != ''">
                    <h4>
                        <xsl:value-of select="portal:localize('Related-links')"/>
                    </h4>
                    <ul>
                        <xsl:for-each select="contentdata/link[url != '']">
                            <li>
                                <a href="{url}">
                                    <xsl:if test="target = 'new'">
                                        <xsl:attribute name="rel">external</xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="if (description != '') then description else url"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key]">
                    <h4>
                        <xsl:value-of select="portal:localize('Related-articles')"/>
                    </h4>
                    <ul>
                        <xsl:for-each select="contentdata/articles/content[@key = /result/contents/relatedcontents/content/@key]">
                            <xsl:variable name="current-article" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
                            <li>
                                <a href="{portal:createContentUrl($current-article/@key, ())}">
                                    <xsl:value-of select="$current-article/title"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/file/file/file/@key]">
                    <h4>
                        <xsl:value-of select="portal:localize('Related-files')"/>
                    </h4>
                    <ul>
                        <xsl:for-each select="contentdata/file/file/file[@key = /result/contents/relatedcontents/content/@key]">
                            <xsl:variable name="current-file" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
                            <li>
                                <a href="{portal:createBinaryUrl($current-file/contentdata/binarydata/@key, ('download', 'true'))}">
                                    <xsl:call-template name="util:file.icon-image">
                                        <xsl:with-param name="file-name" select="$current-file/title"/>
                                        <xsl:with-param name="icon-folder-path" select="concat($fw:theme-public, '/images')"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="$current-file/title"/>
                                </a>
                                <xsl:value-of select="concat(' (', util:file.format-bytes($current-file/binaries/binary/@filesize), ')')"/>
                                <xsl:if test="$current-file/contentdata/description != ''">
                                    <br/>
                                    <xsl:value-of select="util:text.crop($current-file/contentdata/description, 200)"/>
                                </xsl:if>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/events/content/@key]">
                    <h4>
                        <xsl:value-of select="portal:localize('Related-events')"/>
                    </h4>
                    <ul>
                        <xsl:for-each select="contentdata/events/content[@key = /result/contents/relatedcontents/content/@key]">
                            <xsl:variable name="current-event" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
                            <li>
                                <a href="{portal:createContentUrl($current-event/@key, ())}">
                                    <xsl:value-of select="$current-event/title"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
