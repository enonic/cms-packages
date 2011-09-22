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
        <xsl:call-template name="jquery-scripts" />
        <xsl:if test="/result/spot-images/contents/content[@contenttype='Image']">
            <div class="spot-thumbnails">
                <ul id="sdt_menu" class="sdt_menu">
                    <xsl:apply-templates select="/result/spot-images/contents/content[@contenttype='Image']" mode="spot-thumbnails"/>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="content" mode="spot-thumbnails">
           <li class="spot-thumbnail">
                    <span>
                        <span>
                            <img id="{@key}" onclick="changeBkg('{portal:createImageUrl(@key, '')}')" class="image-spot-thumbnail" alt="{title}" src="{portal:createImageUrl(@key, 'scalesquare(85)')}" />
                            <img id="{@key}big" style="visibility:hidden" alt="" src="{portal:createImageUrl(@key,'')}" />
                        </span>
                    </span>
            </li>
    </xsl:template>

    <xsl:template name="jquery-scripts">
        <script type="text/javascript">
            function changeBkg(url){
                $('.bg').each(function(){
                    if ($(this).attr('id')!='bg1'){
                        $(this).remove();
                    }
                    $('#bg1').attr("src",url);
                    $('#bg1').css({opacity: 0.0, visibility: "visible"}).animate({opacity: 1.0}, 3500);
                });
            }
        </script>
    </xsl:template>
</xsl:stylesheet>
