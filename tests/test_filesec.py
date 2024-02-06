"""Tests for the schematron rules for fileSec metadata, i.e for the
rules located in mets_filesec.sch.

.. seealso:: mets_filesec.sch
"""
import lxml.etree as ET
import pytest
from tests.common import (SVRL_FAILED, SVRL_REPORT, NAMESPACES,
                          parse_xml_string, parse_xml_file, fix_version_17,
                          get_attribute, set_attribute, del_attribute,
                          find_element, set_element, del_element)

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
    ('1.5.0', 1), ('1.6.0', 0), ('1.7.5', 0)
])
def test_streams_catalogs(schematron_fx, specification, failed):
    """Test that streams are disallowed in old catalog versions.

    :schematron_fx: Schematron compile fixture
    :specification: Specification to test
    :failed: Number of failures
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    if specification == '1.7.5':
        fix_version_17(root)
    else:
        set_attribute(root, 'CATALOG', 'fikdk', specification)
        set_attribute(root, 'SPECIFICATION', 'fikdk', specification)

    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == failed

    elem_handler = find_element(root, 'file', 'mets')
    del_element(elem_handler, 'stream', 'mets')
    del_element(elem_handler, 'stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_handler = find_element(root, 'formatName', 'premis')
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
    elem_handler = find_element(root, 'delimFileFormat', 'addml')
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
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = 'image/jp2'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # SpecialFormatCharacteristics added, still requires JPEG2000 element
    elem_handler = find_element(root, 'BasicImageInformation', 'mix')
    elem_handler = set_element(
        elem_handler, 'SpecialFormatCharacteristics', 'mix')
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
    elem_handler = find_element(root, 'formatName', 'premis')
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
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder missing with DPX
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = 'image/x-dpx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder added, success with DPX
    elem_handler = find_element(root, 'BasicDigitalObjectInformation', 'mix')
    set_element(elem_handler, 'byteOrder', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # byteOrder added, success with TIFF
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("fileformat, mdinfo", [
    ('audio/x-aiff', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/x-wav', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/L8', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/L16', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/L20', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/L24', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/flac', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/aac', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/mpeg', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('audio/x-ms-wma', ['OTHER', 'AudioMD', 'AUDIOMD', 'audiomd']),
    ('video/jpeg2000', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd']),
    ('video/mp4', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd']),
    ('video/dv', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd']),
    ('video/mpeg', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd']),
    ('video/x-ms-wmv', ['OTHER', 'VideoMD', 'VIDEOMD', 'videomd']),
    ('image/x-dpx', ['NISOIMG', None, 'mix', 'mix']),
    ('image/x-adobe-dng', ['NISOIMG', None, 'mix', 'mix']),
    ('image/tiff', ['NISOIMG', None, 'mix', 'mix']),
    ('image/jpeg', ['NISOIMG', None, 'mix', 'mix']),
    ('image/jp2', ['NISOIMG', None, 'mix', 'mix']),
    ('image/png', ['NISOIMG', None, 'mix', 'mix']),
    ('image/gif', ['NISOIMG', None, 'mix', 'mix']),
    ('text/csv', ['OTHER', 'ADDML', 'addml', 'addml'])
])
def test_fileformat_metadata(schematron_fx, fileformat, mdinfo):
    """Some file formats require additonal metadata. Test that if such file
    format is used, additional metadat is required.

    :schematron_fx: Schematron compile fixture
    :fileformat: File format
    :mdinfo: Working metadata info: [MDTYPE, OTHERMDTYPE, root element in the
             metadata section, namespace of the root]
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s"
             xmlns:mix="%(mix)s"
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
    elem_handler = find_element(root, 'formatName', 'premis')
    elem_handler.text = fileformat
    elem_section = find_element(root, 'techMD[@ID="tech02"]', 'mets')
    elem_handler = find_element(elem_section, 'xmlData', 'mets')
    elem_handler.clear()
    elem_meta = set_element(elem_handler, mdinfo[2], mdinfo[3])
    elem_handler = find_element(elem_section, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', mdinfo[1])

    extra = 0
    if fileformat in ['image/x-dpx', 'image/tiff']:
        elem_meta = set_element(
            elem_meta, 'BasicDigitalObjectInformation', 'mix')
        set_element(elem_meta, 'byteOrder', 'mix')
        extra = 1
    if fileformat in ['image/jp2']:
        elem_meta = set_element(elem_meta, 'BasicImageInformation', 'mix')
        elem_meta = set_element(
            elem_meta, 'SpecialFormatCharacteristics', 'mix')
        set_element(elem_meta, 'JPEG2000', 'mix')
        extra = 2
    if fileformat in ['text/csv']:
        elem_meta = set_element(elem_meta, 'dataset', 'addml')
        elem_meta = set_element(elem_meta, 'flatFiles', 'addml')
        elem_meta = set_element(elem_meta, 'structureTypes', 'addml')
        elem_meta = set_element(elem_meta, 'flatFileTypes', 'addml')
        elem_meta = set_element(elem_meta, 'flatFileType', 'addml')
        elem_meta = set_element(elem_meta, 'delimFileFormat', 'addml')
        set_element(elem_meta, 'fieldSeparatingChar', 'addml')
        set_element(elem_meta, 'recordSeparator', 'addml')
        extra = 2

    # Success
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Remove link to metadata section, and have failure
    set_attribute(elem_section, 'ID', 'mets', 'tech_nolink')
    allversions = ['1.5.0', '1.6.0', '1.7.0', '1.7.1', '1.7.2', '1.7.3',
                   '1.7.5']
    for testversion in allversions:
        if testversion in ['1.7.0', '1.7.1', '1.7.2', '1.7.3', '1.7.5']:
            fix_version_17(root)
        else:
            set_attribute(root, 'CATALOG', 'fikdk', testversion)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == 2 + extra


def test_file_format_bitlevel_stream(schematron_fx):
    """Test that a DPS supported container containing a supported stream and
    a bit-level stream does not need to have VideoMD nor AudioMD.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file("mets_native_video_stream.xml")
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1


def test_nisoimg_vs_othermdtype(schematron_fx):
    """Test that MIX metadata is considered missing, if NISOIMG is missing
    and MIX is in OTHERMDTYPE metadata.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s"
             xmlns:mix="%(mix)s"
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
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    elem_section = find_element(root, 'techMD[@ID="tech02"]', 'mets')
    elem_handler = find_element(elem_section, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', 'OTHER')
    set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', 'MIX')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_dependent_attributes_filesec(schematron_fx):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'file', 'mets')

    # Both attributes
    set_attribute(elem_handler, 'CHECKSUM', 'mets', 'xxx')
    set_attribute(elem_handler, 'CHECKSUMTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the second attribute
    del_attribute(elem_handler, 'CHECKSUM', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # No attributes
    del_attribute(elem_handler, 'CHECKSUMTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the first attribute
    set_attribute(elem_handler, 'CHECKSUM', 'mets', 'xxx')
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
    elem_handler = find_element(root, 'FLocat', 'mets')
    set_attribute(elem_handler, attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    set_attribute(elem_handler, attribute, nspace, '')
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
    elem_handler = find_element(root, context, 'mets')

    # Missing ADMID gives more than one error
    extra = 0
    if mandatory == 'ADMID':
        extra = 1

    # Remove mandatory attribute
    del_attribute(elem_handler, mandatory, nspace)
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
    elem_handler = find_element(root, context, 'mets')
    if disallowed[0] == '@':
        set_attribute(elem_handler, disallowed[1:], 'mets', 'default')
    else:
        set_element(elem_handler, disallowed, 'mets')
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
    elem_handler = find_element(root, context, 'mets')
    for spec in [None, '1.7.5']:
        if spec == '1.7.5':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)


def test_bitlevel_migration(schematron_fx):
    """Test the bitlevel file case where file requires a migration event to
    a recommended/acceptable file format. Here we test various cases related to
    this kind of file.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_native.xml')

    # Working case
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1

    # Make required migration event to something else
    elem_handler = find_element(root, 'eventType', 'premis')
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_handler.text = 'migration'
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Make bitlevel file as outcome and recommended format as source
    # The bitlevel file needs to be the source
    elem_handler = find_element(root, 'eventType', 'premis')
    slink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="source"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    olink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="outcome"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    elem_source = find_element(root, slink % NAMESPACES, 'premis')
    elem_outcome = find_element(root, olink % NAMESPACES, 'premis')
    elem_source.text = 'outcome'
    elem_outcome.text = 'source'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_source.text = 'source'
    elem_outcome.text = 'outcome'
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Missing outcome
    elem_outcome.text = 'foo'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_outcome.text = 'outcome'
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Give error, if linking to migration event is destroyed
    elem_handler = find_element(
        root, 'file[@ADMID="techmd-001 event-001 agent-001"]', 'mets')
    set_attribute(elem_handler, 'ADMID', 'mets', 'techmd-001')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0


def test_bitlevel_conversion(schematron_fx):
    """Test conversion to bit-level file case. This requires a conversion
    event from a recommended/acceptable file format to a bit-level format.

    The METS describing the migration case from a bit-level file is used.
    The migration is changed to conversion, and source and outcome are
    swapped for a working case.
    """
    (mets, root) = parse_xml_file('mets_valid_native.xml')

    # Make bit-level as source and recommended format as outcome
    # The bit-level file needs to be the outcome
    elem_handler = find_element(root, 'eventType', 'premis')
    elem_handler.text = 'conversion'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Working case
    slink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="outcome"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    olink = 'linkingObjectIdentifier[{%(premis)s}linkingObjectRole="source"]'\
            + '/{%(premis)s}linkingObjectRole' % NAMESPACES
    elem_source = find_element(root, slink % NAMESPACES, 'premis')
    elem_outcome = find_element(root, olink % NAMESPACES, 'premis')
    elem_source.text = 'source'
    elem_outcome.text = 'outcome'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1

    # Make required conversion event to something else
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_handler.text = 'conversion'
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Missing source
    elem_source.text = 'foo'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_source.text = 'source'
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Give error, if linking to conversion event is destroyed
    elem_handler = find_element(
        root, 'file[@ADMID="techmd-001 event-001 agent-001"]', 'mets')
    set_attribute(elem_handler, 'ADMID', 'mets', 'techmd-001')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0


def test_bitlevel_identification(schematron_fx):
    """Test file format identification.

    This is a bit-level file format without corresponding
    recommended/acceptable format.
    """
    (mets, root) = parse_xml_file('mets_valid_native.xml')
    elem_handler = find_element(
        root, 'file[@ADMID="techmd-001 event-001 agent-001"]', 'mets')
    set_attribute(elem_handler, 'ADMID', 'mets', 'techmd-001')
    set_attribute(elem_handler, 'USE', 'mets',
                  'fi-dpres-file-format-identification')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1


def test_container_links(schematron_fx):
    """Test the container and stream case.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_container = find_element(root, 'techMD[@ID="tech-container"]', 'mets')
    elem_handler = find_element(
        elem_container, 'relatedObjectIdentifierValue', 'premis')
    related_value = elem_handler.text
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    elem_handler.text = related_value

    techid_value = get_attribute(elem_container, 'ID', 'mets')
    set_attribute(elem_container, 'ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 4   # Container, two streams, and AMDID
    set_attribute(elem_container, 'ID', 'mets', techid_value)

    elem_vstream = find_element(root, 'techMD[@ID="tech-videopremis"]', 'mets')
    set_attribute(elem_vstream, 'ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3


def test_audio_container(schematron_fx):
    """Test the happy path for the audio container and stream case.

    :schematron_fx: Schematron compile fixture
    """
    (mets, _) = parse_xml_file('mets_audio_container.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_multi_image_links(schematron_fx):
    """Test linkings of multi-image case. The following cases are tested:
    - Valid linkings of a multi-image file.
    - PREMIS section ID changed, causing an orphan section and broken link
      to ADMID.
    - MIX section ID changed, causing an orphan section and broken link
      to ADMID.
    - Link in stream@ADMID to MIX section is missing.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_multi_image_file.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_premis = find_element(root, 'techMD[@ID="image-premis"]', 'mets')
    set_attribute(elem_premis, 'ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 16
    set_attribute(elem_premis, 'ID', 'mets', "image-premis")

    elem_stream = find_element(root, 'techMD[@ID="image-mix"]', 'mets')
    set_attribute(elem_stream, 'ID', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 18
    set_attribute(elem_stream, 'ID', 'mets', 'image-mix')

    elem_stream = find_element(root, 'stream', 'mets')
    set_attribute(elem_stream, 'ADMID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2


def test_missing_links_filesec(schematron_fx):
    """Test the case where linking missing from FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'fptr', 'mets')
    refs = get_attribute(elem_handler, 'FILEID', 'mets').split()
    set_attribute(elem_handler, 'FILEID', 'mets', '')
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
    elem_handler = find_element(root, context, 'mets')
    # We actually just remove the id
    set_attribute(elem_handler, 'ID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    extra = 0
    if context in ['techMD']:
        extra = 1
    assert svrl.count(SVRL_FAILED) == 1 + extra
