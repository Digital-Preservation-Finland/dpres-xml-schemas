"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_rightsmd.sch.

.. seealso:: mets_rightsmd.sch
"""
from tests.common import (SVRL_FAILED, parse_xml_file, fix_version_17,
                          find_element, set_element, set_attribute)

SCHFILE = 'mets_rightsmd.sch'


def test_valid_complete_rightsmd(schematron_fx):
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


def test_mdtype_items_rightsmd(schematron_fx):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'rightsMD', 'mets')
    elem_handler = find_element(elem_handler, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', 'PREMIS:RIGHTS')

    # Test that all MDTYPEVERSIONs work with all specifications
    for specversion in ['1.5.0', '1.6.0', '1.7.0', '1.7.1', '1.7.2', '1.7.3',
                        '1.7.4', '1.7.5', '1.7.6', '1.7.7']:
        if specversion in ['1.7.0', '1.7.1', '1.7.3', '1.7.4', '1.7.5',
                           '1.7.6', '1.7.7']:
            fix_version_17(root, version=specversion)
        else:
            set_attribute(root, 'CATALOG', 'fikdk', specversion)
            set_attribute(root, 'SPECIFICATION', 'fikdk', specversion)
        for version in ['2.3', '2.2']:
            set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', version)
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 0

    # Test unknown version
    fix_version_17(root)
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_disallowed_items_rightsmd(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = find_element(root, 'rightsMD', 'mets')
    set_element(elem_handler, 'mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
