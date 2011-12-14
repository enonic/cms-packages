<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:param name="shopManagerName"/>
  <xsl:param name="shopManagerEmail"/>
  <xsl:param name="createInCategory"/>
  <xsl:param name="showURL"/>
  <xsl:param as="xs:integer" name="momsVariabel" select="25"/>
  <xsl:param name="redirectPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="productsPage">
    <type>page</type>
  </xsl:param>
  <xsl:param name="unitkey"/>
  <xsl:param name="currency"/>
  <xsl:variable name="language" select="/verticaldata/context/@languagecode"/>

  <xsl:template match="/">
    <xsl:variable name="tax">
      <xsl:element name="taxes">
        <xsl:for-each select="/verticaldata/contentobject/shoppingcart/item">
          <!--<xsl:if test="/verticaldata/contents/content[@key = current()/@productid]/contentdata/mva and /verticaldata/contents/content[@key = current()/@productid]/contentdata/mva != 'NaN'">-->
          <xsl:element name="tax">
            <!--<xsl:variable name="momsVariabel" select="../../../contents/content[@key = current()/@productid]/contentdata/mva"/>
              brukes kun dersom moms angis i innholdstype (12%/24%)
              -->
            <xsl:variable name="nyMomsVariabel" select="1+($momsVariabel div 100)"/>
            <xsl:variable name="eksklMVA" select="@subtotal div $nyMomsVariabel"/>
            <xsl:variable name="moms" select="@subtotal - $eksklMVA"/>
            <xsl:value-of select="format-number($moms, '#.00')"/>
          </xsl:element>
          <!--</xsl:if>-->
        </xsl:for-each>
      </xsl:element>
    </xsl:variable>
    <script type="text/javascript">
      <xsl:comment>
      function validateEmail(e) {
        var i;
        var regExpEmail = /^.+\@.+\..+$/;

        if (e.value != '') {
          if (!regExpEmail.test(e.value)) {
            return false;
          }
        }
        return true;
      }

      function cartCheckout() {
        var ok=true;

        if (document.formCheckout['customer_firstname'].value == '')
          ok=false;

        if (document.formCheckout['customer_surname'].value == '')
          ok=false;

        if (document.formCheckout['customer_company'].value == '')
          ok=false;

        if (document.formCheckout['customer_email'].value == '')
          ok=false;

        if (document.formCheckout['customer_telephone'].value == '')
          ok=false;

        if (document.formCheckout['billing_postaladdress'].value == '')
          ok=false;

        if (document.formCheckout['billing_postalcode'].value == '')
          ok=false;

        if (document.formCheckout['billing_location'].value == '')
          ok=false;

        var mail=true;

        if (!validateEmail(document.formCheckout['customer_email']))
          mail=false;

        if (mail != true) {
          alert("Error!\nInvalid e-mail format.");
          document.formCheckout['customer_email'].focus();
          return false;
        }
        
        if (ok != true) {
          alert("Error!\nAll fields marked with * is mandatory.");
          return false;
        } else {
          document.formCheckout.submit();
          return true;
        }
      }
      //</xsl:comment>
    </script>
    <form action="{portal:createServicesUrl('order','cart_checkout',())}" method="post" name="formCheckout" onsubmit="return cartCheckout();">
      <div>
        <input name="unitkey" type="hidden" value="{$unitkey}"/>
        <input name="categorykey" type="hidden" value="{$createInCategory}"/>
        <input name="redirect" type="hidden" value="{portal:createPageUrl($redirectPage, ())}"/>
        <input name="showorderonredirect" type="hidden" value="true"/>
        <!--        <input type="hidden" name="showorderurl" value="{$showURL}"/>
        <input type="hidden" name="showorderpage" value="{$showPage}"/>-->
        <input name="mail_sender_email" type="hidden" value="{$shopManagerEmail}"/>
        <input name="mail_sender_name" type="hidden" value="{$shopManagerName}"/>
        <input name="shopmanager_email" type="hidden" value="{$shopManagerEmail}"/>
        <input name="details_shippingoptions" type="hidden" value="{format-number(sum($tax/taxes/tax), '#.00')}"/>
        <input name="billing_state" type="hidden" value="{format-number(/verticaldata/contentobject/shoppingcart/@total, '#.00')}"/>
        <input name="shipping_country" type="hidden" value="{/verticaldata/contentobject/shoppingcart/item/@price}"/>
        <input name="shopmanager_name" type="hidden" value="{$shopManagerName}"/>
        <input name="mail_subject" type="hidden" value="Shop: # %order_id%"/>
        <input name="mail_message" type="hidden">
          <xsl:attribute name="value">
            <xsl:text>Bestilling\n</xsl:text>
            <xsl:text>--------------------------\n</xsl:text>
            <xsl:text>Order no.: %order_id%\n</xsl:text>
            <xsl:text>Order date: %order_date%\n\n</xsl:text>
            <xsl:text>Customer information\n</xsl:text>
            <xsl:text>--------------------------\n</xsl:text>
            <xsl:text>Customer no.: %customer_refno%\n</xsl:text>
            <xsl:text>Name: %customer_firstname% %customer_surname%\n</xsl:text>
            <xsl:text>E-mail: %customer_email%\n</xsl:text>
            <xsl:text>Company: %customer_company%\n</xsl:text>
            <xsl:text>Phone: %customer_telephone%\n</xsl:text>
            <xsl:text>%details_comments%\n\n</xsl:text>
            <xsl:text>Billing address\n</xsl:text>
            <xsl:text>---------------------------\n</xsl:text>
            <xsl:text>Address:\n</xsl:text>
            <xsl:text>%billing_postaladdress%\n</xsl:text>
            <xsl:text>Postal number/place: %billing_postalcode% %billing_location%\n</xsl:text>
            <xsl:text>Country: %billing_country%\n</xsl:text>
            <xsl:text>------------------------------------------------------------------------------\n\n</xsl:text>
            <xsl:text>Product number       Quantity        Price         VAT             Product\n</xsl:text>
            <xsl:text>------------------------------------------------------------------------------\n</xsl:text>
            <xsl:apply-templates mode="mail" select="/verticaldata/contentobject/shoppingcart/item"/>
            <xsl:text>------------------------------------------------------------------------------\n</xsl:text>
            <xsl:text>Total price                     MVA\n</xsl:text>
            <xsl:text>------------------------------------------------------------------------------\n</xsl:text>
            <xsl:text>      %billing_state%                      %details_shippingoptions%</xsl:text>
          </xsl:attribute>
          <!--<xsl:text>Fax: %customer_fax%\n</xsl:text>-->
        </input>
        <input name="mail_order_item" type="hidden">
          <xsl:attribute name="value">
            <xsl:text>%item_productname(30,l)% %item_productnumber(15,l)% %item_count(4,c)%\n</xsl:text>
          </xsl:attribute>
        </input>
        <xsl:choose>
          <xsl:when test="number(/verticaldata/contentobject/shoppingcart/@count) > 0">
            <xsl:call-template name="backTop"/>
            <table cellspacing="0" class="list">
              <thead>
                <tr>
                  <th>Your order</th>
                  <th>Product number</th>
                  <th class="right">Quantity</th>
                  <th class="right">Retail price</th>
                  <th class="right">VAT</th>
                </tr>
              </thead>
              <tbody>
                <xsl:apply-templates mode="page" select="/verticaldata/contentobject/shoppingcart/item"/>
              </tbody>
              <tfoot>
                <tr>
                  <td class="total strong" colspan="2">Total</td>
                  <td class="total right strong"><xsl:value-of select="/verticaldata/contentobject/shoppingcart/@count"/></td>
                  <td class="total right strong"><xsl:value-of select="format-number(/verticaldata/contentobject/shoppingcart/@total, '#.00')"/> <xsl:value-of select="$currency"/></td>
                  <td class="total right strong"><xsl:value-of select="format-number(sum($tax/taxes/tax), '#.00')"/> <xsl:value-of select="$currency"/></td>
                </tr>
              </tfoot>
            </table>
            <h2>Account information</h2>
            <table class="operaform">
              <tr>
                <th class="left">Acccount number:</th>
                <td class="right"><input class="text" maxlength="40" name="customer_refno" size="40" type="text"/></td>
              </tr>
              <tr>
                <th class="left">Firstname: <span class="required">*</span></th>
                <td class="right">
                  <input class="text" maxlength="40" name="customer_firstname" size="40" type="text">
                    <xsl:if test="/verticaldata/context/user/*/firstname != '' and /verticaldata/context/user/*/firstname != 'N/A'">
                      <xsl:attribute name="value">
                        <xsl:value-of select="/verticaldata/context/user/*/firstname"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr>
                <th class="left">Surname: <span class="required">*</span></th>
                <td class="right">
                  <input class="text" maxlength="40" name="customer_surname" size="40" type="text">
                    <xsl:if test="/verticaldata/context/user/*/surname != '' and /verticaldata/context/user/*/surname != 'N/A'">
                      <xsl:attribute name="value">
                        <xsl:value-of select="/verticaldata/context/user/*/surname"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr>
                <th class="left">Company: <span class="required">*</span></th>
                <td class="right">
                  <input class="text" maxlength="40" name="customer_company" size="40" type="text">
                    <xsl:if test="/verticaldata/context/user/*/company != '' and /verticaldata/context/user/*/company != 'N/A'">
                      <xsl:attribute name="value">
                        <xsl:value-of select="/verticaldata/context/user/*/company"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr>
                <th class="left">E-mail: <span class="required">*</span></th>
                <td class="right">
                  <input class="text" maxlength="40" name="customer_email" onchange="validateEmail(this);" size="40" type="text">
                    <xsl:if test="/verticaldata/context/user/*/email != '' and /verticaldata/context/user/*/email != 'N/A'">
                      <xsl:attribute name="value">
                        <xsl:value-of select="/verticaldata/context/user/*/email"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr>
                <th class="left">Phone: <span class="required">*</span></th>
                <td class="right">
                  <input class="text" maxlength="40" name="customer_telephone" size="40" type="text">
                    <xsl:if test="/verticaldata/context/user/*/phone != '' and /verticaldata/context/user/*/phone != 'N/A'">
                      <xsl:attribute name="value">
                        <xsl:value-of select="/verticaldata/context/user/*/phone"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr>
                <th class="left">Address: <span class="required">*</span></th>
                <td class="right"><input class="text" maxlength="40" name="billing_postaladdress" size="40" type="text"/></td>
              </tr>
              <tr>
                <th class="left">Postal number: <span class="required">*</span></th>
                <td class="right"><input class="text" maxlength="40" name="billing_postalcode" size="40" type="text"/></td>
              </tr>
              <tr>
                <th class="left">Postal location: <span class="required">*</span></th>
                <td class="right"><input class="text" maxlength="40" name="billing_location" size="40" type="text"/></td>
              </tr>
              <tr>
                <th class="left">Country:</th>
                <td class="right"><input class="text" maxlength="40" name="billing_country" size="40" type="text"/></td>
              </tr>
              <tr>
                <th class="left">Additional comments:</th>
                <td class="right"><textarea cols="34" name="details_comments" rows="8"> </textarea></td>
              </tr>
            </table>
            <p class="enter-button">
              <input type="submit" value="Submit"/>
              <input type="reset" value="Reset"/>
            </p>
          </xsl:when>
          <xsl:otherwise>
            <div class="cart-is-empty"><p>No items in shopping cart</p></div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
    <xsl:call-template name="backTop"/>
  </xsl:template>
  <xsl:template match="/verticaldata/contentobject/shoppingcart/item" mode="page">
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="class">
          <xsl:text>dark</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <td><img alt="Produkt" class="icon_shop" src="{portal:createResourceUrl('/_public/packages/site/images/images/shop.gif')}"/><xsl:value-of select="."/></td>
      <td><xsl:value-of select="@productnumber"/></td>
      <td class="right"><xsl:value-of select="@count"/></td>
      <td class="right"><xsl:value-of select="format-number(@subtotal, '#.00')"/><xsl:text> </xsl:text><xsl:value-of select="$currency"/></td>
      <!-- <xsl:variable name="momsVariabel" select="../../../contents/content[@key = current()/@productid]/contentdata/mva"/>-->
      <xsl:variable as="xs:double" name="nyMomsVariabel" select="1+($momsVariabel div 100)"/>
      <xsl:variable as="xs:double" name="eksklMVA" select="@subtotal div $nyMomsVariabel"/>
      <xsl:variable as="xs:double" name="moms" select="@subtotal - $eksklMVA"/>
      <xsl:choose>
        <xsl:when test="$momsVariabel != 0">
          <td class="right"><xsl:value-of select="format-number($moms, '#.00')"/><xsl:text> </xsl:text><xsl:value-of select="$currency"/></td>
        </xsl:when>
        <xsl:otherwise>
          <td class="right"><xsl:text>00.00</xsl:text></td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>

  <xsl:template match="/verticaldata/contentobject/shoppingcart/item" mode="mail">
    <!-- <xsl:variable name="momsVariabel" select="../../../contents/content[@key = current()/@productid]/contentdata/mva"/>-->
    <xsl:variable as="xs:double" name="nyMomsVariabel" select="1+($momsVariabel div 100)"/>
    <xsl:variable as="xs:double" name="eksklMVA" select="@subtotal div $nyMomsVariabel"/>
    <xsl:variable as="xs:double" name="moms" select="@subtotal - $eksklMVA"/>
    <xsl:value-of select="@productnumber"/><xsl:text>                  </xsl:text><xsl:value-of select="@count"/><xsl:text>             </xsl:text><xsl:value-of select="format-number(@subtotal, '#.00')"/><xsl:text> </xsl:text><xsl:value-of select="$currency"/>          
    <xsl:choose>
      <xsl:when test="$momsVariabel != 0">
        <xsl:text>        </xsl:text><xsl:value-of select="format-number($moms, '#.00')"/><xsl:text> </xsl:text><xsl:value-of select="$currency"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>00.00 </xsl:text><xsl:value-of select="$currency"/>
      </xsl:otherwise>
    </xsl:choose><xsl:text>     </xsl:text><xsl:value-of select="."/>\n
  </xsl:template>
  <xsl:template name="backTop">
    <div id="back-top">
      <a href="javascript:history.back()">Back</a><xsl:text> | </xsl:text><a href="{portal:createPageUrl($productsPage, ())}">Continue shopping</a>
    </div>
  </xsl:template>
</xsl:stylesheet>