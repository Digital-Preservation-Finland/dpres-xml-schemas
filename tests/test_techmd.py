"""Tests for the schematron rules for internal METS, i.e for the rules located
in mets_techmd.sch.

.. seealso:: mets_techmd.sch
"""
import pytest
from tests.common import SVRL_FAILED, parse_xml_file, \
    fix_version_17

SCHFILE = 'mets_techmd.sch'


def test_valid_complete_techmd(schematron_fx):
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


@pytest.mark.parametrize("mdtype, othermdtype, mdtypeversion", [
    ('NISOIMG', None, ['2.0']),
    ('PREMIS:OBJECT', None, ['2.3', '2.2']),
    ('OTHER', 'AudioMD', ['2.0']),
    ('OTHER', 'VideoMD', ['2.0']),
    ('OTHER', 'ADDML', ['8.2', '8.3']),
    ('OTHER', 'EBUCORE', ['1.10'])
])
def test_mdtype_items_techmd(schematron_fx, mdtype, othermdtype,
                             mdtypeversion):
    """Test that all valid metadata types and their versions work properly.

    :schematron_fx: Schematron compile fixture
    :mdtype: MDTYPE attribute value
    :othermdtype: OTHERMDTYPE attribute valur
    :mdtypeversion: MDTYPEVERSION attribute value
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    elem_handler = root.find_element('techMD', 'mets')
    elem_handler = elem_handler.find_element('mdWrap', 'mets')
    elem_handler.set_attribute('MDTYPE', 'mets', mdtype)
    if othermdtype is not None:
        elem_handler.set_attribute('OTHERMDTYPE', 'mets', othermdtype)

    # Test that all MDTYPEVERSIONs work with all specifications
    for specversion in ['1.5.0', '1.6.0', '1.7.0', '1.7.1', '1.7.2', '1.7.3']:
        if specversion in ['1.7.0', '1.7.1', '1.7.2', '1.7.3']:
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


def test_disallowed_items_techmd(schematron_fx):
    """Test if use of disallowed atrtibute or element causes error.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_complete.xml')

    # Set disallowed attribute/element
    elem_handler = root.find_element('techMD', 'mets')
    elem_handler.set_element('mdRef', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


@pytest.mark.parametrize("container_format", [
    ('video/x-ms-asf'), ('video/avi'), ('video/MP1S'), ('video/MP2P'),
    ('video/MP2T'), ('application/mxf'), ('video/mj2'), ('video/quicktime')
])
def test_stream(schematron_fx, container_format):
    """Test the container and stream case.

    :schematron_fx: Schematron compile fixture
    :container_format: Container format to test
    """
    (mets, root) = parse_xml_file('mets_video_container.xml')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    elem_handler = root.find_element('techMD[@ID="tech-container"]', 'mets')
    elem_format = elem_handler.find_element('formatName', 'premis')
    elem_format.text = container_format
    elem_handler = root.find_element('file', 'mets')
    elem_handler.del_element('stream', 'mets')
    elem_handler.del_element('stream', 'mets')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # video/mp4 is not necessary a container
    elem_format.text = 'video/mp4'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0


def test_native_stream(schematron_fx):
    """
    Test a case where a video container listed in specifications contains
    an unsupported stream, and fi-preservation-no-file-format-validation is
    marked. In this case, streams are not required in METS.
    """
    (mets, root) = parse_xml_file("mets_video_container.xml")
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    elem_handler = root.find_element("file", "mets")
    elem_handler.set_attribute(
        "USE", "mets", "fi-preservation-no-file-format-validation")
    elem_handler.del_element("stream", "mets")
    elem_handler.del_element("stream", "mets")
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
