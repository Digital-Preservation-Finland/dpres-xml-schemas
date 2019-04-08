<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="2.2">

<!--
Validates various internal issues in PREMIS 2.2 formatted ingest report.
See: http://www.loc.gov/standards/premis/
-->

    <sch:title>PREMIS ingest report validation</sch:title>
	
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	
	<!-- sip object check -->
    <sch:pattern name="SipObject">
        <sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-sip-id']">
			<sch:assert test="./premis:originalName">
				&lt;originalName&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="not(./premis:relationship)">
				&lt;relationship&gt; element must not be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	<!-- sip object environment check -->
    <sch:pattern name="SipObjectEnvironment">
		<!-- In case environment is found, see that it is not incorrect nor empty -->
		<sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-sip-id' and (./premis:environment)]">
			<sch:assert test="normalize-space(.//premis:dependencyIdentifierType) = 'mets:OBJID'">
				&lt;dependencyIdentifierType&gt; in object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must be 'mets:OBJID'.
			</sch:assert>
			<sch:assert test="string-length(normalize-space(.//premis:dependencyIdentifierValue)) &gt; 0">
				&lt;dependencyIdentifierValue&gt; in object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must not be empty.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	
	<!-- signature object check -->
    <sch:pattern name="SigObject">
        <sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-signature-id']">
			<sch:assert test="normalize-space(./premis:originalName)='varmiste.sig' or normalize-space(./premis:originalName)='signature.sig'">
                Original name must be 'varmiste.sig' or 'signature.sig' in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
            </sch:assert>
			<sch:assert test="not(./premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="normalize-space(.//premis:relationshipType)='structural' and normalize-space(.//premis:relationshipSubType)='is included in'">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='structural' and relationshipSubType='is included in'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:relatedObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:relatedObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a SIP object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>

	<!-- mets object check -->
    <sch:pattern name="MetsObject">
        <sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-mets-id']">
			<sch:assert test="normalize-space(./premis:originalName)='mets.xml'">
				Original name must be 'mets.xml' in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="not(./premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="normalize-space(.//premis:relationshipType)='structural' and normalize-space(.//premis:relationshipSubType)='is included in'">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='structural' and relationshipSubType='is included in'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:relatedObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:relatedObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a SIP object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- digital object check -->
	<sch:pattern name="FileObject">
        <sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-object-id']">
			<sch:assert test="./premis:originalName">
				Original name must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>			
			<sch:assert test="./premis:environment">
				&lt;environment&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>			
			<sch:assert test="normalize-space(.//premis:relationshipType)='structural' and normalize-space(.//premis:relationshipSubType)='is included in'">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='structural' and relationshipSubType='is included in'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:relatedObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:relatedObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a SIP object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
	
	<!-- aip object check -->
	<sch:pattern name="AipObject">
        <sch:rule context="premis:object[normalize-space(.//premis:objectIdentifierType)='preservation-aip-id']">
			<sch:assert test="./premis:originalName">
				Original name must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>		
			<sch:assert test="not(.//premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="normalize-space(.//premis:relationshipType)='derivation' and normalize-space(.//premis:relationshipSubType)='has source'">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='derivation' and relationshipSubType='has source'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:relatedObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:relatedObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a SIP object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>

	<!-- Transfer event check -->
	<sch:pattern name="EventTransfer">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='transfer']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Transfer of submission information package'">
				Transfer event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Transfer of submission information package'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-user-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-user-id']))">
				Transfer event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a user agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Transfer event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- Decompression event check -->
	<sch:pattern name="EventDecompression">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='decompression']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Decompression of submission information package'">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Decompression of submission information package'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'extract_sip.py')]))">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a decompression agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	<!-- Virus check event check -->
	<sch:pattern name="EventVirusCheck">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='virus check']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Virus check of transferred files'">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Virus check of transferred files'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'check_virus.py')]))">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a virus check agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Signature validation event check -->
	<sch:pattern name="EventSignatureCheck">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='digital signature validation']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Submission information package digital signature validation'">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Submission information package digital signature validation'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'check_signature.py')]))">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a signature validation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-signature-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-signature-id']))">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a signature object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Fixity check event check -->
	<sch:pattern name="EventFixityCheck">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='fixity check']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Fixity check of digital objects in submission information package'">
				Fixity check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Fixity check of digital objects in submission information package'
			</sch:assert>		
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'check_checksums.py')]))">
				Fixity check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a fixity check agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Fixity check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Service contract validation event check -->
	<sch:pattern name="EventServiceContractValidation">
		<sch:rule context="premis:event[normalize-space(./premis:eventType)='validation' and contains(./premis:eventDetail,'service contract')]">
			<sch:assert test="normalize-space(./premis:eventDetail)='Validation of service contract properties'">
				Service contract validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Validation of service contract properties'
			</sch:assert>		
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'contract.py')]))">
				Service contract validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a contract validation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Service contract validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS schema validation event check -->
	<sch:pattern name="EventMetsSchemaCheck">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='validation' and ./premis:eventDetail='METS schema validation']">
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'validate_mets_schema.py')]))">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS schema validation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-mets-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-mets-id']))">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS additional validation event check -->
	<sch:pattern name="EventMetsAdditionalCheck">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='validation' and ./premis:eventDetail='Additional METS validation of required features']">
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and (contains(.,'validate_mets_schematron.py') or contains(.,'mets_version.py'))]))">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS schematron validation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-mets-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-mets-id']))">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Digital object validation event check -->
	<sch:pattern name="EventDigitalObjectValidation">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='validation' and ./premis:eventDetail='Digital object validation']">
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'check_sip_digital_objects.py')]))">
				Digital object validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a digital object validation agent.
			</sch:assert>
			<sch:let name="id" value="normalize-space(.//premis:linkingObjectIdentifierValue)"/>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-object-id') and count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-object-id' and normalize-space(.)=$id]) = 1">
				Digital object validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a digital object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- SIP validation compilation event check -->
	<sch:pattern name="EventSIPValidation">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='validation' and ./premis:eventDetail='Validation compilation of submission information package']">
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'create_premis_report.py')]))">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a ingest report creation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-sip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-sip-id']))">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- validation detail check -->
	<sch:pattern name="EventValidationDetail">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='validation']">
			<sch:assert test="((./premis:eventDetail='METS schema validation') or (./premis:eventDetail='Additional METS validation of required features') or (./premis:eventDetail='Digital object validation') or (./premis:eventDetail='Validation of service contract properties') or (./premis:eventDetail='Validation compilation of submission information package'))">
				Incorrect event detail in '<sch:value-of select=".//premis:eventIdentifierValue"/>'.
			</sch:assert>
		</sch:rule>		
	</sch:pattern>

	<!-- AIP creation event check -->
	<sch:pattern name="EventAIPCreation">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='creation']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Creation of archival information package'">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Creation of archival information package'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'create_premis_report.py')]))">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a ingest report creation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-aip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-aip-id']))">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to an AIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- preservation responsibility change event check -->
	<sch:pattern name="EventResponsibilityChange">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='preservation responsibility change']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Preservation responsibility change to the digital preservation service'">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Preservation responsibility change to the digital preservation service'
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingAgentIdentifierType)='preservation-agent-id') and (normalize-space(.//premis:linkingAgentIdentifierValue)=normalize-space(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(preceding-sibling::premis:agentIdentifierType)='preservation-agent-id' and contains(.,'create_premis_report.py')]))">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a ingest report creation agent.
			</sch:assert>
			<sch:assert test="(normalize-space(.//premis:linkingObjectIdentifierType)='preservation-aip-id') and (normalize-space(.//premis:linkingObjectIdentifierValue)=normalize-space(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(preceding-sibling::premis:objectIdentifierType)='preservation-aip-id']))">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to an AIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- approvals -->
	<sch:pattern name="EventApproveFailedIngestEvents">
        <sch:rule context="premis:event[normalize-space(./premis:eventType)='approval']">
			<sch:assert test="normalize-space(./premis:eventDetail)='Failed ingest events approved by the service'">
				Approve failed ingest events '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: 'Failed ingest events approved by the service'
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- agent name check -->
	<sch:pattern name="AgentName">
        <sch:rule context="premis:agent">
			<sch:assert test="contains(normalize-space(.//premis:agentIdentifierValue), normalize-space(./premis:agentName))">
				agentIdentifierValue '<sch:value-of select=".//premis:agentIdentifierValue"/>' must contain agent name '<sch:value-of select="./premis:agentName"/>'
			</sch:assert>
			<sch:assert test="(contains(normalize-space(.//premis:agentIdentifierType), 'preservation-user-id') and normalize-space(.//premis:agentType)='organization') or (normalize-space(.//premis:agentType)='software')">
				agentIdentifierValue '<sch:value-of select=".//premis:agentIdentifierValue"/>' has illegal agent type
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- PREMIS object ID check -->
	<sch:pattern name="ObjectID">
        <sch:rule context="premis:objectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS object identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
		</sch:rule>		
        <sch:rule context="premis:linkingObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the linking object identifier.
			</sch:assert>
        </sch:rule>
        <sch:rule context="premis:relatedObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the related object identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- PREMIS event ID check -->
	<sch:pattern name="EventID">
        <sch:rule context="premis:eventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS event identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
	</sch:pattern>
	
	<!-- PREMIS agent ID check -->
	<sch:pattern name="AgentID">
        <sch:rule context="premis:agentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS agent identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>
        <sch:rule context="premis:linkingAgentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the linking agent identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>

	
</sch:schema>
