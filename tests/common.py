"""Common constants and functions for the tests
"""

import os
import xml.etree.ElementTree as ET
from tests.customelement import CustomElement


SVRL_FIRED = '<svrl:fired-rule'
SVRL_FAILED = '<svrl:failed-assert'
SVRL_REPORT = '<svrl:successful-report'
DATA = os.path.abspath(os.path.join(os.path.dirname(__file__), 'data'))

NAMESPACES = {'mets': 'http://www.loc.gov/METS/',
              'fikdk': 'http://www.kdk.fi/standards/mets/kdk-extensions',
              'fi': 'http://digitalpreservation.fi/schemas/mets/fi-extensions',
              'xlink': 'http://www.w3.org/1999/xlink',
              'xml': 'http://www.w3.org/XML/1998/namespace',
              'premis': 'info:lc/xmlns/premis-v2',
              'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
              'mix': 'http://www.loc.gov/mix/v20',
              'textmd': 'info:lc/xmlns/textMD-v3',
              'textmd_kdk': 'http://www.kdk.fi/standards/textmd',
              'addml': 'http://www.arkivverket.no/standarder/addml',
              'audiomd': 'http://www.loc.gov/audioMD/',
              'videomd': 'http://www.loc.gov/videoMD/',
              'metsrights': 'http://cosimo.stanford.edu/sdr/metsrights/',
              'marc21': 'http://www.loc.gov/MARC21/slim',
              'mods': 'http://www.loc.gov/mods/v3',
              'dc': 'http://purl.org/dc/elements/1.1/',
              'dcterms': 'http://purl.org/dc/terms/',
              'dcmitype': 'http://purl.org/dc/dcmitype/',
              'ead': 'urn:isbn:1-931666-22-9',
              'ead3': 'http://ead3.archivists.org/schema/',
              'eac': 'urn:isbn:1-931666-33-4',
              'vra': 'http://www.vraweb.org/vracore4.htm',
              'lido': 'http://www.lido-schema.org',
              'ddilc32': 'ddi:instance:3_2',
              'ddilc31': 'ddi:instance:3_1',
              'ddicb25': 'ddi:codebook:2_5',
              'ddicb21': 'http://www.icpsr.umich.edu/DDI'}


def parse_xml_file(filename):
    """Parse XML from file and make root element as CustomElement
    :filename: XML filename
    :returns: XML tree and it's root element as CustomElement
    """
    xmltree = ET.parse(os.path.join(DATA, filename))
    root = xmltree.getroot()
    CustomElement.cast(root, NAMESPACES)
    return (xmltree, root)


def parse_xml_string(xml):
    """Parse XML from string and make root element as CustomElement
    :xml: XML string
    :returns: XML tree and it's root element as CustomElement
    """
    xmltree = ET.ElementTree(ET.fromstring(xml))
    root = xmltree.getroot()
    CustomElement.cast(root, NAMESPACES)
    return (xmltree, root)
