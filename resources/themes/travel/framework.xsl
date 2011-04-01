<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>
   
   <!-- Includes -->
   <xsl:include href="error-handler.xsl"/>
   <xsl:include href="/libraries/utilities/google-analytics.xsl"/>
   <xsl:include href="/libraries/utilities/utilities.xsl"/>

   <!-- Variables -->
   <xsl:variable name="result" select="/result" as="element()"/>   
   <xsl:variable name="language" as="xs:string" select="/result/context/@languagecode"/>
   <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
   <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
   <xsl:variable name="path" as="xs:string" select="concat('/', string-join(/result/context/resource/path/resource/name, '/'))"/>
   <!-- Site configuration -->
   <xsl:variable name="config-xml" as="document-node()" select="document(concat(/result/context/site/path-to-home-resources, '/config.xml'))"/>
   <xsl:variable name="config" as="element()" select="$config-xml/config"/>
   <xsl:variable name="config-layout" as="element()" select="$config-xml/config"/><!-- deprecated, $config -->
   <xsl:variable name="config-site" as="element()" select="$config-xml/config"/><!-- deprecated, $config -->
   <xsl:variable name="config-region-prefix" as="xs:string" select="$config-site/region-prefix"/>
   <xsl:variable name="config-parameter" as="element()*" select="$config-site/parameters/parameter"/>
   <xsl:variable name="config-group" as="element()*" select="$config-site/passport/groups/group"/>
   <xsl:variable name="config-device-class" as="element()" select="if ($config-layout/device-classes/device-class[tokenize(@name, ',')[. = $device-class]]) then $config-layout/device-classes/device-class[tokenize(@name, ',')[. = $device-class]] else $config-layout/device-classes/device-class[1]"/>
   <xsl:variable name="config-filter">
      <xsl:value-of select="string-join($config-device-class/image/filters/filter, ';')"/>
      <xsl:if test="$config-device-class/image/filters/filter != ''">;</xsl:if>
   </xsl:variable>
   <xsl:variable name="config-style" as="element()*" select="$config-device-class/styles/style"/>
   <xsl:variable name="front-page" select="util:get-scoped-parameter('front-page', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="search-result-page" select="util:get-scoped-parameter('search-result', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="sitemap-page" select="util:get-scoped-parameter('sitemap', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="rss-page" select="util:get-scoped-parameter('rss', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="google-tracker" select="util:get-scoped-parameter('google-tracker', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="google-verify" select="util:get-scoped-parameter('google-verify', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="standard-region-parameters" as="xs:anyAtomicType*">
      <!--<xsl:sequence select="'_config-layout', $config-layout/@name, '_config-site', 'advanced'"/>-->
   </xsl:variable>
   <xsl:variable name="site-public" select="/result/context/site/path-to-public-home-resources" as="xs:string"/>
   <xsl:variable name="theme-public" select="/result/context/site/path-to-public-home-resources" as="xs:string"/><!-- deprecated, $site-config -->
   <xsl:variable name="path-to-skin" select="/result/context/site/path-to-public-home-resources" as="xs:string"/><!-- deprecated, $site-config -->
   <xsl:variable name="path-to-public-resources" select="/result/context/site/path-to-public-home-resources" as="xs:string"/><!-- deprecated, $site-config -->
   <xsl:variable name="rendered-page" as="element()" select="/result/context/page"/>
   <xsl:variable name="active-regions" as="element()*">
      <xsl:copy-of select="$rendered-page/regions/region[count(windows/window) gt 0]"/>
   </xsl:variable>
   <xsl:variable name="device-class" as="xs:string" select="/result/context/device-class"/>
   <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
   <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
   <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
   <xsl:variable name="user" as="element()?" select="/result/context/user"/>
   <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
   <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
   <!-- Meta data -->
   <xsl:variable name="meta-generator" select="util:get-scoped-parameter('meta-generator', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="meta-author" select="util:get-scoped-parameter('meta-author', $path, $config-parameter)" as="element()?"/>
   <xsl:variable name="meta-description">
      <xsl:choose>
         <xsl:when test="/result/contents/content/contentdata/meta-description != ''">
            <xsl:value-of select="/result/contents/content/contentdata/meta-description"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$current-resource/description"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="meta-keywords">
      <xsl:choose>
         <xsl:when test="/result/contents/content/contentdata/meta-keywords != ''">
            <xsl:value-of select="/result/contents/content/contentdata/meta-keywords"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$current-resource/keywords"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="meta-content-key">
      <xsl:value-of select="/result/context/resource[@type = 'content']/@key"/>
   </xsl:variable>
   <xsl:variable name="meta-content-type">
      <xsl:value-of select="/result/context/resource[@type = 'content']/type"/>
   </xsl:variable>



   <!-- Regions template -->
   <!-- Renders all regions defined in config.xml -->
   <xsl:template name="framework.regions">
      <xsl:for-each select="$config-device-class/layout//region">
         <!-- Creates region if it contains portlets -->
         <xsl:if test="count($rendered-page/regions/region[name = concat($config-region-prefix, current()/@name)]/windows/window) gt 0 or (current()/system = 'true' and ($login-page/@key = portal:getPageKey() or $error-page/@key = portal:getPageKey()))">
            <div id="{concat($config-region-prefix, current()/@name)}" class="region">
               <xsl:variable name="width">
                  <xsl:choose>
                     <xsl:when test="scalable = 'true'">
                        <xsl:variable name="active-siblings" as="element()*" select="../region[not(scalable = 'true')][index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]"/>
                        <xsl:variable name="width-of-siblings" as="xs:integer">
                           <xsl:value-of select="sum($active-siblings/width) + sum($active-siblings/margin/*) + sum($active-siblings/padding/*)"/>
                        </xsl:variable>
                        <xsl:variable name="padding-width" as="xs:integer">
                           <xsl:value-of select="if (padding/node()) then sum(padding/node()[name() = 'left' or name() = 'right']) else 0" />
                        </xsl:variable>
                        <xsl:value-of select="xs:integer(../@width) - $width-of-siblings - $padding-width"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="width"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:call-template name="framework.render-region">
                  <xsl:with-param name="region" select="concat($config-region-prefix, current()/@name)"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                     <xsl:sequence select="'_config-region-width', xs:integer($width), $standard-region-parameters"/>
                  </xsl:with-param>
               </xsl:call-template>
            </div>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   
   
    
   <!-- region size css (width, margin, padding) for active regions -->
   <xsl:template match="region" mode="css">
      <xsl:variable name="width" as="xs:integer">
         <xsl:choose>
            <xsl:when test="scalable = 'true'">
               <xsl:variable name="active-siblings" as="element()*" select="../region[not(scalable = 'true')][index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]"/>
               <xsl:variable name="width-of-siblings" as="xs:integer">
                  <xsl:value-of select="sum($active-siblings/width) + sum($active-siblings/margin/*) + sum($active-siblings/padding/*)"/>
               </xsl:variable>
               <xsl:variable name="padding-width" as="xs:integer">
                  <xsl:value-of select="if (padding/node()) then sum(padding/node()[name() = 'left' or name() = 'right']) else 0" />
               </xsl:variable>
               <xsl:value-of select="xs:integer(../@width) - $width-of-siblings - $padding-width"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="width"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="margin" as="xs:string" select="if (margin/node()) then concat(if (margin/top) then margin/top else 0, 'px ', if (margin/right) then margin/right else 0, 'px ', if (margin/bottom) then margin/bottom else 0, 'px ', if (margin/left) then margin/left else 0, 'px') else '0'"/>
      <xsl:variable name="padding" as="xs:string" select="if (padding/node()) then concat(if (padding/top) then padding/top else 0, 'px ', if (padding/right) then padding/right else 0, 'px ', if (padding/bottom) then padding/bottom else 0, 'px ', if (padding/left) then padding/left else 0, 'px') else '0'"/>

      <xsl:value-of select="concat('#', @name, '{')"/>
      <xsl:value-of select="concat('width: ', $width, 'px;')"/>
      <xsl:value-of select="concat('margin: ', $margin, ';')"/>
      <xsl:value-of select="concat('padding: ', $padding, ';')"/>
      <xsl:text>}</xsl:text>
   </xsl:template>
   
   
   
   <!-- Region template -->
   <!-- Create portlet placeholder for region -->
   <xsl:template name="framework.render-region">
      <xsl:param name="region"/>
      <xsl:param name="parameters" as="xs:anyAtomicType*"/>
      <xsl:for-each select="$rendered-page/regions/region[name = $region]/windows/window">
         <xsl:value-of select="portal:createWindowPlaceholder(@key, $parameters)"/>
      </xsl:for-each>
   </xsl:template>
   
   

   <!-- Title template -->
   <!-- Output for page title based on current location in menutree and the site name -->
   <xsl:template name="framework.title">
      <xsl:value-of select="util:menuitem-name($current-resource)"/>
      <xsl:value-of select="concat(' - ', $site-name)"/>
   </xsl:template>
   
   

   <!-- Accessibility links -->
   <!-- Renders hotkeys to access different anchors as defined in the config.xml -->
   <xsl:template name="framework.accessibility">
      <xsl:if test="exists($config/accessibility/access-key)">
         <ul id="accessibility-links">
            <xsl:for-each select="$config/accessibility/access-key">
               <li>
                  <a href="#{@anchor}" accesskey="{@key}">
                     <xsl:value-of select="portal:localize(@text)"/>
                  </a>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:if>
   </xsl:template>
   
   
   
   <!-- Metadata common template -->
   <!-- Renders standard metadata based on config.xml -->
   <xsl:template name="framework.meta-common">
      <meta name="robots" content="all"/>
      <xsl:if test="$meta-generator != ''">
         <meta name="generator" content="{$meta-generator}"/>
      </xsl:if>
      <meta http-equiv="content-language" content="{$language}"/>
      <xsl:if test="$meta-author != ''">
         <meta name="author" content="{$meta-author}"/>
      </xsl:if>
      <xsl:if test="$meta-description != ''">
         <meta name="description" content="{$meta-description}"/>
      </xsl:if>
      <xsl:if test="$meta-keywords != ''">
         <meta name="keywords" content="{$meta-keywords}"/>
      </xsl:if>
      <xsl:if test="$google-verify != ''">
         <meta content="{$google-verify}" name="google-site-verification"/>
      </xsl:if>
      <xsl:if test="$meta-content-key != ''">
         <meta name="_key" content="{$meta-content-key}"/>
      </xsl:if>
      <xsl:if test="$meta-content-type != ''">
         <meta name="_cty" content="{$meta-content-type}"/>
      </xsl:if>
   </xsl:template>
   
   

   <!-- Css common template -->
   <!-- Renders all CSS files and creates CSS for the regions defined in config.xml  -->
   <xsl:template name="framework.css-common">
      <xsl:for-each select="$config-style[not(@condition != '')]">
         <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css"/>
      </xsl:for-each>

      <xsl:if test="$config-style[@condition != '']">
         <xsl:text disable-output-escaping="yes">&lt;!--[if </xsl:text>
         <xsl:for-each-group select="$config-style[@condition != '']" group-by="@condition">
            <xsl:value-of select="@condition"/>
            <xsl:text disable-output-escaping="yes">]&gt;</xsl:text>
            <xsl:for-each select="$config-style[@condition = current()/@condition]">
               <xsl:text disable-output-escaping="yes">&lt;link rel="stylesheet" type="text/css" href="</xsl:text>
               <xsl:value-of select="portal:createResourceUrl(.)"/>
               <xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
         </xsl:for-each-group>
      </xsl:if>

      <!-- insert region size css for active regions -->
      <style type="text/css">
         <xsl:apply-templates select="$config-device-class/layout//region[index-of($active-regions/name, concat($config-region-prefix, @name)) castable as xs:integer]" mode="css"/>
        </style>
   </xsl:template>
   
   

   <!-- Script common template -->
   <!-- Renders all javascripts for current device as defined in config.xml -->
   <xsl:template name="framework.script-common">
      <xsl:for-each select="$config-device-class/scripts/script">
         <script type="text/javascript" src="{portal:createResourceUrl(current())}"/>
      </xsl:for-each>
   </xsl:template>
   
   
   
   <!-- Menu template -->
   <!-- Renders a standard ul-li menutree based on parameters sent as input -->
   <xsl:template name="framework.menu">
      <xsl:param name="menuitems" select="/result/menus/menu/menuitems" as="element()*"/>
      <xsl:param name="levels" select="0" as="xs:integer"/>
      <xsl:param name="currentLevel" select="1" as="xs:integer"/>
      <xsl:param name="list-class" />
      <xsl:param name="list-id" />
      
      <xsl:choose>
         <xsl:when test="exists($menuitems)">
            <xsl:if test="$menuitems/menuitem">
               <ul>
                  <xsl:if test="$list-class != ''">
                     <xsl:attribute name="class">
                        <xsl:value-of select="$list-class" />
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$list-id != ''">
                     <xsl:attribute name="id">
                        <xsl:value-of select="$list-id" />
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:for-each select="$menuitems/menuitem">
                     <li class="menu-level-{$currentLevel}">
                        <xsl:if test="@path = 'true'">
                           <xsl:attribute name="class">menu-level-<xsl:value-of select="$currentLevel"/> active</xsl:attribute>
                        </xsl:if>
                        <a href="{portal:createPageUrl(@key, ())}" class="{if (current()/@path = 'true') then 'path' else ''} {if (position() = 1) then 'first' else if (position() = last()) then 'last' else ''}">
                           <xsl:choose>
                              <xsl:when test="menu-name != ''">
                                 <xsl:value-of select="menu-name"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="display-name"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </a>
                        <xsl:if test="current()/menuitems">
                           <xsl:if test="$levels = 0 or $levels > $currentLevel">
                              <xsl:call-template name="framework.menu">
                                 <xsl:with-param name="menuitems" select="current()/menuitems"/>
                                 <xsl:with-param name="currentLevel" select="$currentLevel + 1"/>
                                 <xsl:with-param name="levels" select="$levels"/>
                              </xsl:call-template>
                           </xsl:if>
                        </xsl:if>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <p>No menuitems exists on current menu element</p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
