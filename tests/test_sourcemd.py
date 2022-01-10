"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_sourcemd.sch.

.. seealso:: mets_sourcemd.sch
"""
from tests.common import (SVRL_FAILED, parse_xml_file, fix_version_17,
                          find_element, set_element)

SCHFILE = 'mets_sourcemd.sch'


def test_valid_complete_sourcemd(schematron_fx):
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


def test_disallowed_items_sourcemd(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = find_element(root, 'sourceMD', 'mets')
    set_element(elem_handler, 'mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
