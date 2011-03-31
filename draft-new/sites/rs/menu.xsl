<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:import href="global-variables.xsl" />
  
  <xsl:variable name="toplevel" as="element()*" select="$config-device-class/menu/toplevels/toplevel"/>
  <xsl:variable name="sublevel" as="element()*" select="$config-device-class/menu/sublevels/sublevel"/>
  <!-- Menu items on level 1 -->
  <xsl:variable name="menu" as="element()*" select="/result/menu/menuitems/menuitem"/>
  <!-- First menu level to display -->
  <xsl:variable name="main-menu" as="element()*" select="if ($config-site/multilingual = 'true') then $menu[@path = 'true']/menuitems/menuitem else $menu"/>
  <!-- Sub menu start level -->
  <xsl:variable name="sub-menu" as="element()*">
    <!-- Only if sublevel exists in skin config -->
    <xsl:if test="$sublevel">
      <xsl:choose>
        <!-- No toplevels, start submenu at menu level 1 -->
        <xsl:when test="count($toplevel) = 0 and $main-menu">
          <xsl:sequence select="$main-menu"/>
        </xsl:when>
        <!-- Start submenu at correct level, calculated from number of toplevels and multilingual -->
        <xsl:when test="$main-menu/descendant::menuitems[count(ancestor::menuitems) = (count($toplevel) + count($config-site/multilingual[. = 'true'])) and parent::menuitem/@path = 'true']/menuitem">
          <xsl:sequence select="$main-menu/descendant::menuitems[count(ancestor::menuitems) = (count($toplevel) + count($config-site/multilingual[. = 'true'])) and parent::menuitem/@path = 'true']/menuitem"/>
        </xsl:when>
        <!-- No regular sub menuitems and active menuitem is at last toplevel, start custom submenu at level 1 -->
        <xsl:when test="count($current-menuitem/ancestor::menuitems) = count($toplevel) + count($config-site/multilingual[. = 'true'])">
          <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
        </xsl:when>
        <!-- No regular sub menuitems, start custom submenu at correct level -->
        <xsl:otherwise>
          <xsl:sequence select="/result/custom-menu/menuitems/descendant::menuitem[ancestor::menuitem[1]/@path = 'true' and count(ancestor::menuitems) = count($toplevel) + count($config-site/multilingual[. = 'true'])]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>
  <!-- Menu items under current menu item. Used by mobile menu ajax call. -->
  <xsl:variable name="current-menuitem" as="element()?" select="/result/menu/menuitems/descendant::menuitem[@key = portal:getPageKey()]"/>
  
  
  
  <!-- Submenu only, used by mobile menu ajax call -->
  <xsl:template name="menu.sub-menu">
    <xsl:variable name="menuitem" as="element()*">
      <xsl:choose>
        <xsl:when test="$current-menuitem/menuitems/menuitem">
          <xsl:sequence select="$current-menuitem/menuitems/menuitem"/>
        </xsl:when>
        <xsl:when test="/result/context/querystring/parameter[@name = 'page']">
          <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/descendant::menuitem[@custom-key = /result/context/querystring/parameter[@name = 'page']]/menuitems/menuitem"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$menuitem">
      <div xmlns="http://www.w3.org/1999/xhtml">
        <div>
          <ul>
            <xsl:apply-templates select="$menuitem" mode="sub-menu-current"/>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- Horizontal menu -->
  <xsl:template name="menu.main-menu">
    <xsl:param name="current-menuitem" select="$main-menu"/>
    <xsl:param name="level" select="1"/>
    <ul class="menu horizontal main screen clearfix level{$level}">
      <xsl:choose>
        <!-- Fixed menu - calculate menuitem width -->
        <xsl:when test="$toplevel[$level]/@fixed = 'true'">
          <xsl:apply-templates select="$current-menuitem" mode="menu">
            <xsl:with-param name="levels" tunnel="yes" select="1"/>
            <xsl:with-param name="fixed" tunnel="yes" select="true()"/>
            <xsl:with-param name="rest" select="$layout-width mod count($current-menuitem)"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- Non-fixed menu -->
        <xsl:otherwise>
          <xsl:apply-templates select="$current-menuitem" mode="menu">
            <xsl:with-param name="levels" tunnel="yes" select="1"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
    <xsl:if test="($current-menuitem[@path = 'true']/menuitems/menuitem or ($current-menuitem[@active = 'true'] and /result/custom-menu/menuitems/menuitem/menuitems/menuitem)) and $level &lt; count($toplevel)">
      <xsl:variable name="menuitem" as="element()+">
        <xsl:sequence select="$current-menuitem[@path = 'true']/menuitems/menuitem"/>
        <xsl:if test="$current-menuitem[@active = 'true'] and /result/custom-menu/menuitems/menuitem/menuitems/menuitem">
          <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
        </xsl:if>
      </xsl:variable>
      <xsl:call-template name="menu.main-menu">
        <xsl:with-param name="current-menuitem" select="$menuitem"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- Display menu -->
  <xsl:template match="menuitem" mode="menu">
    <xsl:param name="levels" select="1000" tunnel="yes"/>
    <xsl:param name="level" select="1"/>
    <xsl:param name="fixed" tunnel="yes" select="false()"/>
    <xsl:param name="rest" select="0"/>
    <xsl:variable name="href" select="if (@type = 'custom') then portal:createPageUrl(@key, ('page', @custom-key)) else portal:createPageUrl(@key, ())"/>
    <li>
      <xsl:if test="$fixed">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="position() &lt;= $rest">fixed-add-one</xsl:when>
            <xsl:otherwise>fixed</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@type = 'label' or @type = 'section'">
          <div>
            <xsl:if test="position() = 1 or position() = last() or @path = 'true' or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true']))">
              <xsl:attribute name="class">
                <xsl:if test="position() = 1">
                  <xsl:text>first</xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
                <xsl:if test="@path = 'true'">
                  <xsl:text> path</xsl:text>
                </xsl:if>
                <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true'])">
                  <xsl:attribute name="class"> active</xsl:attribute>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <!-- Includes title to support the case of horizontal menu and a long menuitem name that doesn't fit in the design -->
            <xsl:attribute name="title">
              <xsl:value-of select="util:menuitem-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$href}">
            <xsl:if test="url/@newwindow = 'yes'">
              <xsl:attribute name="rel">external</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = 1 or position() = last() or @path = 'true' or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true']))">
              <xsl:attribute name="class">
                <xsl:if test="position() = 1">
                  <xsl:text>first</xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
                <xsl:if test="@path = 'true'">
                  <xsl:text> path</xsl:text>
                </xsl:if>
                <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true'])">
                  <xsl:attribute name="class"> active</xsl:attribute>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <!-- Includes title to support the case of horizontal menu and a long menuitem name that doesn't fit in the design -->
            <xsl:attribute name="title">
              <xsl:value-of select="util:menuitem-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Display next menu level -->
      <xsl:if test="((@path = 'true' and menuitems/menuitem) or (@type != 'custom' and @active = 'true' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem)) and $level &lt; $levels">
        <xsl:variable name="menuitem" as="element()+">
          <xsl:sequence select="menuitems/menuitem"/>
          <xsl:if test="@type != 'custom' and @active = 'true' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem">
            <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
          </xsl:if>
        </xsl:variable>
        <ul class="clearfix">
          <xsl:choose>
            <!-- Fixed width -->
            <xsl:when test="$fixed">
              <xsl:apply-templates select="$menuitem" mode="menu">
                <xsl:with-param name="level" select="$level + 1"/>
                <xsl:with-param name="rest" select="$layout-width mod count($menuitem)"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$menuitem" mode="menu">
                <xsl:with-param name="level" select="$level + 1"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <!-- Styles for fixed horizontal menu -->
  <xsl:template name="menu.main-menu-styles">
    <xsl:param name="current-menuitem" select="$main-menu"/>
    <xsl:param name="level" select="1"/>
    <xsl:if test="$toplevel[$level]/@fixed = 'true'">
      <xsl:variable name="current-menu-level" select="concat('.menu.main.level', $level)"/>
      <xsl:variable name="width-per-menuitem" select="floor($layout-width div count($current-menuitem))"/>
      <xsl:value-of select="concat($current-menu-level, ' .fixed-add-one { width: ', $width-per-menuitem + 1, 'px; } ', $current-menu-level, ' .fixed { width: ', $width-per-menuitem, 'px; }')"/>
    </xsl:if>
    <xsl:if test="($current-menuitem[@path = 'true']/menuitems/menuitem or ($current-menuitem[@active = 'true'] and /result/custom-menu/menuitems/menuitem/menuitems/menuitem)) and $level &lt; count($toplevel)">
      <xsl:variable name="menuitem" as="element()+">
        <xsl:sequence select="$current-menuitem[@path = 'true']/menuitems/menuitem"/>
        <xsl:if test="$current-menuitem[@active = 'true'] and /result/custom-menu/menuitems/menuitem/menuitems/menuitem">
          <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
        </xsl:if>
      </xsl:variable>
      <xsl:call-template name="menu.main-menu-styles">
        <xsl:with-param name="current-menuitem" select="$menuitem"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
  <!-- Display current sub menu for mobile menu ajax call -->
  <xsl:template match="menuitem" mode="sub-menu-current">
    <xsl:variable name="href" select="if (@type = 'custom') then portal:createPageUrl(@key, ('page', @custom-key)) else portal:createPageUrl(@key, ())"/>
    <li>
      <xsl:if test="position() = 1 or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true']))">
        <xsl:attribute name="class">
          <xsl:if test="position() = 1">
            <xsl:text>first</xsl:text>
          </xsl:if>
          <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem[@path = 'true'])">
            <xsl:attribute name="class"> active</xsl:attribute>
          </xsl:if>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@type = 'label' or @type = 'section'">
          <div>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$href}">
            <xsl:choose>
              <xsl:when test="@type = 'url' and url/@newwindow = 'yes'">
                <xsl:attribute name="rel">external</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:text>nav</xsl:text>
                  <xsl:choose>
                    <xsl:when test="(@path = 'true' and menuitems/menuitem) or (parameters/parameter[@name = 'custom-menu'] = 'true' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem)"> open</xsl:when>
                    <xsl:when test="menuitems/@child-count &gt; 0 or parameters/parameter[@name = 'custom-menu'] = 'true'"> closed</xsl:when>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </a>
          <a href="{$href}" class="bullet arrow">
            <xsl:if test="url/@newwindow = 'yes'">
              <xsl:attribute name="rel">external</xsl:attribute>
            </xsl:if>
            <br/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="(@path = 'true' and menuitems/menuitem) or (@type != 'custom' and @active = 'true' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem)">
        <xsl:variable name="menuitem" as="element()+">
          <xsl:sequence select="menuitems/menuitem"/>
          <xsl:if test="@type != 'custom' and @active = 'true' and /result/custom-menu/menuitems/menuitem/menuitems/menuitem">
            <xsl:sequence select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
          </xsl:if>
        </xsl:variable>
        <ul>
          <xsl:apply-templates select="$menuitem" mode="sub-menu-current"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>


</xsl:stylesheet>
