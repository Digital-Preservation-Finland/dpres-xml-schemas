"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_structmap.sch.

.. seealso:: mets_structmap.sch
"""
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file, fix_version_17,
                          find_element, set_element, del_element,
                          get_attribute, set_attribute, del_attribute)

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
    elem_handler = find_element(root, 'fptr', 'mets')
    elem_handler_area = set_element(elem_handler, 'area', 'mets')
    set_attribute(elem_handler_area, 'FILEID', 'mets',
                  get_attribute(elem_handler, 'FILEID', 'mets'))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # FILEID only in area
    del_attribute(elem_handler, 'FILEID', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Also area missing
    del_element(elem_handler, 'area', 'mets')
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
    elem_handler = find_element(root, 'structMap', 'mets')
    if nspace == 'fi':
        fix_version_17(root)

    # Both attributes
    set_attribute(elem_handler, 'PID', nspace, 'xxx')
    set_attribute(elem_handler, 'PIDTYPE', nspace, 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the second attribute
    del_attribute(elem_handler, 'PID', nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # No attributes
    del_attribute(elem_handler, 'PIDTYPE', nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the first attribute
    set_attribute(elem_handler, 'PID', nspace, 'xxx')
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
    elem_handler = find_element(root, 'mptr', 'mets')
    set_attribute(elem_handler, attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    set_attribute(elem_handler, attribute, nspace, '')
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
    elem_handler = find_element(root, context, 'mets')

    # Remove mandatory attribute
    del_attribute(elem_handler, mandatory, nspace)
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
    elem_handler = find_element(root, context, 'mets')
    if disallowed[0] == '@':
        set_attribute(elem_handler, disallowed[1:], 'mets', 'default')
    else:
        set_element(elem_handler, disallowed, 'mets')
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
    elem_handler = find_element(root, context, 'mets')
    for spec in [None, '1.7.0']:
        if spec == '1.7.0':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)


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
    elem_handler = find_element(root, context, 'mets')
    # We actually just remove the id
    set_attribute(elem_handler, 'ID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
