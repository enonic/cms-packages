<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="/libraries/page/global-variables.xsl" />
  
  <xsl:template name="templates.localized-form-validator-script">
    <script type="text/javascript">
      <xsl:comment>
        
        $(function() {
        
        <!-- Validates all forms -->
        $('form:not(.dont-validate)').each(function() {
        $(this).validate({
        ignoreTitle: true,
        errorPlacement: function(label, element) {
        label.insertBefore(element.prev());
        }
        });
        });
        
        <!-- Adds and localizes datepicker for all date inputs -->
        <xsl:value-of select="concat('$(&quot;.datepicker&quot;).datepicker($.extend({dateFormat: &quot;', portal:localize('jquery-datepicker-date-format'), '&quot;}, $.datepicker.regional[&quot;', $language, '&quot;]));')"/>
        <!-- , onSelect: function(dateText, inst) {$(this).trigger(&quot;focus&quot;);} -->
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
  
  <xsl:template name="templates.login">
    <h1>
      <xsl:value-of select="util:menuitem-name($current-resource)"/>
    </h1>
    <xsl:choose>
      <xsl:when test="$login-page/@key = portal:getPageKey()">
        <xsl:call-template name="passport.passport">
          <xsl:with-param name="user-image-src" tunnel="yes">
            <xsl:if test="$user/photo/@exists = 'true'">
              <xsl:value-of select="portal:createImageUrl(concat('user/', $user/@key), $config-filter)"/>
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user.png'))"/>
          <xsl:with-param name="user" select="$user"/>
          <xsl:with-param name="email-login" tunnel="yes" select="$config-site/passport/email-login"/>
          <xsl:with-param name="edit-display-name" tunnel="yes" select="$config-site/passport/edit-display-name"/>
          <xsl:with-param name="set-password" tunnel="yes" select="$config-site/passport/set-password"/>
          <xsl:with-param name="userstore" tunnel="yes" select="/result/userstores/userstore"/>
          <xsl:with-param name="time-zone" tunnel="yes" select="/result/time-zones/time-zone"/>
          <xsl:with-param name="locale" tunnel="yes" select="/result/locales/locale"/>
          <xsl:with-param name="country" tunnel="yes" select="/result/countries/country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="error" tunnel="yes" select="$error-user"/>
          <xsl:with-param name="success" tunnel="yes" select="$success"/>
          <xsl:with-param name="session-parameter" tunnel="yes" select="/result/context/session/attribute[@name = 'error_user_create']/form/parameter"/>
          <xsl:with-param name="group" select="$config-group"/>
          <xsl:with-param name="join-group-key" tunnel="yes" select="$config-site/passport/join-group-keys/join-group-key"/>
          <xsl:with-param name="admin-name" tunnel="yes" select="$config-site/passport/admin-name"/>
          <xsl:with-param name="admin-email" tunnel="yes" select="$config-site/passport/admin-email"/>
          <xsl:with-param name="site-name" select="$site-name"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error-handler.error-handler">
          <xsl:with-param name="error" select="/result/context/querystring/parameter[@name = 'http_status_code']"/>
          <xsl:with-param name="url" select="$url"/>
          <xsl:with-param name="exception-message" select="/result/context/querystring/parameter[@name = 'exception_message']"/>
          <xsl:with-param name="admin-name" select="$config-site/passport/admin-name"/>
          <xsl:with-param name="admin-email" select="$config-site/passport/admin-email"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
