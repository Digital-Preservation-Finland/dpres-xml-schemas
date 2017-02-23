"""Tests for the schematron rules for PREMIS metadata, i.e for the
rules located in mets_premis.sch.

.. seealso:: mets_premis.sch
"""

import xml.etree.ElementTree as ET
import pytest
from tests.common import SVRL_FAILED, SVRL_REPORT, NAMESPACES, \
    parse_xml_string, parse_xml_file

SCHFILE = 'mets_premis.sch'


@pytest.mark.parametrize("premisroot, mdtype", [
    ('object', 'PREMIS:OBJECT'), ('event', 'PREMIS:EVENT'),
    ('agent', 'PREMIS:AGENT'), ('rightsStatement', 'PREMIS:RIGHTS')
])
def test_disallowed_attribute(schematron_fx, premisroot, mdtype):
    """Test that attributes 'authority', 'authorityURI', 'valueURI' in
    PREMIS 2.3 are disallowed in PREMIS 2.2.

    :schematron_fx: Schematron compile fixture
    :premisroot: Root element in PREMIS.
    :mdtype: MDTYPE value
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData/></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    elem_wrap = root.find_element('mdWrap', 'mets')
    elem_wrap.set_attribute('MDTYPE', 'mets', mdtype)
    elem_handler = elem_wrap.find_element('xmlData', 'mets')
    elem_handler = elem_handler.set_element(premisroot, 'premis')
    elem_handler = elem_handler.set_element('xxx', 'premis')
    for disallowed in ['authority', 'authorityURI', 'valueURI']:
        elem_handler.set_attribute(disallowed, 'premis', 'default')

    # Works in 2.3
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Disallowed in 2.2
    elem_wrap.set_attribute('MDTYPEVERSION', 'mets', '2.2')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3

    # 2.2 works, if attributes removed
    elem_handler.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("algorithm", [
    ('MD5'), ('SHA-1'), ('SHA-224'), ('SHA-256'), ('SHA-384'), ('SHA-512'),
    ('md5'), ('sha-1'), ('sha-224'), ('sha-256'), ('sha-384'), ('sha-512'),
    ('xxx')
])
def test_checksums(schematron_fx, algorithm):
    """Test that the controlled vocabulary for messageDigestAlgorithm work.

    :schematron_fx: Schematron compile fixture
    :algorithm: Valid algorithm name or 'xxx' as invalid arbitrary name.
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s"
               xmlns:xsi="%(xsi)s">
               <mets:mdWrap MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="2.3">
                 <mets:xmlData>
                   <premis:object xsi:type="premis:file">
                     <premis:messageDigestAlgorithm/>
                   </premis:object>
                 </mets:xmlData>
               </mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    elem_handler = root.find_element('messageDigestAlgorithm', 'premis')
    elem_handler.text = algorithm
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if algorithm == 'xxx':
        assert svrl.count(SVRL_FAILED) == 1
    else:
        assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("metssection, premisroot, mdtype, nonempty", [
    ('techMD', 'object', 'PREMIS:OBJECT', 'objectIdentifierType'),
    ('techMD', 'object', 'PREMIS:OBJECT', 'objectIdentifierValue'),
    ('digiprovMD', 'event', 'PREMIS:EVENT', 'eventIdentifierType'),
    ('digiprovMD', 'event', 'PREMIS:EVENT', 'eventIdentifierValue'),
    ('digiprovMD', 'agent', 'PREMIS:AGENT', 'agentIdentifierType'),
    ('digiprovMD', 'agent', 'PREMIS:AGENT', 'agentIdentifierValue'),
    ('rightsMD', 'rights', 'PREMIS:RIGHTS', 'rightsStatementIdentifierType'),
    ('rightsMD', 'rights', 'PREMIS:RIGHTS', 'rightsStatementIdentifierValue')
])
def test_identifier_value(
        schematron_fx, metssection, premisroot, mdtype, nonempty):
    """PREMIS identifier elements can not be empty. Test that a value in the
    element is required.

    :schematron_fx: Schematron compile fixture
    :metssection: Section where the test is done
    :premisroot: PREMIS root element name
    :mdtype: MDTYPE
    :nonempty: element that requires a value
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData/></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    root.tag = ('{%(mets)s}'+metssection) % NAMESPACES
    elem_handler = root.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdtype)
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    elem_handler = elem_handler.set_element(premisroot, 'premis')
    elem_handler = elem_handler.set_element(nonempty, 'premis')

    # Empty identifier element fails
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary value added
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("fileformat, pronom", [
    ('text/csv;charset=utf-8', ['x-fmt/18']),
    ('application/epub+zip', ['fmt/483']),
    ('application/xhtml+xml;charset=utf-8', ['fmt/102', 'fmt/103']),
    ('text/xml;charset=utf-8', ['fmt/101']),
    ('text/html;charset=utf-8', ['fmt/100', 'fmt/471']),
    ('application/vnd.oasis.opendocument.text', ['fmt/136']),
    ('application/vnd.oasis.opendocument.spreadsheet', ['fmt/137']),
    ('application/vnd.oasis.opendocument.presentation', ['fmt/138']),
    ('application/vnd.oasis.opendocument.graphics', ['fmt/139']),
    ('application/vnd.oasis.opendocument.formula', ['']),
    ('application/pdf', ['fmt/95', 'fmt/354', 'fmt/476', 'fmt/477', 'fmt/478',
                         'fmt/16', 'fmt/17', 'fmt/18', 'fmt/19', 'fmt/20',
                         'fmt/276']),
    ('text/plain;charset=utf-8', ['x-fmt/111']),
    ('audio/x-aiff', ['x-fmt/135']),
    ('audio/x-wav', ['fmt/527', 'fmt/141']),
    ('audio/flac', ['fmt/279']),
    ('audio/mp4', ['fmt/199']),
    ('video/jpeg2000', ['x-fmt/392']),
    ('video/mp4', ['fmt/199']),
    ('image/jpeg', ['fmt/42', 'fmt/43', 'fmt/44']),
    ('image/jp2', ['x-fmt/392']),
    ('image/tiff', ['fmt/353', 'fmt/438', 'fmt/730', 'fmt/155']),
    ('image/png', ['fmt/13']),
    ('application/warc', ['fmt/289']),
    ('application/msword', ['fmt/40']),
    ('application/vnd.ms-excel', ['fmt/61', 'fmt/62']),
    ('application/vnd.ms-powerpoint', ['fmt/126']),
    ('audio/mpeg', ['fmt/134']),
    ('audio/x-ms-wma', ['fmt/132']),
    ('video/dv', ['x-fmt/152']),
    ('video/mpeg', ['fmt/649', 'fmt/640']),
    ('video/x-ms-wmv', ['fmt/133']),
    ('application/postscript', ['fmt/124']),
    ('image/gif', ['fmt/3', 'fmt/4']),
    ('application/x-internet-archive', ['x-fmt/219', 'fmt/410']),
    ('application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     ['fmt/412']),
    ('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     ['fmt/214']),
    ('application/vnd.openxmlformats-officedocument.presentationml.' +
     'presentation', ['fmt/215']),
    ('image/dpx', ['fmt/541']),
    ('application/gml+xml;charset=utf-8', ['x-fmt/227']),
    ('application/vnd.google-earth.kml+xml;charset=utf-8', ['fmt/224']),
    ('application/x-spss-por', ['']),
    ('video/x-ms-asf', ['fmt/131']),
    ('video/avi', ['fmt/5']),
    ('video/MP1S', ['x-fmt/385']),
    ('video/MP2P', ['x-fmt/386']),
    ('video/MP2T', ['fmt/585']),
    ('video/mp4', ['fmt/199']),
    ('application/mxf', ['']),
    ('video/mj2', ['fmt/337']),
    ('video/quicktime', ['x-fmt/384'])
])
def test_pronom_codes(schematron_fx, fileformat, pronom):
    """Test that checks for PRONOM code matching to MIME type is done.

    :schematron_fx: Schematron compile fixture
    :fileformat: File format as MIME type
    :pronom: Allowed PRONOM codes for the file format
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData><premis:object>
                 <premis:format><premis:formatDesignation><premis:formatName/>
                   <premis:formatRegistryKey/></premis:formatDesignation>
               </premis:format></premis:object></mets:xmlData></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = fileformat
    elem_handler = root.find_element('formatRegistryKey', 'premis')

    # All acceptable PRONOM codes work
    for pronomcode in pronom:
        elem_handler.text = pronomcode
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == 0

    # Arbitrary PRONOM code fails
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("fileformat", [
    ('text/csv'), ('application/xhtml+xml'), ('text/xml'), ('text/html'),
    ('text/plain'), ('application/gml+xml'),
    ('application/vnd.google-earth.kml+xml')
])
def test_charset_parameter(schematron_fx, fileformat):
    """Text file format require character set info in the formatName from
    specification 1.5.0. Test all allowed character sets.

    :schematron_fx: Schematron compile fixture
    :fileformat: Text file format
    """
    xml = '''<mets:mets fi:CATALOG="1.4" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fi)s">
             <mets:techMD><mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData>
               <premis:object><premis:format><premis:formatDesignation>
                 <premis:formatName/></premis:formatDesignation>
               </premis:format></premis:object></mets:xmlData></mets:mdWrap>
             </mets:techMD></mets:mets>''' % NAMESPACES
    charsets = ['ISO-8859-15', 'UTF-8', 'UTF-16', 'UTF-32', 'iso-8859-15',
                'utf-8', 'utf-16', 'utf-32']
    (mets, root) = parse_xml_string(xml)
    elem_handler = root.find_element('formatName', 'premis')

    # Missing charset is valid in specification 1.4
    elem_handler.text = fileformat
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Error, since charset is missing
    root.set_attribute('CATALOG', 'fi', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # All valid caharcter sets work
    for charset in charsets:
        elem_handler.text = fileformat+';charset='+charset
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == 0

    # Arbitrary character set is disallowed
    elem_handler.text = fileformat+';charset=xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Character set not required with arbitrary formats
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_identifiers_unique(schematron_fx):
    """Test that check for PREMIS identifiers are unique works. We give 8
    PREMIS sections with same identifiers, and loop those unique one by one.
    Finally, when all are unique, no errors are expected. No errors are
    expected in any case, if the specification is 1.4.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<premis:object><premis:objectIdentifier>
                 <premis:objectIdentifierType>local
                 </premis:objectIdentifierType>
                 <premis:objectIdentifierValue>xxx
                 </premis:objectIdentifierValue>
               </premis:objectIdentifier></premis:object>
             <premis:rights><premis:rightsStatement>
               <premis:rightsStatementIdentifier>
                 <premis:rightsStatementIdentifierType>local
                 </premis:rightsStatementIdentifierType>
                 <premis:rightsStatementIdentifierValue>xxx
                 </premis:rightsStatementIdentifierValue>
               </premis:rightsStatementIdentifier></premis:rightsStatement>
             </premis:rights>
             <premis:event><premis:eventIdentifier>
                 <premis:eventIdentifierType>local</premis:eventIdentifierType>
                 <premis:eventIdentifierValue>xxx</premis:eventIdentifierValue>
               </premis:eventIdentifier></premis:event>
             <premis:agent><premis:agentIdentifier>
                 <premis:agentIdentifierType>local</premis:agentIdentifierType>
                 <premis:agentIdentifierValue>xxx</premis:agentIdentifierValue>
               </premis:agentIdentifier></premis:agent>'''
    head = '''<mets:mets fi:CATALOG="1.4" xmlns:mets="%(mets)s"
              xmlns:premis="%(premis)s" xmlns:fi="%(fi)s"><premis:premis>''' \
              % NAMESPACES
    tail = '''</premis:premis></mets:mets>'''
    (mets, root) = parse_xml_string(head+xml+xml+tail)

    # No errors with specification 1.4
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Errors with specification 1.5.0, we fix the identifiers one by one.
    root.set_attribute('CATALOG', 'fi', '1.5.0')
    number = 0
    for idtag in ['objectIdentifierValue', 'rightsStatementIdentifierValue',
                  'eventIdentifierValue', 'agentIdentifierValue']:
        for tag in root.find_all_elements(idtag, 'premis'):
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            number = number + 1
            tag.text = 'xxx'+str(number)
            if number < 8:
                assert svrl.count(SVRL_FAILED) == 1
            else:
                assert svrl.count(SVRL_FAILED) == 0


def test_linking(schematron_fx):
    """Test that check of PREMIS links work. A linking element must have a
    corresponding PREMIS section. No errors are expected in any case, if the
    specification is 1.4. We give lniks to 8 PREMIS sections without the
    sections. Then we add the required sections one by one.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.4" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fi)s">
             <mets:amdSec><mets:techMD><mets:mdWrap><mets:xmlData>
               <premis:object><premis:linkingEventIdentifier>
                   <premis:linkingEventIdentifierType>local
                   </premis:linkingEventIdentifierType>
                   <premis:linkingEventIdentifierValue>event-001
                   </premis:linkingEventIdentifierValue>
                 </premis:linkingEventIdentifier>
                 <premis:linkingRightsStatementIdentifier>
                   <premis:linkingRightsStatementIdentifierType>local
                   </premis:linkingRightsStatementIdentifierType>
                   <premis:linkingRightsStatementIdentifierValue>rights-001
                   </premis:linkingRightsStatementIdentifierValue>
                 </premis:linkingRightsStatementIdentifier>
             </premis:object></mets:xmlData></mets:mdWrap></mets:techMD>
             <mets:rightsMD><mets:mdWrap><mets:xmlData><premis:rights>
               <premis:rightsStatement><premis:linkingObjectIdentifier>
                   <premis:linkingObjectIdentifierType>local
                   </premis:linkingObjectIdentifierType>
                   <premis:linkingObjectIdentifierValue>object-001
                   </premis:linkingObjectIdentifierValue>
                 </premis:linkingObjectIdentifier>
                 <premis:linkingAgentIdentifier>
                   <premis:linkingAgentIdentifierType>local
                   </premis:linkingAgentIdentifierType>
                   <premis:linkingAgentIdentifierValue>agent-001
                   </premis:linkingAgentIdentifierValue>
               </premis:linkingAgentIdentifier></premis:rightsStatement>
             </premis:rights></mets:xmlData></mets:mdWrap></mets:rightsMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:event>
                 <premis:linkingAgentIdentifier>
                   <premis:linkingAgentIdentifierType>local
                   </premis:linkingAgentIdentifierType>
                   <premis:linkingAgentIdentifierValue>agent-001
                   </premis:linkingAgentIdentifierValue>
                 </premis:linkingAgentIdentifier>
                 <premis:linkingObjectIdentifier>
                   <premis:linkingObjectIdentifierType>local
                   </premis:linkingObjectIdentifierType>
                   <premis:linkingObjectIdentifierValue>object-001
                   </premis:linkingObjectIdentifierValue>
                 </premis:linkingObjectIdentifier></premis:event>
             </mets:xmlData></mets:mdWrap></mets:digiprovMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:agent>
                 <premis:linkingEventIdentifier>
                   <premis:linkingEventIdentifierType>local
                   </premis:linkingEventIdentifierType>
                   <premis:linkingEventIdentifierValue>event-001
                   </premis:linkingEventIdentifierValue>
                 </premis:linkingEventIdentifier>
                 <premis:linkingRightsStatementIdentifier>
                   <premis:linkingRightsStatementIdentifierType>local
                   </premis:linkingRightsStatementIdentifierType>
                   <premis:linkingRightsStatementIdentifierValue>rights-001
                   </premis:linkingRightsStatementIdentifierValue>
                 </premis:linkingRightsStatementIdentifier></premis:agent>
             </mets:xmlData></mets:mdWrap></mets:digiprovMD></mets:amdSec>
             </mets:mets>''' % NAMESPACES

    (mets, root) = parse_xml_string(xml)

    # No errors with specification 1.4
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Eight dead links
    root.set_attribute('CATALOG', 'fi', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 8

    # Object section added, six dead links
    elem_handler = root.find_element('object', 'premis')
    xml_id = '''<premis:objectIdentifier xmlns:premis="%(premis)s">
                <premis:objectIdentifierType>local
                </premis:objectIdentifierType>
                <premis:objectIdentifierValue>object-001
                </premis:objectIdentifierValue>
                </premis:objectIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 6

    # Event section added, four dead links
    elem_handler = root.find_element('event', 'premis')
    xml_id = '''<premis:eventIdentifier xmlns:premis="%(premis)s">
                <premis:eventIdentifierType>local
                </premis:eventIdentifierType>
                <premis:eventIdentifierValue>event-001
                </premis:eventIdentifierValue>
                </premis:eventIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 4

    # Agent section added, two dead links
    elem_handler = root.find_element('agent', 'premis')
    xml_id = '''<premis:agentIdentifier xmlns:premis="%(premis)s">
                <premis:agentIdentifierType>local
                </premis:agentIdentifierType>
                <premis:agentIdentifierValue>agent-001
                </premis:agentIdentifierValue>
                </premis:agentIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # Rights section added, no dead links
    elem_handler = root.find_element('rightsStatement', 'premis')
    xml_id = '''<premis:rightsStatementIdentifier xmlns:premis="%(premis)s">
                <premis:rightsStatementIdentifierType>local
                </premis:rightsStatementIdentifierType>
                <premis:rightsStatementIdentifierValue>rights-001
                </premis:rightsStatementIdentifierValue>
                </premis:rightsStatementIdentifier>''' \
             % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("specification, check_result", [
    ('1.5.0', 1), ('1.4', 0)
])
def test_native(schematron_fx, specification, check_result):
    """Test the native file case. Native file requires a migration event to
    a recommended/acceptable file format. Here we test various cases related to
    native files.

    :schematron_fx: Schematron compile fixture
    :specification: Used specification sa string
    :check_result: 1 native check done with specification, 0 otherwise
    """
    (mets, root) = parse_xml_file('mets_valid_native.xml')

    # Working case
    root.set_attribute('CATALOG', 'fi', specification)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == check_result

    # Make required migration event to something else
    elem_handler = root.find_element('eventType', 'premis')
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_handler.text = 'migration'
    assert svrl.count(SVRL_FAILED) == check_result
    assert svrl.count(SVRL_REPORT) == 0

    # Make native as outcome and recommended format as source
    # The native file needs to be the source
    elem_handler = root.find_element('eventType', 'premis')
    slink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="source"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    olink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="outcome"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    elem_source = root.find_element(slink % NAMESPACES,
                                    'premis')
    elem_outcome = root.find_element(olink % NAMESPACES,
                                     'premis')
    elem_source.text = 'outcome'
    elem_outcome.text = 'source'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_source.text = 'source'
    elem_outcome.text = 'outcome'
    assert svrl.count(SVRL_FAILED) == check_result
    assert svrl.count(SVRL_REPORT) == 0

    # Give error, if linking to migration event is destroyed
    elem_handler = root.find_element(
        'file[@ADMID="techmd-001 event-001 agent-001"]', 'mets')
    elem_handler.set_attribute('ADMID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == check_result
    assert svrl.count(SVRL_REPORT) == 0


@pytest.mark.parametrize("container_format", [
    ('video/x-ms-asf'), ('video/avi'), ('video/MP1S'), ('video/MP2P'),
    ('video/MP2T'), ('application/mxf'), ('video/mj2'), ('video/quicktime')
])
def test_stream(schematron_fx, container_format):
    """Test the container and stream case.

    :schematron_fx: Schematron compile fixture
    :container_format: Container format to test
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_handler = root.find_element('techMD[@ID="tech-container"]', 'mets')
    elem_format = elem_handler.find_element('formatName', 'premis')
    elem_format.text = container_format
    elem_handler = root.find_element('file', 'mets')
    elem_handler.del_element('stream', 'mets')
    elem_handler.del_element('stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # video/mp4 is not necessary a container
    elem_format.text = 'video/mp4'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_container_links(schematron_fx):
    """Test the container and stream case.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)

    elem_container = root.find_element('techMD[@ID="tech-container"]', 'mets')
    elem_handler = elem_container.find_element(
        'relatedObjectIdentifierValue', 'premis')
    related_value = elem_handler.text
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    elem_handler.text = related_value

    techid_value = elem_container.get_attribute('ID', 'mets')
    elem_container.set_attribute('ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2   # Two streams
    elem_container.set_attribute('ID', 'mets', techid_value)

    elem_vstream = root.find_element('techMD[@ID="tech-videopremis"]', 'mets')
    elem_vstream.set_attribute('ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
