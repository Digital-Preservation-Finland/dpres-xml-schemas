"""Tests for the schematron rules for PREMIS metadata, i.e for the
rules located in mets_premis_techmd.sch.

.. seealso:: mets_premis_techmd.sch
"""

import pytest
from tests.common import (SVRL_FAILED, NAMESPACES, parse_xml_string,
                          add_containers, find_element, set_element)

SCHFILE = 'mets_premis_techmd.sch'


@pytest.mark.parametrize("nonempty", [
    ('objectIdentifierType'), ('objectIdentifierValue')
])
def test_identifier_value_object(schematron_fx, nonempty):
    """PREMIS identifier elements can not be empty. Test that a value in the
    element is required.

    :schematron_fx: Schematron compile fixture
    :nonempty: element that requires a value
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="2.3">
               <mets:xmlData><premis:object><premis:objectIdentifier/>
               </premis:object></mets:xmlData></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'objectIdentifier', 'premis')
    elem_handler = set_element(elem_handler, nonempty, 'premis')

    # Empty identifier element fails
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary value added
    elem_handler.text = 'xxx'
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
                     <premis:objectCharacteristics><premis:fixity>
                     <premis:messageDigestAlgorithm/>
                     </premis:fixity></premis:objectCharacteristics>
                   </premis:object>
                 </mets:xmlData>
               </mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'messageDigestAlgorithm', 'premis')
    elem_handler.text = algorithm
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if algorithm == 'xxx':
        assert svrl.count(SVRL_FAILED) == 2
    else:
        assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("fileformat, pronom", [
    ('text/csv;charset=utf-8', ['x-fmt/18']),
    ('application/epub+zip', ['fmt/483']),
    ('application/xhtml+xml;charset=utf-8',
     ['fmt/102', 'fmt/103', 'fmt/471']),
    ('text/xml;charset=utf-8', ['fmt/101']),
    ('text/html;charset=utf-8', ['fmt/100', 'fmt/471']),
    ('model/step', ['fmt/700']),
    ('application/vnd.oasis.opendocument.text',
     ['fmt/136', 'fmt/290', 'fmt/291']),
    ('application/vnd.oasis.opendocument.spreadsheet',
     ['fmt/137', 'fmt/294', 'fmt/295']),
    ('application/vnd.oasis.opendocument.presentation',
     ['fmt/138', 'fmt/292', 'fmt/293']),
    ('application/vnd.oasis.opendocument.graphics',
     ['fmt/139', 'fmt/296', 'fmt/297']),
    ('application/vnd.oasis.opendocument.formula', ['']),
    ('application/pdf', ['fmt/95', 'fmt/354', 'fmt/476', 'fmt/477', 'fmt/478',
                         'fmt/479', 'fmt/480', 'fmt/481', 'fmt/16', 'fmt/17',
                         'fmt/18', 'fmt/19', 'fmt/20', 'fmt/276']),
    ('text/plain;charset=utf-8', ['x-fmt/111']),
    ('audio/x-aiff', ['x-fmt/135', 'x-fmt/136']),
    ('audio/x-wav', ['fmt/527', 'fmt/141']),
    ('audio/flac', ['fmt/279']),
    ('audio/L16', ['']),
    ('audio/L8', ['']),
    ('audio/L20', ['']),
    ('audio/L24', ['']),
    ('audio/mp4', ['fmt/199']),
    ('image/x-dpx', ['fmt/541']),
    ('video/x-ffv', ['']),
    ('video/jpeg2000', ['x-fmt/392']),
    ('video/mp4', ['fmt/199']),
    ('video/h264', ['fmt/199']),
    ('video/h265', ['']),
    ('image/tiff', ['fmt/353', 'fmt/155']),
    ('image/x-adobe-dng', ['fmt/438', 'fmt/730', 'fmt/152', 'fmt/437']),
    ('image/jpeg', ['fmt/42', 'fmt/43', 'fmt/44', 'x-fmt/398', 'x-fmt/390',
                    'x-fmt/391', 'fmt/645']),
    ('image/jp2', ['x-fmt/392']),
    ('image/svg+xml', ['fmt/92']),
    ('image/png', ['fmt/13']),
    ('application/warc', ['fmt/1355']),
    ('application/gml+xml;charset=utf-8', ['fmt/1047']),
    ('application/geopackage+sqlite3', ['fmt/1700']),
    ('application/vnd.google-earth.kml+xml;charset=utf-8', ['fmt/244']),
    ('application/x-siard', ['fmt/1777']),
    ('application/x-spss-por', ['fmt/997']),
    ('application/matlab', ['fmt/806', 'fmt/828']),
    ('application/x-hdf5', ['fmt/807', 'fmt/286', 'fmt/287']),
    ('application/msword', ['fmt/40']),
    ('application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     ['fmt/412']),
    ('application/vnd.ms-excel', ['fmt/61', 'fmt/62']),
    ('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     ['fmt/214']),
    ('application/vnd.ms-powerpoint', ['fmt/126']),
    ('application/vnd.openxmlformats-officedocument.presentationml.' +
     'presentation', ['fmt/215']),
    ('audio/mpeg', ['fmt/134']),
    ('audio/x-ms-wma', ['fmt/132']),
    ('video/dv', ['x-fmt/152']),
    ('video/mpeg', ['fmt/649', 'fmt/640']),
    ('video/x-ms-wmv', ['fmt/133']),
    ('application/postscript', ['fmt/124']),
    ('image/gif', ['fmt/3', 'fmt/4']),
    ('video/avi', ['fmt/5']),
    ('video/x-matroska', ['fmt/569']),
    ('video/MP2T', ['fmt/585']),
    ('application/mxf', ['']),
    ('video/mj2', ['fmt/337']),
    ('video/quicktime', ['x-fmt/384']),
    ('video/x-ms-asf', ['fmt/131']),
    ('video/MP1S', ['x-fmt/385']),
    ('video/MP2P', ['x-fmt/386'])
])
def test_pronom_codes(schematron_fx, fileformat, pronom):
    """Test that checks for PRONOM code matching to MIME type is done.

    :schematron_fx: Schematron compile fixture
    :fileformat: File format as MIME type
    :pronom: Allowed PRONOM codes for the file format
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData><premis:object>
                 <premis:objectCharacteristics>
                 <premis:format><premis:formatDesignation><premis:formatName/>
                   </premis:formatDesignation><premis:formatRegistry>
                   <premis:formatRegistryKey/></premis:formatRegistry>
               </premis:format></premis:objectCharacteristics>
               </premis:object></mets:xmlData></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = fileformat
    elem_handler = find_element(root, 'formatRegistryKey', 'premis')

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
    xml = '''<mets:mets fikdk:CATALOG="1.5.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fikdk="%(fikdk)s"><mets:amdSec>
             <mets:techMD><mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData>
               <premis:object><premis:objectCharacteristics>
                 <premis:format><premis:formatDesignation>
                 <premis:formatName/></premis:formatDesignation>
               </premis:format></premis:objectCharacteristics>
               </premis:object></mets:xmlData></mets:mdWrap>
             </mets:techMD></mets:amdSec></mets:mets>''' % NAMESPACES
    charsets = ['ISO-8859-15', 'UTF-8', 'UTF-16', 'UTF-32', 'iso-8859-15',
                'utf-8', 'utf-16', 'utf-32']
    (mets, root) = parse_xml_string(xml)
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = fileformat

    # Error, since charset is missing
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
