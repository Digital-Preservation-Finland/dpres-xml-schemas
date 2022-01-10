"""Tests for the schematron rules for PREMIS metadata, i.e for the
rules located in mets_premis_rightsmd.sch.

.. seealso:: mets_premis_rightsmd.sch
"""

import pytest
from tests.common import (SVRL_FAILED, NAMESPACES, parse_xml_string,
                          add_containers, find_element, set_element,
                          set_attribute)

SCHFILE = 'mets_premis_rightsmd.sch'


def test_disallowed_attribute_premis_rightsmd(schematron_fx):
    """Test that attributes 'authority', 'authorityURI', 'valueURI' in
    PREMIS 2.3 are disallowed in PREMIS 2.2.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:rightsMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap MDTYPE="PREMIS:RIGHTS" MDTYPEVERSION="2.3">
               <mets:xmlData><premis:rights><premis:rightsStatement/>
               </premis:rights></mets:xmlData></mets:mdWrap>
             </mets:rightsMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'rightsStatement', 'premis')
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


@pytest.mark.parametrize("nonempty", [
    ('rightsStatementIdentifierType'), ('rightsStatementIdentifierValue')
])
def test_identifier_value_rights(schematron_fx, nonempty):
    """PREMIS identifier elements can not be empty. Test that a value in the
    element is required.

    :schematron_fx: Schematron compile fixture
    :nonempty: element that requires a value
    """
    xml = '''<mets:rightsMD xmlns:mets="%(mets)s" xmlns:premis="%(premis)s">
               <mets:mdWrap iMDTYPE="PREMIS:RIGHTS" MDTYPEVERSION="2.3">
               <mets:xmlData><premis:rights><premis:rightsStatement>
                   <premis:rightsStatementIdentifier/>
               </premis:rightsStatement>
               </premis:rights></mets:xmlData></mets:mdWrap>
             </mets:rightsMD>''' % NAMESPACES
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    elem_handler = find_element(root, 'rightsStatementIdentifier', 'premis')
    elem_handler = set_element(elem_handler, nonempty, 'premis')

    # Empty identifier element fails
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary value added
    elem_handler.text = 'xxx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
