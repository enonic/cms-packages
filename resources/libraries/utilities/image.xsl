<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">

    <!-- Display image template -->
    <xsl:template name="util:image.display">
        <xsl:param name="image" as="element()"/><!-- Image content node -->
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="background" as="xs:string?"/>
        <xsl:param name="title" as="xs:string?" select="$image/title"/>
        <xsl:param name="alt" as="xs:string" select="if ($image/contentdata/description != '') then $image/contentdata/description else $image/title"/>
        <xsl:param name="class" as="xs:string?"/>
        <xsl:param name="style" as="xs:string?"/>
        <xsl:param name="id" as="xs:string?"/>
        <xsl:param name="format" as="xs:string?" select="$fw:default-image-format"/>
        <xsl:param name="quality" as="xs:integer?" select="$fw:default-image-quality"/>
        <xsl:param name="region-width" as="xs:integer" select="$fw:region-width"/>
        <xsl:param name="filter" as="xs:string?" select="$fw:config-filter"/><!-- Custom image filters -->
        <xsl:param name="imagesize" as="element()*" select="$fw:config-imagesize"/><!-- Rel image size config -->
        <xsl:variable name="width" select="util:image-size($region-width, $imagesize, $size, (), $filter, $image, ())"/>
        <xsl:variable name="height" select="util:image-size($region-width, $imagesize, $size, (), $filter, $image, 'height')"/>
        
        <img alt="{$alt}">
            <xsl:attribute name="src">
                <xsl:call-template name="util:image.generate-url">
                    <xsl:with-param name="image" select="$image"/>
                    <xsl:with-param name="size" select="$size"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="quality" select="$quality"/>
                    <xsl:with-param name="region-width" select="$region-width"/>
                    <xsl:with-param name="filter" select="$filter"/>
                    <xsl:with-param name="imagesize" select="$imagesize"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:if test="$title">
                <xsl:attribute name="title">
                    <xsl:value-of select="$title"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$width">
                <xsl:attribute name="width">
                    <xsl:value-of select="$width"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
                <xsl:attribute name="height">
                    <xsl:value-of select="$height"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$class != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="$class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$style != ''">
                <xsl:attribute name="style">
                    <xsl:value-of select="$style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$id != ''">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>
    
    <!-- Display image template -->
    <xsl:template name="util:image.generate-url">
        <xsl:param name="image" as="element()"/><!-- Image content node -->
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="background" as="xs:string?"/>
        <xsl:param name="format" as="xs:string?" select="$fw:default-image-format"/>
        <xsl:param name="quality" as="xs:integer?" select="$fw:default-image-quality"/>
        <xsl:param name="region-width" as="xs:integer" select="$fw:region-width"/>
        <xsl:param name="filter" as="xs:string?" select="$fw:config-filter"/><!-- Custom image filters -->
        <xsl:param name="imagesize" as="element()*" select="$fw:config-imagesize"/><!-- Rel image size config -->
        
        <xsl:variable name="width" select="util:image-size($region-width, $imagesize, $size, (), $filter, $image, ())"/>
        <xsl:variable name="height" select="util:image-size($region-width, $imagesize, $size, (), $filter, $image, 'height')"/>
        <xsl:value-of select="portal:createImageUrl(util:image-attachment-key($image/@key, $region-width, $imagesize, $size, (), $filter, $image), util:image-filter($region-width, $imagesize, $size, (), $filter), $background, $format, $quality)"/>
    </xsl:template>


    <!-- Returns final image filter as xs:string? -->
    <xsl:function name="util:image-filter" as="xs:string?">
        <xsl:param name="region-width" as="xs:integer"/>
        <xsl:param name="imagesize" as="element()*"/>
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="url-filter" as="xs:string?"/>
        <xsl:param name="filter" as="xs:string?"/>
        <xsl:variable name="selected-imagesize" select="$imagesize[@name = $size]"/>
        <xsl:variable name="final-filter">
            <xsl:choose>
                <!-- If custom image size definitions exists -->
                <xsl:when test="$selected-imagesize">
                    <!-- Supports all scale filters -->
                    <xsl:variable name="first-filter-parameter">
                        <xsl:choose>
                            <xsl:when test="$selected-imagesize/filter = 'scaleheight'">
                                <xsl:value-of select="$selected-imagesize/height"/>
                            </xsl:when>
                            <xsl:when test="$selected-imagesize/filter = 'scalemax' or $selected-imagesize/filter = 'scalesquare'">
                                <xsl:value-of select="$selected-imagesize/size"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$selected-imagesize/width"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="concat($selected-imagesize/filter, '(', floor($region-width * $first-filter-parameter))"/>
                    <xsl:if test="$selected-imagesize/filter = 'scalewide' and $selected-imagesize/height != ''">
                        <xsl:value-of select="concat(',', floor($region-width * $selected-imagesize/height))"/>
                        <xsl:if test="$selected-imagesize/offset != ''">
                            <xsl:value-of select="concat(',', $selected-imagesize/offset)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:text>);</xsl:text>
                </xsl:when>
                <!-- If no custom image size definitions exists default sizes are used -->
                <xsl:when test="$size = 'full'">
                    <xsl:value-of select="concat('scalewidth(', util:size-by-default-ratio($region-width, $size), ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'wide'">
                    <xsl:value-of select="concat('scalewide(', util:size-by-default-ratio($region-width, 'wide-width'), ',', util:size-by-default-ratio($region-width, 'wide-height'), ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'regular'">
                    <xsl:value-of select="concat('scalewidth(', util:size-by-default-ratio($region-width, $size), ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'list'">
                    <xsl:value-of select="concat('scalewidth(', util:size-by-default-ratio($region-width, $size), ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'square'">
                    <xsl:value-of select="concat('scalesquare(', util:size-by-default-ratio($region-width, $size), ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'thumbnail'">
                    <xsl:value-of select="concat('scalesquare(', util:size-by-default-ratio($region-width, $size),');')"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="$url-filter != ''">
                <xsl:value-of select="concat($url-filter, ';')"/>
            </xsl:if>
            <xsl:if test="$filter != ''">
                <xsl:value-of select="$filter"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$final-filter"/>
    </xsl:function>
    
    <!-- Returns final image width or height as xs:integer? -->
    <xsl:function name="util:image-size" as="xs:integer?">
        <xsl:param name="region-width" as="xs:integer"/>
        <xsl:param name="imagesize" as="element()*"/>
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="url-filter" as="xs:string?"/>
        <xsl:param name="filter" as="xs:string?"/>
        <xsl:param name="source-image" as="element()?"/>
        <xsl:param name="dimension" as="xs:string?"/>
        <xsl:variable name="selected-imagesize" select="$imagesize[@name = $size]"/>
        <xsl:variable name="source-image-size" as="xs:integer*" select="$source-image/contentdata/sourceimage/@width, $source-image/contentdata/sourceimage/@height"/>
        <xsl:variable name="final-image-size" as="xs:double*">
            <xsl:choose>
                <!-- If custom scale filter applied. Possible weakness here; only the last scalefilter is taken into consideration -->
                <xsl:when test="contains($filter, 'scale')">
                    <xsl:variable name="last-scale-filter" select="tokenize($filter, ';')[contains(., 'scale')][position() = last()]"/>
                    <!-- Supports all scale filters -->
                    <xsl:choose>
                        <!-- Scaleheight -->
                        <xsl:when test="contains($last-scale-filter, 'scaleheight')">
                            <xsl:sequence select="util:calculate-size($source-image-size, (), xs:integer(tokenize($last-scale-filter, '\(|\)')[2])), xs:integer(tokenize($last-scale-filter, '\(|\)')[2])"/>
                        </xsl:when>
                        <!-- Scalemax -->
                        <xsl:when test="contains($last-scale-filter, 'scalemax')">
                            <xsl:choose>
                                <xsl:when test="$source-image-size[1] &gt;= $source-image-size[2]">
                                    <xsl:sequence select="xs:integer(tokenize($last-scale-filter, '\(|\)')[2]), util:calculate-size($source-image-size, xs:integer(tokenize($last-scale-filter, '\(|\)')[2]), ())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="util:calculate-size($source-image-size, (), xs:integer(tokenize($last-scale-filter, '\(|\)')[2])), xs:integer(tokenize($last-scale-filter, '\(|\)')[2])"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- Scalesquare -->
                        <xsl:when test="contains($last-scale-filter, 'scalesquare')">
                            <xsl:sequence select="xs:integer(tokenize($last-scale-filter, '\(|\)')[2]), xs:integer(tokenize($last-scale-filter, '\(|\)')[2])"/>
                        </xsl:when>
                        <!-- Scalewide -->
                        <xsl:when test="contains($last-scale-filter, 'scalewide')">
                            <xsl:sequence select="xs:integer(tokenize($last-scale-filter, '\(|,|\)')[2])"/>
                            <xsl:choose>
                                <xsl:when test="util:calculate-size($source-image-size, xs:integer(tokenize($last-scale-filter, '\(|,|\)')[2]), ()) &lt;= xs:integer(normalize-space(tokenize($last-scale-filter, '\(|,|\)')[3]))">
                                    <xsl:sequence select="util:calculate-size($source-image-size, xs:integer(tokenize($last-scale-filter, '\(|,|\)')[2]), ())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="xs:integer(normalize-space(tokenize($last-scale-filter, '\(|,|\)')[3]))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- Scalewidth -->
                        <xsl:when test="contains($last-scale-filter, 'scalewidth')">
                            <xsl:sequence select="xs:integer(tokenize($last-scale-filter, '\(|\)')[2]), util:calculate-size($source-image-size, xs:integer(tokenize($last-scale-filter, '\(|\)')[2]), ())"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <!-- If custom image size selected -->
                <xsl:when test="$size = 'custom' and contains($url-filter, 'scalewidth')">
                    <xsl:sequence select="xs:integer(tokenize($url-filter, '\(|\)')[2]), util:calculate-size($source-image-size, xs:integer(tokenize($url-filter, '\(|\)')[2]), ())"/>
                </xsl:when>
                <!-- If custom image size definitions exists -->
                <xsl:when test="$selected-imagesize">
                    <!-- Supports all scale filters -->
                    <xsl:choose>
                        <!-- Scaleheight -->
                        <xsl:when test="$selected-imagesize/filter = 'scaleheight'">
                            <xsl:sequence select="util:calculate-size($source-image-size, (), floor($region-width * $selected-imagesize/height)), floor($region-width * $selected-imagesize/height)"/>
                        </xsl:when>
                        <!-- Scalemax -->
                        <xsl:when test="$selected-imagesize/filter = 'scalemax'">
                            <xsl:choose>
                                <xsl:when test="$source-image-size[1] &gt;= $source-image-size[2]">
                                    <xsl:sequence select="floor($region-width * $selected-imagesize/size), util:calculate-size($source-image-size, floor($region-width * $selected-imagesize/size), ())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="util:calculate-size($source-image-size, (), floor($region-width * $selected-imagesize/size)), floor($region-width * $selected-imagesize/size)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- Scalesquare -->
                        <xsl:when test="$selected-imagesize/filter = 'scalesquare'">
                            <xsl:sequence select="floor($region-width * $selected-imagesize/size), floor($region-width * $selected-imagesize/size)"/>
                        </xsl:when>
                        <!-- Scalewide -->
                        <xsl:when test="$selected-imagesize/filter = 'scalewide'">
                            <xsl:sequence select="floor($region-width * $selected-imagesize/width)"/>
                            <xsl:choose>
                                <xsl:when test="util:calculate-size($source-image-size, floor($region-width * $selected-imagesize/width), ()) &lt;= floor($region-width * $selected-imagesize/height)">
                                    <xsl:sequence select="util:calculate-size($source-image-size, floor($region-width * $selected-imagesize/width), ())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="floor($region-width * $selected-imagesize/height)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- Scalewidth -->
                        <xsl:when test="$selected-imagesize/filter = 'scalewidth'">
                            <xsl:sequence select="floor($region-width * $selected-imagesize/width), util:calculate-size($source-image-size, floor($region-width * $selected-imagesize/width), ())"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <!-- If no custom image size definitions exists default sizes are used -->
                <xsl:when test="$size = 'full'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, $size), util:calculate-size($source-image-size, util:size-by-default-ratio($region-width, $size), ())"/>
                </xsl:when>
                <xsl:when test="$size = 'wide'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, 'wide-width')"/>
                    <xsl:choose>
                        <xsl:when test="util:calculate-size($source-image-size, util:size-by-default-ratio($region-width, 'wide-width'), ()) &lt;= util:size-by-default-ratio($region-width, 'wide-height')">
                            <xsl:sequence select="util:calculate-size($source-image-size, util:size-by-default-ratio($region-width, 'wide-width'), ())"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="util:size-by-default-ratio($region-width, 'wide-height')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$size = 'regular'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, $size), util:calculate-size($source-image-size, util:size-by-default-ratio($region-width, $size), ())"/>
                </xsl:when>
                <xsl:when test="$size = 'list'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, $size), util:calculate-size($source-image-size, util:size-by-default-ratio($region-width, $size), ())"/>
                </xsl:when>
                <xsl:when test="$size = 'square'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, $size), util:size-by-default-ratio($region-width, $size)"/>
                </xsl:when>
                <xsl:when test="$size = 'thumbnail'">
                    <xsl:sequence select="util:size-by-default-ratio($region-width, $size), util:size-by-default-ratio($region-width, $size)"/>
                </xsl:when>
                <!-- Original image size -->
                <xsl:otherwise>
                    <xsl:sequence select="$source-image-size[1], $source-image-size[2]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$dimension = 'height' and $final-image-size[2]">
                <xsl:value-of select="$final-image-size[2]"/>
            </xsl:when>
            <xsl:when test="$final-image-size[1]">
                <xsl:value-of select="$final-image-size[1]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Returns final image attachment key as xs:string -->
    <xsl:function name="util:image-attachment-key" as="xs:string">
        <xsl:param name="key" as="xs:string"/>
        <xsl:param name="region-width" as="xs:integer"/>
        <xsl:param name="imagesize" as="element()*"/>
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="url-filter" as="xs:string?"/>
        <xsl:param name="filter" as="xs:string?"/>
        <xsl:param name="source-image" as="element()?"/>
        <xsl:variable name="image-width" select="util:image-size($region-width, $imagesize, $size, $url-filter, $filter, $source-image, ())"/>
        <xsl:variable name="attachment-key">
            <xsl:value-of select="$key"/>
            <xsl:choose>
                <xsl:when test="$image-width &lt;= 256 and $source-image/binaries/binary/@label = 'small'">/label/small</xsl:when>
                <xsl:when test="$image-width &lt;= 512 and $source-image/binaries/binary/@label = 'medium'">/label/medium</xsl:when>
                <xsl:when test="$image-width &lt;= 1024 and $source-image/binaries/binary/@label = 'large'">/label/large</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$attachment-key"/>
    </xsl:function>
    
    <!-- Returns size based on default ratio as xs:integer -->
    <xsl:function name="util:size-by-default-ratio" as="xs:integer">
        <xsl:param name="region-width" as="xs:integer"/>
        <xsl:param name="size" as="xs:string"/>
        <xsl:variable name="ratio">
            <xsl:choose>
                <xsl:when test="$size = 'full'">1</xsl:when>
                <xsl:when test="$size = 'wide-width'">1</xsl:when>
                <xsl:when test="$size = 'wide-height'">0.4</xsl:when>
                <xsl:when test="$size = 'regular'">0.4</xsl:when>
                <xsl:when test="$size = 'list'">0.3</xsl:when>
                <xsl:when test="$size = 'square'">0.4</xsl:when>
                <xsl:when test="$size = 'thumbnail'">0.1</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="floor($region-width * $ratio)"/>
    </xsl:function>
    
    <!-- Returns width calculated from new-height, old-width and old-height, or height calculated from new-width, old-width and old-height as xs:double? -->
    <xsl:function name="util:calculate-size" as="xs:double?">
        <xsl:param name="source-image-size" as="xs:integer*"/>
        <xsl:param name="new-width" as="xs:double?"/>
        <xsl:param name="new-height" as="xs:double?"/>
        <xsl:if test="$source-image-size[1] and $source-image-size[2]">
            <xsl:choose>
                <xsl:when test="$new-width">
                    <xsl:value-of select="floor($new-width * $source-image-size[2] div $source-image-size[1])"/>
                </xsl:when>
                <xsl:when test="$new-height">
                    <xsl:value-of select="floor($new-height * $source-image-size[1] div $source-image-size[2])"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:function>


</xsl:stylesheet>
