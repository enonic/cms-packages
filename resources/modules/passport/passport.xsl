<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities">
    
    <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
    <xsl:include href="/libraries/utilities/frame.xsl"/>
    <xsl:include href="/libraries/utilities/xhtml.xsl"/>
    <xsl:include href="/libraries/utilities/utilities.xsl"/>
    <xsl:include href="/libraries/utilities/error-handler.xsl"/>
    <xsl:include href="passport-lib.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
    <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
    <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
    <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
    <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
    <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
    <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
    <xsl:variable name="passport-config" as="element()*" select="document(concat($config-home, '/modules/passport.xml'))/passport"/>
    <xsl:variable name="passport-groups" as="element()*" select="$passport-config/groups/group"/>
    
    <xsl:template match="/">
        <xsl:call-template name="passport" />
    </xsl:template>
    
    <xsl:template name="passport">
            <xsl:choose>
                <xsl:when test="$login-page/@key = portal:getPageKey()">
                    <xsl:call-template name="passport-lib.passport">
                        <xsl:with-param name="user-image-src" tunnel="yes">
                            <xsl:if test="$user/photo/@exists = 'true'">
                                <xsl:value-of select="portal:createImageUrl(concat('user/', $user/@key), $config-filter)"/>
                            </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($theme-public, '/images/dummy-user.png'))"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="email-login" tunnel="yes" select="$passport-config/email-login"/>
                        <xsl:with-param name="edit-display-name" tunnel="yes" select="$passport-config/edit-display-name"/>
                        <xsl:with-param name="set-password" tunnel="yes" select="$passport-config/set-password"/>
                        <xsl:with-param name="userstore" tunnel="yes" select="/result/userstores/userstore"/>
                        <xsl:with-param name="time-zone" tunnel="yes" select="/result/time-zones/time-zone"/>
                        <xsl:with-param name="locale" tunnel="yes" select="/result/locales/locale"/>
                        <xsl:with-param name="country" tunnel="yes" select="/result/countries/country"/>
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="error" tunnel="yes" select="$error-user"/>
                        <xsl:with-param name="success" tunnel="yes" select="$success"/>
                        <xsl:with-param name="session-parameter" tunnel="yes" select="/result/context/session/attribute[@name = 'error_user_create']/form/parameter"/>
                        <xsl:with-param name="group" select="$passport-groups"/>
                        <xsl:with-param name="join-group-key" tunnel="yes" select="$passport-config/join-group-keys/join-group-key"/>
                        <xsl:with-param name="admin-name" tunnel="yes" select="$passport-config/admin-name"/>
                        <xsl:with-param name="admin-email" tunnel="yes" select="$passport-config/admin-email"/>
                        <xsl:with-param name="site-name" select="$site-name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="error-handler.error-handler">
                        <xsl:with-param name="error" select="/result/context/querystring/parameter[@name = 'http_status_code']"/>
                        <xsl:with-param name="url" select="$url"/>
                        <xsl:with-param name="exception-message" select="/result/context/querystring/parameter[@name = 'exception_message']"/>
                        <xsl:with-param name="admin-name" select="$passport-config/admin-name"/>
                        <xsl:with-param name="admin-email" select="$passport-config/admin-email"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
