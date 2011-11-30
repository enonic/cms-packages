<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fw="http://www.enonic.com/cms/xslt/framework"
  xmlns:portal="http://www.enonic.com/cms/xslt/portal" 
  xmlns:util="http://www.enonic.com/cms/xslt/utilities">
   
   
  <xsl:template name="mobile.scripts">
    <script type="text/javascript">
    <xsl:comment>
      
      $(function() {
      
      
        $('#navigation').enonicTree();
        
        
        
      
      <!--<!-\- Mobile menu: Toggle -\->
      $('#navigation a').click(function (event) {
      event.preventDefault();
      var navBar = $(this);
      $('#menu').slideToggle('fast', function() {
      navBar.toggleClass('plus');
      navBar.toggleClass('minus');
      <xsl:value-of select="concat('if (navBar.text() == &quot;', portal:localize('Show-menu'), '&quot;) {')"/>
      <xsl:text>
      </xsl:text>
      <xsl:value-of select="concat('navBar.text(&quot;', portal:localize('Hide-menu'), '&quot;);')"/>
      } else {
      <xsl:value-of select="concat('navBar.text(&quot;', portal:localize('Show-menu'), '&quot;);')"/>
      }
      });
      });-->
      
      <!-- Validates all forms -->
      $('form:not(.dont-validate)').each(function() {
      $(this).validate({
      ignoreTitle: true,
      errorPlacement: function(label, element) {
      label.insertBefore(element);
      }
      });
      });
      
      <!-- Adds and localizes datepicker for all date inputs -->
      <xsl:value-of select="concat('$(&quot;.datepicker&quot;).datepicker($.extend({dateFormat: &quot;', portal:localize('jquery-datepicker-date-format'), '&quot;}, $.datepicker.regional[&quot;', $fw:language, '&quot;]));')"/>
      $.validator.addMethod('datepicker', function(value, element) {
      var isValid = true;
      try {
      $.datepicker.parseDate($(element).datepicker('option', 'dateFormat'), value)
      }
      catch(err) {
      isValid = false;
      }
      return isValid;
      }, $.validator.messages.date);
      
      if ($('.datepicker').length &amp;&amp; $('.datepicker').rules) {
      $('.datepicker').rules('add', {
      datepicker: true
      });
      }
      
      <!-- Localization of standard jquery.validate messages -->
      jQuery.extend(jQuery.validator.messages, {
      <xsl:value-of select="concat('required: &quot;', portal:localize('jquery-validate-required'), '&quot;,')"/>
      <xsl:value-of select="concat('maxlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-maxlength'), '&quot;),')"/>
      <xsl:value-of select="concat('minlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-minlength'), '&quot;),')"/>
      <xsl:value-of select="concat('rangelength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-rangelength'), '&quot;),')"/>
      <xsl:value-of select="concat('email: &quot;', portal:localize('jquery-validate-email'), '&quot;,')"/>
      <xsl:value-of select="concat('url: &quot;', portal:localize('jquery-validate-url'), '&quot;,')"/>
      <xsl:value-of select="concat('date: &quot;', portal:localize('jquery-validate-date'), '&quot;,')"/>
      <xsl:value-of select="concat('dateISO: &quot;', portal:localize('jquery-validate-dateISO'), '&quot;,')"/>
      <xsl:value-of select="concat('number: &quot;', portal:localize('jquery-validate-number'), '&quot;,')"/>
      <xsl:value-of select="concat('digits: &quot;', portal:localize('jquery-validate-digits'), '&quot;,')"/>
      <xsl:value-of select="concat('equalTo: &quot;', portal:localize('jquery-validate-equalTo'), '&quot;,')"/>
      <xsl:value-of select="concat('range: jQuery.validator.format(&quot;', portal:localize('jquery-validate-range'), '&quot;),')"/>
      <xsl:value-of select="concat('max: jQuery.validator.format(&quot;', portal:localize('jquery-validate-max'), '&quot;),')"/>
      <xsl:value-of select="concat('min: jQuery.validator.format(&quot;', portal:localize('jquery-validate-min'), '&quot;),')"/>
      <xsl:value-of select="concat('creditcard: &quot;', portal:localize('jquery-validate-creditcard'), '&quot;')"/>
      });
      
      });
      
      //</xsl:comment>
  </script>
 </xsl:template> 
   
  
  <xsl:template name="mobile.header">
    
    
    <div id="header" class="clearfix">
      <a href="{portal:createUrl($fw:front-page)}">
        <img alt="{$fw:site-name}-{portal:localize('logo')}" id="logo" src="{portal:createResourceUrl(concat($fw:theme-public, '/images-mobile/logo.png'))}" title="{$fw:site-name}"/>
      </a>
      <xsl:if test="$fw:user or $fw:login-page">
        <div id="top-menu" class="screen">
          <xsl:choose>
            <!-- User logged in -->
            <xsl:when test="$fw:user">
              <img src="{if ($fw:user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $fw:user/@key), 'scalesquare(28);rounded(2)') else portal:createResourceUrl(concat($fw:theme-public, '/images/dummy-user-smallest.png'))}" title="{$fw:user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $fw:user/display-name)}">
                <xsl:if test="$fw:login-page">
                  <xsl:attribute name="class">user-image clickable</xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($fw:login-page/@key, ()), '&quot;;')"/>
                  </xsl:attribute>
                </xsl:if>
              </img>
              <xsl:comment>googleoff: anchor</xsl:comment>
              <a href="{portal:createServicesUrl('user', 'logout')}">
                <xsl:value-of select="portal:localize('Logout')"/>
              </a>
              <xsl:comment>googleon: anchor</xsl:comment>
            </xsl:when>
            <!-- User not logged in -->
            <xsl:when test="$fw:login-page">
              <a href="{portal:createPageUrl($fw:login-page/@key, ())}">
                <xsl:value-of select="portal:localize('Login')"/>
              </a>
            </xsl:when>
          </xsl:choose>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template name="mobile.footer">
    <div id="footer">
      <p>
        <!--<xsl:if test="$rss-page">
          <a href="{portal:createUrl($rss-page)}">
            <img src="{portal:createResourceUrl(concat($fw:theme-public, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
          </a>
        </xsl:if>-->
        <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
      </p>
      <p>
        <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'pc', 'lifetime', 'session'))}">
          <img src="{portal:createResourceUrl(concat($fw:theme-public, '/images-mobile/icon-pc.png'))}" alt="{portal:localize('PC-version')}" class="icon text"/>
          <xsl:value-of select="portal:localize('Change-to-pc-version')"/>
        </a>
      </p>
    </div>
  </xsl:template>

</xsl:stylesheet>
