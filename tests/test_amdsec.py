"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_amdsec.sch.

.. seealso:: mets_amdsec.sch
"""
import pytest
from tests.common import (SVRL_FAILED, parse_xml_file, fix_version_17,
                          find_element, set_attribute, get_attribute,
                          del_attribute)

SCHFILE = 'mets_amdsec.sch'


def test_valid_complete_amdsec(schematron_fx):
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


@pytest.mark.parametrize("context, nspaces, attributes, error", [
    ('techMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('rightsMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('sourceMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('digiprovMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('techMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('rightsMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('sourceMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('digiprovMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('techMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('rightsMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('sourceMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('digiprovMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('techMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('rightsMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('sourceMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('digiprovMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
])
def test_dependent_attributes_amdsec(schematron_fx, context, nspaces,
                                     attributes, error):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    :context: Element where the attributes exist
    :nspaces: Namespace keys of the attributes (two)
    :attributes: Dependent attributes (two)
    :error: The error table [a, b, c, d] where the values are the number of
            expected errors. (a) both attributes missing, (b) first exists,
            (c) second exists, (d) both exist.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, context, 'mets')
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


@pytest.mark.parametrize("context", [
    ('techMD'), ('sourceMD'), ('rightsMD'), ('digiprovMD'), ('amdSec')
])
def test_arbitrary_attributes_amdsec(schematron_fx, context):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.

    :schematron_fx: Schematron compile fixture
    :context: Element to be checked
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, context, 'mets')
    for spec in [None, '1.7.6']:
        if spec == '1.7.6':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)


@pytest.mark.parametrize("context", [
    ('file'), ('div')
])
def test_missing_links_admid(schematron_fx, context):
    """Test the case where linking missing from ADMID, DMDID and FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    :context: Element, where the reference attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, context, 'mets')
    refs = get_attribute(elem_handler, 'ADMID', 'mets').split()
    set_attribute(elem_handler, 'ADMID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == len(refs)
