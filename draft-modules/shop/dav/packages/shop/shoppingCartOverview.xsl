<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:param name="topLevelPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="checkOutPage">
    <type>page</type>
  </xsl:param>
  <xsl:variable name="language" select="/verticaldata/context/@languagecode"/>

  <xsl:template match="/">
    <script src="/_public/libraries/scripts/shop.js" type="text/javascript">
      <xsl:comment>//</xsl:comment>
    </script>
    <xsl:choose>
      <xsl:when test="verticaldata/contentobject/shoppingcart/@count != 0">
        <xsl:call-template name="shopTools"/>
        <table cellpadding="0" cellspacing="0" class="list">
          <tr>
            <th>Item</th>
            <th>Product number</th>
            <th class="right">Quantity</th>
            <th class="right">Subtotal</th>
            <th class="center">Update</th>
            <th class="center">Delete</th>
          </tr>
          <xsl:apply-templates select="verticaldata/contentobject/shoppingcart/item"/>
          <tr>
            <td class="strong">Total</td>
            <td>
              <br/>
            </td>
            <td class="strong right pr6">
              <xsl:value-of select="verticaldata/contentobject/shoppingcart/@count"/>
            </td>
            <td class="strong right">
              <xsl:text> </xsl:text>
              <xsl:value-of select="format-number(verticaldata/contentobject/shoppingcart/@total, '#.00')"/>
            </td>
            <td>
              <br/>
            </td>
            <td>
              <br/>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <div class="shop-tools">No items in shopping cart</div>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="shopTools"/>
  </xsl:template>
  <xsl:template match="item">
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="class">
          <xsl:text>dark</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <td>
        <xsl:value-of select="."/>
      </td>
      <td>
        <xsl:value-of select="@productnumber"/>
      </td>
      <td class="right">
        <form action="{portal:createServicesUrl('order','cart_update',())}" method="post"
              name="{concat('form' ,position())}" onsubmit="return check(this.count)">
          <input name="count" class="w20r" type="text" value="{@count}"/>
          <input name="productid" type="hidden" value="{@productid}"/>
        </form>
      </td>
      <td class="right">
        <xsl:value-of select="format-number(@subtotal, '#.00')"/>
      </td>
      <td class="center">
        <input type="button" value="Update" onclick="document.forms['form{position()}'].submit()"/>
      </td>
      <td class="center">
        <a href="{portal:createServicesUrl('order','cart_remove',('productid',@productid))}">Remove</a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="shopTools">
    <div class="shop-tools">
      <p>
        <a href="javascript:void(0);" onclick="history.back();">Back</a>
        <xsl:text> | </xsl:text>
        <a href="{portal:createPageUrl($topLevelPage, ())}">Continue shopping</a>
        <xsl:text> | </xsl:text>
        <a href="{portal:createPageUrl($checkOutPage, ())}">Submit order</a>
        <xsl:text> | </xsl:text>
        <a href="{portal:createServicesUrl('order','cart_empty',())}">Empty shopping cart</a>
      </p>
    </div>
  </xsl:template>
</xsl:stylesheet>