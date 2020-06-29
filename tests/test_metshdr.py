"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_metshdr.sch.

.. seealso:: mets_metshdr.sch
"""
import pytest
from tests.common import SVRL_FAILED, parse_xml_file, fix_version_17

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
    hdr = root.find_element('metsHdr', 'mets')

    hdr.set_attribute('RECORDSTATUS', 'mets', 'update')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    hdr.set_attribute('RECORDSTATUS', 'mets', 'dissemination')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    agent = hdr.find_element('name', 'mets')
    agent.text = 'CSC - IT Center for Science Ltd.'

    hdr.set_attribute('RECORDSTATUS', 'mets', 'submission')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    hdr.set_attribute('RECORDSTATUS', 'mets', 'update')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    hdr.set_attribute('RECORDSTATUS', 'mets', 'dissemination')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_value_items_metshdr(schematron_fx):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Use arbitrary value
    elem_handler = root.find_element('metsHdr', 'mets')
    elem_handler.set_attribute('RECORDSTATUS', 'mets', 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Use empty value
    elem_handler.set_attribute('RECORDSTATUS', 'mets', '')
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
    elem_handler = root.find_element(context, 'mets')

    # Missing attribute in agent gives more than one error
    extra = 0
    if context == 'agent':
        extra = 1

    # Remove mandatory attribute
    elem_handler.del_attribute(mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1 + extra


def test_disallowed_items_metshdr(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element('metsHdr', 'mets')
    elem_handler.set_element('altRecordID', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_arbitrary_attributes_metshdr(schematron_fx):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('metsHdr', 'mets')
    for spec in [None, '1.7.2']:
        if spec == '1.7.2':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            elem_handler.set_attribute('xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            elem_handler.del_attribute('xxx', ns)


def test_mandatory_agents(schematron_fx):
    """Test that mandatory agents work.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('agent', 'mets')

    elem_handler.set_attribute('ROLE', 'mets', 'CREATOR')
    elem_handler.set_attribute('TYPE', 'mets', 'OTHER')
    elem_handler.set_attribute('OTHERTYPE', 'mets', 'SOFTWARE')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    fix_version_17(root)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

