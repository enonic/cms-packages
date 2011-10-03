<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="enonic:local">

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>

  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:variable name="page-url" select="portal:createPageUrl(portal:getPageKey(), ())"/>
  <xsl:variable name="page-name" select="/result/page/@name"/>
  <xsl:variable name="attachment-pattern" select="':::attachment:([0-9]+):([^:]+):::'"/>
  <xsl:variable name="attachment-result-pattern" select="'_wikifile?page=$1&amp;amp;file=$2'"/>
  <xsl:variable name="page-pattern" select="':::page:([^:]+):([^:]+):::'"/>
  <xsl:variable name="page-result-pattern" select="concat($page-url,'?page=$2')"/>
  <xsl:variable name="anchor-pattern" select="':::anchor:([^:]+):::'"/>
  <xsl:variable name="anchor-result-pattern" select="concat($page-url, '?page=', $page-name, '#$1')"/>
  <xsl:variable name="static-file-pattern" select="':::image:([^:]+):::'"/>
  <xsl:variable name="static-file-result-pattern" select="'http://wiki.enonic.com/images/$1'"/>
  <xsl:variable name="break-element-pattern" select="'&lt;br(.*?)&gt;'"/>
  <xsl:variable name="break-element-result-pattern" select="'&lt;br/&gt;'"/>
  <xsl:variable name="bold-element-pattern" select="'&lt;b&gt;(.*?)&lt;/b&gt;'"/>
  <xsl:variable name="bold-element-result-pattern" select="'&lt;strong&gt;$1&lt;/strong&gt;'"/>
  <xsl:variable name="image-element-alt-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img(\s(a[^l]|al[^t]|alt\s*[^=]|[^a&gt;])*)&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-alt-result-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img alt=""$1&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-align-to-style-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img([^&gt;]*) align="(left|right)"([^&gt;]*)&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-align-to-style-result-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img$1 style="float: $2;"$3&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-remove-align-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img([^&gt;]*) align="[^"]*"([^&gt;]*)&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-remove-align-result-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img$1$2&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-remove-border-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img([^&gt;]*) border="[^"]*"([^&gt;]*)&gt;</xsl:text>
  </xsl:variable>
  <xsl:variable name="image-element-remove-border-result-pattern">
    <xsl:text disable-output-escaping="yes">&lt;img$1$2&gt;</xsl:text>
  </xsl:variable>

  <xsl:function name="local:create-xhtml" as="xs:string">
    <xsl:param name="content" as="xs:string"/>
    <xsl:variable name="tmp1" select="replace($content, $break-element-pattern, $break-element-result-pattern)"/>
    <xsl:variable name="tmp2" select="replace($tmp1, $bold-element-pattern, $bold-element-result-pattern)"/>
    <xsl:variable name="tmp3" select="replace($tmp2, $image-element-alt-pattern, $image-element-alt-result-pattern)"/>
    <xsl:variable name="tmp4" select="replace($tmp3, $image-element-align-to-style-pattern, $image-element-align-to-style-result-pattern)"/>
    <xsl:variable name="tmp5" select="replace($tmp4, $image-element-remove-align-pattern, $image-element-remove-align-result-pattern)"/>
    <xsl:variable name="tmp6" select="replace($tmp5, $image-element-remove-border-pattern, $image-element-remove-border-result-pattern)"/>
    <xsl:variable name="tmp7" select="replace($tmp6, $attachment-pattern, $attachment-result-pattern)"/>
    <xsl:variable name="tmp8" select="replace($tmp7, $page-pattern, $page-result-pattern)"/>
    <xsl:variable name="tmp9" select="replace($tmp8, $anchor-pattern, $anchor-result-pattern)"/>
    <xsl:variable name="tmp10" select="replace($tmp9, $static-file-pattern, $static-file-result-pattern)"/>
    <xsl:value-of select="$tmp10"/>
  </xsl:function>

  <xsl:template match="/">
    <xsl:if test="/result/page/html != ''">
      <script type="text/javascript" src="{portal:createResourceUrl('/_public/modules/confluence/scripts/confluence.js')}"/>
      <h1>
        <xsl:value-of select="/result/page/@title"/>
      </h1>
      <xsl:value-of select="local:create-xhtml(/result/page/html)" disable-output-escaping="yes"/>
      <script type="text/javascript">
        <xsl:comment>
          cms.util.addLoadEvent(function () {
            <xsl:value-of select="concat('cms.confluence.resizeImages(', $region-width, ');')"/>
          });
        //</xsl:comment>
      </script>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
