<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:variable as="xs:double" name="totalCount" select="number(/verticaldata/contents/@totalcount)"/>

  <xsl:template match="/">
    <div id="productlist">
      <xsl:choose>
        <xsl:when test="/verticaldata/contents/@totalcount = 0">
          <h2>No products published.</h2>
        </xsl:when>
        <xsl:otherwise>
          <script src="/_public/libraries/scripts/shop.js" type="text/javascript"><xsl:comment>//</xsl:comment></script>
          <xsl:apply-templates select="/verticaldata/contents/content"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="content">
    <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
    <div class="item">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item first</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key]">
          <a href="{$url}">
            <xsl:call-template name="displayImage">
              <xsl:with-param name="key" select="contentdata/teaser/image/@key"/>
              <xsl:with-param name="imageMaxWidth" select="180"/>
            </xsl:call-template>
          </a>
        </xsl:when>
        <xsl:when test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/images/image/@key]">
          <a href="{$url}">
            <xsl:call-template name="displayImage">
              <xsl:with-param name="key" select="contentdata/images/image/@key"/>
              <xsl:with-param name="imageMaxWidth" select="180"/>
            </xsl:call-template>
          </a>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key] or /verticaldata/contents/relatedcontents/content[@key = current()/contentdata/images/image/@key]">
        <!-- xsl:text disable-output-escaping="yes">&lt;div class="inner-articlelist" style="margin-left:</xsl:text><xsl:value-of select="180 + 15"/><xsl:text>px;"</xsl:text><xsl:text disable-output-escaping="yes">&gt;</xsl:text-->
        <xsl:text disable-output-escaping="yes">&lt;div class="inner-articlelist"&gt;</xsl:text>
      </xsl:if>
      <h2><a href="{$url}"><xsl:value-of select="title"/></a></h2>
      <p>
        <xsl:if test="string-length(contentdata/number) > 2">
          <xsl:value-of select="concat('Product number: ', contentdata/number)"/>
          <br/>
        </xsl:if>
        <xsl:if test="string-length(contentdata/price) > 2">
          <xsl:value-of select="concat('Retail price: ', format-number(contentdata/price, '#.00'))"/>
        </xsl:if>
      </p>
      <div class="addToCart">
        <form action="{portal:createServicesUrl('order','cart_add',())}" method="post" name="form{position()}" onsubmit="javascript:return check(this.count);">
          <div>
          <input name="productid" type="hidden" value="{@key}"/>
          <xsl:value-of select="'Quantity '"/>
          <input name="count" class="count" type="text" value="1"/>
          <xsl:text> </xsl:text>
          <input class="cart-add" type="submit" value="Add to shopping cart"/>
          </div>
        </form>
      </div>
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key] or /verticaldata/contents/relatedcontents/content[@key = current()/contentdata/images/image/@key]">
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
      </xsl:if>
    </div>
  </xsl:template>
</xsl:stylesheet>