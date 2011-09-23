<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/verticaldata/contents/@totalcount = 0">
        <h2>No persons published.</h2>
      </xsl:when>
      <xsl:otherwise>
        <div class="item">
          <table cellspacing="0" class="list">
            <thead>
              <tr>
                <th class="thumb"><xsl:comment> thumbnail image </xsl:comment></th>
                <th>Name</th>
                <th>Phone</th>
                <th>Mobile</th>
                <th>E-mail</th>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates select="/verticaldata/contents/content"/>
            </tbody>
          </table>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <tr>
      <td class="thumb">
        <xsl:choose>
          <xsl:when test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
            <xsl:call-template name="displayImage">
              <xsl:with-param name="key" select="contentdata/image/@key"/>
              <xsl:with-param name="imageMaxWidth" select="100"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <img alt="No thumbnail image" height="53" src="{portal:createResourceUrl('/_public/packages/site/images/images/empty.gif')}" width="50"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td><a href="{portal:createContentUrl(@key, ())}"><xsl:value-of select="concat(contentdata/firstname,' ',contentdata/surname)"/></a></td>
      <td><xsl:value-of select="contentdata/phone"/></td>
      <td><xsl:value-of select="contentdata/mobile"/></td>
      <td><a href="mailto:{contentdata/email}"><img alt="Send e-mail" height="10" src="{portal:createResourceUrl('/_public/packages/site/images/images/mail.gif')}" width="13"/></a></td>
    </tr>      
  </xsl:template>
</xsl:stylesheet>