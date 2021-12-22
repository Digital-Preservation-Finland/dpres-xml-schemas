"""Tests for the schematron rules for EAD3 metadata, i.e for the
rules located in mets_ead3.sch.

.. seealso:: mets_ead3.sch
"""

import pytest
from tests.common import SVRL_FIRED, SVRL_FAILED, NAMESPACES, \
    parse_xml_string, add_containers

SCHFILE = 'mets_ead3.sch'


def prepare_xml(context_element, version):
    """The EAD3 metadata is prepared here for all the tests below.

    :context_element: Context element, where the test is done
    :version: EAD3 version to be used.
    """
    xml = '''<mets:dmdSec xmlns:mets="%(mets)s" xmlns:ead3="%(ead3)s">
               <mets:mdWrap MDTYPE="EAD3" MDTYPEVERSION="1.1.0">
               <mets:xmlData><ead3:ead/></mets:xmlData></mets:mdWrap>
             </mets:dmdSec>''' % NAMESPACES
    (ead3, root) = parse_xml_string(xml)
    (ead3, root) = add_containers(root, 'mets:mets')
    elem_handler = root.find_element('ead', 'ead3')
    if context_element is not None:
        elem_context = elem_handler.set_element(context_element, 'ead3')
    elem_version = root.find_element('mdWrap', 'mets')
    elem_version.set_attribute('MDTYPEVERSION', 'mets', version)
    return (ead3, elem_context, elem_version)


@pytest.mark.parametrize(
    "context_element, disallowedlist, version", [
        ('control', ['rightsdeclaration'], '1.1.0'),
        ('part', ['date'], '1.1.0'),
        ('quote', ['@render'], '1.1.0'),
        ('conventiondeclaration', ['@localtype'], '1.1.0')
    ])
def test_disallowed_field(
        schematron_fx, context_element, disallowedlist, version):
    """Various elements and attributes have been added to newer EAD3 version.
    Test the checks that disallow the use of new element/attribute in an old
    EAD3 version.

    :schematron_fx: Schematron compile fixture
    :context_element: Context element, which may contain new elements or
                      attributes.
    :disallowedlist: List of new elements and attributes
    :version: Earliest EAD3 version where the list apply
    """
    (ead3, elem_context, elem_version) = prepare_xml(context_element, version)
    for disallowed in disallowedlist:
        if disallowed[0] == '@':
            elem_context.set_attribute(disallowed[1:], 'ead3', 'default')
        else:
            elem_context.set_element(disallowed, 'ead3')

    # The elements/attributes are allowed in the given EAD3 version
    elem_version.set_attribute('MDTYPEVERSION', 'mets', version)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == 0

    # The elements/attributes are disallowed in the previous EAD3 version
    elem_version.set_attribute(
        'MDTYPEVERSION', 'mets', '1.0.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == len(disallowedlist)

    # No errors, if the disallowed items are removed
    elem_context.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == 0


def test_containerid_values(schematron_fx):
    """Test that containerid can have any characters in EAD3 1.1.0
    but only characters listed in xsd:NMTOKEN in EAD3 1.0.0.

    :schematron_fx: Schematron compile fixture
    """
    (ead3, elem_context, elem_version) = prepare_xml('container', '1.1.0')
    elem_context.set_attribute('containerid', 'ead3', '###')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == 0

    elem_version.set_attribute('MDTYPEVERSION', 'mets', '1.0.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == 1

    elem_context.set_attribute('containerid', 'ead3', 'abc')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=ead3)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("xml, failures", [
    ('''<ead3:objectxmlwrap xmlns:ead3="%(ead3)s">
        <ead3:xxx/></ead3:objectxmlwrap>''' % NAMESPACES, 1),
    ('''<ead3:objectxmlwrap xmlns:ead3="%(ead3)s">
        <xxx/></ead3:objectxmlwrap>''' % NAMESPACES, 0)
])
def test_ead3_extension(schematron_fx, xml, failures):
    """Test the rule which checks the content of the <objectxmlwrap> element in
       EAD3. It may contain any elements, but only outside EAD3 namespace.

    :schematron_fx: Schematron compile fixture
    :xml: XML to be validated
    :failures: Number of Schematron failures to expect
    """
    (xmltree, root) = parse_xml_string(xml)
    (xmltree, mets_root) = add_containers(
        root, 'mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/ead3:ead')
    mdwrap = mets_root.find_element('mdWrap', 'mets')
    mdwrap.set_attribute('MDTYPEVERSION', 'mets', '1.0.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=xmltree, params=False)
    assert svrl.count(SVRL_FIRED) == 1
    assert svrl.count(SVRL_FAILED) == failures

    mdwrap.set_attribute('MDTYPEVERSION', 'mets', '1.1.0')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=xmltree, params=False)
    assert svrl.count(SVRL_FIRED) == 0
