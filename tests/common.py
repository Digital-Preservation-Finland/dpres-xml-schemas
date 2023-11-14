"""Common constants and functions for the tests
"""

import os
import lxml.etree as ET


SVRL_FIRED = b'<svrl:fired-rule'
SVRL_FAILED = b'<svrl:failed-assert'
SVRL_REPORT = b'<svrl:successful-report'
DATA = os.path.abspath(os.path.join(os.path.dirname(__file__), 'data'))

NAMESPACES = {'mets': 'http://www.loc.gov/METS/',
              'fikdk': 'http://www.kdk.fi/standards/mets/kdk-extensions',
              'fi': 'http://digitalpreservation.fi/schemas/mets/fi-extensions',
              'xlink': 'http://www.w3.org/1999/xlink',
              'xml': 'http://www.w3.org/XML/1998/namespace',
              'premis': 'info:lc/xmlns/premis-v2',
              'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
              'mix': 'http://www.loc.gov/mix/v20',
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
              'eac2': 'https://archivists.org/ns/eac/v2',
              'vra': 'http://www.vraweb.org/vracore4.htm',
              'lido': 'http://www.lido-schema.org',
              'datacite': 'http://datacite.org/schema/kernel-4',
              'ddilc33': 'ddi:instance:3_3',
              'ddilc32': 'ddi:instance:3_2',
              'ddilc31': 'ddi:instance:3_1',
              'ddicb25': 'ddi:codebook:2_5',
              'ddicb21': 'http://www.icpsr.umich.edu/DDI',
              'ebucore': 'urn:ebu:metadata-schema:ebucore'}


def parse_xml_file(filename):
    """Parse XML from file and make root element as CustomElement
    :filename: XML filename
    :returns: XML tree and it's root element as CustomElement
    """
    xmltree = ET.parse(os.path.join(DATA, filename))
    root = xmltree.getroot()
    return (xmltree, root)


def parse_xml_string(xml):
    """Parse XML from string and make root element as CustomElement
    :xml: XML string
    :returns: XML tree and it's root element as CustomElement
    """
    xmltree = ET.ElementTree(ET.fromstring(xml))
    root = xmltree.getroot()
    return (xmltree, root)


def add_containers(root, container_path):
    """Add containers to given metadata based on given path

    :root: Root element where containers are needed
    :container_path: Simple xpath of expected parent elements
    """
    split_path = container_path.split('/')
    (new_tree, new_root) = parse_xml_string(
        '<' + split_path[0] + ' xmlns:'+split_path[0].split(':')[0] +
        '="' + NAMESPACES[split_path[0].split(':')[0]] + '"/>')
    elem = new_root
    for path_part in split_path[1:]:
        part = path_part.split(':')
        elem = set_element(elem, part[1], part[0])
    elem.append(root)
    return (new_tree, new_root)


def set_element(element, elem_name, namespace):
    """Adds a new element as subelement of given element.

    :element: Element to which the new element is added.
    :elem_name: Element name to add.
    :namespace: Namespace key, in which the element belongs to.
    :returns: The added element
    """
    if namespace is not None:
        elem_tag = ('{%s}'+elem_name) % NAMESPACES[namespace]
        elem = ET.SubElement(element, elem_tag)
    else:
        elem = ET.SubElement(element, elem_name)
    return elem


def del_element(element, elem_name, namespace):
    """Removes subelement from given element.

    :element: Element from which the subelement is removed.
    :elem_name: Name of the element to remove.
    :namespace: Namespace key, in which the element belongs to.
    """
    if namespace is None:
        elem = element.find('./'+elem_name)
    else:
        elem_tag = ('{%s}'+elem_name) % NAMESPACES[namespace]
        elem = element.find('./'+elem_tag)
    if elem is not None:
        element.remove(elem)


def find_all_elements(element, elem_name, namespace):
    """Finds all elements with certain tag name under given element.

    :element: Element to search under.
    :elem_name: Element tag name to find.
    :namespace: Namespace key, in which the element belongs to.
    :returns: The found elements as list.
    """
    elem_tag = elem_name
    if namespace is None:
        elemlist = element.findall('.//'+elem_name)
    else:
        elem_tag = ('{%s}'+elem_name) % NAMESPACES[namespace]
        elemlist = element.findall('.//'+elem_tag)
    if elemlist is None and element.tag == elem_tag:
        return element
    return elemlist


def find_element(element, elem_name, namespace):
    """Finds the first element with certain tag name under given element.

    :element: Element to search under.
    :elem_name: Element name tag to find.
    :namespace: Namespace key, in which the element belongs to.
    :returns: The found element.
    """
    if namespace is None:
        elem = element.find('.//'+elem_name)
        if elem is None and element.tag == elem_name:
            return element
    else:
        elem_tag = ('{%s}'+elem_name) % NAMESPACES[namespace]
        elem = element.find('.//'+elem_tag)
        if elem is None and element.tag == elem_tag:
            return element
    return elem


def set_attribute(element, attribute, namespace, value):
    """Sets a new or resets an existing attribute to given element.

    :element: Element whose attribute is edited.
    :attribute: Attribute key.
    :namespace: Namespace key, in which the attribute belongs to.
                Overridden, if the attribute key contains namespace.
    :value: Value for the attribute.
    """
    if namespace is None:
        element.set(attribute, value)
    elif '{%s}' % NAMESPACES[namespace] in element.tag:
        element.set(attribute, value)
    elif attribute[0] == '{':
        element.set(attribute, value)
    else:
        element.set(('{%s}'+attribute) % NAMESPACES[namespace], value)


def get_attribute(element, attribute, namespace):
    """Gets an attribute from given element.

    :element: Element whose attribute is gotten.
    :attribute: Attribute key.
    :namespace: Namespace key, in which the attribute belongs to.
                Overridden, if the attribute key contains namespace.
    :returns: The found attribute.
    """
    if namespace is None:
        return element.get(attribute)
    elif '{%s}' % NAMESPACES[namespace] in element.tag:
        return element.get(attribute)
    elif attribute[0] == '{':
        return element.get(attribute)
    else:
        return element.get(
            ('{%s}'+attribute) % NAMESPACES[namespace])


def del_attribute(element, attribute, namespace):
    """Deletes an attribute from given element.

    :element: Element whose attribute is deleted.
    :attribute: Attribute key.
    :namespace: Namespace key, in which the attribute belongs to.
                Overridden, if the attribute key contains namespace.
    """
    if namespace is None:
        del element.attrib[attribute]
    elif '{%s}' % NAMESPACES[namespace] in element.tag:
        del element.attrib[attribute]
    elif attribute[0] == '{':
        del element.attrib[attribute]
    else:
        del element.attrib[
            ('{%s}'+attribute) % NAMESPACES[namespace]]


def fix_version_17(root):
    """Local namespaces need to be changed for catalog version 1.7.5 to make
    the tree valid. This is used in various tests.

    :root: METS root element
    """
    fikdk_dict = {'mets': ['CATALOG', 'SPECIFICATION', 'CONTENTID'],
                  'dmdSec': ['CREATED', 'PID', 'PIDTYPE'],
                  'techMD': ['CREATED', 'PID', 'PIDTYPE'],
                  'rightsMD': ['CREATED', 'PID', 'PIDTYPE'],
                  'sourceMD': ['CREATED', 'PID', 'PIDTYPE'],
                  'digiprovMD': ['CREATED', 'PID', 'PIDTYPE'],
                  'structMap': ['PID', 'PIDTYPE']}
    for elem, attributes in fikdk_dict.items():
        element_list = find_all_elements(root, elem, 'mets')
        if elem == 'mets':
            element_list = [root]
        for elem_tree in element_list:
            for attr in attributes:
                fi_attrib = get_attribute(elem_tree, attr, 'fikdk')
                if fi_attrib is not None:
                    del_attribute(elem_tree, attr, 'fikdk')
                    set_attribute(elem_tree, attr, 'fi', fi_attrib)
    mdref = find_element(root, 'mdRef', 'mets')
    if mdref is not None:
        set_attribute(mdref, 'OTHERMDTYPE', 'mets', 'FiPreservationPlan')
    set_attribute(
        root, 'PROFILE', 'mets',
        'http://digitalpreservation.fi/mets-profiles/cultural-heritage')
    set_attribute(root, 'CATALOG', 'fi', '1.7.5')
    set_attribute(root, 'SPECIFICATION', 'fi', '1.7.5')
    set_attribute(root, 'CONTRACTID', 'fi',
                  'urn:uuid:c5a193b3-bb63-4348-bd25-6c20bb72264b')
