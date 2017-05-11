"""Tests for the schematron rules for metadata sections in METS, i.e for the
rules located in mets_mdtype.sch.

.. seealso:: mets_mdtype.sch
"""

import xml.etree.ElementTree as ET
import pytest
from tests.common import SVRL_FAILED, SVRL_REPORT, NAMESPACES, parse_xml_string

SCHFILE = 'mets_mdtype.sch'


@pytest.mark.parametrize("section, mdinfo", [
    ('dmdSec', ['DC', None, '1.1', 'subject', 'dc']),
    ('dmdSec', ['MARC', None, 'marcxml=1.2; marc=marc21', 'record', 'marc21']),
    ('dmdSec', ['EAD', None, '2002', 'ead', 'ead']),
    ('dmdSec', ['OTHER', 'EAD3', '1.0.0', 'ead', 'ead3']),
    ('dmdSec', ['LIDO', None, '1.0', 'lido', 'lido']),
    ('dmdSec', ['VRA', None, '4.0', 'vra', 'vra']),
    ('dmdSec', ['MODS', None, '3.6', 'mods', 'mods']),
    ('dmdSec', ['EAC-CPF', None, '2010', 'eac-cpf', 'eac']),
    ('dmdSec', ['DDI', None, '3.2', 'instance', 'ddilc32']),
    ('dmdSec', ['DDI', None, '3.1', 'instance', 'ddilc31']),
    ('dmdSec', ['DDI', None, '2.5', 'instance', 'ddicb25']),
    ('dmdSec', ['DDI', None, '2.1', 'instance', 'ddicb21']),
    ('techMD', ['PREMIS:OBJECT', None, '2.3', 'object', 'premis']),
    ('techMD', ['NISOIMG', None, '2.0', 'mix', 'mix']),
    ('techMD', ['TEXTMD', None, '3.01a', 'textMD', 'textmd']),
    ('techMD', ['OTHER', 'ADDML', '8.3', 'addml', 'addml']),
    ('techMD', ['OTHER', 'AudioMD', '2.0', 'AUDIOMD', 'audiomd']),
    ('techMD', ['OTHER', 'VideoMD', '2.0', 'VIDEOMD', 'videomd']),
    ('rightsMD', ['PREMIS:RIGHTS', None, '2.3', 'rights', 'premis']),
    ('digiprovMD', ['PREMIS:EVENT', None, '2.3', 'event', 'premis']),
    ('digiprovMD', ['PREMIS:AGENT', None, '2.3', 'agent', 'premis'])
])
def test_mdtype_namespace(schematron_fx, section, mdinfo):
    """Test that the check for comparing given metadata type and the actual
    metadata works.

    :schematron_fx: Schematron compile fixture
    :section: Context section to be tested
    :mdinfo: Working metadata info: [MDTYPE, OTHERMDTYPE, MDTYPEVERSION,
             root element in the metadata section, namespace of the root]
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fi)s" xmlns:dc="%(dc)s"
             xmlns:marc21="%(marc21)s" xmlns:ead="%(ead)s"
             xmlns:ead3="%(ead3)s" xmlns:lido="%(lido)s" xmlns:vra="%(vra)s"
              xmlns:mods="%(mods)s" xmlns:eac="%(eac)s"
              xmlns:ddilc32="%(ddilc32)s" xmlns:ddilc31="%(ddilc31)s"
              xmlns:ddicb25="%(ddicb25)s" xmlns:ddicb21="%(ddicb21)s"
              xmlns:mix="%(mix)s" xmlns:textmd="%(textmd)s"
              xmlns:addml="%(addml)s" xmlns:audiomd="%(audiomd)s"
              xmlns:videomd="%(videomd)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'><mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'><mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:rightsMD><mets:mdWrap MDTYPE="PREMIS:RIGHTS">
                 <mets:xmlData><premis:rights/></mets:xmlData></mets:mdWrap>
               </mets:rightsMD>
               <mets:rightsMD><mets:mdWrap MDTYPE="PREMIS:RIGHTS">
                 <mets:xmlData><premis:rights/></mets:xmlData></mets:mdWrap>
               </mets:rightsMD>
               <mets:digiprovMD><mets:mdWrap MDTYPE='PREMIS:EVENT'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
               </mets:digiprovMD><mets:digiprovMD>
               <mets:mdWrap MDTYPE='PREMIS:EVENT'><mets:xmlData>
                 <premis:event/></mets:xmlData></mets:mdWrap></mets:digiprovMD>
             </mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # Test that the given combination works
    elem_section = root.find_element(section, 'mets')
    elem_wrap = elem_section.find_element('mdWrap', 'mets')
    elem_wrap.set_attribute('MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        elem_wrap.set_attribute('OTHERMDTYPE', 'mets', mdinfo[1])
    elem_wrap.set_attribute('MDTYPEVERSION', 'mets', mdinfo[2])
    elem_handler = elem_wrap.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler.set_element(mdinfo[3], mdinfo[4])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Wrong (empty) namespace
    elem_handler.clear()
    elem_handler.set_element(mdinfo[3], None)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary MDTYPE (wrong)
    elem_wrap.set_attribute('MDTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_wrap.set_attribute('MDTYPE', 'mets', mdinfo[0])
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary MDTYPEVERSION (wrong)
    elem_wrap.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_wrap.set_attribute('MDTYPEVERSION', 'mets', mdinfo[2])
    assert svrl.count(SVRL_FAILED) == 1

    # Check that the metadata fails in other sections
    for othersection in ['dmdSec', 'techMD', 'rightsMD', 'digiprovMD']:
        if othersection != section:
            elem_section.key = (
                '%(mets)s'+othersection) % NAMESPACES
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1

def test_digiprov_object(schematron_fx):
    """PREMIS:OBJECT is allowed in digiprovMD, if it's type is representation.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:xsi="%(xsi)s"
             xmlns:fi="%(fi)s" xmlns:dc="%(dc)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'><mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:digiprovMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'>
                 <mets:xmlData>
                   <premis:object xsi:type='premis:representation'/>
                 </mets:xmlData></mets:mdWrap></mets:digiprovMD>
               <mets:digiprovMD><mets:mdWrap MDTYPE='PREMIS:EVENT'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:mets>''' % NAMESPACES
    ET.register_namespace('premis', NAMESPACES['premis'])
    (mets, root) = parse_xml_string(xml)

    # Works with premis:representation
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Fails with other values
    elem_handler = root.find_element('digiprovMD', 'mets')
    elem_handler = elem_handler.find_element('object', 'premis')
    elem_handler.set_attribute('type', 'xsi', 'premis:file')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    elem_handler.set_attribute('type', 'xsi', 'premis:bitstream')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

def test_textmd(schematron_fx):
    """When TEXTMD is used, the KDK version is required in 1.4, but standard
    version in versions 1.5.0 (and later). They both have different namespaces.
    Test namespace issue, when TEXMD is used.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.5.0" xmlns:mets="%(mets)s"
             xmlns:textmd="%(textmd)s" xmlns:premis="%(premis)s"
             xmlns:fi="%(fi)s" xmlns:dc="%(dc)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'><mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:techMD><mets:mdWrap MDTYPE="TEXTMD"><mets:xmlData>
                 <textmd:textMD/>
               </mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:digiprovMD><mets:mdWrap MDTYPE='PREMIS:EVENT'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # Standard version works in specification 1.5.0
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # KDK version fails in specification 1.5.0
    elem_handler = root.find_element('mdWrap[@MDTYPE="TEXTMD"]', 'mets')
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler.set_element('textMD', 'textmd_kdk')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # KDK version works in specification 1.4
    root.set_attribute('CATALOG', 'fi', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_rightsstatement(schematron_fx):
    """There was an accidential error in specification 1.5.0 where
    rightsStatement was accepted as root element in PREMIS:RIGHTS. The correct
    element is 'rights'. Test that 'rights' works in all versions, and
    'rightsStatement' gives a warning with specification 1.5.0 and error
    in all other versions.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:dc="%(dc)s" xmlns:premis="%(premis)s" xmlns:fi="%(fi)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'><mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:rightsMD><mets:mdWrap MDTYPE="PREMIS:RIGHTS">
                 <mets:xmlData><premis:rightsStatement/>
               </mets:xmlData></mets:mdWrap></mets:rightsMD>
               <mets:digiprovMD><mets:mdWrap MDTYPE='PREMIS:EVENT'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # rightsStatement gives an error with specification 1.6.0
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # rightsStatement gives a warning with specification 1.5.0
    root.set_attribute('CATALOG', 'fi', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1

    # rights work with specification 1.6.0
    root.set_attribute('CATALOG', 'fi', '1.6.0')
    elem_handler = root.find_element('mdWrap[@MDTYPE="PREMIS:RIGHTS"]', 'mets')
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler.set_element('rights', 'premis')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 0

    # rights work with specification 1.5.0
    root.set_attribute('CATALOG', 'fi', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 0


def test_special_mdtype(schematron_fx):
    """Standard portfolio's EN15744 metadata format does not have a schema.
    Therefore it is currently disallowed. Test that disallowing works.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:dc="%(dc)s" xmlns:premis="%(premis)s" xmlns:fi="%(fi)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:dmdSec><mets:mdWrap MDTYPE='OTHER' OTHERMDTYPE='EN15744'>
                 <mets:xmlData><xxx/></mets:xmlData></mets:mdWrap>
               </mets:dmdSec><mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'>
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD><mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT'><mets:xmlData>
                 <premis:event/></mets:xmlData></mets:mdWrap></mets:digiprovMD>
             </mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # EN15744 is not allowed
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 0

    # Everything works, if something else is given
    elem_handler = root.find_element('mdWrap[@MDTYPE="OTHER"]', 'mets')
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1


def test_mandatory_sections(schematron_fx):
    """Three metadata sectons are required: (1) dmdSec with standard metadata
    format, (2) techMD, (3) digiprovMD. All of these should give one error,
    if just METS root is given.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets xmlns:mets="%(mets)s"/>''' \
          % NAMESPACES
    (mets, _) = parse_xml_string(xml)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3


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
             xmlns:premis="%(premis)s" xmlns:fi="%(fi)s" xmlns:dc="%(dc)s"
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
                 <mets:file ADMID="tech01 tech02 dp01">
                 <mets:FLocat xlink:href="xxx"/></mets:file></mets:fileGrp>
             </mets:fileSec></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # Insert given metadata
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = fileformat
    elem_section = root.find_element('techMD[@ID="tech02"]', 'mets')
    elem_handler = elem_section.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler.set_element(mdinfo[2], mdinfo[3])
    elem_handler = elem_section.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        elem_handler.set_attribute('OTHERMDTYPE', 'mets', mdinfo[1])
    if version is not None:
        root.set_attribute('CATALOG', 'fi', version[0])

    # Success
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Remove link to metadata section, and have failure
    elem_section.set_attribute('ID', 'mets', 'tech_nolink')
    allversions = ['1.4', '1.4.1', '1.5.0', '1.6.0']
    for testversion in allversions:
        root.set_attribute('CATALOG', 'fi', testversion)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        if version is None or testversion in version:
            assert svrl.count(SVRL_FAILED) == 1
