"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_internal.sch.

.. seealso:: mets_internal.sch
"""
import xml.etree.ElementTree as ET
import pytest
from tests.common import SVRL_FAILED, SVRL_REPORT, parse_xml_file, \
    parse_xml_string, NAMESPACES, fix_version_17

SCHFILE = 'mets_internal.sch'


def fix_version_14(root):
    """PID needs to be removed from structMap and CONTENTID from root for
    catalog version 1.4 to make the tree valid. This is used in various
    tests below.

    :root: METS root element
    """
    elem_handler = root.find_element('structMap', 'mets')
    elem_handler.del_attribute('PID', 'fikdk')
    elem_handler.del_attribute('PIDTYPE', 'fikdk')
    root.del_attribute('CONTENTID', 'fikdk')


def test_valid_overall_mets(schematron_fx):
    """Test valid METS, where all mandatory and optional METS elements and
    attributes have been used at least once.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
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
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    fix_version_14(root)

    # Conflict between fi:CATALOG and fi:SPECIFICATION
    root.set_attribute('CATALOG', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1
    assert svrl.count(SVRL_REPORT) == 1

    # Old specification
    root.set_attribute('SPECIFICATION', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1


def test_fileid(schematron_fx):
    """Test that FILEID is allowed in fptr or area, but disallowed, if missing.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')

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

    # FILEID missing
    elem_handler_area.del_attribute('FILEID', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("specification, failed", [
    ('1.4', 4), ('1.5.0', 2), ('1.6.0', 1), ('1.7.0', 0)
])
def test_new_mets_elements_attributes(schematron_fx, specification, failed):
    """Test that PID in structMap, CONTENTID, CONTRACTID and streams are
    disallowed in old catalog versions.

    :schematron_fx: Schematron compile fixture
    :specification: Specification to test
    :failed: Number of failures
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    if specification == '1.7.0':
        fix_version_17(root)
    else:
        root.set_attribute('CATALOG', 'fikdk', specification)
        root.set_attribute('SPECIFICATION', 'fikdk', specification)
        root.set_attribute('CONTRACTID', 'fikdk', specification)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == failed

    if specification != '1.7.0':
        root.del_attribute('CONTRACTID', 'fikdk')
    elem_handler = root.find_element('file', 'mets')
    elem_handler.set_element('stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)

    if specification == '1.6.0':
        assert svrl.count(SVRL_FAILED) == failed - 1
    else:
        assert svrl.count(SVRL_FAILED) == failed

    elem_handler.del_element('stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if specification == '1.7.0':
        assert svrl.count(SVRL_FAILED) == failed
    else:
        assert svrl.count(SVRL_FAILED) == failed - 1


def test_textmd(schematron_fx):
    """Test that TEXTMD is still allowed.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    fix_version_14(root)
    elem_handler = root.find_element('techMD', 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', 'TEXTMD')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_metsrights(schematron_fx):
    """Test that METSRIGHTS in MDTYPE is allowed only in 1.4.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    fix_version_14(root)

    # Add METSRIGHTS to current specification.
    elem_handler = root.find_element('rightsMD', 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', 'METSRIGHTS')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Change version to 1.4
    root.set_attribute('CATALOG', 'fikdk', '1.4')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("context, nspaces, attributes, error", [
    ('mets', ['fikdk', 'fikdk'], ['CATALOG', 'SPECIFICATION'], [1, 0, 0, 0]),
    ('mets', ['fi', 'fi'], ['CATALOG', 'SPECIFICATION'], [1, 0, 0, 0]),
    ('dmdSec', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('techMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('rightsMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('sourceMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('digiprovMD', ['fikdk', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('dmdSec', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('techMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('rightsMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('sourceMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('digiprovMD', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('structMap', ['fikdk', 'fikdk'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('dmdSec', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('techMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('rightsMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('sourceMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('digiprovMD', ['fi', 'mets'], ['CREATED', 'CREATED'], [1, 0, 0, 1]),
    ('dmdSec', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('techMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('rightsMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('sourceMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('digiprovMD', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('structMap', ['fi', 'fi'], ['PID', 'PIDTYPE'], [0, 1, 1, 0]),
    ('mdWrap', ['mets', 'mets'], ['CHECKSUM', 'CHECKSUMTYPE'], [0, 1, 1, 0]),
    ('mdRef', ['mets', 'mets'], ['CHECKSUM', 'CHECKSUMTYPE'], [0, 1, 1, 0]),
    ('file', ['mets', 'mets'], ['CHECKSUM', 'CHECKSUMTYPE'], [0, 1, 1, 0])
])
def test_dependent_attributes(schematron_fx, context, nspaces, attributes,
                              error):
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
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    elem_handler = root.find_element(context, 'mets')
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


@pytest.mark.parametrize("context", [
    ('dmdSec'), ('techMD'), ('sourceMD'), ('rightsMD'), ('digiprovMD')
])
def test_othermdtype(schematron_fx, context):
    """Test that OTHERMDTYPE and the version are mandatory, but can be anything
    in all METS sections, if MDTYPE is OTHER.

    :schematron_fx: Schematron compile fixture
    :context: METS section to be tested
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    fix_version_14(root)

    # OTHERMDTYPE and version can be anything
    elem_handler = root.find_element(context, 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', 'OTHER')
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Version is mandatory
    elem_handler.del_attribute('MDTYPEVERSION', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Version is not mandatory in 1.4
    root.set_attribute('CATALOG', 'fikdk', '1.4')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.4')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # OTHERMDTYPE is mandatory in 1.4
    elem_handler.del_attribute('OTHERMDTYPE', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # OTHERMDTYPE is (still) missing
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    root.set_attribute('CATALOG', 'fikdk', '1.5.0')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.5.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("context, mdtype, othermdtype, mdtypeversion", [
    ('dmdSec', 'MARC', None, ['marcxml=1.2;marc=marc21',
                              'marcxml=1.2;marc=finmarc']),
    ('dmdSec', 'DC', None, ['1.1']),
    ('dmdSec', 'MODS', None, ['3.6', '3.5', '3.4', '3.3', '3.2', '3.1',
                              '3.0']),
    ('dmdSec', 'EAD', None, ['2002']),
    ('dmdSec', 'EAC-CPF', None, ['2010']),
    ('dmdSec', 'LIDO', None, ['1.0']),
    ('dmdSec', 'VRA', None, ['4.0']),
    ('dmdSec', 'DDI', None, ['3.2', '3.1', '2.5.1', '2.5', '2.1']),
    ('dmdSec', 'OTHER', 'EAD3', ['1.0.0']),
    ('dmdSec', 'OTHER', 'DATACITE', ['4.0']),
    ('techMD', 'NISOIMG', None, ['2.0']),
    ('techMD', 'PREMIS:OBJECT', None, ['2.3', '2.2']),
    ('techMD', 'OTHER', 'AudioMD', ['2.0']),
    ('techMD', 'OTHER', 'VideoMD', ['2.0']),
    ('techMD', 'OTHER', 'ADDML', ['8.2', '8.3']),
    ('rightsMD', 'PREMIS:RIGHTS', None, ['2.3', '2.2']),
    ('digiprovMD', 'PREMIS:EVENT', None, ['2.3', '2.2']),
    ('digiprovMD', 'PREMIS:AGENT', None, ['2.3', '2.2'])
])
def test_mdtype_items(schematron_fx, context, mdtype, othermdtype,
                      mdtypeversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :context: METS section to be tested
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute value
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    fix_version_14(root)
    elem_handler = root.find_element(context, 'mets')
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

    # Test that unknown OTHERMDTYPE gives error, if MDTYPE is not 'OTHER'
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', mdtypeversion[0])
    elem_handler.set_attribute('OTHERMDTYPE', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if mdtype == 'OTHER':
        assert svrl.count(SVRL_FAILED) == 0
    else:
        assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("attribute, nspace, context, fixed", [
    ('PROFILE', 'mets', 'mets', True),
    ('RECORDSTATUS', 'mets', 'metsHdr', True),
    ('LOCTYPE', 'mets', 'mdRef', True),
    ('LOCTYPE', 'mets', 'FLocat', True),
    ('LOCTYPE', 'mets', 'mptr', True),
    ('OTHERLOCTYPE', 'mets', 'mdRef', True),
    ('type', 'xlink', 'mdRef', True),
    ('type', 'xlink', 'FLocat', True),
    ('type', 'xlink', 'mptr', True),
    ('MDTYPE', 'mets', 'mdRef', True),
    ('OTHERMDTYPE', 'mets', 'mdRef', True),
    ('OBJID', 'mets', 'mets', False),
    ('CONTENTID', 'fikdk', 'mets', False),
    ('CONTENTID', 'fi', 'mets', False),
    ('CONTRACTID', 'fi', 'mets', False)
])
def test_value_items(schematron_fx, attribute, nspace, context, fixed):
    """Test that a value is required in a certain attributes.

    :schematron_fx: Schematron compile fixture
    :attribute: Attribute, where the value is required
    :nspace: Namespace key of the attribute
    :context: Element where the attribute exists
    :fixed: Boolean, if the required value is fixed
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    if nspace == 'fi':
        fix_version_17(root)

    # Use arbitrary value
    elem_handler = root.find_element(context, 'mets')
    elem_handler.set_attribute(attribute, nspace, 'aaa')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    if fixed:
        assert svrl.count(SVRL_FAILED) == 1
    else:
        assert svrl.count(SVRL_FAILED) == 0

    # Use empty value
    elem_handler.set_attribute(attribute, nspace, '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("mandatory, nspace, context", [
    ('OBJID', 'mets', 'mets'),
    ('PROFILE', 'mets', 'mets'),
    ('CONTRACTID', 'fi', 'mets'),
    ('CREATEDATE', 'mets', 'metsHdr'),
    ('ROLE', 'mets', 'agent'),
    ('TYPE', 'mets', 'agent'),
    ('MDTYPEVERSION', 'mets', 'mdWrap'),
    ('OTHERLOCTYPE', 'mets', 'mdRef'),
    ('href', 'xlink', 'mdRef'),
    ('href', 'xlink', 'FLocat'),
    ('href', 'xlink', 'mptr'),
    ('type', 'xlink', 'mdRef'),
    ('type', 'xlink', 'FLocat'),
    ('type', 'xlink', 'mptr'),
    ('ADMID', 'mets', 'file'),
    ('TYPE', 'mets', 'div')
])
def test_mandatory_items(schematron_fx, mandatory, nspace, context):
    """

    :schematron_fx: Schematron compile fixture
    :mandatory: Mandatory attribute
    :nspace: Namespace key of the mandatory attribute
    :context: Element, where the attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    if nspace == 'fi':
        fix_version_17(root)
    elem_handler = root.find_element(context, 'mets')

    # Missing ADMID or missing attribute in agent gives more than one error
    extra = 0
    if mandatory == 'ADMID':
        extra = len(elem_handler.get(mandatory).split())
    if context == 'agent':
        extra = 1

    # Remove mandatory attribute
    elem_handler.del_attribute(mandatory, nspace)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1 + extra


@pytest.mark.parametrize("disallowed, context", [
    ('behaviorSec', 'mets'),
    ('structLink', 'mets'),
    ('altRecordID', 'metsHdr'),
    ('mdRef', 'dmdSec'),
    ('mdRef', 'techMD'),
    ('mdRef', 'rightsMD'),
    ('mdRef', 'sourceMD'),
    ('FContent', 'file'),
    ('file', 'file'),
    ('transformFile', 'file'),
    ('@OTHERLOCTYPE', 'FLocat'),
    ('@OTHERLOCTYPE', 'mptr'),
    ('div', 'structMap'),
    ('amdSec', 'mets')
])
def test_disallowed_items(schematron_fx, disallowed, context):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    :disallowed: Disallowed element or attribute, use '@' for attributes.
    :context: Context element, where the attribute or element exists
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element(context, 'mets')
    if disallowed[0] == '@':
        elem_handler.set_attribute(disallowed[1:], 'mets', 'default')
    else:
        elem_handler.set_element(disallowed, 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("reference, context", [
    ('ADMID', 'file'), ('ADMID', 'div'), ('DMDID', 'div'), ('FILEID', 'fptr')
])
def test_missing_links(schematron_fx, reference, context):
    """Test the case where linking missing from ADMID, DMDID and FILEID to
    corresponding METS sections.

    :schematron_fx: Schematron compile fixture
    :reference: Reference attribute ADMID, DMDID or FILEID
    :context: Element, where the reference attribute exists
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    elem_handler = root.find_element(context, 'mets')
    refs = elem_handler.get_attribute(reference, 'mets').split()
    elem_handler.set_attribute(reference, 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == len(refs)


@pytest.mark.parametrize("context", [
    ('dmdSec'), ('techMD'), ('sourceMD'), ('rightsMD'), ('digiprovMD'),
    ('file')
])
def test_missing_ids(schematron_fx, context):
    """Test the case where sections are missing for ADMID, DMDID and FILEID
    links.

    :schematron_fx: Schematron compile fixture
    :context: Section to be removed.
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    elem_handler = root.find_element(context, 'mets')
    # We actually just remove the link
    elem_handler.set_attribute('ID', 'mets', '')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2


def test_objid_unique(schematron_fx):
    """Check that error is given, if OBJID is not unique with METS IDs.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    objid = root.get_attribute('OBJID', 'mets')
    contentid = root.get_attribute('CONTENTID', 'fikdk')
    root.set_attribute('CONTENTID', 'fikdk', objid)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    root.set_attribute('CONTENTID', 'fikdk', contentid)
    elem_handler = root.find_element('dmdSec', 'mets')
    section_id = elem_handler.get_attribute('ID', 'mets')
    root.set_attribute('OBJID', 'mets', section_id)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    root.set_attribute('OBJID', 'mets', objid)
    fix_version_17(root)
    root.set_attribute('CONTRACTID', 'fi', objid)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("context", [
    ('mets'), ('dmdSec'), ('techMD'), ('sourceMD'), ('rightsMD'),
    ('digiprovMD'), ('amdSec'), ('metsHdr'), ('fileSec'), 
    ('fileGrp'), ('file'), ('structMap'), ('fptr')
])
def test_arbitrary_attributes(schematron_fx, context):
    """Test that arbitrary attributes are forbidden in METS anyAttribute
       sections.
    """
    (mets, root) = parse_xml_file('mets_valid_overall_mets.xml')
    elem_handler = root.find_element(context, 'mets')
    for spec in [None, '1.7.0']:
        if spec == '1.7.0':
            fix_version_17(root)
        for ns in ['fi', 'fikdk', 'dc']:
            elem_handler.set_attribute('xxx', ns, 'xxx')
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 1
            elem_handler.del_attribute('xxx', ns)
