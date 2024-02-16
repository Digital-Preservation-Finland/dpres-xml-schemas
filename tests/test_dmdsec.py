"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_dmdsec.sch.

.. seealso:: mets_dmdsec.sch
"""
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file,
                          parse_xml_string, NAMESPACES, fix_version_17,
                          find_element, set_element, set_attribute,
                          del_attribute, get_attribute)

SCHFILE = 'mets_dmdsec.sch'


def test_valid_complete_dmdsec(schematron_fx):
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


@pytest.mark.parametrize("nspaces, attributes, error", [
    (['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    (['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    (['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    (['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
])
def test_dependent_attributes_dmdsec(schematron_fx, nspaces, attributes,
                                     error):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    :nspaces: Namespace keys of the attributes (two)
    :attributes: Dependent attributes (two)
    :error: The error table [a, b, c, d] where the values are the number of
            expected errors. (a) both attributes missing, (b) first exists,
            (c) second exists, (d) both exist.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'dmdSec', 'mets')
    if nspaces[0] == 'fi':
        fix_version_17(root)

    # Both attributes
    set_attribute(elem_handler, attributes[0], nspaces[0], 'xxx')
    set_attribute(elem_handler, attributes[1], nspaces[1], 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[3]

    # Just the second attribute
    del_attribute(elem_handler, attributes[0], nspaces[0])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[2]

    # No attributes
    del_attribute(elem_handler, attributes[1], nspaces[1])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[0]

    # Just the first attribute
    set_attribute(elem_handler, attributes[0], nspaces[0], 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[1]


@pytest.mark.parametrize("mdtype, othermdtype, mdtypeversion, specversion", [
    ('MARC', None, ['marcxml=1.2;marc=marc21'], ['1.7.3', '1.7.4', '1.7.5',
                                                 '1.7.6']),
    ('MARC', None, ['marcxml=1.2;marc=marc21', 'marcxml=1.2;marc=finmarc'],
     ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1', '1.7.2']),
    ('DC', None, ['1.1', '2008'], ['1.7.2', '1.7.3', '1.7.4', '1.7.5',
                                   '1.7.6']),
    ('DC', None, ['1.1'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1']),
    ('MODS', None, ['3.8', '3.7', '3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                    '3.0'], ['1.7.6']),
    ('MODS', None, ['3.7', '3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                    '3.0'], ['1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5']),
    ('MODS', None, ['3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                    '3.0'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0']),
    ('EAD', None, ['2002'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1',
                             '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6']),
    ('EAC-CPF', None, ['2.0', '2010_revised'], ['1.7.5', '1.7.6']),
    ('EAC-CPF', None, ['2010_revised'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0',
                                         '1.7.1', '1.7.2', '1.7.3', '1.7.4']),
    ('LIDO', None, ['1.1', '1.0'], ['1.7.6']),
    ('LIDO', None, ['1.0'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1',
                             '1.7.2', '1.7.3', '1.7.4', '1.7.5']),
    ('VRA', None, ['4.0'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1',
                            '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6']),
    ('DDI', None, ['3.3', '3.2', '3.1', '2.5.1', '2.5', '2.1'],
     ['1.7.3', '1.7.4', '1.7.5', '1.7.6']),
    ('DDI', None, ['3.2', '3.1', '2.5.1', '2.5', '2.1'],
     ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1', '1.7.2']),
    ('OTHER', 'EAD3', ['1.1.1', '1.1.0', '1.0.0'],
     ['1.7.3', '1.7.4', '1.7.5', '1.7.6']),
    ('OTHER', 'EAD3', ['1.1.0', '1.0.0'], ['1.7.1', '1.7.2']),
    ('OTHER', 'EAD3', ['1.0.0'], ['1.5.0', '1.6.0', '1.6.1', '1.7.0']),
    ('OTHER', 'DATACITE', ['4.4', '4.3', '4.2', '4.1'], ['1.7.4', '1.7.5',
                                                         '1.7.6']),
    ('OTHER', 'DATACITE', ['4.3', '4.2', '4.1'], ['1.7.2', '1.7.3']),
    ('OTHER', 'DATACITE', ['4.1'],
     ['1.5.0', '1.6.0', '1.6.1', '1.7.0', '1.7.1']),
    ('OTHER', 'EBUCORE', ['1.10'], ['1.7.3', '1.7.4', '1.7.5', '1.7.6'])
])
def test_mdtype_items_dmdsec(schematron_fx, mdtype, othermdtype,
                             mdtypeversion, specversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute values
    :specversion: Specification versions
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'dmdSec', 'mets')
    elem_handler = find_element(elem_handler, 'mdWrap', 'mets')
    set_attribute(elem_handler, 'MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        set_attribute(elem_handler, 'OTHERMDTYPE', 'mets', othermdtype)

    # Test that all MDTYPEVERSIONs work with all specifications
    for sversion in specversion:
        if sversion in ['1.7.0', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5',
                        '1.7.6']:
            fix_version_17(root)
        else:
            set_attribute(root, 'CATALOG', 'fikdk', sversion)
            set_attribute(root, 'SPECIFICATION', 'fikdk', sversion)
        for version in mdtypeversion:
            set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', version)
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 0

    # Test unknown version
    fix_version_17(root)
    set_attribute(elem_handler, 'MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_disallowed_items_dmdsec(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = find_element(root, 'dmdSec', 'mets')
    set_element(elem_handler, 'mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_arbitrary_attributes_dmdsec(schematron_fx):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'dmdSec', 'mets')
    for spec in [None, '1.7.6']:
        if spec == '1.7.6':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)


def test_missing_links_dmdsec(schematron_fx):
    """Test the case where linking missing from ADMID, DMDID and FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'div', 'mets')
    refs = get_attribute(elem_handler, 'DMDID', 'mets').split()
    set_attribute(elem_handler, 'DMDID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == len(refs)
