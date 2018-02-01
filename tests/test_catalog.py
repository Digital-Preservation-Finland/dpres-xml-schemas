"""Tests for the METS XMML schema catalog
"""

import xml.etree.ElementTree as ET
import pytest
from tests.common import NAMESPACES, parse_xml_file, fix_version_17


def prepare_xml_for_tests():
    """Prepare XML file for the catalog tests
    """
    ET.register_namespace('premis', NAMESPACES['premis'])
    (mets, root) = parse_xml_file('mets_valid_complete.xml')
    return (mets, root)


def test_catalog_mets_complete(catalog_fx):
    """Test valid METS, where all mandatory and optional METS elements and
    attributes have been used at least once.

    :catalog_fx: Schema catalog validation fixture
    """
    (mets, root) = prepare_xml_for_tests()
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 0

    root.set_attribute('CATALOG', 'fikdk', '1.7.0')
    root.set_attribute('SPECIFICATION', 'fikdk', '1.7.0')
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 3

    # Use new specification
    fix_version_17(root)
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 0

    root.set_attribute('CATALOG', 'fi', '1.6.0')
    root.set_attribute('SPECIFICATION', 'fi', '1.6.0')
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 3


def test_contractid_format(catalog_fx):
    """Test that contractid allows only correctly formatted UUID
    """
    (mets, root) = prepare_xml_for_tests()
    fix_version_17(root)
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 0

    root.set_attribute('CONTRACTID', 'fi', 'c5a193b3-bb63-4348-bd25-6c20bb72264b')
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 3
    
    root.set_attribute('CONTRACTID', 'fi', 'urn:uuid:xxx')
    (returncode, _, _) = catalog_fx(xmltree=mets)
    assert returncode == 3


@pytest.mark.parametrize("rootelement, namespace, section", [
    ('record', 'marc21', 'dmdSec'),
    ('mods', 'mods', 'dmdSec'),
    ('ead', 'ead', 'dmdSec'),
    ('ead', 'ead3', 'dmdSec'),
    ('eac-cpf', 'eac', 'dmdSec'),
    ('vra', 'vra', 'dmdSec'),
    ('lido', 'lido', 'dmdSec'),
    ('DDIInstance', 'ddilc32', 'dmdSec'),
    ('DDIInstance', 'ddilc31', 'dmdSec'),
    ('codeBook', 'ddicb25', 'dmdSec'),
    ('codeBook', 'ddicb21', 'dmdSec'),
    ('object', 'premis', 'techMD'),
    ('rights', 'premis', 'rightsMD'),
    ('event', 'premis', 'digiprovMD'),
    ('agent', 'premis', 'digiprovMD'),
    ('addml', 'addml', 'techMD'),
    ('mix', 'mix', 'techMD'),
    ('AUDIOMD', 'audiomd', 'techMD'),
    ('VIDEOMD', 'videomd', 'techMD'),
    ('resource', 'datacite', 'dmdSec')
])
def test_section_schemas(catalog_fx, rootelement, namespace, section):
    """Test that section schemas in the catalog work in validation.

    :catalog_fx: Schema catalog validation fixture
    :rootelement: Root element of the section metadata
    :namespace: Namespace of the section metadata
    :section: METS metadata section
    """
    (mets, root) = prepare_xml_for_tests()
    elem_handler = root.find_element(section, 'mets')
    elem_handler = elem_handler.find_element('xmlData', 'mets')
    elem_handler.clear()
    elem_handler = elem_handler.set_element(rootelement, namespace)
    if namespace != 'premis':
        root.set_attribute(('xmlns:'+namespace), None, NAMESPACES[namespace])
    elif rootelement == 'object':
        elem_handler.set_attribute('type', 'xsi', 'premis:file')
    elem_handler.set_element('xxx', namespace)
    (returncode, _, stderr) = catalog_fx(xmltree=mets)
    assert returncode == 3
    assert 'xxx' in stderr
