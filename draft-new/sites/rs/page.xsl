<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl"/>
  <xsl:import href="meta.xsl"/>
  <xsl:import href="menu.xsl"/>
  <xsl:import href="layout.xsl"/>
  <xsl:import href="regions.xsl"/>
  <xsl:import href="skin.xsl"/>
  <xsl:import href="user.xsl"/>
  <xsl:import href="functions.xsl"/>

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:include href="passport.xsl"/>
  <xsl:include href="error-handler.xsl"/>
  <xsl:include href="/libraries/utilities/google-analytics.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>

  <xsl:param name="north">
    <type>region</type>
  </xsl:param>
  <xsl:param name="west">
    <type>region</type>
  </xsl:param>
  <xsl:param name="center">
    <type>region</type>
  </xsl:param>
  <xsl:param name="east">
    <type>region</type>
  </xsl:param>
  <xsl:param name="south">
    <type>region</type>
  </xsl:param>

  <xsl:template match="/">
    <!-- Error casting -->
    <xsl:if test="not($config-site)">
      <xsl:value-of select="error(missingConfig, concat('Required sites/advanced/config.xml not found in: ', /result/context/site/path-to-home-resources))"/>
    </xsl:if>
    <xsl:if test="not($config-device-class)">
      <xsl:value-of select="error(missingDeviceClassConfig, 'Required config-device-class not resolved correctly.')"/>
    </xsl:if>
    <xsl:choose>
      <!-- Display submenu, used by mobile menu ajax call -->
      <xsl:when test="$page-mode = 'submenu'">
        <xsl:call-template name="menu.sub-menu"/>
      </xsl:when>
      <!-- Display framework for device class mobile -->
      <xsl:when test="$device-class = 'mobile'">
        <xsl:call-template name="mobile-page"/>
      </xsl:when>
      <!-- Display framework for device class pc (default) -->
      <xsl:otherwise>
        <xsl:call-template name="pc-page"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Framework for device class mobile -->
  <xsl:template name="mobile-page">
    
    <html xmlns="http://www.w3.org/1999/xhtml" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <!-- TODO: Display custom menu-item title -->
          <xsl:value-of select="util:menuitem-name($current-resource)"/>
          <xsl:value-of select="concat(' - ', $site-name)"/>
        </title>
        <xsl:call-template name="meta.mobile-tags"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/scripts/jquery-1.4.2.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/scripts/jquery.validate.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/scripts/jquery-ui-1.7.2.custom.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/scripts/jquery.cookie.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/advanced/scripts/common-all.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/advanced/scripts/common-mobile.js')}"/>
        <script type="text/javascript">
          <xsl:comment>
            
            $(function() {
            
              <!-- Mobile menu: Toggle -->
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
              });
            
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
              <xsl:value-of select="concat('$(&quot;.datepicker&quot;).datepicker($.extend({dateFormat: &quot;', portal:localize('jquery-datepicker-date-format'), '&quot;}, $.datepicker.regional[&quot;', $language, '&quot;]));')"/>
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
        <!-- iPhone icon -->
        <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/apple-touch-icon.png'))}"/>
        <!-- CSS -->
        <xsl:for-each select="$config-style[not(@type = 'conditional')]">
          <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css"/>
        </xsl:for-each>
        <style type="text/css">
          <xsl:call-template name="layout.mobile-regionstyles"/>
        </style>
      </head>
      <body>
        <!-- Header with logo and search box -->
        <div id="header" class="clearfix">
          <a href="{portal:createUrl($front-page)}">
            <img alt="{$site-name}-{portal:localize('logo')}" id="logo" src="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/logo.png'))}" title="{$site-name}"/>
          </a>
          <xsl:if test="$user or $login-page or $config-site/multilingual = 'true'">
            <div id="top-menu" class="screen">
              <xsl:choose>
                <!-- User logged in -->
                <xsl:when test="$user">
                  <img src="{if ($user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $user/@key), 'scalesquare(28);rounded(2)') else portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user-smallest.png'))}" title="{$user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $user/display-name)}">
                    <xsl:if test="$login-page">
                      <xsl:attribute name="class">user-image clickable</xsl:attribute>
                      <xsl:attribute name="onclick">
                        <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($login-page/@key, ()), '&quot;;')"/>
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
                <xsl:when test="$login-page">
                  <a href="{portal:createPageUrl($login-page/@key, ())}">
                    <xsl:value-of select="portal:localize('Login')"/>
                  </a>
                </xsl:when>
              </xsl:choose>
              <xsl:if test="$config-site/multilingual = 'true'">
                <select onchange="location.href = this.value;">
                  <xsl:for-each select="$menu">
                    <option value="{portal:createPageUrl(@key, ())}">
                      <xsl:if test="@path = 'true'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="parameters/parameter[@name = 'display-name']"/>
                    </option>
                  </xsl:for-each>
                </select>
              </xsl:if>
            </div>
          </xsl:if>
        </div>
        <div id="outer-container" class="clear clearfix">
          <!-- Mobile menu and search -->
          <xsl:if test="$main-menu">
            <div id="navigation" class="clearfix">
              <a href="#" class="bullet plus">
                <xsl:value-of select="portal:localize('Show-menu')"/>
              </a>
            </div>
            <!-- Menu -->
            <ul id="menu" class="clear">
              <!-- Does not support submenus under labels/sections, because the ajax request to a label page will fail -->
              <xsl:apply-templates select="$main-menu" mode="sub-menu-current"/>
            </ul>
          </xsl:if>
          <!-- Search box -->
          <xsl:if test="$search-result-page != ''">
            <form action="{portal:createUrl($search-result-page)}" method="get" class="clear" id="page-search-form">
              <fieldset>
                <label for="page-search-box">
                  <xsl:value-of select="portal:localize('Search')"/>
                </label>
                <input type="text" class="text" name="q" id="page-search-box" value="{$site-search-term}"/>
                <input type="submit" class="button" value="{portal:localize('Go')}"/>
              </fieldset>
            </form>
          </xsl:if>
          <div id="middle-container" class="clear clearfix">
            <!-- Region north -->
            <xsl:if test="$region-north-count > 0">
              <div id="north" class="clear clearfix">
                <xsl:call-template name="region.render-region">
                  <xsl:with-param name="region" select="'north'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-north/width - $layout-region-north/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
            <div id="inner-container" class="clear clearfix">
              <!-- Region center -->
              <div id="center" class="clear clearfix">
                <xsl:if test="$login-page/@key = portal:getPageKey() or $error-page/@key = portal:getPageKey()">
                  <h1>
                    <xsl:value-of select="util:menuitem-name($current-resource)"/>
                  </h1>
                  <xsl:choose>
                    <xsl:when test="$login-page/@key = portal:getPageKey()">
                      <xsl:call-template name="passport.passport">
                        <xsl:with-param name="user-image-src" tunnel="yes">
                          <xsl:if test="$user/photo/@exists = 'true'">
                            <xsl:value-of select="portal:createImageUrl(concat('user/', $user/@key), concat($config-filter, 'scalewidth(200)'))"/>
                          </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user-mobile.png'))"/>
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
                </xsl:if>
                <xsl:call-template name="region.render-region">
                  <xsl:with-param name="region" select="'center'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-center/width - $layout-region-center/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </div>
            <!-- Region south -->
            <xsl:if test="$region-south-count > 0">
              <div id="south" class="clear clearfix">
                <xsl:call-template name="region.render-region">
                  <xsl:with-param name="region" select="'south'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-south/width - $layout-region-south/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
          </div>
        </div>
        <!-- Footer -->
        <div id="footer">
          <p>
            <xsl:if test="$rss-page">
              <a href="{portal:createUrl($rss-page)}">
                <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
              </a>
            </xsl:if>
            <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
          </p>
          <p>
            <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'pc', 'lifetime', 'session'))}">
              <img src="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/icon-pc.png'))}" alt="{portal:localize('PC-version')}" class="icon text"/>
              <xsl:value-of select="portal:localize('Change-to-pc-version')"/>
            </a>
          </p>
        </div>
        <xsl:if test="$google-tracker != ''">
          <xsl:call-template name="google-analytics.google-analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <!-- Framework for device class pc (default) -->
  <xsl:template name="pc-page">
    <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:value-of select="util:menuitem-name($current-resource)"/>
          <xsl:value-of select="concat(' - ', $site-name)"/>
        </title>
        <xsl:call-template name="meta.meta-tags"/>

        <link rel="shortcut icon" type="image/x-icon" href="{portal:createResourceUrl(concat($path-to-skin, '/images/favicon.ico'))}"/>
        <xsl:call-template name="layout.stylesheets"/>
        <style type="text/css">
          <xsl:call-template name="layout.pc-regionstyles"/>
        </style>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/rs/scripts/jquery-1.4.3.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/rs/scripts/jquery.cookie.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/rs/scripts/common.js')}"/>
      </head>
      <body>
        <div id="outer-container">
          <!-- Header with logo, top menu, user menu and search box -->
          <div id="header">
              <div class="header-content">
                <img src="{portal:createResourceUrl('/_public/sites/rs/images/rs-logo.png')}" />
                <ul id="global-options">
                  <xsl:if test="$config-site/accessibility-text-size = 'true'">
                    <li id="text-size">
                      <a href="#">A</a>
                      <a href="#" class="large-text">A</a>
                      <a href="#" class="largest-text">A</a>
                    </li>
                  </xsl:if>
                  <xsl:if test="$config-site/accessibility-contrast = 'true'">
                    <li>
                      <a href="#" id="contrast">
                        <xsl:value-of select="portal:localize('High-contrast')"/>
                      </a>
                    </li>
                  </xsl:if>
                </ul>
              </div>
              <!-- Search box -->
              <xsl:call-template name="functions.searchbox"/>
          </div>

          <!-- Main menu -->
          <h1>
            <xsl:copy-of select="$menu" />
          </h1>
          
          <xsl:if test="$main-menu and count($toplevel) &gt; 0">
            <div id="main-menu">
              <xsl:call-template name="menu.main-menu"/>
            </div>
          </xsl:if>

          <xsl:call-template name="functions.breadcrumbs"/>
          <xsl:comment>googleon: index</xsl:comment>
          <xsl:comment>startindex</xsl:comment>
          <div id="middle-container">

            <div id="inner-container">
              <!-- Sub menu and region west -->
              <xsl:if test="$region-west-count > 0 or $sub-menu">
                <div id="west">
                  <xsl:if test="$sub-menu">
                    <xsl:comment>googleoff: index</xsl:comment>
                    <xsl:comment>stopindex</xsl:comment>
                    <ul id="sub-menu">
                      <xsl:choose>
                        <xsl:when test="count($toplevel) &gt; 0">
                          <xsl:variable name="parent-menuitem" as="item()">
                            <xsl:choose>
                              <xsl:when test="$sub-menu/ancestor::*[4]/name() = 'custom-menu'">
                                <xsl:sequence select="$current-menuitem"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:sequence select="$sub-menu/ancestor::menuitem[1]"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <li>
                            <xsl:choose>
                              <xsl:when test="$parent-menuitem/@type = 'label' or $parent-menuitem/@type = 'section'">
                                <div class="first">
                                  <xsl:value-of select="util:menuitem-name($parent-menuitem)"/>
                                </div>
                              </xsl:when>
                              <xsl:otherwise>
                                <a href="{if ($parent-menuitem/@type = 'custom') then portal:createPageUrl($parent-menuitem/@key, ('page', $parent-menuitem/@custom-key)) else portal:createPageUrl($parent-menuitem/@key, ())}" class="first">
                                  <xsl:value-of select="util:menuitem-name($parent-menuitem)"/>
                                </a>
                              </xsl:otherwise>
                            </xsl:choose>
                            <ul>
                              <xsl:apply-templates select="$sub-menu" mode="menu">
                                <xsl:with-param name="levels" tunnel="yes" select="count($sublevel)"/>
                              </xsl:apply-templates>
                            </ul>
                          </li>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="$sub-menu" mode="menu">
                            <xsl:with-param name="levels" tunnel="yes" select="count($sublevel)"/>
                          </xsl:apply-templates>
                        </xsl:otherwise>
                      </xsl:choose>
                    </ul>
                    <xsl:comment>googleon: index</xsl:comment>
                    <xsl:comment>startindex</xsl:comment>
                  </xsl:if>

                  <xsl:call-template name="region.render-region">
                    <xsl:with-param name="region" select="'west'"/>
                    <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                      <xsl:sequence select="'_config-region-width', xs:integer($layout-region-west/width - $layout-region-west/padding * 2), $standard-region-parameters"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </xsl:if>

              <!-- Region center -->
              <div id="center" class="column clearfix">
                <!-- If current page is login and error page -->
                <xsl:if test="$login-page/@key = portal:getPageKey() or $error-page/@key = portal:getPageKey()">
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
                </xsl:if>
                <xsl:call-template name="region.render-region">
                  <xsl:with-param name="region" select="'center'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', $center-column-attribute[1], $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
              <!-- Region east -->
              <xsl:if test="$region-east-count > 0">
                <div id="east" class="column clearfix screen">
                  <xsl:call-template name="region.render-region">
                    <xsl:with-param name="region" select="'east'"/>
                    <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                      <xsl:sequence select="'_config-region-width', xs:integer($layout-region-east/width - $layout-region-east/padding * 2), $standard-region-parameters"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </xsl:if>
            </div>
          </div>
          <xsl:comment>googleoff: index</xsl:comment>
          <xsl:comment>stopindex</xsl:comment>
          <!-- Footer -->
          <div id="footer">
            <xsl:if test="$rss-page">
              <a href="{portal:createUrl($rss-page)}">
                <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
              </a>
            </xsl:if>

            <!-- Text main menu in footer -->
            <xsl:if test="$config-device-class/menu/footer = 'true' and $main-menu and count($toplevel) &gt; 0">
              <ul class="menu horizontal footer screen">
                <xsl:apply-templates select="$main-menu" mode="menu">
                  <xsl:with-param name="levels" tunnel="yes" select="1"/>
                </xsl:apply-templates>
              </ul>
            </xsl:if>

            <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="device-class screen" rel="nofollow">
              <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
            </a>
          </div>
        </div>
        <xsl:if test="$google-tracker != ''">
          <xsl:call-template name="google-analytics.google-analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
