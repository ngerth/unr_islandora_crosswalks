<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.ascc.net/xml/schematron">
    <ns uri="http://www.loc.gov/mods/v3" prefix="mods"/>
    <ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <pattern name="titleInfo: must be present">
        <rule context="mods:mods/mods:titleInfo">
            <assert test="count(mods:titleInfo[not(@type)]) = 1">Your record must include 1 titleInfo without type attribute</assert>
        </rule>
    </pattern>
    <pattern name="typeOfResource: must be present">
        <rule context="mods:mods/mods:typeOfResource">
            <assert test="mods:typeOfResource = 'text' or 'cartographic' or 'notated music' or 'sound recording-musical' or 'sound recording-nonmusical' or 'still image' or 'moving image' or 'three dimensional object' or 'software, multimedia' or 'mixed material'">Your record must include typeOfResource with controlled vocabulary</assert>
        </rule>
    </pattern>
    <pattern name="originInfo: only one must be present">
        <rule context="mods:mods/mods:originInfo">
            <assert test="not(mods:originInfo[2])">Your record must include only one originInfo</assert>
        </rule>
    </pattern>
    <pattern name="1 keyDate">
        <rule context="mods:mods">
            <assert test="count(descendant::*[@keyDate])=1">@keyDate should be used exactly once per record, within a mods:originInfo element</assert>
        </rule>
    </pattern>
    <pattern name="@keyDate in W3CDTF">
        <rule context="*[@keyDate]">
            <assert test="*[@encoding='w3cdtf']">@keyDate should be expressed using W3CDTF</assert>
            <assert test="ancestor::mods:originInfo">@keyDate should appear within mods:originInfo.</assert>
        </rule>
    </pattern>
    <pattern name="language: languageTerm must be present">
        <rule context="mods:mods/mods:language/mods:languageTerm">
            <assert test="mods:language/mods:languageTerm[@type]">languageTerm is required under language; @type is required</assert>
        </rule>
    </pattern>
    <pattern name="languageTerm: @type must be 'code'">
        <rule context="mods:languageTerm">
            <assert test="@type = 'code'">@type should be "code" and the value should be in code form</assert>
        </rule>
    </pattern>
    <pattern name="languageTerm: @authority must be 'iso639-2b'">
        <rule context="mods:languageTerm">
            <assert test="@authority = 'iso639-2b'">@authority should be "iso639-2b" and the value should be in code form</assert>
        </rule>
    </pattern>
    <pattern name="physicalDescription: must be present">
        <rule context="mods:mods/mods:physicalDescription">
            <assert test="mods:physicalDescription">Your record must include physicalDescription</assert>
        </rule>
    </pattern>
    <pattern name="physicalDescription: internetMediaType must have / ">
        <rule context="mods:mods/mods:physicalDescription/mods:internetMediaType">
            <assert test="mods:internetMediaType[contains(., '/')]"></assert>
        </rule>
    </pattern>
    <pattern name="physicalDescription: digitalOrigin must have value from controlled vocabulary">
        <rule context="mods:mods/mods:physicalDescription/mods:digitalOrigin">
            <assert test="mods:physicalDescription/mods:digitalOrigin = 'born digital' or 'reformatted digital' or 'digitized microfilm' or 'digital other analog'">Your record must include digitalOrigin with controlled vocabulary</assert>
        </rule>
    </pattern>
    <pattern name="subject: is present, must have @authority with set list of values">
        <rule context="mods:subject">
            <assert test="@authority='lcsh' or @authority='tgm' or @authority='local'">subject @authority with one of these values: lcsh, tgm, or local</assert>
        </rule>
    </pattern>
    <pattern name="identifier: @type must be present">
        <rule context="mods:identifier">
            <assert test="@type">@type is required under identifier</assert>
        </rule>
    </pattern>
    <pattern name="location must have url">
        <rule context="mods:mods/mods:location">
            <assert test="mods:url">location must have url</assert>
        </rule>
    </pattern>
    <pattern name="accessCondition: must have @type">
        <rule context="mods:accessCondition">
            <assert test="@type">accessCondition must include @type</assert>
        </rule>
    </pattern>
    <pattern name="should have mods:languageOfCataloging/mods:languageTerm with @authority='iso639-2b'">
        <rule context="mods:languageOfCataloging/mods:languageTerm">
            <assert test="@type='code' and @authority='iso639-2b'"></assert>
        </rule>
    </pattern>
    
    <pattern name="normalize white space">
        <rule context="mods:mods">
            <assert test=". = normalize-space(.)">
                Elements with text should not contain extraneous whitespace (including line breaks). [<name path=".."/>/<name/>]
            </assert>
        </rule>
    </pattern>
    <pattern name="dates encoded in w3cdtf">
        <rule context="*[matches(name(.), 'date', 'i')][@encoding='w3cdtf']">
            <assert test="matches(.,'^[0-9]{4}(-[0-9]{2}){0,2}$') or
                matches(.,'^[0-9]{4}(-[0-9]{2}){2}T[0-9]{2}:[0-9]{2}(:[0-9]{2}(\.[0-9]+)?)?(Z|[+-][0-9]{2}:[0-9]{2})$')">
                W3CDTF dates should match the specified format (YYYY-MM-DD, YYYY-MM, or YYYY).
            </assert>
        </rule>
    </pattern>
</schema>
