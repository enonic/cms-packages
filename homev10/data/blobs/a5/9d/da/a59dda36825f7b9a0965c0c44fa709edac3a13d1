<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/frame.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:param name="include-frame" select="false()"/>
  <xsl:param name="frame-heading"/>
  
  <xsl:variable name="available-region-width" select="if ($include-frame) then xs:integer($region-width - $config-frame-padding * 2 - $config-frame-border * 2) else $region-width"/>

  <xsl:template match="/">
    <xsl:if test="/result/contents/relatedcontents/content[@key = /result/contents/content/contentdata/file/file/@key]">
      <xsl:variable name="content">
        <div class="clear">
          <xsl:if test="not($include-frame)">
            <xsl:attribute name="class">clear append-bottom</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="/result/contents/content"/>
        </div>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$include-frame">
          <xsl:call-template name="frame.frame">
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="frame-heading" select="$frame-heading"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="contentdata/scale = 'true' or $device-class = 'mobile'">
          <xsl:value-of select="$available-region-width"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="contentdata/width"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="contentdata/scale = 'true' or $device-class = 'mobile'">
          <xsl:value-of select="floor($available-region-width div (contentdata/width div contentdata/height))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="contentdata/height"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <script type="text/javascript" src="{portal:createResourceUrl('/_public/modules/flash/scripts/swfobject-2.2.js')}"/>
    <div id="{concat('flash', @key, replace(/result/context/window/@key, ':', ''))}">
      <script type="text/javascript">
        <xsl:comment>
          var flashvars = {};
          <xsl:for-each select="contentdata/variable[name != '' and value != '']">
            <xsl:value-of select="concat('flashvars.', name, ' = &quot;', value, '&quot;;')"/>
          </xsl:for-each>
          var params = {};
          <xsl:for-each select="contentdata/parameter[name != '' and value != '']">
            <xsl:value-of select="concat('params.', name, ' = &quot;', value, '&quot;;')"/>
          </xsl:for-each>
          var attributes = {};
          <xsl:for-each select="contentdata/attribute[name != '' and value != '']">
            <xsl:value-of select="concat('attributes.', name, ' = &quot;', value, '&quot;;')"/>
          </xsl:for-each>
          <xsl:value-of select="concat('swfobject.embedSWF(&quot;', portal:createAttachmentUrl(contentdata/file/file/@key, ('xt', '.swf')), '&quot;, &quot;', concat('flash', @key, replace(/result/context/window/@key, ':', '')), '&quot;, &quot;', $width, '&quot;, &quot;', $height, '&quot;, &quot;', contentdata/version, '&quot;, false, flashvars, params, attributes);')"/>
        //</xsl:comment>
      </script>
      <noscript>
        <p>
          <xsl:call-template name="utilities.display-image">
            <xsl:with-param name="region-width" select="$available-region-width"/>
            <xsl:with-param name="filter">
              <xsl:if test="not(contentdata/scale = 'true' or $device-class = 'mobile')">
                <xsl:value-of select="concat('scalewidth(', $width, ');')"/>
              </xsl:if>
              <xsl:value-of select="$config-filter"/>
            </xsl:with-param>
            <xsl:with-param name="imagesize" select="$config-imagesize"/>
            <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]"/>
            <xsl:with-param name="size">
              <xsl:if test="contentdata/scale = 'true' or $device-class = 'mobile'">full</xsl:if>
            </xsl:with-param>
          </xsl:call-template>
        </p>
        <a href="http://www.adobe.com/go/getflashplayer">
          <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="{portal:localize('Get-Adobe-Flash-player')}"/>
        </a>
      </noscript>
    </div>
  </xsl:template>

</xsl:stylesheet>
