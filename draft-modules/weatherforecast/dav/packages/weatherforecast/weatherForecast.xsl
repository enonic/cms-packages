<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" extension-element-prefixes="date" version="2.0"
                xmlns:date="http://exslt.org/dates-and-times" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:saxon="http://saxon.sf.net" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

  <xsl:include href="/packages/site/border.xsl"/>
  <xsl:variable name="cities" select="document('cities.xml')"/>

  <xsl:variable name="selectedCity" select="/verticaldata/preferences/preference[@basekey = 'weatherForecast.city']"/>
  <xsl:variable name="selectedUnit" select="/verticaldata/preferences/preference[@basekey = 'weatherForecast.unit']"/>
  <xsl:variable name="instanceKey" select="portal:getInstanceKey()"/>
  <xsl:variable name="days">
    <xsl:choose>
      <xsl:when test="/verticaldata/preferences/preference[@basekey = 'weatherForecast.days'] != ''">
        <xsl:value-of select="/verticaldata/preferences/preference[@basekey = 'weatherForecast.days']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>5</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">

    <xsl:call-template name="borderStart">
      <xsl:with-param name="headerText" select="concat('Forecast for ', /verticaldata/weatherdata/location/name)"/>
      <xsl:with-param name="showPreferenceButton" select="true()"/>
    </xsl:call-template>
        
    <div id="preference-panel-{$instanceKey}" class="preference-panel" style="display:none;">

      Set preferences: 

      <form action="{portal:createServicesUrl('user', 'setpreferences', '')}" method="post">
        <p style="padding:0">
          <table border="0" cellpadding="2" cellspacing="0" style="width:100%">
            <tr>
              <td>
                City:
              </td>
              <td>
                <select name="PORTLET.weatherForecast.city" style="width:100%">
                  <xsl:for-each select="$cities/cities/city">
                    <option value="{url}">
                      <xsl:if test="($selectedCity and $selectedCity = url) or @default = 'true'">
                        <xsl:attribute name="selected">true</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="name"/>
                    </option>
                  </xsl:for-each>
                </select>
              </td>
            </tr>
            <tr>
              <td>
                Unit:
              </td>
              <td>
                <input type="radio" name="PORTLET.weatherForecast.unit" value="C">
                  <xsl:if test="$selectedUnit = 'C' or not($selectedUnit = '')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                </input>
                C
                <input type="radio" name="PORTLET.weatherForecast.unit" value="F">
                  <xsl:if test="$selectedUnit = 'F'">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                </input>
                F
              </td>
            </tr>
            <tr>
              <td>
                Days:
              </td>
              <td>
                <input type="text" name="PORTLET.weatherForecast.days" value="{$days}" style="width:20px;text-align:center"/>
              </td>
            </tr>
          </table>
          <p>
            <button>
              Save
            </button>
          </p>
        </p>
      </form>
    </div>
        
    <xsl:choose>
      <xsl:when test="count(/verticaldata/weatherdata/forecast/tabular/time[@period = 2]) !=0">
        <div>
          <xsl:apply-templates select="/verticaldata/weatherdata/forecast/tabular/time[@period = 2]"/>
        </div>
        <div style="clear:both">
          <a href="http://www.yr.no">yr.no</a>
        </div>
      </xsl:when>
      <xsl:otherwise>
        No items found
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="borderEnd"/>

  </xsl:template>

  <xsl:template match="time">
    <xsl:if test="position() &lt;= $days">

      <div class="weather-forecast-box">
        <xsl:variable name="from" select="substring-after(@from, 'T')"/>
        <xsl:variable name="to" select="substring-after(@to, 'T')"/>
        <xsl:variable name="period">
          <xsl:choose>
            <xsl:when test="@period  = 0">
              <xsl:text>night</xsl:text>
            </xsl:when>
            <xsl:when test="@period  = 1">
              <xsl:text>morning</xsl:text>
            </xsl:when>
            <xsl:when test="@period  = 2">
              <xsl:text>day</xsl:text>
            </xsl:when>
            <xsl:when test="@period  = 3">
              <xsl:text>evening</xsl:text>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="date" select="xs:date(substring(@from, 1, 10))" as="xs:date"/>
        <xsl:variable name="day-of-week" select="format-date($date, '[F1]', 'en', (), () )"/>

        <strong>
          <xsl:call-template name="formatDayOfWeek">
            <xsl:with-param name="day-of-week" select="number($day-of-week)"/>
          </xsl:call-template>
          <xsl:text> kl </xsl:text>
          <xsl:value-of select="substring($from, 1, 2)"/>
          <xsl:text> - </xsl:text>
          <xsl:text> kl </xsl:text>
          <xsl:value-of select="substring($to, 1, 2)"/>
        </strong>
        <br/>
        <p>
          <xsl:value-of select="symbol/@name"/>.<xsl:value-of select="windSpeed/@name"/>,
          <xsl:value-of select="windSpeed/@mps"/>
          m/s fra<xsl:value-of select="windDirection/@name"/>.
          <xsl:value-of select="concat(precipitation/@value, ' mm precipitation.')"/>
        </p>
        <p style="float: left; margin: 0">
          <xsl:variable name="icon">
            <xsl:choose>
              <xsl:when test="symbol/@number &lt; 10">
                <xsl:value-of select="concat('0', symbol/@number)"/>
              </xsl:when>
              <xsl:when test="symbol/@number &lt;= 3">
                <xsl:value-of select="concat('0', symbol/@number)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="symbol/@number"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="symbol/@number &lt; 9 and symbol/@number != 4">
              <xsl:choose>
                <xsl:when test="@period = 0">
                  <xsl:text>n</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>d</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:variable>
          <img src="http://www12.nrk.no/nyheter/ver/symbol/Versymbol_100px/{$icon}.png" alt="{symbol/@name}" width="50" height="50"/>
        </p>
        <p style="font-size: 2.2em; color: red; float: left; padding-top: 12px; font-weight: bold; margin: 0 0 0 12px">
          <xsl:variable name="temprature">
            <xsl:choose>
              <xsl:when test="$selectedUnit = 'F'">
                <xsl:value-of select="(number(temperature/@value) * 1.8) + 32"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="temperature/@value"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="concat($temprature, '°', $selectedUnit)"/>
        </p>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="formatDayOfWeek">
    <xsl:param name="day-of-week"/>
    <xsl:choose>
      <xsl:when test="$day-of-week = 1">Monday</xsl:when>
      <xsl:when test="$day-of-week = 2">Tuesday</xsl:when>
      <xsl:when test="$day-of-week = 3">Wedensday</xsl:when>
      <xsl:when test="$day-of-week = 4">Thursday</xsl:when>
      <xsl:when test="$day-of-week = 5">Friday</xsl:when>
      <xsl:when test="$day-of-week = 6">Saturday</xsl:when>
      <xsl:when test="$day-of-week = 7">Sunday</xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>