"""Tests for the schematron rules for PREMIS metadata, i.e for the
rules located in mets_premis.sch.

.. seealso:: mets_premis.sch
"""

import lxml.etree as ET
from tests.common import (SVRL_FAILED, NAMESPACES, parse_xml_string,
                          add_containers, find_element, set_element,
                          set_attribute)

SCHFILE = 'mets_premis.sch'


def test_disallowed_attribute_object(schematron_fx):
    """Test that attributes 'authority', 'authorityURI', 'valueURI' in
    PREMIS 2.3 are disallowed in PREMIS 2.2.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap MDTYPE="PREMIS:OBJECT" MDTYPEVERSION="2.3">
               <mets:xmlData><premis:object/></mets:xmlData></mets:mdWrap>
             </mets:techMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'object', 'premis')
    elem_handler = set_element(elem_handler, 'xxx', 'premis')
    for disallowed in ['authority', 'authorityURI', 'valueURI']:
        set_attribute(elem_handler, disallowed, 'premis', 'default')

    # Works in 2.3
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Disallowed in 2.2
    elem_wrap = find_element(root, 'mdWrap', 'mets')
    set_attribute(elem_wrap, 'MDTYPEVERSION', 'mets', '2.2')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 3

    # 2.2 works, if attributes removed
    elem_handler.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_linking_premis(schematron_fx):
    """Test that check of PREMIS links work. A linking element must have a
    corresponding PREMIS section. We give lniks to 8 PREMIS sections without
    the sections. Then we add the required sections one by one.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.5.0" xmlns:mets="%(mets)s"
             xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s">
             <mets:amdSec><mets:techMD><mets:mdWrap><mets:xmlData>
               <premis:object><premis:linkingEventIdentifier>
                   <premis:linkingEventIdentifierType>local
                   </premis:linkingEventIdentifierType>
                   <premis:linkingEventIdentifierValue>event-001
                   </premis:linkingEventIdentifierValue>
                 </premis:linkingEventIdentifier>
                 <premis:linkingRightsStatementIdentifier>
                   <premis:linkingRightsStatementIdentifierType>local
                   </premis:linkingRightsStatementIdentifierType>
                   <premis:linkingRightsStatementIdentifierValue>rights-001
                   </premis:linkingRightsStatementIdentifierValue>
                 </premis:linkingRightsStatementIdentifier>
             </premis:object></mets:xmlData></mets:mdWrap></mets:techMD>
             <mets:rightsMD><mets:mdWrap><mets:xmlData><premis:rights>
               <premis:rightsStatement><premis:linkingObjectIdentifier>
                   <premis:linkingObjectIdentifierType>local
                   </premis:linkingObjectIdentifierType>
                   <premis:linkingObjectIdentifierValue>object-001
                   </premis:linkingObjectIdentifierValue>
                 </premis:linkingObjectIdentifier>
                 <premis:linkingAgentIdentifier>
                   <premis:linkingAgentIdentifierType>local
                   </premis:linkingAgentIdentifierType>
                   <premis:linkingAgentIdentifierValue>agent-001
                   </premis:linkingAgentIdentifierValue>
               </premis:linkingAgentIdentifier></premis:rightsStatement>
             </premis:rights></mets:xmlData></mets:mdWrap></mets:rightsMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:event>
                 <premis:linkingAgentIdentifier>
                   <premis:linkingAgentIdentifierType>local
                   </premis:linkingAgentIdentifierType>
                   <premis:linkingAgentIdentifierValue>agent-001
                   </premis:linkingAgentIdentifierValue>
                 </premis:linkingAgentIdentifier>
                 <premis:linkingObjectIdentifier>
                   <premis:linkingObjectIdentifierType>local
                   </premis:linkingObjectIdentifierType>
                   <premis:linkingObjectIdentifierValue>object-001
                   </premis:linkingObjectIdentifierValue>
                 </premis:linkingObjectIdentifier></premis:event>
             </mets:xmlData></mets:mdWrap></mets:digiprovMD>
             <mets:digiprovMD><mets:mdWrap><mets:xmlData><premis:agent>
                 <premis:linkingEventIdentifier>
                   <premis:linkingEventIdentifierType>local
                   </premis:linkingEventIdentifierType>
                   <premis:linkingEventIdentifierValue>event-001
                   </premis:linkingEventIdentifierValue>
                 </premis:linkingEventIdentifier>
                 <premis:linkingRightsStatementIdentifier>
                   <premis:linkingRightsStatementIdentifierType>local
                   </premis:linkingRightsStatementIdentifierType>
                   <premis:linkingRightsStatementIdentifierValue>rights-001
                   </premis:linkingRightsStatementIdentifierValue>
                 </premis:linkingRightsStatementIdentifier></premis:agent>
             </mets:xmlData></mets:mdWrap></mets:digiprovMD></mets:amdSec>
             </mets:mets>''' % NAMESPACES

    (mets, root) = parse_xml_string(xml)

    # Eight dead links
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 8

    # Object section added, six dead links
    elem_handler = find_element(root, 'object', 'premis')
    xml_id = '''<premis:objectIdentifier xmlns:premis="%(premis)s">
                <premis:objectIdentifierType>local
                </premis:objectIdentifierType>
                <premis:objectIdentifierValue>object-001
                </premis:objectIdentifierValue>
                </premis:objectIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 6

    # Event section added, four dead links
    elem_handler = find_element(root, 'event', 'premis')
    xml_id = '''<premis:eventIdentifier xmlns:premis="%(premis)s">
                <premis:eventIdentifierType>local
                </premis:eventIdentifierType>
                <premis:eventIdentifierValue>event-001
                </premis:eventIdentifierValue>
                </premis:eventIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 4

    # Agent section added, two dead links
    elem_handler = find_element(root, 'agent', 'premis')
    xml_id = '''<premis:agentIdentifier xmlns:premis="%(premis)s">
                <premis:agentIdentifierType>local
                </premis:agentIdentifierType>
                <premis:agentIdentifierValue>agent-001
                </premis:agentIdentifierValue>
                </premis:agentIdentifier>''' % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # Rights section added, no dead links
    elem_handler = find_element(root, 'rightsStatement', 'premis')
    xml_id = '''<premis:rightsStatementIdentifier xmlns:premis="%(premis)s">
                <premis:rightsStatementIdentifierType>local
                </premis:rightsStatementIdentifierType>
                <premis:rightsStatementIdentifierValue>rights-001
                </premis:rightsStatementIdentifierValue>
                </premis:rightsStatementIdentifier>''' \
             % NAMESPACES
    elem_handler.insert(0, ET.fromstring(xml_id))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
