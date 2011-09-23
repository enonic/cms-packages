<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="rdf purl saxon xs" version="2.0"
    xmlns:purl="http://purl.org/rss/1.0/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="xmlProxy">
        <type>page</type>
    </xsl:param>    
    
    <xsl:param name="flickrUserNSID" select="'24246873@N00'"/>
    <xsl:param name="flickrPhotosetID"/>
    <xsl:param name="numOfItems" select="'3'"/>
    
    <xsl:variable name="feedUrl">
        <xsl:choose>
            <xsl:when test="string-length($flickrPhotosetID) gt 0">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('http://pipes.yahoo.com/pipes/pipe.run?_id=42fdb222e772e97d4c7545a36fbf5609&amp;_render=rss&amp;nsid=', $flickrUserNSID, '&amp;max=', $numOfItems)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        
        <div class="socialPhotos">
            <h2>Photo gallery - flickr</h2>
            <ul class="list" id="{concat('socialPhotosList', /verticaldata/context/portlet-window/portlet/@key)}">
                <li class="system"></li>
                <li class="navigation">                    
                    <a href="{portal:createPageUrl($xmlProxy, ('url', $feedUrl))}" rel="1" class="showMore">Show more</a>
                    <a href="#" class="showList selected">Liste</a>
                    <a href="#" class="showSlideshow">Slideshow</a>
                    <a href="#" class="prevImage" rel="0">Prev</a>
                    <a href="#" class="nextImage">Next</a>
                </li>
                <li class="feedInfo"></li>
            </ul>
        </div>        
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/modules/flickr-gallery/scripts/flickr-gallery.js')}"/>
        <script type="text/javascript">   
            <xsl:comment>
                $(function () {
                    feedList = '<xsl:value-of select="concat('#socialPhotosList', /verticaldata/context/portlet-window/portlet/@key)"/>';
                    feedUrl = '<xsl:value-of select="portal:createPageUrl($xmlProxy, ('url', $feedUrl))"/>';
                    loadFeedImages(feedList, feedUrl);
                });
            //</xsl:comment>
        </script>

    </xsl:template>
</xsl:stylesheet>
