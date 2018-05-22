"""Tests for the schematron rules for EAD3 metadata, i.e for the
rules located in mets_ead3.sch.

.. seealso:: mets_ead3.sch
"""

import pytest
from tests.common import SVRL_FIRED, SVRL_FAILED, NAMESPACES, \
    parse_xml_string, add_containers

SCHFILE = 'mets_ead3.sch'


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
    (xmltree, _) = add_containers(
        root, 'mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/ead3:ead')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=xmltree)
    assert svrl.count(SVRL_FIRED) == 1
    assert svrl.count(SVRL_FAILED) == failures
