<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:include href="/libraries/utilities/frame.xsl"/>
    
    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="frame-heading"/>
    <xsl:param name="flickr-user-nsid" select="'24246873@N00'"/>
    <xsl:param name="number-of-items" select="3"/>

    <xsl:variable name="feed-url" select="concat('http://pipes.yahoo.com/pipes/pipe.run?_id=42fdb222e772e97d4c7545a36fbf5609&amp;_render=rss&amp;nsid=', $flickr-user-nsid, '&amp;max=', $number-of-items)"/>

    <xsl:template match="/">
        <xsl:variable name="id" select="concat('flickr-gallery-', /result/context/resource/@key, /result/context/window/portlet/@key)"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/modules/flickr-gallery/scripts/flickr-gallery.js')}"/>
        <div class="feed-info">
            <h4>
                <xsl:value-of select="/result/rss/channel/title"/>
            </h4>
            <xsl:choose>
                <xsl:when test="contains(/result/rss/channel/pubDate, ' +')">
                    <xsl:value-of select="substring-before(/result/rss/channel/pubDate, ' +')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/result/rss/channel/pubDate"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <ul class="flickr-gallery" id="{$id}">
            <li class="system"/>
            <li class="navigation">
                <a href="{portal:createWindowUrl(('url', $feed-url))}" rel="1" class="show-more">
                    <xsl:value-of select="portal:localize('Show-more')"/>
                </a>
                <a href="#" class="show-list selected">
                    <xsl:value-of select="portal:localize('List')"/>
                </a>
                <a href="#" class="show-slideshow">
                    <xsl:value-of select="portal:localize('Slideshow')"/>
                </a>
                <a href="#" class="prev-image" rel="0">
                    <xsl:value-of select="portal:localize('Previous')"/>
                </a>
                <a href="#" class="next-image">
                    <xsl:value-of select="portal:localize('Next')"/>
                </a>
            </li>
        </ul>
        <script type="text/javascript">
            <xsl:comment>
                $(function () {
                    <xsl:value-of select="concat('feedList = &quot;#', $id, '&quot;;')"/>
                    <xsl:value-of select="concat('feedUrl = &quot;', portal:createWindowUrl(('url', $feed-url)), '&quot;;')"/>
                    loadFeedImages(feedList, feedUrl);
                });
            //</xsl:comment>
        </script>
    </xsl:template>
    
</xsl:stylesheet>
