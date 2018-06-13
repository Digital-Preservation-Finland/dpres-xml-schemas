"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_dmdsec.sch.

.. seealso:: mets_dmdsec.sch
"""
import pytest
from tests.common import SVRL_FAILED, parse_xml_file, \
    parse_xml_string, NAMESPACES, fix_version_17, fix_version_14

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
    elem_handler = root.find_element('dmdSec', 'mets')
    if nspaces[0] == 'fi':
        fix_version_17(root)

    # Both attributes
    elem_handler.set_attribute(attributes[0], nspaces[0], 'xxx')
    elem_handler.set_attribute(attributes[1], nspaces[1], 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[3]

    # Just the second attribute
    elem_handler.del_attribute(attributes[0], nspaces[0])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[2]

    # No attributes
    elem_handler.del_attribute(attributes[1], nspaces[1])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[0]

    # Just the first attribute
    elem_handler.set_attribute(attributes[0], nspaces[0], 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == error[1]


@pytest.mark.parametrize("mdtype, othermdtype, mdtypeversion", [
    ('MARC', None, ['marcxml=1.2;marc=marc21',
                    'marcxml=1.2;marc=finmarc']),
    ('DC', None, ['1.1']),
    ('MODS', None, ['3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                    '3.0']),
    ('EAD', None, ['2002']),
    ('EAC-CPF', None, ['2010']),
    ('LIDO', None, ['1.0']),
    ('VRA', None, ['4.0']),
    ('DDI', None, ['3.2', '3.1', '2.5.1', '2.5', '2.1']),
    ('OTHER', 'EAD3', ['1.0.0']),
    ('OTHER', 'DATACITE', ['4.1']),
])
def test_mdtype_items_dmdsec(schematron_fx, mdtype, othermdtype,
                             mdtypeversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute value
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    fix_version_14(root)
    elem_handler = root.find_element('dmdSec', 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        elem_handler.set_attribute('OTHERMDTYPE', 'mets', othermdtype)

    # Test that all MDTYPEVERSIONs work with all specifications
    for specversion in ['1.4', '1.4.1', '1.5.0', '1.6.0', '1.7.0']:
        if specversion == '1.7.0':
            fix_version_17(root)
        else:
            root.set_attribute('CATALOG', 'fikdk', specversion)
            root.set_attribute('SPECIFICATION', 'fikdk', specversion)
        for version in mdtypeversion:
            elem_handler.set_attribute('MDTYPEVERSION', 'mets', version)
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 0

    # Test unknown version
    fix_version_17(root)
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_disallowed_items_dmdsec(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element('dmdSec', 'mets')
    elem_handler.set_element('mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_special_mdtype(schematron_fx):
    """Standard portfolio's EN15744 metadata format does not have a schema.
    Therefore it is currently disallowed. Test that disallowing works.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.6.0" xmlns:mets="%(mets)s"
             xmlns:dc="%(dc)s" xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s">
               <mets:dmdSec ID="dmd-dc" fi:CREATED="2018-05-05">
                 <mets:mdWrap MDTYPE='DC'><mets:xmlData>
                 <dc:subject/></mets:xmlData></mets:mdWrap></mets:dmdSec>
               <mets:dmdSec ID="dmd-en" fi:CREATED="2018-05-05">
                 <mets:mdWrap MDTYPE='OTHER' OTHERMDTYPE='EN15744'>
                 <mets:xmlData><xxx/></mets:xmlData></mets:mdWrap>
               </mets:dmdSec><mets:amdSec>
               <mets:techMD><mets:mdWrap MDTYPE='PREMIS:OBJECT'>
                 <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
               </mets:techMD><mets:digiprovMD>
                 <mets:mdWrap MDTYPE='PREMIS:EVENT'><mets:xmlData>
                 <premis:event/></mets:xmlData></mets:mdWrap></mets:digiprovMD>
             </mets:amdSec>
             <mets:structMap><mets:div DMDID="dmd-dc dmd-en"/>
             </mets:structMap></mets:mets>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)

    # EN15744 is not allowed
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Everything works, if something else is given
    elem_handler = root.find_element('mdWrap[@MDTYPE="OTHER"]', 'mets')
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_arbitrary_attributes_dmdsec(schematron_fx):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('dmdSec', 'mets')
    for spec in [None, '1.7.0']:
        if spec == '1.7.0':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            elem_handler.set_attribute('xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            elem_handler.del_attribute('xxx', ns)


def test_missing_links_dmdsec(schematron_fx):
    """Test the case where linking missing from ADMID, DMDID and FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('div', 'mets')
    refs = elem_handler.get_attribute('DMDID', 'mets').split()
    elem_handler.set_attribute('DMDID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == len(refs)
