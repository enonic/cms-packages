<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:purl="http://purl.org/rss/1.0/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:include href="/modules/library-stk/utilities/frame.xsl"/>
    
    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="heading"/>
    <xsl:param name="feed-url" select="'http://www.enonic.com/rss'"/>
    <xsl:param name="show-feed-information" select="true()" as="xs:boolean"/>
    
    <xsl:variable name="feed-provider">
        <xsl:choose>
            <xsl:when test="matches(lower-case($feed-url), 'delicious')">delicious</xsl:when>
            <xsl:when test="matches(lower-case($feed-url), 'twitter')">twitter</xsl:when>
            <xsl:when test="matches(lower-case($feed-url), 'digg')">digg</xsl:when>
            <xsl:when test="matches(lower-case($feed-url), 'facebook')">facebook</xsl:when>
            <xsl:when test="matches(lower-case($feed-url), 'audioscrobbler')">lastfm</xsl:when>
            <xsl:when test="matches(lower-case($feed-url), 'stumbleupon')">stumbleupon</xsl:when>
            <xsl:otherwise>rss</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="count">
        <xsl:choose>
            <xsl:when test="/result/context/querystring/parameter[@name = 'count'] != ''">
                <xsl:value-of select="/result/context/querystring/parameter[@name = 'count']"/>
            </xsl:when>
            <xsl:otherwise>5</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:variable name="id" select="concat('feed-list-', /result/context/resource/@key, /result/context/window/portlet/@key)"/>
        <xsl:variable name="content">
            <script type="text/javascript">
                <xsl:comment>
                    
                    $(function () {
                        
                        var count = 5;
                            
                        function reloadFeed(fadeIn) {
                            <xsl:value-of select="concat('$.get(&quot;', portal:createWindowUrl(('url', $feed-url)), '&amp;count=&quot; + count, function(data){')"/>
                                <xsl:value-of select="concat('$(&quot;#', $id, ' .feed&quot;).html($(data).find(&quot;.feed&quot;).html());')"/>
                                <xsl:value-of select="concat('if (fadeIn) $(&quot;#', $id, ' .feed&quot;).hide().fadeIn(1500);')"/>
                            });
                        }
                                
                        <xsl:value-of select="concat('$(&quot;#', $id, ' a.tool.refresh&quot;).click(function (event) {')"/>
                            event.preventDefault();
                            reloadFeed(true);
                        });
                                
                        <xsl:value-of select="concat('$(&quot;#', $id, ' a.tool.expand, #', $id, ' a.tool.collapse&quot;).click(function (event) {')"/>
                            event.preventDefault();
                            if ($(this).hasClass('expand')) {
                                count = 20;
                                <xsl:value-of select="concat('$(this).attr(&quot;title&quot;, &quot;', portal:localize('Collapse'), '&quot;);')"/>
                            } else {
                                count = 5;
                                <xsl:value-of select="concat('$(this).attr(&quot;title&quot;, &quot;', portal:localize('Expand'), '&quot;);')"/>
                            }
                            $(this).toggleClass('collapse').toggleClass('expand');
                            reloadFeed();
                        });
                                        
                        <xsl:value-of select="concat('$(&quot;#', $id, ' a.tool.refresh&quot;).trigger(&quot;click&quot;)')"/>
                        
                    });
                    
                //</xsl:comment>
            </script>
            <div class="feed">
                <xsl:apply-templates select="/result/rdf:RDF | /result/rss/channel"/>
            </div>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$include-frame">
                <xsl:call-template name="frame.frame">
                    <xsl:with-param name="content" select="$content"/>
                    <xsl:with-param name="frame-heading" select="$heading"/>
                    <xsl:with-param name="frame-id" select="$id"/>
                    <xsl:with-param name="frame-tools" select="'refresh','expand'"/>
                    <xsl:with-param name="frame-icon" select="$feed-provider"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <div id="{$id}">
                    <a href="#" class="tool refresh" title="{portal:localize('Refresh')}"/>
                    <a href="#" class="tool expand" title="{portal:localize('Expand')}"/>
                    <xsl:if test="$heading != ''">
                        <h1>
                            <xsl:value-of select="$heading"/>
                        </h1>
                    </xsl:if>
                    <xsl:copy-of select="$content"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="channel | rdf:RDF">
        <xsl:if test="$show-feed-information and (title != '' or image/url != '' or description != '')">
            <div class="feed-info">
                <xsl:if test="image/url != '' or purl:image/purl:url != ''">
                    <xsl:choose>
                        <xsl:when test="image/link != '' or purl:image/purl:link != ''">
                            <a href="{image/link | purl:image/purl:link}" rel="external">
                                <img src="{image/url | purl:image/purl:url}" alt="{image/title | purl:image/purl:title}"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <img src="{image/url | purl:image/purl:url}" alt="{image/title | purl:image/purl:title}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="title != '' or purl:channel/purl:title != ''">
                    <h4>
                        <xsl:choose>
                            <xsl:when test="link != '' or purl:channel/purl:link != ''">
                                <a href="{link | purl:channel/purl:link}" rel="external">
                                    <xsl:value-of select="title | purl:channel/purl:title"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="title | purl:channel/purl:title"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </h4>
                </xsl:if>
                <xsl:if test="description !='' or purl:channel/purl:description !=''">
                    <p>
                        <xsl:value-of select="description | purl:channel/purl:description"/>
                    </p>
                </xsl:if>
            </div>
        </xsl:if>
        <div class="list clear clearfix">
            <xsl:apply-templates select="item[position() &lt;= $count] | purl:item[position() &lt;= $count]"/>            
        </div>
    </xsl:template>
    
    <xsl:template match="item | purl:item">
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <h5>
                <a href="{link | purl:link}" rel="external">
                    <xsl:value-of select="title | purl:title"/>
                </a>
            </h5>
            <xsl:if test="not(contains('delicious|stumbleupon', $feed-provider)) and pubDate != ''">
                <xsl:choose>
                    <xsl:when test="contains(pubDate, ' +')">
                        <xsl:value-of select="substring-before(pubDate, ' +')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="pubDate"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="(description != '' or purl:description != '') and not(contains('twitter|lastfm|stumbleupon', $feed-provider))">
                <div class="description">
                    <xsl:value-of select="description | purl:description" disable-output-escaping="yes"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
