<?xml version="1.0" encoding="UTF-8"?>

<!--
    **************************************************
    
    time.xsl
    version: ###VERSION-NUMBER-IS-INSERTED-HERE###
    
    **************************************************
-->

<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <!-- Returns timezone as xs:string -->
    <xsl:function name="util:time.get-timezone" as="xs:string">
        <xsl:variable name="timezone">
            <xsl:choose>
                <xsl:when test="timezone-from-date(current-date()) lt xs:dayTimeDuration('PT0S')">-</xsl:when>
                <xsl:otherwise>+</xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="concat(format-number(xs:integer(tokenize(xs:string(timezone-from-date(current-date())), 'T|S|H')[2]), '00'), ':00')"/>
        </xsl:variable>
        <xsl:value-of select="$timezone"/>
    </xsl:function>
    
    <!--
        Returns relative timestamp
        
        Valid formats for the 'date-time' parameter:
        'yyyy-mm-dd hh:mm'
        'yyyy-mm-dd+hh:mm'
        'yyyy-mm-dd hh:mm:ss'
        'yyyy-mm-dd+hh:mm:ss'
    -->
    <xsl:function name="util:time.relative-timestamp" as="xs:string*">
        <xsl:param name="date-time" as="xs:string"/>
        <xsl:param name="language" as="xs:string?"/>
        <xsl:variable name="date-time-complete">
            <xsl:value-of select="replace($date-time, '\s+|\+', 'T')"/>
            <xsl:if test="count(tokenize(tokenize($date-time, ' ')[2], ':')) &lt; 3">:00</xsl:if>
            <xsl:value-of select="util:time.get-timezone()"/>
        </xsl:variable>
        <xsl:variable name="date-time-final" select="xs:dateTime($date-time-complete)"/>
        <xsl:variable name="difference" select="current-dateTime() - $date-time-final"/>
        <xsl:choose>
            <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('P7D')">
                <xsl:value-of select="util:time.format-date($date-time, $language, (), true())"/>
            </xsl:when>
            <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT23H')">
                <xsl:choose>
                    <xsl:when test="xs:date($date-time-final) = current-date() - xs:dayTimeDuration('P1D')">
                        <xsl:value-of select="portal:localize('Yesterday')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="format-dateTime($date-time-final, '[FNn]', $language, (), ())"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="concat(' ', portal:localize('at'), ' ', util:time.format-time(substring-before(tokenize($date-time-complete, 'T')[2], '+'), $language))"/>
            </xsl:when>
            <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT45M')">
                <xsl:choose>
                    <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT1H30M')">
                        <xsl:variable name="hours" select="if (minutes-from-duration($difference) lt 30) then hours-from-duration($difference) else hours-from-duration($difference) + 1"/>
                        <xsl:value-of select="portal:localize('hours-ago', ($hours))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="portal:localize('About-an-hour-ago')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT1M30S')">
                        <xsl:variable name="minutes" select="if (seconds-from-duration($difference) lt 30) then minutes-from-duration($difference) else minutes-from-duration($difference) + 1"/>
                        <xsl:value-of select="portal:localize('minutes-ago', ($minutes))"/>
                    </xsl:when>
                    <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT50S')">
                        <xsl:value-of select="portal:localize('About-a-minute-ago')"/>
                    </xsl:when>
                    <xsl:when test="$date-time-final &lt;= current-dateTime() - xs:dayTimeDuration('PT25S')">
                        <xsl:value-of select="portal:localize('Less-than-a-minute-ago')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="portal:localize('Just-now')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
        Formats time
        
        Valid formats for the 'time' parameter:
        'hh:mm'
        'hh:mm:ss'
    -->
    <xsl:function name="util:time.format-time" as="xs:string">
        <xsl:param name="time" as="xs:string"/>
        <xsl:param name="language" as="xs:string?"/>
        <xsl:variable name="time-final">
            <xsl:value-of select="$time"/>
            <xsl:if test="count(tokenize($time, ':')) &lt; 3">:00</xsl:if>
            <xsl:value-of select="util:time.get-timezone()"/>
        </xsl:variable>
        <xsl:variable name="format-string">
            <xsl:choose>
                <!-- Norwegian -->
                <xsl:when test="$language = 'no'">[H01].[m01]</xsl:when>
                <!-- English is default -->
                <xsl:otherwise>[H01]:[m01]</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- Supplied time is erroneous format -->
            <xsl:when test="not($time-final castable as xs:time)">Erroneous time format</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-time(xs:time($time-final), $format-string, $language, (), ())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
        Formats date-time
        
        Valid formats for the 'date-time' parameter:
        'yyyy-mm-dd hh:mm'
        'yyyy-mm-dd+hh:mm'
        'yyyy-mm-dd'
        Valid values for the 'format' parameter:
        'long' (default)
        'short'
        Valid values for the 'include-time' parameter:
        true()
        false() (default)
    -->
    <xsl:function name="util:time.format-date" as="xs:string">
        <xsl:param name="date-time" as="xs:string"/>
        <xsl:param name="language" as="xs:string?"/>
        <xsl:param name="format" as="xs:string?"/>
        <xsl:param name="include-time" as="xs:boolean?"/>
        <xsl:variable name="format-string">
            <xsl:choose>
                <!-- Norwegian -->
                <xsl:when test="$language = 'no'">
                    <xsl:choose>
                        <!-- Short date format -->
                        <xsl:when test="$format = 'short'">[D01].[M01].[Y0001]</xsl:when>
                        <!-- Long date format -->
                        <xsl:otherwise>[D1]. [MNn] [Y0001]</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- English is default -->
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- Short date format -->
                        <xsl:when test="$format = 'short'">[D01]/[M01]/[Y0001]</xsl:when>
                        <!-- Long date format -->
                        <xsl:otherwise>[D1] [MNn] [Y0001]</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="final-date-time">
            <xsl:choose>
                <!-- Supplied date is erroneous format -->
                <xsl:when test="not(tokenize($date-time, '[\s+|\+]+')[1] castable as xs:date)">Erroneous date format</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-date(xs:date(tokenize($date-time, '[\s+|\+]+')[1]), $format-string, $language, (), ())"/>
                    <!-- Time included -->
                    <xsl:if test="$include-time and tokenize($date-time, '[\s+|\+]+')[2]">
                        <xsl:value-of select="concat(' ', util:time.format-time(tokenize($date-time, '[\s+|\+]+')[2], $language))"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$final-date-time"/>
    </xsl:function>

</xsl:stylesheet>
