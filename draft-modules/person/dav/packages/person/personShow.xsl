<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  
  <xsl:template match="/">
    <xsl:if test="/verticaldata/contents/content">
      <div id="person">
        <xsl:apply-templates select="/verticaldata/contents/content"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content">
    <h1><xsl:value-of select="concat(contentdata/firstname,' ',contentdata/surname)"/></h1>
    <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
      <div id="images">
        <xsl:for-each select="contentdata/image[@key = /verticaldata/contents/relatedcontents/content/@key]">
          <xsl:variable name="currentImage" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
          <div class="image">
            <xsl:attribute name="style">
              <xsl:value-of select="concat('width: ', '230', 'px')"/>
            </xsl:attribute>
            <xsl:call-template name="displayImage">
              <xsl:with-param name="image" select="$currentImage"/>
              <xsl:with-param name="imageMaxWidth" select="230"/>
            </xsl:call-template>
            <xsl:if test="text != ''">
              <div class="text">
                <xsl:value-of select="text"/>
              </div>
            </xsl:if>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
    <table cellspacing="0" class="personalia">
      <tbody>
        <tr class="odd">
          <th>Title</th>
          <td><xsl:value-of select="contentdata/title"/></td>
        </tr>
        <tr>
          <th>Phone</th>
          <td><xsl:value-of select="contentdata/phone"/></td>
        </tr>
        <tr class="odd">
          <th>Mobile</th>
          <td><xsl:value-of select="contentdata/mobile"/></td>
        </tr>
        <tr>
          <th>E-mail</th>
          <td><a href="mailto:{contentdata/email}"><img alt="Send e-mail" height="10" src="{portal:createResourceUrl('/_public/packages/site/images/images/mail.gif')}" width="13"/></a></td>
        </tr>
      </tbody>
    </table>
    <xsl:if test="string-length(contentdata/description) > 0">
      <p>
        <xsl:call-template name="replaceSubstring">
          <xsl:with-param name="inputString" select="contentdata/description"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <p>
      <a href="javascript:history.back()">
        &lt;&lt; Back
      </a>
    </p>
  </xsl:template>
</xsl:stylesheet>