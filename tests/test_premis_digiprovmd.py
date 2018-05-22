"""Tests for the schematron rules for PREMIS metadata, i.e for the
rules located in mets_premis_digiprovmd.sch.

.. seealso:: mets_premis_digiprovmd.sch
"""

import pytest
from tests.common import SVRL_FAILED, NAMESPACES, \
    parse_xml_string, add_containers

SCHFILE = 'mets_premis_digiprovmd.sch'


@pytest.mark.parametrize("premisroot, mdtype", [
    ('event', 'PREMIS:EVENT'),
    ('agent', 'PREMIS:AGENT')
])
def test_disallowed_attribute_premis_digiprov(schematron_fx, premisroot,
                                              mdtype):
    """Test that attributes 'authority', 'authorityURI', 'valueURI' in
    PREMIS 2.3 are disallowed in PREMIS 2.2.

    :schematron_fx: Schematron compile fixture
    :premisroot: Root element in PREMIS.
    :mdtype: MDTYPE value
    """
    xml = '''<mets:digiprovMD xmlns:mets="%(mets)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData/></mets:mdWrap>
             </mets:digiprovMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_wrap = root.find_element('mdWrap', 'mets')
    elem_wrap.set_attribute('MDTYPE', 'mets', mdtype)
    elem_handler = elem_wrap.find_element('xmlData', 'mets')
    elem_handler = elem_handler.set_element(premisroot, 'premis')
    elem_handler = elem_handler.set_element('xxx', 'premis')
    for disallowed in ['authority', 'authorityURI', 'valueURI']:
        elem_handler.set_attribute(disallowed, 'premis', 'default')

    # Works in 2.3
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Disallowed in 2.2
    elem_wrap.set_attribute('MDTYPEVERSION', 'mets', '2.2')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3

    # 2.2 works, if attributes removed
    elem_handler.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("premisroot, mdtype, nonempty", [
    (['event', 'eventIdentifier'], 'PREMIS:EVENT', 'eventIdentifierType'),
    (['event', 'eventIdentifier'], 'PREMIS:EVENT', 'eventIdentifierValue'),
    (['agent', 'agentIdentifier'], 'PREMIS:AGENT', 'agentIdentifierType'),
    (['agent', 'agentIdentifier'], 'PREMIS:AGENT', 'agentIdentifierValue'),
])
def test_identifier_value_premis_event_agent(
        schematron_fx, premisroot, mdtype, nonempty):
    """PREMIS identifier elements can not be empty. Test that a value in the
    element is required.

    :schematron_fx: Schematron compile fixture
    :premisroot: PREMIS root element name
    :mdtype: MDTYPE
    :nonempty: element that requires a value
    """
    xml = '''<mets:digiprovMD xmlns:mets="%(mets)s">
               <mets:mdWrap MDTYPEVERSION="2.3"><mets:xmlData/></mets:mdWrap>
             </mets:digiprovMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = root.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdtype)
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    for elem in premisroot:
        elem_handler = elem_handler.set_element(elem, 'premis')
    elem_handler = elem_handler.set_element(nonempty, 'premis')

    # Empty identifier element fails
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary value added
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
