<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:rightsMD/mets:mdWrap/mets:xmlData/premis:* -->
<!-- context-filter: premis:* -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.7">
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
        <sch:include href="./abstracts/disallowed_element_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_value_attribute_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/disallowed_value_element_smaller_version_pattern.incl"/>
        <sch:include href="./abstracts/required_nonempty_element_pattern.incl"/>

        <!-- Version specific checks until smaller than 2.3 -->
        <sch:pattern id="premis23_rights_authority" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsStatement//*"/>
                <sch:param name="context_condition" value="@authority"/>
                <sch:param name="disallowed_attribute" value="@authority"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>
        <sch:pattern id="premis23_rights_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsStatement//*"/>
                <sch:param name="context_condition" value="@authorityURI"/>
                <sch:param name="disallowed_attribute" value="@authorityURI"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>
        <sch:pattern id="premis23_rights_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsStatement//*"/>
                <sch:param name="context_condition" value="@valueURI"/>
                <sch:param name="disallowed_attribute" value="@valueURI"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.3')"/>
        </sch:pattern>

        <!-- Identifier value not empty -->
        <sch:pattern id="premis_rightsStatementIdentifierType_value" is-a="required_nonempty_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData/premis:rights/premis:rightsStatement/premis:rightsStatementIdentifier/premis:rightsStatementIdentifierType"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="premis_rightsStatementIdentifierValue_value" is-a="required_nonempty_element_pattern">
                <sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData/premis:rights/premis:rightsStatement/premis:rightsStatementIdentifier/premis:rightsStatementIdentifierValue"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>


        <!-- COMPATIBILITY WITH OLDER SPECIFICATIONS -->

        <!-- Version specific checks until smaller than 2.2 -->
        <sch:pattern id="premis22_copyrightDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:copyrightInformation"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:copyrightDocumentationIdentifier"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_copyrightApplicableDates" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:copyrightInformation"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:copyrightApplicableDates"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_licenseDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:licenseInformation"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:licenseDocumentationIdentifier"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_licenseApplicableDates" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:licenseInformation"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:licenseApplicableDates"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_statuteDocumentationIdentifier" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:statuteInformation"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:statuteDocumentationIdentifier"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_otherRightsInformation" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsStatement"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:otherRightsInformation"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_termOfRestriction" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsGranted"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:termOfRestriction"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_termOfGrant" is-a="disallowed_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:rightsGranted"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="premis:termOfGrant"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_startDate_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:startDate"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_endDate_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:endDate"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_copyrightStatusDeterminationDate_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:copyrightStatusDeterminationDate"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_statuteInformationDeterminationDate_values" is-a="disallowed_value_element_smaller_version_pattern">
                <sch:param name="context_element" value="premis:statuteInformationDeterminationDate"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>
        <sch:pattern id="premis22_rights_CREATED_values" is-a="disallowed_value_attribute_smaller_version_pattern">
                <sch:param name="context_element" value="premis:mdSec"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="context_attribute" value="@CREATED"/>
                <sch:param name="disallowed_value" value="string('OPEN')"/>
                <sch:param name="mdattribute" value="@MDTYPE"/>
                <sch:param name="mdtype_name" value="string('PREMIS:RIGHTS')"/>
                <sch:param name="mdtype_version" value="string('2.2')"/>
        </sch:pattern>

</sch:schema>
