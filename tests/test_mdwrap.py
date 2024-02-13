"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_mdwrap.sch.

.. seealso:: mets_mdwrap.sch
"""
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file, parse_xml_string,
                          NAMESPACES, fix_version_17, find_element,
                          set_element, set_attribute, del_attribute)

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
    ('dmdSec', 'MARC', None, ['marcxml=1.2;marc=marc21']),
    ('dmdSec', 'DC', None, ['1.1', '2008']),
    ('dmdSec', 'MODS', None, ['3.8', '3.7', '3.6', '3.5', '3.4', '3.3', '3.2',
                              '3.1', '3.0']),
    ('dmdSec', 'EAD', None, ['2002']),
    ('dmdSec', 'EAC-CPF', None, ['2010_revised', '2.0']),
    ('dmdSec', 'LIDO', None, ['1.0', '1.1']),
    ('dmdSec', 'VRA', None, ['4.0']),
    ('dmdSec', 'DDI', None, ['3.3', '3.2', '3.1', '2.5.1', '2.5', '2.1']),
    ('dmdSec', 'OTHER', 'EAD3', ['1.1.1', '1.1.0', '1.0.0']),
    ('dmdSec', 'OTHER', 'DATACITE', ['4.3', '4.2', '4.1']),
    ('dmdSec', 'OTHER', 'EBUCORE', ['1.10']),
    ('techMD', 'NISOIMG', None, ['2.0']),
    ('techMD', 'PREMIS:OBJECT', None, ['2.3', '2.2']),
    ('techMD', 'OTHER', 'AudioMD', ['2.0']),
    ('techMD', 'OTHER', 'VideoMD', ['2.0']),
    ('techMD', 'OTHER', 'ADDML', ['8.2', '8.3']),
    ('techMD', 'OTHER', 'EBUCORE', ['1.10']),
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
    elem_handler = find_element(root, context, 'mets')
    elem_handler = find_element(elem_handler, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', othermdtype)

    # Test that unknown OTHERMDTYPE gives error, if MDTYPE is not 'OTHER'
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', mdtypeversion[0])
    set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', 'xxx')
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
    elem_handler = find_element(root, 'mdWrap', 'mets')

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

    # OTHERMDTYPE and version can be anything
    elem_handler = find_element(root, context, 'mets')
    elem_handler = find_element(elem_handler, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', 'OTHER')
    set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', 'xxx')
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Version is mandatory
    del_attribute(elem_handler, 'MDTYPEVERSION', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # OTHERMDTYPE is missing
    del_attribute(elem_handler, 'OTHERMDTYPE', 'mets')
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', 'xxx')
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
    elem_handler = find_element(root, 'mdWrap', 'mets')

    # Remove mandatory attribute
    del_attribute(elem_handler, 'MDTYPEVERSION', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("section, mdinfo", [
    ('dmdSec', ['DC', None, '1.1', 'subject', 'dc']),
    ('dmdSec', ['MARC', None, 'marcxml=1.2; marc=marc21', 'record', 'marc21']),
    ('dmdSec', ['EAD', None, '2002', 'ead', 'ead']),
    ('dmdSec', ['OTHER', 'EAD3', '1.0.0', 'ead', 'ead3']),
    ('dmdSec', ['LIDO', None, '1.0', 'lido', 'lido']),
    ('dmdSec', ['VRA', None, '4.0', 'vra', 'vra']),
    ('dmdSec', ['MODS', None, '3.7', 'mods', 'mods']),
    ('dmdSec', ['EAC-CPF', None, '2010_revised', 'eac-cpf', 'eac']),
    ('dmdSec', ['EAC-CPF', None, '2.0', 'eac', 'eac2']),
    ('dmdSec', ['DDI', None, '3.2', 'instance', 'ddilc32']),
    ('dmdSec', ['DDI', None, '3.1', 'instance', 'ddilc31']),
    ('dmdSec', ['DDI', None, '2.5', 'instance', 'ddicb25']),
    ('dmdSec', ['DDI', None, '2.1', 'instance', 'ddicb21']),
    ('dmdSec', ['OTHER', 'DATACITE', '4.0', 'resource', 'datacite']),
    ('techMD', ['PREMIS:OBJECT', None, '2.3', 'object', 'premis']),
    ('techMD', ['NISOIMG', None, '2.0', 'mix', 'mix']),
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
              xmlns:mods="%(mods)s" xmlns:eac="%(eac)s" xmlns:eac2="%(eac2)s"
              xmlns:ddilc32="%(ddilc32)s" xmlns:ddilc31="%(ddilc31)s"
              xmlns:ddicb25="%(ddicb25)s" xmlns:ddicb21="%(ddicb21)s"
              xmlns:mix="%(mix)s"
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
    elem_section = find_element(root, section, 'mets')
    elem_wrap = find_element(elem_section, 'mdWrap', 'mets')
    set_attribute(elem_wrap, 'MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        set_attribute(elem_wrap, 'OTHERMDTYPE', 'mets', mdinfo[1])
    set_attribute(elem_wrap, 'MDTYPEVERSION', 'mets', mdinfo[2])
    elem_handler = find_element(elem_wrap, 'xmlData', 'mets')
    elem_handler.clear()
    set_element(elem_handler, mdinfo[3], mdinfo[4])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Wrong (empty) namespace
    elem_handler.clear()
    set_element(elem_handler, mdinfo[3], None)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary MDTYPE (wrong)
    set_attribute(elem_wrap, 'MDTYPE', 'mets', 'xxx')
    if mdinfo[1] is not None:
        del_attribute(elem_wrap, 'OTHERMDTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    set_attribute(elem_wrap, 'MDTYPE', 'mets', mdinfo[0])
    if mdinfo[1] is not None:
        set_attribute(elem_wrap, 'OTHERMDTYPE', 'mets', mdinfo[1])
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary MDTYPEVERSION (wrong)
    set_attribute(elem_wrap, 'MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    set_attribute(elem_wrap, 'MDTYPEVERSION', 'mets', mdinfo[2])
    assert svrl.count(SVRL_FAILED) == 1

    # Check that the metadata fails in other sections
    for othersection in ['dmdSec', 'techMD', 'rightsMD', 'digiprovMD']:
        if othersection != section:
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1


def test_rightsstatement_failure(schematron_fx):
    """There was an accidential error in specification 1.5.0 where
    rightsStatement was accepted as root element in PREMIS:RIGHTS. The correct
    element is 'rights'. Test that 'rights' works and 'rightsStatement' gives
    an error in all versions.

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

    # rightsStatement fails also with specification 1.5.0
    set_attribute(root, 'CATALOG', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # rights works with specification 1.6.0
    set_attribute(root, 'CATALOG', 'fikdk', '1.6.0')
    elem_handler = find_element(
        root, 'mdWrap[@MDTYPE="PREMIS:RIGHTS"]', 'mets')
    elem_handler = find_element(elem_handler, 'xmlData', 'mets')
    elem_handler.clear()
    set_element(elem_handler, 'rights', 'premis')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # rights works with specification 1.5.0
    set_attribute(root, 'CATALOG', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
