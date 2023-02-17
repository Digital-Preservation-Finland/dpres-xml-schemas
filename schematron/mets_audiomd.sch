<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:techMD/mets:mdWrap/mets:xmlData/audiomd:AUDIOMD -->
<!-- context-filter: audiomd:AUDIOMD|audiomd:fileData|audiomd:audioInfo|audiomd:compression -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.5">
        <sch:title>AudioMD metadata validation</sch:title>

<!--
Validates AudioMD metadata.
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>
        <sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>

        <sch:include href="./abstracts/required_element_pattern.incl"/>


        <!-- Mandatory elements AudioMD -->
        <sch:pattern id="audio_fileData" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:AUDIOMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:fileData"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_audioInfo" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:AUDIOMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:audioInfo"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="audio_audioDataEncoding" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:audioDataEncoding"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_bitsPerSample" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:bitsPerSample"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_compression" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:compression"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_dataRate" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:dataRate"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_dataRateMode" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:dataRateMode"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_samplingFrequency" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:samplingFrequency"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="audio_duration" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:audioInfo"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:duration"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_numChannels" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:audioInfo"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:numChannels"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="audio_codecCreatorApp" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:codecCreatorApp"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_codecCreatorAppVersion" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:codecCreatorAppVersion"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_codecName" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:codecName"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="audio_codecQuality" is-a="required_element_pattern">
                <sch:param name="context_element" value="audiomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="audiomd:codecQuality"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

</sch:schema>
