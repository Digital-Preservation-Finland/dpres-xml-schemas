"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_metshdr.sch.

.. seealso:: mets_metshdr.sch
"""
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file, fix_version_17,
                          find_element, set_element, set_attribute,
                          del_attribute)

SCHFILE = 'mets_metshdr.sch'


def test_valid_complete_metshdr(schematron_fx):
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


def test_recordstatus(schematron_fx):
    """Test that RECORDSTATUS can always be 'submission',
    and also 'update' and 'dissemination' for CSC.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    hdr = find_element(root, 'metsHdr', 'mets')

    set_attribute(hdr, 'RECORDSTATUS', 'mets', 'update')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    set_attribute(hdr, 'RECORDSTATUS', 'mets', 'dissemination')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    agent = find_element(hdr, 'name', 'mets')
    agent.text = 'CSC - IT Center for Science Ltd.'

    set_attribute(hdr, 'RECORDSTATUS', 'mets', 'submission')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    set_attribute(hdr, 'RECORDSTATUS', 'mets', 'update')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    set_attribute(hdr, 'RECORDSTATUS', 'mets', 'dissemination')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_value_items_metshdr(schematron_fx):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Use arbitrary value
    elem_handler = find_element(root, 'metsHdr', 'mets')
    set_attribute(elem_handler, 'RECORDSTATUS', 'mets', 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    set_attribute(elem_handler, 'RECORDSTATUS', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace, context", [
    ('CREATEDATE', 'mets', 'metsHdr'),
    ('ROLE', 'mets', 'agent'),
    ('TYPE', 'mets', 'agent'),
])
def test_mandatory_items_metshdr(schematron_fx, mandatory, nspace, context):
    """

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    :context: Element, where the attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, context, 'mets')

    # Missing attribute in agent gives more than one error
    extra = 0
    if context == 'agent':
        extra = 1

    # Remove mandatory attribute
    del_attribute(elem_handler, mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1 + extra


def test_disallowed_items_metshdr(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = find_element(root, 'metsHdr', 'mets')
    set_element(elem_handler, 'altRecordID', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_arbitrary_attributes_metshdr(schematron_fx):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'metsHdr', 'mets')
    for spec in [None, '1.7.6']:
        if spec == '1.7.6':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)


def test_mandatory_agents(schematron_fx):
    """Test that mandatory agents work.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'agent', 'mets')

    set_attribute(elem_handler, 'ROLE', 'mets', 'CREATOR')
    set_attribute(elem_handler, 'TYPE', 'mets', 'OTHER')
    set_attribute(elem_handler, 'OTHERTYPE', 'mets', 'SOFTWARE')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    fix_version_17(root)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
