"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_rightsmd.sch.

.. seealso:: mets_rightsmd.sch
"""
from tests.common import SVRL_FAILED, SVRL_REPORT, parse_xml_file, \
    parse_xml_string, NAMESPACES, fix_version_17

SCHFILE = 'mets_rightsmd.sch'


def test_valid_complete_rightsmd(schematron_fx):
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


def test_mdtype_items_rightsmd(schematron_fx):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('rightsMD', 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', 'PREMIS:RIGHTS')

    # Test that all MDTYPEVERSIONs work with all specifications
    for specversion in ['1.5.0', '1.6.0', '1.7.0', '1.7.1']:
        if specversion in ['1.7.0', '1.7.1']:
            fix_version_17(root)
        else:
            root.set_attribute('CATALOG', 'fikdk', specversion)
            root.set_attribute('SPECIFICATION', 'fikdk', specversion)
        for version in ['2.3', '2.2']:
            elem_handler.set_attribute('MDTYPEVERSION', 'mets', version)
            svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
            assert svrl.count(SVRL_FAILED) == 0

    # Test unknown version
    fix_version_17(root)
    elem_handler.set_attribute('MDTYPEVERSION', 'mets', 'xxx')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_disallowed_items_rightsmd(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element('rightsMD', 'mets')
    elem_handler.set_element('mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_rightsstatement_warning(schematron_fx):
    """There was an accidential error in specification 1.5.0 where
    rightsStatement was accepted as root element in PREMIS:RIGHTS. The correct
    element is 'rights'. Test that 'rights' works in all versions, and
    'rightsStatement' gives a warning with specification 1.5.0 and error
    in all other versions.

    :schematron_fx: Schematron compile fixture
    """
    xml = '''<mets:mets fi:CATALOG="1.5.0" xmlns:mets="%(mets)s"
             xmlns:dc="%(dc)s" xmlns:premis="%(premis)s" xmlns:fi="%(fikdk)s">
               <mets:dmdSec><mets:mdWrap MDTYPE="DC" MDTYPEVERSION="1.1">
                 <mets:xmlData><dc:subject/></mets:xmlData></mets:mdWrap>
               </mets:dmdSec><mets:amdSec>
                 <mets:techMD>
                   <mets:mdWrap MDTYPE='PREMIS:OBJECT' MDTYPEVERSION="2.3">
                   <mets:xmlData><premis:object/></mets:xmlData>
                 </mets:mdWrap></mets:techMD>
                 <mets:rightsMD>
                   <mets:mdWrap MDTYPE="PREMIS:RIGHTS" MDTYPEVERSION="2.3">
                   <mets:xmlData><premis:rightsStatement/>
                 </mets:xmlData></mets:mdWrap></mets:rightsMD>
                 <mets:digiprovMD>
                   <mets:mdWrap MDTYPE='PREMIS:EVENT' MDTYPEVERSION="2.3">
                   <mets:xmlData><premis:event/></mets:xmlData></mets:mdWrap>
             </mets:digiprovMD></mets:amdSec></mets:mets>''' % NAMESPACES
    (mets, _) = parse_xml_string(xml)

    # rightsStatement gives a warning with specification 1.5.0
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
    assert svrl.count(SVRL_REPORT) == 1
