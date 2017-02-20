"""Custom element class, which makes extensions to Element class.

.. seealso:: xml.etree.ElementTree.Element
"""

import xml.etree.ElementTree as ET


class CustomElement(ET.Element):
    """Customized XML Element class that handles known namespaces in a more
    automatic way.
    """
    known_namespaces = []

    @staticmethod
    def cast(element, nspaces):
        """Casts given Element to CustomElement

        :element: XML Element
        :returns: Given element as CustomElement
        """
        element.__class__ = CustomElement
        element.known_namespaces = nspaces
        return element

    def set_element(self, element, namespace):
        """Adds a new element as subelement of self.

        :element: Element name to add.
        :namespace: Namespace key, in which the element belongs to.
        :returns: The added element
        """
        if namespace is not None:
            elem_tag = ('{%s}'+element) % self.known_namespaces[namespace]
            elem = ET.SubElement(self, elem_tag)
        else:
            elem = ET.SubElement(self, element)
        CustomElement.cast(elem, self.known_namespaces)
        return elem

    def del_element(self, element, namespace):
        """Removes subelement.

        :element: Name of the element to remove.
        :namespace: Namespace key, in which the element belongs to.
        """
        if namespace is None:
            elem = self.find('./'+element)
        else:
            elem_tag = ('{%s}'+element) % self.known_namespaces[namespace]
            elem = self.find('./'+elem_tag)
        if elem is not None:
            self.remove(elem)

    def find_all_elements(self, element, namespace):
        """Finds all elements with certain tag name under self.

        :element: Element tag name to find.
        :namespace: Namespace key, in which the element belongs to.
        :returns: The found elements as list.
        """
        elem_tag = element
        if namespace is None:
            elemlist = self.findall('.//'+element)
        else:
            elem_tag = ('{%s}'+element) % self.known_namespaces[namespace]
            elemlist = self.findall('.//'+elem_tag)
        if elemlist is None and self.tag == elem_tag:
            return self
        for elem_item in elemlist:
            CustomElement.cast(elem_item, self.known_namespaces)
        return elemlist

    def find_element(self, element, namespace):
        """Finds the first element with certain tag name under self.

        :element: Element name tag to find.
        :namespace: Namespace key, in which the element belongs to.
        :returns: The found element.
        """
        elem = None
        elem_tag = element
        if namespace is None:
            elem = self.find('.//'+element)
            if elem is None and self.tag == element:
                return self
        else:
            elem_tag = ('{%s}'+element) % self.known_namespaces[namespace]
            elem = self.find('.//'+elem_tag)
            if elem is None and self.tag == elem_tag:
                return self
        if elem is not None:
            CustomElement.cast(elem, self.known_namespaces)
        return elem

    def set_attribute(self, attribute, namespace, value):
        """Sets a new or resets an existing attribute to self.

        :attribute: Attribute key.
        :namespace: Namespace key, in which the attribute belongs to.
                    Overridden, if the attribute key contains namespace.
        :value: Value for the attribute.
        """
        if namespace is None:
            self.set(attribute, value)
        elif '{%s}' % self.known_namespaces[namespace] in self.tag:
            self.set(attribute, value)
        elif attribute[0] == '{':
            self.set(attribute, value)
        else:
            self.set(('{%s}'+attribute) % self.known_namespaces[namespace],
                     value)

    def get_attribute(self, attribute, namespace):
        """Gets an attribute from self.

        :attribute: Attribute key.
        :namespace: Namespace key, in which the attribute belongs to.
                    Overridden, if the attribute key contains namespace.
        :returns: The found attribute.
        """
        if namespace is None:
            return self.get(attribute)
        elif '{%s}' % self.known_namespaces[namespace] in self.tag:
            return self.get(attribute)
        elif attribute[0] == '{':
            return self.get(attribute)
        else:
            return self.get(
                ('{%s}'+attribute) % self.known_namespaces[namespace])

    def del_attribute(self, attribute, namespace):
        """Deletes an attribute from self.

        :attribute: Attribute key.
        :namespace: Namespace key, in which the attribute belongs to.
                    Overridden, if the attribute key contains namespace.
        """
        if namespace is None:
            del self.attrib[attribute]
        elif '{%s}' % self.known_namespaces[namespace] in self.tag:
            del self.attrib[attribute]
        elif attribute[0] == '{':
            del self.attrib[attribute]
        else:
            del self.attrib[
                ('{%s}'+attribute) % self.known_namespaces[namespace]]
