"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_structmap.sch.

.. seealso:: mets_structmap.sch
"""
import pytest
from tests.common import SVRL_FAILED, parse_xml_file, fix_version_17

SCHFILE = 'mets_structmap.sch'


def test_valid_complete_structmap(schematron_fx):
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


def test_fileid(schematron_fx):
    """Test that FILEID is allowed in fptr or area, but disallowed,
    if missing.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # FILEID in fptr and area
    elem_handler = root.find_element('fptr', 'mets')
    elem_handler_area = elem_handler.set_element('area', 'mets')
    elem_handler_area.set_attribute(
        'FILEID', 'mets', elem_handler.get_attribute('FILEID', 'mets'))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # FILEID only in area
    elem_handler.del_attribute('FILEID', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Also area missing
    elem_handler.del_element('area', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("nspace", [
    ('fikdk'), ('fi')
])
def test_dependent_attributes_structmap(schematron_fx, nspace):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    :nspace: Namespace key of the attributes
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('structMap', 'mets')
    if nspace == 'fi':
        fix_version_17(root)

    # Both attributes
    elem_handler.set_attribute('PID', nspace, 'xxx')
    elem_handler.set_attribute('PIDTYPE', nspace, 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the second attribute
    elem_handler.del_attribute('PID', nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # No attributes
    elem_handler.del_attribute('PIDTYPE', nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the first attribute
    elem_handler.set_attribute('PID', nspace, 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("attribute, nspace", [
    ('LOCTYPE', 'mets'),
    ('type', 'xlink')
])
def test_value_items_structmap(schematron_fx, attribute, nspace):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    :attribute: Attribute, where the value is required
    :nspace: Namespace key of the attribute
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Use arbitrary value
    elem_handler = root.find_element('mptr', 'mets')
    elem_handler.set_attribute(attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    elem_handler.set_attribute(attribute, nspace, '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace, context", [
    ('href', 'xlink', 'mptr'),
    ('type', 'xlink', 'mptr'),
    ('TYPE', 'mets', 'div')
])
def test_mandatory_items_structmap(schematron_fx, mandatory, nspace, context):
    """Test mandatory attributes

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    :context: Element, where the attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element(context, 'mets')

    # Remove mandatory attribute
    elem_handler.del_attribute(mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("disallowed, context", [
    ('@OTHERLOCTYPE', 'mptr'),
    ('div', 'structMap')
])
def test_disallowed_items_structmap(schematron_fx, disallowed, context):
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
    ('structMap'), ('fptr')
])
def test_arbitrary_attributes_structmap(schematron_fx, context):
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


@pytest.mark.parametrize("context", [
    ('dmdSec'), ('rightsMD'), ('file')
])
def test_missing_ids_structmap(schematron_fx, context):
    """Test the case where sections are missing for ADMID, DMDID and FILEID
    links.

    :schematron_fx: Schematron compile fixture
    :context: Section to be removed.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element(context, 'mets')
    # We actually just remove the id
    elem_handler.set_attribute('ID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
