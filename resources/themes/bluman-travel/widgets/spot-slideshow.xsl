<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:util="enonic:utilities"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="spot-slideshow-jquery-scripts">
        <script  type="text/javascript">
            $(document).ready(function() {
                var currentSlide = 1;
                var totalSlides =  $('figure').size();
                var backgroundslideshow = 0;

                function runSlideshow(){
                    cssTransitionsAvailable = $('html').hasClass('csstransitions');
                    if (cssTransitionsAvailable){
                        slideshowTransitions();
                    }else{
                        slideshowAnimation();
                    }
                }
                function slideshowTransitions(){
                    crossFadeCurrentAndNextSlide();
                    if (totalSlides>1){
                        backgroundSlideshow = setTimeout(slideshowTransitions, 5000);
                    }
                }
                function slideshowAnimation(){
                    console.log('slideshow animation with javascript not implemented');
                }
                function crossFadeCurrentAndNextSlide(){
                    $("figure:eq(0)")
                    $('figure:nth-of-type(currentslide),figcaption:nth-of-type(currentslide)').toggleClass("transparent");
                    currentSlide++;
                    if (currentSlide>totalSlides){currentSlide = 1;}
                    $('figure:nth-of-type(currentslide),figcaption:nth-of-type(currentslide)').toggleClass("transparent");
                }
                runSlideshow();
            });
        </script>
    </xsl:template>

    <xsl:template name="spot-slideshow">
        <xsl:param name="slideshow-images" select="/result/slideshow-images" as="element()*"/>
        <xsl:if test="exists($slideshow-images)">
            <div id="slideshow-images">
                <xsl:for-each select="$slideshow-images/contents/content">
                    <xsl:choose>
                        <xsl:when test="/result/context/resource/type='Spot' and current()/@key = /result/context/resource/@key">
                            <xsl:call-template name="slideshow-image">
                                <xsl:with-param name="images" select="contentdata/image" />
                                <xsl:with-param name="location" select="display-name" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="slideshow-image">
                                <xsl:with-param name="images" select="contentdata/image[1]" />
                                <xsl:with-param name="location" select="display-name" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:call-template name="spot-slideshow-jquery-scripts" />
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="slideshow-image">
        <xsl:param name="location" />
        <xsl:param name="images" />
        <xsl:for-each select="$images">
            <figure class="slideshow-image transparent" style="background-image: url('{portal:createImageUrl(image/@key, 'scalewidth(1200)','','jpg','50')}')">
                <figcaption class="slideshow-image-info transparent">
                    <ul>
                        <xsl:if test="$location"><li><xsl:value-of select="$location" /></li></xsl:if>
                        <li><xsl:value-of select="image_text" /></li>
                    </ul>
                </figcaption>
            </figure>
        </xsl:for-each>
    </xsl:template>

            <!--
            <script  type="text/javascript">
                $(document).ready(function(){

                    Array.prototype.shuffle = function() {
                        var s = [];
                        while (this.length) s.push(this.splice(Math.random() * this.length, 1)[0]);
                        while (s.length) this.push(s.pop());
                        return this;
                    }

                    var images=new Array();
                    var imageId;
                    var imageUrl;

                    <xsl:if test="/result/background-images/contents/relatedcontents/content[@contenttype='Image']">
                        <xsl:for-each select="/result/background-images/contents/relatedcontents/content[@contenttype='Image'] ">
                            imageUrl = "<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                            imageId = imageUrl.substring(imageUrl.lastIndexOf('=')+1);
                            $('#footer').append('<figcaption class="photo-info transparent" rel="tempId">"<xsl:value-of select="display-name" />"<xsl:if test="not(contentdata/photographer/@name='')"> by <xsl:value-of select="contentdata/photographer/@name" /></xsl:if></figcaption>');
                            $('figcaption[rel="tempId"]').attr("id",imageId);
                            images[<xsl:value-of select="position()-1"/>] = imageUrl;
                        </xsl:for-each>
                        runSlideshow(images.shuffle());

                    </xsl:if>
                    <xsl:if test="/result/background-images/contents/relatedcontents/content[@contenttype='Image']">
                        <xsl:choose>
                            <xsl:when test="/result/context/resource/type='Spot'">
                                <xsl:variable name="resourceKey" select="/result/context/resource/@key" />
                                <xsl:for-each select="/result/background-images/contents/content[@contenttype='Spot' and @key = $resourceKey]" >
                                    <xsl:for-each select="relatedcontentkeys/relatedcontentkey[@contenttype='Image']">
                                         <xsl:choose>
                                            <xsl:when test="$device-class = 'mobile'">
                                                imageUrl = "<xsl:value-of select="portal:createImageUrl(current()/@key, 'scaleblock(320, 480)','','jpg','50')" />";
                                            </xsl:when>
                                            <xsl:otherwise>
                                                imageUrl = "<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        imageId = imageUrl.substring(imageUrl.lastIndexOf('=')+1);
                                       <xsl:for-each select="/result/background-images/contents/relatedcontents/content[@contenttype='Image' and @key = current()/@key]">
                                            $('#footer').append('<figcaption class="photo-info transparent" rel="tempId">"<xsl:value-of select="display-name" />"<xsl:if test="not(contentdata/photographer/@name='')"> by <xsl:value-of select="contentdata/photographer/@name" /></xsl:if></figcaption>');
                                            $('figcaption[rel="tempId"]').attr("id",imageId);
                                        </xsl:for-each>
                                        images[<xsl:value-of select="position()-1"/>] = imageUrl;
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="/result/background-images/contents/relatedcontents/content[@contenttype='Image'] ">
                                     <xsl:choose>
                                        <xsl:when test="$device-class = 'mobile'">
                                            imageUrl = "<xsl:value-of select="portal:createImageUrl(current()/@key, 'scaleblock(320, 800)','','jpg','50')" />";
                                        </xsl:when>
                                        <xsl:otherwise>
                                            imageUrl = "<xsl:value-of select="portal:createImageUrl(current()/@key, 'scalewidth(1200)','','jpg','50')" />";
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    imageId = imageUrl.substring(imageUrl.lastIndexOf('=')+1);
                                    $('#footer').append('<figcaption class="photo-info transparent" rel="tempId">"<xsl:value-of select="display-name" />" <xsl:if test="not(contentdata/photographer/@name='')"> by <xsl:value-of select="contentdata/photographer/@name" /></xsl:if></figcaption>');
                                    $('figcaption[rel="tempId"]').attr("id",imageId);
                                    images[<xsl:value-of select="position()-1"/>] = imageUrl;
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                        runSlideshow(images.shuffle());
                    </xsl:if>
                });
            </script>
            -->
</xsl:stylesheet>