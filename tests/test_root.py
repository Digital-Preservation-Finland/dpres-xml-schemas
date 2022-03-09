"""Tests for the schematron rules for metadata sections in METS, i.e for the
rules located in mets_mdtype.sch.

.. seealso:: mets_root.sch
"""

import pytest
from tests.common import (SVRL_FAILED, SVRL_REPORT, NAMESPACES,
                          parse_xml_file, parse_xml_string, fix_version_17,
                          find_element, find_all_elements, set_element,
                          get_attribute, set_attribute, del_attribute)

SCHFILE = 'mets_root.sch'


def test_valid_complete_root(schematron_fx):
    """Test valid METS, where all mandatory and optional METS elements and
    attributes have been used at least once.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1

    # Use new specification
    fix_version_17(root)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 0


def test_mets_root(schematron_fx):
    """Test that other root elements than METS are not allowed.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<premis:premis xmlns:premis="%(premis)s"/>''' % NAMESPACES
    (xmltree, _) = parse_xml_string(xml)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=xmltree)
    assert svrl.count(SVRL_FAILED) == 1


def test_catalogs(schematron_fx):
    """Test the Schema catalog version numbering in METS.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Conflict between fi:CATALOG and fi:SPECIFICATION
    set_attribute(root, 'CATALOG', 'fikdk', '1.5.0')
    del_attribute(root, 'CONTENTID', 'fikdk')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)

    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 1

    # Deprecated specification
    set_attribute(root, 'SPECIFICATION', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1


def test_mandatory_sections_root(schematron_fx):
    """Attributes @PROFILE and @OBJID are required. Metadata sectons are
    required: (1) mets header, (2) dmdSec with standard metadata format,
    (3) techMD, (4) digiprovMD. All of these should give one error,
    if just METS root is given.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets xmlns:mets="%(mets)s"/>''' \
          % NAMESPACES
    (mets, _) = parse_xml_string(xml)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 6


@pytest.mark.parametrize("specification, failed", [
    ('1.5.0', 2), ('1.6.0', 1), ('1.7.4', 0)
])
def test_new_mets_attributes_root(schematron_fx, specification, failed):
    """Test that CONTENTID, and CONTRACTID are
    disallowed in old catalog versions.

    :schematron_fx: Schematron compile fixture
    :specification: Specification to test
    :failed: Number of failures
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    if specification == '1.7.4':
        fix_version_17(root)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == failed
    else:
        set_attribute(root, 'CATALOG', 'fikdk', specification)
        set_attribute(root, 'SPECIFICATION', 'fikdk', specification)
        set_attribute(root, 'CONTRACTID', 'fikdk', specification)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == failed


def test_identifiers_unique(schematron_fx):
    """Test that check for PREMIS identifiers are unique works. We give 8
    PREMIS sections with same identifiers, and loop those unique one by one.
    Finally, when all are unique, no errors are expected.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:techMD><mets:mdWrap><mets:xmlData><premis:object><premis:objectIdentifier>
                 <premis:objectIdentifierType>local
                 </premis:objectIdentifierType>
                 <premis:objectIdentifierValue>xxx
                 </premis:objectIdentifierValue>
               </premis:objectIdentifier></premis:object></mets:xmlData></mets:mdWrap></mets:techMD>
             <mets:rightsMD><mets:mdWrap><mets:xmlData><premis:rights><premis:rightsStatement>
               <premis:rightsStatementIdentifier>
                 <premis:rightsStatementIdentifierType>local
                 </premis:rightsStatementIdentifierType>
                 <premis:rightsStatementIdentifierValue>xxx
                 </premis:rightsStatementIdentifierValue>
               </premis:rightsStatementIdentifier></premis:rightsStatement>
             </premis:rights></mets:xmlData></mets:mdWrap></mets:rightsMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:event><premis:eventIdentifier>
                 <premis:eventIdentifierType>local</premis:eventIdentifierType>
                 <premis:eventIdentifierValue>xxx</premis:eventIdentifierValue>
               </premis:eventIdentifier></premis:event></mets:xmlData></mets:mdWrap></mets:digiprovMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:agent><premis:agentIdentifier>
                 <premis:agentIdentifierType>local</premis:agentIdentifierType>
                 <premis:agentIdentifierValue>xxx</premis:agentIdentifierValue>
               </premis:agentIdentifier></premis:agent></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD>'''
    head = '''<mets:mets fi:CATALOG="1.5.0" xmlns:mets="%(mets)s"
               xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s"
               PROFILE="http://www.kdk.fi/kdk-mets-profile" OBJID="bbb">
              <mets:metsHdr/><mets:dmdSec/><mets:amdSec>''' \
              % NAMESPACES
    tail = '''</mets:amdSec><mets:structMap/></mets:mets>'''
    (mets, root) = parse_xml_string(head+xml+xml+tail)

    # Errors with specification 1.5.0, we fix the identifiers one by one.
    number = 0
    for idtag in ['objectIdentifierValue', 'rightsStatementIdentifierValue',
                  'eventIdentifierValue', 'agentIdentifierValue']:
        for tag in find_all_elements(root, idtag, 'premis'):
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            number = number + 1
            tag.text = 'xxx'+str(number)
            if number < 8:
                assert svrl.count(SVRL_FAILED) == 1
            else:
                assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("nspaces, attributes, version", [
    (['fikdk', 'fikdk'], ['CATALOG', 'SPECIFICATION'], "1.6.0"),
    (['fi', 'fi'], ['CATALOG', 'SPECIFICATION'], "1.7.4"),
])
def test_dependent_attributes_root(schematron_fx, nspaces, attributes,
                                   version):
    """Test attribute dependencies with another attribute. Some attributes
    become mandatory or disallowed, if another attribute is used.

    :schematron_fx: Schematron compile fixture
    :nspaces: Namespace keys of the attributes (two)
    :attributes: Dependent attributes (two)
    :version: Specification version
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'mets', 'mets')
    failed = 2
    if nspaces[0] == 'fi':
        fix_version_17(root)
        failed = 1

    # Both attributes
    set_attribute(elem_handler, attributes[0], nspaces[0], version)
    set_attribute(elem_handler, attributes[1], nspaces[1], version)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Just the second attribute
    del_attribute(elem_handler, attributes[0], nspaces[0])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # No attributes
    del_attribute(elem_handler, attributes[1], nspaces[1])
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == failed

    # Just the first attribute
    set_attribute(elem_handler, attributes[0], nspaces[0], version)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("attribute, nspace, fixed", [
    ('PROFILE', 'mets', True),
    ('OBJID', 'mets', False),
    ('CONTENTID', 'fikdk', False),
    ('CONTENTID', 'fi', False),
    ('CONTRACTID', 'fi', False)
])
def test_value_items_root(schematron_fx, attribute, nspace, fixed):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    :attribute: Attribute, where the value is required
    :nspace: Namespace key of the attribute
    :fixed: Boolean, if the required value is fixed
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    if nspace == 'fi':
        fix_version_17(root)

    # Use arbitrary value
    elem_handler = find_element(root, 'mets', 'mets')
    set_attribute(elem_handler, attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if fixed:
        assert svrl.count(SVRL_FAILED) == 1
    else:
        assert svrl.count(SVRL_FAILED) == 0

    # Use empty value
    set_attribute(elem_handler, attribute, nspace, '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace", [
    ('OBJID', 'mets'),
    ('PROFILE', 'mets'),
    ('CONTRACTID', 'fi')
])
def test_mandatory_items_root(schematron_fx, mandatory, nspace):
    """

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    if nspace == 'fi':
        fix_version_17(root)
    elem_handler = find_element(root, 'mets', 'mets')

    # Remove mandatory attribute
    del_attribute(elem_handler, mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("disallowed", [
    ('behaviorSec'),
    ('structLink'),
    ('amdSec')
])
def test_disallowed_items_root(schematron_fx, disallowed):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    :disallowed: Disallowed element or attribute, use '@' for attributes.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = find_element(root, 'mets', 'mets')
    set_element(elem_handler, disallowed, 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_objid_unique(schematron_fx):
    """Check that error is given, if OBJID is not unique with METS IDs,
    except for CONTENTID that can be identical to OBJID.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    objid = get_attribute(root, 'OBJID', 'mets')
    contentid = get_attribute(root, 'CONTENTID', 'fikdk')
    set_attribute(root, 'CONTENTID', 'fikdk', objid)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    set_attribute(root, 'CONTENTID', 'fikdk', contentid)
    elem_handler = find_element(root, 'dmdSec', 'mets')
    section_id = get_attribute(elem_handler, 'ID', 'mets')
    set_attribute(root, 'OBJID', 'mets', section_id)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    set_attribute(root, 'OBJID', 'mets', objid)
    fix_version_17(root)
    set_attribute(root, 'CONTRACTID', 'fi', objid)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_arbitrary_attributes_root(schematron_fx):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = find_element(root, 'mets', 'mets')
    for spec in [None, '1.7.4']:
        if spec == '1.7.4':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            set_attribute(elem_handler, 'xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            del_attribute(elem_handler, 'xxx', ns)
