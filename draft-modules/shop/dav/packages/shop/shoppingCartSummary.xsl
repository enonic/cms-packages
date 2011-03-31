<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/packages/site/border.xsl"/>

  <xsl:param name="myBasketPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="checkOutPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="border" select="'false'"/>
  <xsl:param name="header-text" select="''"/>

  <xsl:template match="/">
    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-start">
        <xsl:with-param name="header-text" select="$header-text"/>
      </xsl:call-template>
    </xsl:if>
    <div id="shopping-cart-summary">
      <xsl:choose>
        <xsl:when test="verticaldata/contentobject/shoppingcart/@count != 0">
          <xsl:text>Items in shopping cart: </xsl:text>
          <strong>
            <xsl:value-of select="verticaldata/contentobject/shoppingcart/@count"/>
          </strong>
          <br/>
          <xsl:text>Retail price: </xsl:text>
          <strong>
            <xsl:value-of select="format-number(verticaldata/contentobject/shoppingcart/@total, '#.00')"/>
          </strong>
          <div class="basket">
            <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
            <p>
              <a href="{portal:createPageUrl($myBasketPage, ())}">View shopping cart</a>
              <br/>
              <a href="{portal:createPageUrl($checkOutPage, ())}">Submit order</a>
              <br/>
              <a href="{portal:createServicesUrl('order','cart_empty',())}">Empty shopping cart</a>
            </p>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <p class="clean">No items in shopping cart</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <xsl:if test="$border = 'true'">
      <xsl:call-template name="border-end"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>