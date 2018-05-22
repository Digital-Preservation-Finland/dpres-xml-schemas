"""A test for container addition.

.. seealso:: common.py
"""
import xml.etree.ElementTree as ET
from tests.common import add_containers, parse_xml_string


def test_container():
    """Test container addition
    """
    (_, root) = parse_xml_string(
        '<mets:foo xmlns:mets="http://www.loc.gov/METS/"/>')
    (_, root) = add_containers(root, 'mets:mets/mets:amdSec')
    xml = '<ns0:mets xmlns:ns0="http://www.loc.gov/METS/">' \
        '<ns0:amdSec><ns0:foo /></ns0:amdSec></ns0:mets>'
    assert ET.tostring(root) == xml
