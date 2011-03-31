<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:variable name="language" as="xs:string" select="/result/context/@languagecode"/>
  <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
  <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
  <xsl:variable name="path" as="xs:string" select="concat('/', string-join(/result/context/resource/path/resource/name, '/'))"/>
  <xsl:variable name="skin" as="xs:string?" select="/result/preferences/preference[@basekey = 'skin']"/>
  <!-- Site configuration -->
  <xsl:variable name="config-site" as="element()" select="document(concat(/result/context/site/path-to-home-resources, '/sites/rs/config.xml'))/config"/>
  <xsl:variable name="config-parameter" as="element()*" select="$config-site/parameters/parameter"/>
  <xsl:variable name="config-group" as="element()*" select="$config-site/passport/groups/group"/>
  <xsl:variable name="config-skin" as="element()" select="if ($config-site/skins/skin[@name = $skin]) then document(concat('/skins/rs/', $skin, '/skin.xml'))/skin else document(concat('/skins/rs/', $config-site/skins/skin[1]/@name, '/skin.xml'))/skin"/>
  <xsl:variable name="config-device-class" as="element()" select="if ($config-skin/device-classes/device-class[tokenize(@name, ',')[. = $device-class]]) then $config-skin/device-classes/device-class[tokenize(@name, ',')[. = $device-class]] else $config-skin/device-classes/device-class[1]"/>
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
  
  <!-- Page mode: set to 'submenu' to display sub menu for mobile menu ajax call -->
  <xsl:variable name="page-mode" as="xs:string?" select="/result/context/querystring/parameter[@name = 'page-mode']"/>
  <xsl:variable name="site-search-term" as="xs:string?" select="/result/context/querystring/parameter[@name = 'q']"/>
  <xsl:variable name="device-class" as="xs:string" select="/result/context/device-class"/>
  <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
  <xsl:variable name="path-to-skin" select="concat('/_public/skins/advanced/', $config-skin/@name)"/>
  <xsl:variable name="rendered-page" as="element()" select="/result/context/page"/>
  
  <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
  <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
  <xsl:variable name="user" as="element()?" select="/result/context/user"/>
  <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
  <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
  <xsl:variable name="breadcrumb-path" as="element()*" select="if ($config-site/multilingual = 'true') then $current-resource/path/resource[position() &gt; 1] else $current-resource/path/resource"/>
  
  
</xsl:stylesheet>
