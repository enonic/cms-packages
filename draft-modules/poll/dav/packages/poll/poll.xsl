<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:param name="showTotalVotes" select="'false'"/>
  <xsl:param name="previousPollsPage">
    <type>page</type>
  </xsl:param>
  <xsl:variable name="urlParamPoll" select="/verticaldata/context/querystring/parameter[@name='poll']"/>
  <xsl:variable name="url">
    <xsl:choose>
      <xsl:when test="contains(/verticaldata/context/querystring/@url,'?')">
        <xsl:value-of select="substring-before(/verticaldata/context/querystring/@url,'?')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/verticaldata/context/querystring/@url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:if test="count(/verticaldata/contents/content) != 0">
      <xsl:apply-templates select="/verticaldata/contents/content" mode="showForm"/>
      <xsl:if test="$previousPollsPage != ''">
        <p>
          <a href="{portal:createPageUrl($previousPollsPage,())}">View Previous Poll Results</a>
        </p>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="content" mode="showForm">
    <div class="poll">
      <h5>
        <xsl:value-of select="title"/>
      </h5>
      <xsl:value-of disable-output-escaping="yes" select="contentdata/description"/>
      <xsl:variable name="thisPoll" select="concat('poll',@key)"/>
      <xsl:variable name="thisVote" select="concat('vote',@key)"/>
      <xsl:choose>
        <xsl:when test="/verticaldata/context/cookies/cookie[@name = $thisPoll] = 'done'">
          <xsl:apply-templates select="/verticaldata/contents/content[@key = current()/@key]" mode="showResult"/>
          <xsl:if test="$showTotalVotes = 'true'">
            <p>
              Total votes: <xsl:value-of select="contentdata/alternatives/@count"/>
            </p>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="formId" select="concat('formPoll',@key)"/>
          <xsl:variable name="votekey"><xsl:text>vote</xsl:text><xsl:value-of select="@key"/></xsl:variable>

          <xsl:variable name="redirectUrl" select="portal:createPageUrl(/verticaldata/context/querystring/parameter[@name = 'id'])"/>
          <form id="{$formId}" action="{portal:createServicesUrl('poll', 'update', $redirectUrl, ())}" method="post">
            <div>
              <!--input type="hidden" name="handler" value="poll"/>
              <input type="hidden" name="op" value="update"/-->
              <input type="hidden" name="key" value="{@key}"/>
              <!-- input type="hidden" name="redirect" value="{$url}?poll=vote{@key}"/-->
              <xsl:variable name="currentVote" select="concat('vote',@key)"/>
              <xsl:variable name="currentShow" select="concat('show',@key)"/>
              <ul class="poll-list">
                <xsl:for-each select="contentdata/alternatives/alternative">
                  <xsl:variable name="gid" select="generate-id(.)"/>
                  <li>
                    <xsl:choose>
                      <xsl:when test="parent::alternatives/@multiplechoice = 'yes'">
                        <input type="checkbox" name="poll{@id}" id="choice{$gid}" value="{@id}"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="radio" name="choice" id="choice{$gid}" value="{@id}"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <label for="choice{$gid}">
                      <xsl:value-of select="."/>
                    </label>
                  </li>
                </xsl:for-each>
              </ul>
              <input value="Vote" class="button" type="button" onmouseup="javascript:pollValidate('{$formId}')" />
            </div>
          </form>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  <xsl:template match="content" mode="showResult">
    <ul class="result">
      <xsl:for-each select="contentdata/alternatives/alternative">
        <xsl:variable name="percent" select="round(@count div (sum(../alternative/@count))*100)"/>
        <xsl:variable name="percentText" select="concat($percent,'%')"/>
        <li>
          <xsl:value-of select="."/> -
          <xsl:value-of select="$percentText"/>
          <div class="pollGraph">
            <xsl:attribute name="style">
              <xsl:text>width:</xsl:text>
              <xsl:value-of select="$percent"/>
              <xsl:text>%;</xsl:text>
            </xsl:attribute>
            <xsl:comment></xsl:comment>
          </div>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>