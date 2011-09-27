<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:util="enonic:utilities"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:math="http://exslt.org/math"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="../../../libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="../../../libraries/utilities/utilities.xsl"/>
    <xsl:include href="../../../libraries/utilities/frame.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <div id="spot-thumbnails">
            <xsl:if test="/result/spot-images/contents/content[@contenttype='Image']">
                <div class="spot-thumbnails">
                    <ul id="sdt_menu" class="sdt_menu">
                        <xsl:apply-templates select="/result/spot-images/contents/content[@contenttype='Image']" mode="spot-thumbnails"/>
                    </ul>
                </div>
            </xsl:if>
        </div>
        <xsl:call-template name="jquery-scripts" />
    </xsl:template>
    <xsl:template match="content" mode="spot-thumbnails">
           <li class="spot-thumbnail">
                <figure>
                    <img id="{@key}" onclick="changeBkg('{portal:createImageUrl(@key, '')}')" class="image-spot-thumbnail" alt="{title}" src="{portal:createImageUrl(@key, 'scalesquare(36)')}" />
                </figure>
            </li>
            <xsl:if test="position()=1">
                <input type="hidden" id="backgroundImage" value="{portal:createImageUrl(@key, '')}" />
            </xsl:if>
    </xsl:template>

    <xsl:template name="jquery-scripts">
        <script type="text/javascript">
            $(document).ready(function(){
                changeBkg($('#backgroundImage').val());
            });
            function changeBkg(url){
                $('#background').css("background-image",'url('+url+')');
                $('#background').css("background-size",'cover');
            }
        </script>
    </xsl:template>
</xsl:stylesheet>
