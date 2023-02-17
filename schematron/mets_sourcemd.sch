<?xml version="1.0" encoding="UTF-8"?>

<!-- pass-filter: /mets:mets/mets:amdSec/mets:sourceMD -->
<!-- context-filter: mets:sourceMD -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.7.5">
        <sch:title>METS sourceMD validation</sch:title>

<!--
Validates METS sourceMD.
-->

        <sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
        <sch:ns prefix="fikdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
        <sch:ns prefix="fi" uri="http://digitalpreservation.fi/schemas/mets/fi-extensions"/>
        <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
        <sch:ns prefix="exsl" uri="http://exslt.org/common"/>
        <sch:ns prefix="sets" uri="http://exslt.org/sets"/>
        <sch:ns prefix="str" uri="http://exslt.org/strings"/>
        <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <sch:ns prefix="xml" uri="https://www.w3.org/XML/1998/namespace"/>

        <sch:include href="./abstracts/disallowed_element_pattern.incl"/>
        <sch:include href="./abstracts/required_element_pattern.incl"/>


        <!-- mdWrap and mdRef elements -->
        <sch:pattern id="mets_sourceMD_mdWrap" is-a="required_element_pattern">
                <sch:param name="context_element" value="mets:sourceMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="required_element" value="mets:mdWrap"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
        <sch:pattern id="mets_sourceMD_mdRef" is-a="disallowed_element_pattern">
                <sch:param name="context_element" value="mets:sourceMD"/>
                <sch:param name="context_condition" value="true()"/>
                <sch:param name="disallowed_element" value="mets:mdRef"/>
                <sch:param name="specifications" value="string('')"/>
        </sch:pattern>
</sch:schema>
