<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:util="enonic:utilities"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="spot-slideshow-jquery-scripts">
        <script  type="text/javascript">
            $(document).ready(function() {
                var currentSlide = 1;
                var totalSlides =  $('.slideshow-image').size();
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
                    backgroundSlideshow = setTimeout(slideshowTransitions, 8000);
                }
                function slideshowAnimation(){
                    console.log('slideshow animation with javascript not implemented');
                }
                function crossFadeCurrentAndNextSlide(){
                    toggleTransparency(currentSlide);
                    increaseOrResetCurrentSlide();
                    toggleTransparency(currentSlide);
                }
                function toggleTransparency(){
                    $("#slideshow-image-"+currentSlide).toggleClass("transparent");
                }
                function increaseOrResetCurrentSlide(){
                    if (currentSlide==totalSlides){
                        currentSlide = 1;
                    }else {
                        currentSlide++;
                    }
                }
                if (totalSlides>1){
                    backgroundSlideshow = setTimeout(runSlideshow, 8000);
                }
            });
        </script>
    </xsl:template>

    <xsl:template match="slideshow-images">
        <xsl:if test="exists(contents/content)">
            <div id="slideshow-images">
                <xsl:for-each select="contents/content">
                    <xsl:choose>
                        <xsl:when test="/result/context/resource/type='Spot' and @key = /result/context/resource/@key">
                            <xsl:apply-templates select="contentdata/image" mode="spot-images">
                                <xsl:with-param name="spot-name" select="display-name" />
                                <xsl:with-param name="spot-key" select="@key" />
                                <xsl:with-param name="position" />
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="contentdata/image[1]" mode="spot-images">
                                <xsl:with-param name="spot-name" select="display-name" />
                                <xsl:with-param name="spot-key" select="@key" />
                                <xsl:with-param name="position" select="position()" />
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:call-template name="spot-slideshow-jquery-scripts" />
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="image" mode="spot-images">
        <xsl:param name="spot-name" />
        <xsl:param name="spot-key" />
        <xsl:param name="position" />
        <xsl:for-each select="/result/slideshow-images/contents/relatedcontents/content[@contenttype='Image' and @key = current()/image/@key]">
            <figure style="background-image: url('{portal:createImageUrl(@key, 'scalewidth(1200)','','jpg','50')}')">
                <xsl:attribute name="id">
                    <xsl:text>slideshow-image-</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$position">
                            <xsl:value-of select="$position"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="position()" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:if test="($position and not($position=1)) or (not($position) and not(position()=1))">
                        <xsl:text>transparent </xsl:text>
                    </xsl:if>
                    <xsl:text>slideshow-image</xsl:text>
                </xsl:attribute>
                <figcaption class="slideshow-image-info">
                    "<xsl:value-of select="contentdata/name" />"<xsl:text>, </xsl:text>
                    <xsl:if test="$spot-name">
                        <a href="{portal:createContentUrl($spot-key, ())}"><xsl:value-of select="$spot-name" /></a>
                    </xsl:if>
                    <xsl:if test="contentdata/photographer/@name and not(contentdata/photographer/@name='')">
                        <xsl:text> by </xsl:text>
                        <xsl:value-of select="contentdata/photographer/@name" />
                    </xsl:if>
                </figcaption>
            </figure>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>