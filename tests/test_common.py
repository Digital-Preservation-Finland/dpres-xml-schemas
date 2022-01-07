"""A test for container addition.

.. seealso:: common.py
"""
import lxml.etree as ET
from tests.common import add_containers, parse_xml_string


def test_container():
    """Test container addition
    """
    (_, root) = parse_xml_string(
        '<mets:foo xmlns:mets="http://www.loc.gov/METS/"/>')
    (_, root) = add_containers(root, 'mets:mets/mets:amdSec')
    xml = b'<mets:mets xmlns:mets="http://www.loc.gov/METS/">' \
        b'<mets:amdSec><mets:foo/></mets:amdSec></mets:mets>'
    assert ET.tostring(root) == xml
