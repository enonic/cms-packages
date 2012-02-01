<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="enonic:utilities" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:import href="/modules/library-stk/utilities/standard-variables.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/frame.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/utilities.xsl"/>

    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="include-frame" select="false()"/>
    <xsl:param name="heading"/>
    <xsl:param name="twitranet-category">
        <type>category</type>
    </xsl:param>

    <xsl:variable name="available-region-width" select="if ($include-frame) then xs:integer($config-region-width - $config-frame-padding * 2 - $config-frame-border * 2) else $config-region-width"/>

    <xsl:template match="/">
        <xsl:variable name="id" select="concat('twitranet-', /result/context/resource/@key, /result/context/window/portlet/@key)"/>
        <xsl:variable name="content">
            <script type="text/javascript">
                <xsl:comment>
                    
                 $(function() {
                     
                     var count = 5;
                     
                     <xsl:if test="$user">
                         <xsl:value-of select="concat('$(&quot;#', $id, ' .twitranet-form&quot;).validate({')"/>
                             ignoreTitle: true,
                             errorPlacement: function(label, element) {},
                             submitHandler: function (form) {
                                 <xsl:value-of select="concat('$.post($(&quot;#', $id, ' .twitranet-form&quot;).attr(&quot;action&quot;), $(&quot;#', $id, ' .twitranet-form&quot;).serialize(), function (data) {')"/>
                                     <xsl:value-of select="concat('$(&quot;#', $id, ' .twitranet-messages&quot;).html($(data).find(&quot;.twitranet-messages&quot;).html());')"/>
                                 });
                                 <xsl:value-of select="concat('$(&quot;#', $id, ' .twitranet-message&quot;).val(&quot;&quot;);')"/>
                             }
                         });
                     </xsl:if>
                     
                     function reloadTwits(fadeIn) {
                         <xsl:value-of select="concat('$.get(&quot;', portal:createWindowUrl(('_config-region-width', $config-region-width)), '&amp;count=&quot; + count, function(data){')"/>
                             <xsl:value-of select="concat('$(&quot;#', $id, ' .twitranet-messages&quot;).html($(data).find(&quot;.twitranet-messages&quot;).html());')"/>
                             <xsl:value-of select="concat('if (fadeIn) $(&quot;#', $id, ' .twitranet-messages&quot;).hide().fadeIn(1500);')"/>
                         });
                     }
                         
                     <xsl:value-of select="concat('$(&quot;#', $id, ' a.tool.refresh&quot;).click(function (event) {')"/>
                         event.preventDefault();
                         reloadTwits(true);
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
                         reloadTwits();
                     });
                     
                     setInterval(function() {
                         reloadTwits();
                     }, 20000);
                     
                 });
                 
                //</xsl:comment>
            </script>
            <xsl:if test="$user">
                <form action="{portal:createServicesUrl('content', 'create')}" method="post" class="dont-validate append-bottom twitranet-form">
                    <fieldset>
                        <input type="hidden" name="categorykey" value="{$twitranet-category}"/>
                        <input type="text" name="message" class="text required twitranet-message" maxlength="141"/>
                        <input type="submit" class="button" value="{portal:localize('Send')}"/>
                    </fieldset>
                </form>
            </xsl:if>
            <div class="list clear clearfix twitranet-messages">
                <xsl:apply-templates select="/result/contents/content"/>
            </div>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$include-frame">
                <xsl:call-template name="frame.frame">
                    <xsl:with-param name="content" select="$content"/>
                    <xsl:with-param name="frame-heading" select="$heading"/>
                    <xsl:with-param name="frame-id" select="$id"/>
                    <xsl:with-param name="frame-tools" select="'refresh','expand'"/>
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

    <xsl:template match="content">
        <div class="item">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>
            <img src="{portal:createResourceUrl(concat($theme-public, '/images/dummy-user-smallest.png'))}" width="28" height="28" title="{owner/display-name}" alt="{concat(portal:localize('Image-of'), ' ', owner/display-name)}">
                <xsl:if test="owner/photo/@exists = 'true'">
                    <xsl:attribute name="src">
                        <xsl:value-of select="portal:createImageUrl(concat('user/', owner/@key), concat('scalesquare(28);', $config-filter))"/>
                    </xsl:attribute>
                </xsl:if>
            </img>
            <div style="width: {$available-region-width - 38}px;">
                <strong>
                    <xsl:value-of select="concat(owner/display-name, ': ')"/>
                </strong>
                <xsl:variable name="markup-with-links">
                    <xsl:analyze-string select="title" regex="((((ht|f)tp(s?))://)?([0-9a-zA-Z\-]+\.)+[a-zA-Z]{{2,6}}(:[0-9]+)?(/\S*)?)">
                        <xsl:matching-substring>
                            <a href="{if (not(regex-group(2))) then concat('http://', regex-group(1)) else regex-group(1)}" rel="external">
                                <xsl:value-of select="regex-group(1)"/>
                            </a>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="markup-with-strong">
                    <xsl:apply-templates select="$markup-with-links/*|$markup-with-links/text()" mode="markup">
                        <xsl:with-param name="regex" tunnel="yes" select="'([_\*]{2}|&lt;strong&gt;)(.+?)([_\*]{2}|&lt;/strong&gt;)'"/>
                        <xsl:with-param name="element-name" tunnel="yes" select="'strong'"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:variable name="markup-with-emphasis">
                    <xsl:apply-templates select="$markup-with-strong/*|$markup-with-strong/text()" mode="markup">
                        <xsl:with-param name="regex" tunnel="yes" select="'([_\*]|&lt;em&gt;)(.+?)([_\*]|&lt;/em&gt;)'"/>
                        <xsl:with-param name="element-name" tunnel="yes" select="'em'"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:copy-of select="$markup-with-emphasis"/>
                <span class="byline">
                    <xsl:value-of select="util:relative-timestamp(@publishfrom, /result/context/@languagecode)"/>
                </span>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="element()" mode="markup">
        <xsl:param name="regex" tunnel="yes"/>
        <xsl:param name="element-name" tunnel="yes"/>
        <xsl:param name="regex-group-index" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="*|text()|@*" mode="markup"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*" mode="markup">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()" mode="markup">
        <xsl:param name="regex" tunnel="yes"/>
        <xsl:param name="element-name" tunnel="yes"/>
        <xsl:param name="regex-group-index" tunnel="yes" select="2"/>
        <xsl:analyze-string select="." regex="{$regex}">
            <xsl:matching-substring>
                <xsl:element name="{$element-name}">
                    <xsl:value-of select="regex-group($regex-group-index)"/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

</xsl:stylesheet>
