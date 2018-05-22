"""Tests for the schematron rules for ADDML metadata, i.e for the
rules located in mets_addml.sch.

.. seealso:: mets_addml.sch
"""

from tests.common import SVRL_FIRED, SVRL_FAILED, NAMESPACES, \
    parse_xml_string, add_containers

SCHFILE = 'mets_addml.sch'

METS_HEAD = '''<mets:techMD xmlns:mets="%(mets)s" xmlns:addml="%(addml)s">
               <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="ADDML"
               MDTYPEVERSION="8.2">
               <mets:xmlData>''' % NAMESPACES
METS_TAIL = '''</mets:xmlData></mets:mdWrap></mets:techMD>'''


def test_addml_reference_version(schematron_fx):
    """Test element 'reference' with ADDML versions 8.2 and 8.3. It is required
    only in 8.2.

    :schematron_fx: Schematron compile fixture
    """
    xml = METS_HEAD+'''<addml:addml><addml:dataset/></addml:addml>'''+METS_TAIL

    # Element 'reference' is required in 8.2, but missing
    (mets, root) = parse_xml_string(xml)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FIRED) == 1
    assert svrl.count(SVRL_FAILED) == 1

    # Element 'reference' is required in 8.2, and it exists
    elem_handler = root.find_element('dataset', 'addml')
    elem_handler.set_element('reference', 'addml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # No checks with version 8.3
    elem_handler = root.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', '8.3')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FIRED) == 0
    assert svrl.count(SVRL_FAILED) == 0


def test_addml_headerlevel_version(schematron_fx):
    """Test element 'headerLevel' with ADDML versions 8.2 and 8.3. It is
    a new element in 8.3 (forbidden in 8.2).

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<addml:addml><addml:dataset><addml:reference/><addml:flatFiles>
               <addml:flatFileDefinitions><addml:flatFileDefinition>
                 <addml:recordDefinitions><addml:recordDefinition>
                   <addml:headerLevel/>
                 </addml:recordDefinition></addml:recordDefinitions>
               </addml:flatFileDefinition></addml:flatFileDefinitions>
             </addml:flatFiles></addml:dataset></addml:addml>''' \
             % NAMESPACES
    (mets, root) = parse_xml_string(METS_HEAD+xml+METS_TAIL)
    (mets, root) = add_containers(root, 'mets:mets/mets:amdSec')

    # Element 'headerLevel' is forbidden in 8.2
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FIRED) == 2
    assert svrl.count(SVRL_FAILED) == 1

    # No checks with version 8.3
    elem_handler = root.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', '8.3')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FIRED) == 0
    assert svrl.count(SVRL_FAILED) == 0
