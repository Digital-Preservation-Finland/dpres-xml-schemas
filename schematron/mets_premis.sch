<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:* -->
<!-- context-filter: premis:* -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.5">
        <sch:title>PREMIS metadata validation</sch:title>

<!--
Validates PREMIS metadata.
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
        <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
        <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>


        <sch:include href="./abstracts/disallowed_attribute_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_value_attribute_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_value_element_smaller_version_pattern.incl"/>

        <!-- Check that identifiers of PREMIS sections are unique between the sections -->
        <sch:let name="objectid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:object/premis:objectIdentifier/premis:objectIdentifierValue"/>
        <sch:let name="eventid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:event/premis:eventIdentifier/premis:eventIdentifierValue"/>
        <sch:let name="agentid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:agent/premis:agentIdentifier/premis:agentIdentifierValue"/>
        <sch:let name="rightsid" value="/mets:mets/mets:amdSec/mets:*/mets:mdWrap/mets:xmlData/premis:rights/premis:rightsStatement/premis:rightsStatementIdentifier/premis:rightsStatementIdentifierValue"/>

        <!-- Version specific checks until smaller than 2.3 -->
        <sch:pattern id="premis23_object_authority" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:object//*"/>
                <sch:param name="context_condition" value="@authority"/>
                <sch:param name="disallowed_attribute" value="@authority"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>
        <sch:pattern id="premis23_object_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:object//*"/>
                <sch:param name="context_condition" value="@authorityURI"/>
                <sch:param name="disallowed_attribute" value="@authorityURI"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>
        <sch:pattern id="premis23_object_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:object//*"/>
                <sch:param name="context_condition" value="@valueURI"/>
                <sch:param name="disallowed_attribute" value="@valueURI"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>


        <!-- Premis linking check -->
        <sch:pattern id="link_premis_element">
                <sch:rule context="premis:linkingObjectIdentifierValue">
                        <sch:let name="id_value" value="normalize-space(.)"/>
                        <sch:assert test="count($objectid[normalize-space(.) = $id_value]) = 1">
                                Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'objectIdentifierValue' with the same value was not found.
                        </sch:assert>
                </sch:rule>
                <sch:rule context="premis:linkingEventIdentifierValue">
                        <sch:let name="id_value" value="normalize-space(.)"/>
                        <sch:assert test="count($eventid[normalize-space(.) = $id_value]) = 1">
                                Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'eventIdentifierValue' with the same value was not found.
                        </sch:assert>
                </sch:rule>
                <sch:rule context="premis:linkingAgentIdentifierValue">
                        <sch:let name="id_value" value="normalize-space(.)"/>
                        <sch:assert test="count($agentid[normalize-space(.) = $id_value]) = 1">
                                Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'agentIdentifierValue' with the same value was not found.
                        </sch:assert>
                </sch:rule>
                <sch:rule context="premis:linkingRightsStatementIdentifierValue">
                        <sch:let name="id_value" value="normalize-space(.)"/>
                        <sch:assert test="count($rightsid[normalize-space(.) = $id_value]) = 1">
                                Value '<sch:value-of select="."/>' in element '<sch:name/>' is a link to nowhere. The corresponding target element 'rightsStatementIdentifierValue' with the same value was not found.
                        </sch:assert>
                </sch:rule>
        </sch:pattern>


        <!-- COMPATIBILITY WITH OLDER SPECIFICATIONS -->

        <!-- Version specific checks until smaller than 2.2 -->
        <sch:pattern id="premis22_preservationLevelDateAssigned_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:preservationLevelDateAssigned"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_object_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:mdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@CREATED"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:OBJECT')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>

</sch:schema>
