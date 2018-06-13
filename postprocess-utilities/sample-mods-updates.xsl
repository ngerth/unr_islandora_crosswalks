<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:cdm="http://www.oclc.org/contentdm"
    exclude-result-prefixes="xs"  extension-element-prefixes="saxon"
    version="2.0">
    
    <!-- Samples of xsl for interventions on ContentDM-to-MODS crosswalk output prior to ingest to Islandora.  -->

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:strip-space elements="*"/>
    
    
    <!-- identity transform to copy through all nodes (except those with specific templates modifying them) -->    
    <xsl:template match="/" exclude-result-prefixes="#all">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="* | @*" exclude-result-prefixes="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | *| text() | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>

    <!-- keep comments and PIs						-->
    <xsl:template match="comment() | processing-instruction()">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    
    <!-- Shows simultaneous cleanup of subjects with more than one topic and topic values that need to be split -->
    <xsl:template match="mods:subject[mods:topic and not(mods:name)]" exclude-result-prefixes="#all">
        <xsl:variable name="subject-attributes" select="@*"/>
        <xsl:for-each select="mods:topic">
            <xsl:for-each select="tokenize(.,';')">
                <subject xmlns="http://www.loc.gov/mods/v3">
                    <xsl:copy-of select="$subject-attributes"/>
                    <topic><xsl:value-of select="normalize-space(.)"/></topic>
                </subject>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="mods:subject[not(mods:topic) and mods:name]" exclude-result-prefixes="#all">
        <xsl:variable name="subject-attributes" select="@*"/>
        <xsl:for-each select="mods:name/mods:namePart">
                <subject xmlns="http://www.loc.gov/mods/v3">
                    <xsl:copy-of select="$subject-attributes"/>
                    <name>
                        <xsl:copy-of select="., parent::mods:name/mods:role"/>
                    </name>
                </subject>
        </xsl:for-each>
    </xsl:template>    
        
    <!-- Shows bust out of names that have more than one namePart (names) -->
    <xsl:template match="mods:name" exclude-result-prefixes="#all">
        <xsl:variable name="name-attributes" select="@*"/>
        <xsl:choose>
            <!--  more than one namePart? fix up -->
            <xsl:when test="count(mods:namePart[normalize-space()]) > 1">
                <xsl:for-each select="mods:namePart">
                    <name xmlns="http://www.loc.gov/mods/v3">
                        <xsl:copy-of select="$name-attributes"/>
                        <namePart><xsl:value-of select="."/></namePart>
                        <xsl:apply-templates select="parent::mods:name/*[not(self::mods:namePart)]"/>
                    </name>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | *| text() | comment() | processing-instruction()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
            
    <!-- shows how to remove some empty elements -->
    <xsl:template match="mods:name[not(mods:namePart[normalize-space()])]
        | mods:genre[not(normalize-space())]
        | mods:extent[not(normalize-space())]
        | mods:physicalDescription[not(*[normalize-space()])]
        | mods:subject[mods:cartographics][not(mods:cartographics/mods:coordinates[normalize-space()])]
        | mods:typeOfResource[not(normalize-space())]
        | mods:language[not(mods:languageTerm[normalize-space()])]
        | mods:relatedItem/mods:extension/*:FULLTEXT[not(normalize-space())]
        | mods:accessCondition[not(normalize-space())]
        | mods:note[not(normalize-space())]
        | mods:relatedItem[@type = 'host'][mods:identifier[@type = 'collectionName'] or not(*)]
        | mods:relatedItem[@otherType = 'FULLTEXTDatastream'][normalize-space(mods:extension) = '']"/>

</xsl:stylesheet>
