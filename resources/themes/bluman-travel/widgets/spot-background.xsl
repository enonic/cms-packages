<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:util="enonic:utilities"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="../../../libraries/utilities/standard-variables.xsl"/>

    <xsl:template match="/">
        <div id="background1">'</div>
        <div id="background2">'</div>
        <script  type="text/javascript">
            $("div").scroll(function() {
            });
            Array.prototype.shuffle = function() {
                var s = [];
                while (this.length) s.push(this.splice(Math.random() * this.length, 1)[0]);
                while (s.length) this.push(s.pop());
                return this;
            }
        </script>
        <xsl:if test="/result/travelinfo-background-images/contents/relatedcontents/content[@contenttype='Image']">
            <script  type="text/javascript">
                $(document).ready(function(){
                    var images=new Array();
                    <xsl:for-each select="/result/travelinfo-background-images/contents/relatedcontents/content[@contenttype='Image'] ">
                        images[<xsl:value-of select="position()-1"/>] ="<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                    </xsl:for-each>
                    runSlideshow(images.shuffle());
                });
            </script>
        </xsl:if>
        <xsl:if test="/result/slideshow-images-spot/contents/relatedcontents/content[@contenttype='Image']">
            <script  type="text/javascript">
                $(document).ready(function(){
                    var images=new Array();
                    <xsl:choose>
                        <xsl:when test="/result/context/resource/type='Spot'">
                            <xsl:variable name="resourceKey" select="/result/context/resource/@key" />
                            <xsl:for-each select="/result/slideshow-images-spot/contents/content[@contenttype='Spot' and @key = $resourceKey]" >
                                <xsl:for-each select="relatedcontentkeys/relatedcontentkey[@contenttype='Image']">
                                    images[<xsl:value-of select="position()-1"/>] ="<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/result/slideshow-images-spot/contents/relatedcontents/content[@contenttype='Image'] ">
                                images[<xsl:value-of select="position()-1"/>] ="<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    runSlideshow(images.shuffle());
                });
            </script>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>