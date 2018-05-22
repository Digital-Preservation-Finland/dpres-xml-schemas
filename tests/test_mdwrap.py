"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_mdwrap.sch.

.. seealso:: mets_mdwrap.sch
"""
import pytest
from tests.common import SVRL_FAILED, parse_xml_file, \
    parse_xml_string, NAMESPACES, fix_version_17, fix_version_14

SCHFILE = 'mets_mdwrap.sch'


def test_valid_complete_mdwrap(schematron_fx):
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


@pytest.mark.parametrize("context, mdtype, othermdtype, mdtypeversion", [
    ('dmdSec', 'MARC', None, ['marcxml=1.2;marc=marc21',
                              'marcxml=1.2;marc=finmarc']),
    ('dmdSec', 'DC', None, ['1.1']),
    ('dmdSec', 'MODS', None, ['3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                              '3.0']),
    ('dmdSec', 'EAD', None, ['2002']),
    ('dmdSec', 'EAC-CPF', None, ['2010']),
    ('dmdSec', 'LIDO', None, ['1.0']),
    ('dmdSec', 'VRA', None, ['4.0']),
    ('dmdSec', 'DDI', None, ['3.2', '3.1', '2.5.1', '2.5', '2.1']),
    ('dmdSec', 'OTHER', 'EAD3', ['1.0.0']),
    ('dmdSec', 'OTHER', 'DATACITE', ['4.0']),
    ('techMD', 'NISOIMG', None, ['2.0']),
    ('techMD', 'PREMIS:OBJECT', None, ['2.3', '2.2']),
    ('techMD', 'OTHER', 'AudioMD', ['2.0']),
    ('techMD', 'OTHER', 'VideoMD', ['2.0']),
    ('techMD', 'OTHER', 'ADDML', ['8.2', '8.3']),
    ('rightsMD', 'PREMIS:RIGHTS', None, ['2.3', '2.2']),
    ('digiprovMD', 'PREMIS:EVENT', None, ['2.3', '2.2']),
    ('digiprovMD', 'PREMIS:AGENT', None, ['2.3', '2.2'])
])
def test_mdtype_items_mdwrap(schematron_fx, context, mdtype, othermdtype,
                             mdtypeversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :context: METS section to be tested
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute value
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    fix_version_17(root)
    elem_handler = root.find_element(context, 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        elem_handler.set_attribute('OTHERMDTYPE', 'mets', othermdtype)

    # Test that unknown OTHERMDTYPE gives error, if MDTYPE is not 'OTHER'
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', mdtypeversion[0])
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if mdtype == 'OTHER':
        assert svrl.count(SVRL_FAILED) == 0
    else:
        assert svrl.count(SVRL_FAILED) == 1


def test_dependent_attributes_mdwrap(schematron_fx):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('mdWrap', 'mets')

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


@pytest.mark.parametrize("context", [
    ('dmdSec'), ('techMD'), ('sourceMD'), ('rightsMD'), ('digiprovMD')
])
def test_othermdtype(schematron_fx, context):
    """Test that OTHERMDTYPE and the version are mandatory, but can be anything
    in all METS sections, if MDTYPE is OTHER.

    :schematron_fx: Schematron compile fixture
    :context: METS section to be tested
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    fix_version_14(root)

    # OTHERMDTYPE and version can be anything
    elem_handler = root.find_element(context, 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', 'OTHER')
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Version is mandatory
    elem_handler.del_attribute('MDTYPEVERSION', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Version is not mandatory in 1.4
    root.set_attribute('CATALOG', 'fikdk', '1.4')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # OTHERMDTYPE is mandatory in 1.4
    elem_handler.del_attribute('OTHERMDTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # OTHERMDTYPE is (still) missing
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    root.set_attribute('CATALOG', 'fikdk', '1.5.0')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2


def test_mandatory_items(schematron_fx):
    """

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    :context: Element, where the attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('mdWrap', 'mets')

    # Remove mandatory attribute
    elem_handler.del_attribute('MDTYPEVERSION', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


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
    ('dmdSec', ['OTHER', 'DATACITE', '4.0', 'resource', 'datacite']),
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
             xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s"
             xmlns:marc21="%(marc21)s" xmlns:ead="%(ead)s"
             xmlns:ead3="%(ead3)s" xmlns:lido="%(lido)s" xmlns:vra="%(vra)s"
              xmlns:mods="%(mods)s" xmlns:eac="%(eac)s"
              xmlns:ddilc32="%(ddilc32)s" xmlns:ddilc31="%(ddilc31)s"
              xmlns:ddicb25="%(ddicb25)s" xmlns:ddicb21="%(ddicb21)s"
              xmlns:mix="%(mix)s" xmlns:textmd="%(textmd)s"
              xmlns:addml="%(addml)s" xmlns:audiomd="%(audiomd)s"
              xmlns:videomd="%(videomd)s">
               <mets:dmdSec><mets:mdWrap MDTYPE='DC' MDTYPEVERSION='1.1'>
                 <mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:dmdSec><mets:mdWrap MDTYPE='DC' MDTYPEVERSION='1.1'>
                 <mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:amdSec>
               <mets:techMD>
                 <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD>
               <mets:techMD>
                 <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD>
               <mets:rightsMD>
                 <mets:mdWrap MDTYPE="PREMIS:RIGHTS" MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:rights/></mets:xmlData></mets:mdWrap>
               </mets:rightsMD>
               <mets:rightsMD>
                 <mets:mdWrap MDTYPE="PREMIS:RIGHTS" MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:rights/></mets:xmlData></mets:mdWrap>
               </mets:rightsMD>
               <mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT' MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
               </mets:digiprovMD><mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT' MDTYPEVERSION='2.3'>
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
               </mets:digiprovMD>
             </mets:amdSec></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    if mdinfo[1] == 'DATACITE':
        fix_version_17(root)

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
    if mdinfo[1] is not None:
        elem_wrap.del_attribute('OTHERMDTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_wrap.set_attribute('MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        elem_wrap.set_attribute('OTHERMDTYPE', 'mets', mdinfo[1])
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


def test_textmd(schematron_fx):
    """When TEXTMD is used, the KDK version is required in 1.4, but standard
    version in versions 1.5.0 (and later). They both have different namespaces.
    Test namespace issue, when TEXMD is used.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.5.0" xmlns:mets="%(mets)s"
             xmlns:textmd="%(textmd)s" xmlns:premis="%(premis)s"
             xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s">
               <mets:dmdSec><mets:mdWrap MDTYPE="DC" MDTYPEVERSION="1.1">
                 <mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:amdSec>
               <mets:techMD>
                 <mets:mdWrap MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD>
               <mets:techMD>
                 <mets:mdWrap MDTYPE="TEXTMD" MDTYPEVERSION="3.01a">
                 <mets:xmlData><textmd:textMD/>
               </mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:digiprovMD>
                 <mets:mdWrap MDTYPE="PREMIS:EVENT" MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:amdSec></mets:mets>''' % NAMESPACES
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
    root.set_attribute('CATALOG', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_rightsstatement_failure(schematron_fx):
    """There was an accidential error in specification 1.5.0 where
    rightsStatement was accepted as root element in PREMIS:RIGHTS. The correct
    element is 'rights'. Test that 'rights' works in all versions, and
    'rightsStatement' gives a warning with specification 1.5.0 and error
    in all other versions.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:dc="%(dc)s" xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s">
               <mets:dmdSec><mets:mdWrap MDTYPE="DC" MDTYPEVERSION="1.1">
                 <mets:xmlData><dc:subject/></mets:xmlData></mets:mdWrap>
               </mets:dmdSec>
               <mets:amdSec>
               <mets:techMD>
                 <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD>
               <mets:rightsMD>
                 <mets:mdWrap MDTYPE="PREMIS:RIGHTS" MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:rightsStatement/>
               </mets:xmlData></mets:mdWrap></mets:rightsMD>
               <mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT' MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:amdSec></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # rightsStatement gives an error with specification 1.6.0
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # rightsStatement works with specification 1.5.0
    root.set_attribute('CATALOG', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # rights works with specification 1.6.0
    root.set_attribute('CATALOG', 'fikdk', '1.6.0')
    elem_handler = root.find_element('mdWrap[@MDTYPE="PREMIS:RIGHTS"]', 'mets')
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler.set_element('rights', 'premis')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # rights works with specification 1.5.0
    root.set_attribute('CATALOG', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
