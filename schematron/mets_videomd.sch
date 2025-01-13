<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:techMD/mets:mdWrap/mets:xmlData/videomd:VIDEOMD -->
<!-- context-filter: videomd:VIDEOMD|videomd:fileData|videomd:compression|videomd:frame -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.7">
        <sch:title>VideoMD metadata validation</sch:title>

<!--
Validates VideoMD metadata.
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>
        <sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>

        <sch:include href="./abstracts/required_element_pattern.incl"/>


        <!-- Mandatory elements VideoMD -->
        <sch:pattern id="video_fileData" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:VIDEOMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:fileData"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="video_duration" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:duration"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_dataRate" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:dataRate"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_bitsPerSample" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:bitsPerSample"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_color" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:color"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_compression" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:compression"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_dataRateMode" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:dataRateMode"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_frameRate" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:frameRate"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_frame" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:frame"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_sampling" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:sampling"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_signalFormat" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:signalFormat"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_sound" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:fileData"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:sound"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="video_codecCreatorApp" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:codecCreatorApp"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_codecCreatorAppVersion" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:codecCreatorAppVersion"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_codecName" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:codecName"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_codecQuality" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:compression"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:codecQuality"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

        <sch:pattern id="video_pixelsHorizontal" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:frame"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:pixelsHorizontal"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_pixelsVertical" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:frame"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:pixelsVertical"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_PAR" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:frame"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:PAR"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="video_DAR" is-a="required_element_pattern">
                <sch:param name="context_element" value="videomd:frame"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="videomd:DAR"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>

</sch:schema>
