<?xml version="1.0"?>
<xsl:stylesheet exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fw="http://www.enonic.com/cms/xslt/framework"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:util="http://www.enonic.com/cms/xslt/utilities">
    
    <xsl:import href="/modules/library-stk/utilities/fw-variables.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/frame.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/html.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/system.xsl"/>
    <xsl:include href="/modules/library-stk/utilities/error.xsl"/>
    <xsl:include href="passport-lib.xsl"/>
    
    <xsl:output indent="yes" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
    <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
    <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
    <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
    <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
    <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
    <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
    <xsl:variable name="passport-config" as="element()*" select="document(concat($fw:config-home, '/modules/passport.xml'))/passport"/>
    <xsl:variable name="passport-groups" as="element()*" select="$passport-config/groups/group"/>
    
    <xsl:template match="/">
        <xsl:call-template name="passport" />
    </xsl:template>
    
    <xsl:template name="passport">
            <xsl:choose>
                <xsl:when test="$login-page/@key = portal:getPageKey()">
                    <xsl:call-template name="passport-lib.passport">
                        <xsl:with-param name="user-image-src" tunnel="yes">
                            <xsl:if test="$fw:user/photo/@exists = 'true'">
                                <xsl:value-of select="portal:createImageUrl(concat('user/', $fw:user/@key), ())"/>
                            </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($fw:theme-public, '/images/dummy-user.png'))"/>
                        <xsl:with-param name="user" select="$fw:user"/>
                        <xsl:with-param name="email-login" tunnel="yes" select="$passport-config/email-login"/>
                        <xsl:with-param name="edit-display-name" tunnel="yes" select="$passport-config/edit-display-name"/>
                        <xsl:with-param name="set-password" tunnel="yes" select="$passport-config/set-password"/>
                        <xsl:with-param name="userstore" tunnel="yes" select="/result/userstores/userstore"/>
                        <xsl:with-param name="time-zone" tunnel="yes" select="/result/time-zones/time-zone"/>
                        <xsl:with-param name="locale" tunnel="yes" select="/result/locales/locale"/>
                        <xsl:with-param name="country" tunnel="yes" select="/result/countries/country"/>
                        <xsl:with-param name="language" select="$fw:language"/>
                        <xsl:with-param name="error" tunnel="yes" select="$error-user"/>
                        <xsl:with-param name="success" tunnel="yes" select="$success"/>
                        <xsl:with-param name="session-parameter" tunnel="yes" select="/result/context/session/attribute[@name = 'error_user_create']/form/parameter"/>
                        <xsl:with-param name="group" select="passport-group"/>
                        <xsl:with-param name="join-group-key" tunnel="yes" select="$passport-config/join-group-keys/join-group-key"/>
                        <xsl:with-param name="admin-name" tunnel="yes" select="$passport-config/admin-name"/>
                        <xsl:with-param name="admin-email" tunnel="yes" select="$passport-config/admin-email"/>
                        <xsl:with-param name="site-name" select="$fw:site-name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="util:error.handle" />
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
