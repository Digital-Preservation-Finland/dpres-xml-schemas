"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_digiprovmd.sch.

.. seealso:: mets_digiprovmd.sch
"""
import lxml.etree as ET
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file,
                          parse_xml_string, NAMESPACES, fix_version_17,
                          find_element, set_attribute, del_attribute)

SCHFILE = 'mets_digiprovmd.sch'


def test_valid_complete_digprovmd(schematron_fx):
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


def test_dependent_attributes_digiprov(schematron_fx):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'mdRef', 'mets')

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


@pytest.mark.parametrize("mdtype, othermdtype, mdtypeversion", [
    ('PREMIS:OBJECT', None, ['2.3', '2.2']),
    ('PREMIS:EVENT', None, ['2.3', '2.2']),
    ('PREMIS:AGENT', None, ['2.3', '2.2'])
])
def test_mdtype_items_digiprovmd(schematron_fx, mdtype, othermdtype,
                                 mdtypeversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute value
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'digiprovMD', 'mets')
    elem_handler = find_element(elem_handler, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', othermdtype)

    # Test that all MDTYPEVERSIONs work with all specifications
    for specversion in ['1.5.0', '1.6.0', '1.7.0', '1.7.1', '1.7.2', '1.7.3',
                        '1.7.4', '1.7.5', '1.7.6', '1.7.7']:
        if specversion in ['1.7.0', '1.7.1', '1.7.2', '1.7.3', '1.7.4',
                           '1.7.5', '1.7.6', '1.7.7']:
            fix_version_17(root, version=specversion)
        else:
            set_attribute(root, 'CATALOG', 'fikdk', specversion)
            set_attribute(root, 'SPECIFICATION', 'fikdk', specversion)
        for version in mdtypeversion:
            set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', version)
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 0

    # Test unknown version
    fix_version_17(root)
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("attribute, nspace", [
    ('LOCTYPE', 'mets'),
    ('OTHERLOCTYPE', 'mets'),
    ('type', 'xlink'),
    ('MDTYPE', 'mets'),
    ('OTHERMDTYPE', 'mets'),
])
def test_value_items_digiprovmd(schematron_fx, attribute, nspace):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    :attribute: Attribute, where the value is required
    :nspace: Namespace key of the attribute
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Use arbitrary value
    elem_handler = find_element(root, 'mdRef', 'mets')
    set_attribute(elem_handler, attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    set_attribute(elem_handler, attribute, nspace, '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace", [
    ('OTHERLOCTYPE', 'mets'),
    ('href', 'xlink'),
    ('type', 'xlink')
])
def test_mandatory_items_mdref(schematron_fx, mandatory, nspace):
    """Test mandatory attributes of mdRef

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'mdRef', 'mets')

    # Remove mandatory attribute
    del_attribute(elem_handler, mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_digiprov_object(schematron_fx):
    """PREMIS:OBJECT is allowed in digiprovMD, if it's type is representation.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:xsi="%(xsi)s"
             xmlns:fi="%(fikdk)s" xmlns:dc="%(dc)s">
               <mets:dmdSec>
                 <mets:mdWrap MDTYPE='DC' MDTYPEVERSION="1.1">
                 <mets:xmlData><dc:subject/></mets:xmlData></mets:mdWrap>
               </mets:dmdSec><mets:amdSec>
               <mets:techMD>
                 <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION="2.3">
                 <mets:xmlData>
                 <premis:object/></mets:xmlData></mets:mdWrap></mets:techMD>
               <mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION="2.3">
                 <mets:xmlData>
                   <premis:object xsi:type='premis:representation'/>
                 </mets:xmlData></mets:mdWrap></mets:digiprovMD>
               <mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT' MDTYPEVERSION="2.3">
                 <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:amdSec></mets:mets>''' % NAMESPACES
    ET.register_namespace('premis', NAMESPACES['premis'])
    (mets, root) = parse_xml_string(xml)

    # Works with premis:representation
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Fails with other values
    elem_handler = find_element(root, 'digiprovMD', 'mets')
    elem_handler = find_element(elem_handler, 'object', 'premis')
    set_attribute(elem_handler, 'type', 'xsi', 'premis:file')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    set_attribute(elem_handler, 'type', 'xsi', 'premis:bitstream')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
