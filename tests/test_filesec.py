"""Tests for the schematron rules for fileSec metadata, i.e for the
rules located in mets_filesec.sch.

.. seealso:: mets_filesec.sch
"""
import xml.etree.ElementTree as ET
import pytest
from tests.common import SVRL_FAILED, SVRL_REPORT, NAMESPACES, \
    parse_xml_string, parse_xml_file, fix_version_17

SCHFILE = 'mets_filesec.sch'


def test_valid_complete_filesec(schematron_fx):
    """Test valid METS, where all mandatory and optional METS elements and
    attributes have been used at least once.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Use new specification
    fix_version_17(root)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("specification, failed", [
    ('1.4', 1), ('1.5.0', 1), ('1.6.0', 0), ('1.7.0', 0)
])
def test_streams_catalogs(schematron_fx, specification, failed):
    """Test that streams are disallowed in old catalog versions.

    :schematron_fx: Schematron compile fixture
    :specification: Specification to test
    :failed: Number of failures
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    if specification == '1.7.0':
        fix_version_17(root)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == failed
    else:
        root.set_attribute('CATALOG', 'fikdk', specification)
        root.set_attribute('SPECIFICATION', 'fikdk', specification)

    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == failed

    elem_handler = root.find_element('file', 'mets')
    elem_handler.del_element('stream', 'mets')
    elem_handler.del_element('stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'video/mp4'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_addml_with_csv(schematron_fx):
    """Some ADDML fields are mandatory, if CSV file format is used.
    Test ADDML mandatory fields with CSV file format.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_csv.xml')

    # Test successful use of ADDML and CSV
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Test missing ADDML elements
    elem_handler = root.find_element('delimFileFormat', 'addml')
    elem_handler.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2


def test_mix_with_jp2(schematron_fx):
    """Test with JPEG2000 file format and MIX. JPEG2000 requires extra section.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_mix.xml')

    # Works, when format is PNG
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Extra elements are required with JPEG2000
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/jp2'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # SpecialFormatCharacteristics added, still requires JPEG2000 element
    elem_handler = root.find_element('BasicImageInformation', 'mix')
    elem_handler = elem_handler.set_element(
        'SpecialFormatCharacteristics', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # JPEG2000 added
    xml = '''<mix:JPEG2000 xmlns:mix="%(mix)s"><mix:EncodingOptions>
               <mix:qualityLayers>4</mix:qualityLayers>
               <mix:resolutionLevels>4</mix:resolutionLevels>
             </mix:EncodingOptions></mix:JPEG2000>'''
    elem_handler.append(ET.XML(xml % NAMESPACES))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # JPEG2000 element is disallowed with other file formats
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/png'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_mix_with_tiff_dpx(schematron_fx):
    """Test with tiff and dpx file formats and MIX. These require byteOrder.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_mix.xml')

    # Works, when format is PNG
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # byteOrder missing with TIFF
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder missing with DPX
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/x-dpx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder added, success with DPX
    elem_handler = root.find_element('BasicDigitalObjectInformation', 'mix')
    elem_handler.set_element('byteOrder', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # byteOrder added, success with TIFF
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("fileformat, mdinfo, version", [
    ('audio/x-aiff', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('audio/x-wav', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('audio/flac', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('audio/mp4', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('audio/mpeg', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('audio/x-ms-wma', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd'], None),
    ('video/jpeg2000', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd'], None),
    ('video/mp4', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd'], None),
    ('video/dv', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd'], None),
    ('video/mpeg', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd'], None),
    ('video/x-ms-wmv', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd'], None),
    ('image/x-dpx', ['NISOIMG', None, 'mix', 'mix'], None),
    ('image/tiff', ['NISOIMG', None, 'mix', 'mix'], None),
    ('image/jpeg', ['NISOIMG', None, 'mix', 'mix'], None),
    ('image/jp2', ['NISOIMG', None, 'mix', 'mix'], None),
    ('image/png', ['NISOIMG', None, 'mix', 'mix'], None),
    ('image/gif', ['NISOIMG', None, 'mix', 'mix'], None),
    ('text/csv', ['OTHER', 'ADDML', 'addml', 'addml'], None),
    ('text/plain', ['TEXTMD', None, 'textMD', 'textmd_kdk'], ['1.4']),
    ('text/xml', ['TEXTMD', None, 'textMD', 'textmd_kdk'], ['1.4']),
    ('text/html', ['TEXTMD', None, 'textMD', 'textmd_kdk'], ['1.4']),
    ('application/xhtml+xml', ['TEXTMD', None, 'textMD', 'textmd_kdk'],
     ['1.4'])
])
def test_fileformat_metadata(schematron_fx, fileformat, mdinfo, version):
    """Some file formats require additonal metadata. Test that if such file
    format is used, additional metadat is required.

    :schematron_fx: Schematron compile fixture
    :fileformat: File format
    :mdinfo: Working metadata info: [MDTYPE, OTHERMDTYPE, root element in the
             metadata section, namespace of the root]
    :version: Applied only in given specifications. If None, applied to all
              specifications.
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s"
             xmlns:mix="%(mix)s" xmlns:textmd_kdk="%(textmd_kdk)s"
             xmlns:addml="%(addml)s" xmlns:audiomd="%(audiomd)s"
             xmlns:videomd="%(videomd)s" xmlns:xsi="%(xsi)s"
             xmlns:xlink="%(xlink)s">
               <mets:dmdSec><mets:mdWrap MDTYPE="DC"><mets:xmlData>
               <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:amdSec>
                 <mets:techMD ID="tech01"><mets:mdWrap MDTYPE="PREMIS:OBJECT">
                 <mets:xmlData><premis:object xsi:type="premis:file">
                   <premis:objectCharacteristics><premis:format>
                   <premis:formatDesignation><premis:formatName>image/png
                   </premis:formatName></premis:formatDesignation>
                   </premis:format></premis:objectCharacteristics>
                 </premis:object></mets:xmlData></mets:mdWrap></mets:techMD>
                 <mets:techMD ID="tech02"><mets:mdWrap MDTYPE="NISOIMG">
                   <mets:xmlData><mix:mix/></mets:xmlData></mets:mdWrap>
                 </mets:techMD><mets:digiprovMD ID="dp01">
                   <mets:mdWrap MDTYPE="PREMIS:EVENT"><mets:xmlData>
                 <premis:event/></mets:xmlData></mets:mdWrap></mets:digiprovMD>
               </mets:amdSec><mets:fileSec><mets:fileGrp>
                 <mets:file ID="fid" ADMID="tech01 tech02 dp01">
                 <mets:FLocat xlink:type="simple" xlink:href="xxx"/>
                 </mets:file></mets:fileGrp>
               </mets:fileSec><mets:structMap><mets:div>
               <mets:fptr FILEID="fid"/></mets:div></mets:structMap>
             </mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # Insert given metadata
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = fileformat
    elem_section = root.find_element('techMD[@ID="tech02"]', 'mets')
    elem_handler = elem_section.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_meta = elem_handler.set_element(mdinfo[2], mdinfo[3])
    elem_handler = elem_section.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        elem_handler.set_attribute('OTHERMDTYPE', 'mets', mdinfo[1])
    if version is not None:
        root.set_attribute('CATALOG', 'fikdk', version[0])

    extra = 0
    if fileformat in ['image/x-dpx', 'image/tiff']:
        elem_meta = elem_meta.set_element(
            'BasicDigitalObjectInformation', 'mix')
        elem_meta.set_element('byteOrder', 'mix')
        extra = 1
    if fileformat in ['image/jp2']:
        elem_meta = elem_meta.set_element('BasicImageInformation', 'mix')
        elem_meta = elem_meta.set_element(
            'SpecialFormatCharacteristics', 'mix')
        elem_meta.set_element('JPEG2000', 'mix')
        extra = 2
    if fileformat in ['text/csv']:
        elem_meta = elem_meta.set_element('dataset', 'addml')
        elem_meta = elem_meta.set_element('flatFiles', 'addml')
        elem_meta = elem_meta.set_element('structureTypes', 'addml')
        elem_meta = elem_meta.set_element('flatFileTypes', 'addml')
        elem_meta = elem_meta.set_element('flatFileType', 'addml')
        elem_meta = elem_meta.set_element('delimFileFormat', 'addml')
        elem_meta.set_element('fieldSeparatingChar', 'addml')
        elem_meta.set_element('recordSeparator', 'addml')
        extra = 2

    # Success
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Remove link to metadata section, and have failure
    elem_section.set_attribute('ID', 'mets', 'tech_nolink')
    allversions = ['1.4', '1.4.1', '1.5.0', '1.6.0', '1.7.0']
    for testversion in allversions:
        if testversion == '1.7.0':
            fix_version_17(root)
        else:
            root.set_attribute('CATALOG', 'fikdk', testversion)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        if version is None or testversion in version:
            assert svrl.count(SVRL_FAILED) == 2 + extra


def test_dependent_attributes_filesec(schematron_fx):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('file', 'mets')

    # Both attributes
    elem_handler.set_attribute('CHECKSUM', 'mets', 'xxx')
    elem_handler.set_attribute('CHECKSUMTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the second attribute
    elem_handler.del_attribute('CHECKSUM', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # No attributes
    elem_handler.del_attribute('CHECKSUMTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the first attribute
    elem_handler.set_attribute('CHECKSUM', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("attribute, nspace", [
    ('LOCTYPE', 'mets'),
    ('type', 'xlink'),
])
def test_value_items_filesec(schematron_fx, attribute, nspace):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    :attribute: Attribute, where the value is required
    :nspace: Namespace key of the attribute
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    if nspace == 'fi':
        fix_version_17(root)

    # Use arbitrary value
    elem_handler = root.find_element('FLocat', 'mets')
    elem_handler.set_attribute(attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    elem_handler.set_attribute(attribute, nspace, '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace, context", [
    ('href', 'xlink', 'FLocat'),
    ('type', 'xlink', 'FLocat'),
    ('ADMID', 'mets', 'file')
])
def test_mandatory_items_filesec(schematron_fx, mandatory, nspace, context):
    """Test mandatory subelements in element.

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    :context: Element, where the attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element(context, 'mets')

    # Missing ADMID gives more than one error
    extra = 0
    if mandatory == 'ADMID':
        extra = 1

    # Remove mandatory attribute
    elem_handler.del_attribute(mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1 + extra


@pytest.mark.parametrize("disallowed, context", [
    ('FContent', 'file'),
    ('file', 'file'),
    ('transformFile', 'file'),
    ('@OTHERLOCTYPE', 'FLocat'),
])
def test_disallowed_items_filesec(schematron_fx, disallowed, context):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    :disallowed: Disallowed element or attribute, use '@' for attributes.
    :context: Context element, where the attribute or element exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element(context, 'mets')
    if disallowed[0] == '@':
        elem_handler.set_attribute(disallowed[1:], 'mets', 'default')
    else:
        elem_handler.set_element(disallowed, 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("context", [
    ('fileSec'), ('fileGrp'), ('file')
])
def test_arbitrary_attributes_filesec(schematron_fx, context):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element(context, 'mets')
    for spec in [None, '1.7.0']:
        if spec == '1.7.0':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            elem_handler.set_attribute('xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            elem_handler.del_attribute('xxx', ns)


@pytest.mark.parametrize("specification, check_report, check_error", [
    ('1.5.0', 1, 0), ('1.4', 0, 1)
])
def test_native(schematron_fx, specification, check_report, check_error):
    """Test the native file case. Native file requires a migration event to
    a recommended/acceptable file format. Here we test various cases related to
    native files.

    :schematron_fx: Schematron compile fixture
    :specification: Used specification sa string
    :check_error: 1 natives are disallowed, 0 otherwise
    :check_report: 1 native check done with specification, 0 otherwise
    """
    (mets, root) = parse_xml_file('mets_valid_native.xml')

    # Working case
    root.set_attribute('CATALOG', 'fikdk', specification)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == check_error
    assert svrl.count(SVRL_REPORT) == check_report

    # Make required migration event to something else
    elem_handler = root.find_element('eventType', 'premis')
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_handler.text = 'migration'
    assert svrl.count(SVRL_FAILED) == 1
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
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Give error, if linking to migration event is destroyed
    elem_handler = root.find_element(
        'file[@ADMID="techmd-001 event-001 agent-001"]', 'mets')
    elem_handler.set_attribute('ADMID', 'mets', 'techmd-001')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0


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
    assert svrl.count(SVRL_FAILED) == 4   # Container, two streams, and AMDID
    elem_container.set_attribute('ID', 'mets', techid_value)

    elem_vstream = root.find_element('techMD[@ID="tech-videopremis"]', 'mets')
    elem_vstream.set_attribute('ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3


def test_missing_links_filesec(schematron_fx):
    """Test the case where linking missing from FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('fptr', 'mets')
    refs = elem_handler.get_attribute('FILEID', 'mets').split()
    elem_handler.set_attribute('FILEID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == len(refs)


@pytest.mark.parametrize("context", [
    ('techMD'), ('sourceMD'), ('digiprovMD[@ID="dp02"]')
])
def test_missing_ids_filesec(schematron_fx, context):
    """Test the case where sections are missing for ADMID and DMDID
    links.

    :schematron_fx: Schematron compile fixture
    :context: Section to be removed.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element(context, 'mets')
    # We actually just remove the id
    elem_handler.set_attribute('ID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    extra = 0
    if context in ['techMD']:
        extra = 1
    assert svrl.count(SVRL_FAILED) == 1 + extra
