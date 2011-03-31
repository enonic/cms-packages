<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/common.xsl"/>
  <xsl:include href="/libraries/editorElements.xsl"/>
  <xsl:param name="productsPage">
    <type>page</type>
  </xsl:param>

  <xsl:template match="/">
    <xsl:if test="/verticaldata/contents/content">
      <script src="/_public/libraries/scripts/shop.js" type="text/javascript"><xsl:comment>//</xsl:comment></script>
      <div id="product">
        <xsl:apply-templates select="/verticaldata/contents/content"/>
      </div>
      <div id="back-top"><a href="javascript:history.back()">&lt;&lt; Back</a><xsl:text> | </xsl:text><a href="{portal:createPageUrl($productsPage, ())}">Continue shopping</a></div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content">
    <h1><xsl:value-of select="title"/></h1>
    <div id="relations">
      <xsl:if test="/verticaldata/contents/relatedcontents/content[@key = current()/contentdata/images/image/@key]">
        <div class="images">
          <xsl:for-each select="contentdata/images/image[@key = /verticaldata/contents/relatedcontents/content/@key]">
            <xsl:variable name="currentImage" select="/verticaldata/contents/relatedcontents/content[@key = current()/@key]"/>
            <div class="image">
              <xsl:call-template name="displayImage">
                <xsl:with-param name="image" select="$currentImage"/>
                <xsl:with-param name="imageMaxWidth" select="310"/>
              </xsl:call-template>
            </div>
          </xsl:for-each>
        </div>
      </xsl:if>
    </div>
    <div id="productWrap">
      <div id="produktInfo">
        <xsl:if test="contentdata/number !=''">
          <span class="p-info">
            <xsl:value-of select="concat('Product number ', contentdata/number)"/>
          </span>
        </xsl:if>
        <xsl:if test="contentdata/price !=''">
          <br/>
          <span class="p-info">
            <xsl:value-of select="concat('Retail price ', format-number(contentdata/price, '#.00'), ',-')"/>
          </span>
        </xsl:if>
      </div>
        <div>
          <form action="{portal:createServicesUrl('order','cart_add',())}" method="post" name="form{position()}" onsubmit="javascript:return check(this.count)">
            <p>
              <input name="productid" type="hidden" value="{@key}"/>
              <xsl:text>Quantity </xsl:text>
              <input class="count" name="count" type="text" value="1"/>
              <xsl:text> </xsl:text>
              <input class="cart-add" type="submit" value="Add to shopping cart"/>
            </p>
          </form>
        </div>
      <xsl:if test="string-length(contentdata/teaser/preface) > 0">
        <p class="preface">
          <xsl:call-template name="replaceSubstring">
            <xsl:with-param name="inputString" select="contentdata/teaser/preface"/>
          </xsl:call-template>
        </p>
      </xsl:if>
      <xsl:if test="contentdata/text/*|contentdata/text/text()">
        <div class="editor">
          <xsl:apply-templates select="contentdata/text"/>
          <!-- look for this templates in editorElements.xsl -->
        </div>
      </xsl:if>
    </div>
  </xsl:template>
</xsl:stylesheet>