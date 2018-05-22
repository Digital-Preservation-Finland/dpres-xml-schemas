"""Tests for the schematron rules for MODS metadata, i.e for the
rules located in mets_mods.sch.

.. seealso:: mets_mods.sch
"""

import pytest
from tests.common import SVRL_FAILED, SVRL_REPORT, NAMESPACES, \
    parse_xml_string, add_containers

SCHFILE = 'mets_mods.sch'


def prepare_xml(context_element, version):
    """The MODS metadata is prepared here for all the tests below.

    :context_element: Context element, where the test is done
    :version: MODS version to be used.
    """
    xml = '''<mets:dmdSec xmlns:mets="%(mets)s" xmlns:mods="%(mods)s">
               <mets:mdWrap MDTYPE="MODS" MDTYPEVERSION="3.6">
               <mets:xmlData><mods:mods/></mets:xmlData></mets:mdWrap>
             </mets:dmdSec>''' % NAMESPACES
    (mods, root) = parse_xml_string(xml)
    (mods, root) = add_containers(root, 'mets:mets')
    elem_handler = root.find_element('mods', 'mods')
    if context_element is not None:
        elem_context = elem_handler.set_element(context_element, 'mods')
    elem_version = root.find_element('mdWrap', 'mets')
    elem_version.set_attribute('MDTYPEVERSION', 'mets', version)
    return (mods, elem_context, elem_version)


@pytest.mark.parametrize("context_element, disallowedlist, version", [
    ('abstract', ['@altFormat', '@contentType'], '3.5'),
    ('abstract', ['@lang', '@{%(xml)s}lang' % NAMESPACES, '@script',
                  '@transliteration'], '3.4'),
    ('accessCondition', ['@altFormat', '@contentType'], '3.5'),
    ('accessCondition', ['@lang', '@{%(xml)s}lang' % NAMESPACES, '@script',
                         '@transliteration'], '3.4'),
    ('cartographics', ['cartographicExtension'], '3.6'),
    ('cartographics', ['@authority'], '3.4'),
    ('classification', ['@generator'], '3.5'),
    ('classification', ['@usage', '@lang', '@{%(xml)s}lang' % NAMESPACES,
                        '@script', '@transliteration'], '3.4'),
    ('classification', ['@displayLabel'], '3.1'),
    ('copyInformation', ['itemIdentifier'], '3.6'),
    ('dateOther', ['@type'], '3.1'),
    ('extension', ['@displayLabel'], '3.4'),
    ('form', ['@type'], '3.1'),
    ('frequency', ['@authority'], '3.3'),
    ('genre', ['@usage', '@displayLabel', '@lang',
               '@{%(xml)s}lang' % NAMESPACES, '@script',
               '@transliteration'], '3.4'),
    ('genre', ['@type'], '3.1'),
    ('hierarchicalGeographic', ['extraTerrestrialArea'], '3.6'),
    ('hierarchicalGeographic', ['@authority'], '3.4'),
    ('hierarchicalGeographic', ['extraterrestrialArea', 'citySection'], '3.3'),
    ('identifier', ['@typeURI'], '3.5'),
    ('identifier', ['@lang', '@{%(xml)s}lang' % NAMESPACES,
                    '@script', '@transliteration'], '3.4'),
    ('language', ['@scriptTerm', '@usage', '@displayLabel'], '3.4'),
    ('language', ['@objectPart'], '3.1'),
    ('languageOfCataloging', ['@usage', '@displayLabel', '@language',
                              '@scriptTerm'], '3.4'),
    ('languageOfCataloging', ['@objectPart'], '3.1'),
    ('location', ['@displayLabel'], '3.4'),
    ('location', ['shelfLocator', 'holdingSimple', 'holdingExternal'], '3.3'),
    ('mods', ['part'], '3.1'),
    ('name', ['nameIdentifier'], '3.6'),
    ('name', ['@displayLabel', '@lang', '@{%(xml)s}lang' % NAMESPACES,
              '@script', '@transliteration'], '3.4'),
    ('nonSort', ['@{%(xml)s}space' % NAMESPACES], '3.6'),
    ('note', ['@typeURI'], '3.5'),
    ('note', ['@ID'], '3.2'),
    ('originInfo', ['@eventType'], '3.5'),
    ('originInfo', ['@displayLabel', '@lang', '@{%(xml)s}lang' % NAMESPACES,
                    '@script', '@transliteration'], '3.4'),
    ('part', ['@displayLabel'], '3.4'),
    ('part', ['@type', '@order', '@ID'], '3.2'),
    ('physicalDescription', ['@displayLabel', '@lang',
                             '@{%(xml)s}lang' % NAMESPACES,
                             '@script', '@transliteration'], '3.4'),
    ('physicalLocation', ['@lang',
                          '@{%(xml)s}lang' % NAMESPACES,
                          '@script', '@transliteration'], '3.4'),
    ('physicalLocation', ['@{%(xlink)s}type' % NAMESPACES,
                          '@{%(xlink)s}href' % NAMESPACES,
                          '@{%(xlink)s}role' % NAMESPACES,
                          '@{%(xlink)s}arcrole' % NAMESPACES,
                          '@{%(xlink)s}title' % NAMESPACES,
                          '@{%(xlink)s}show' % NAMESPACES,
                          '@{%(xlink)s}actuate' % NAMESPACES], '3.3'),
    ('physicalLocation', ['@type'], '3.1'),
    ('recordContentSource', ['@lang', '@{%(xml)s}lang' % NAMESPACES,
                             '@script', '@transliteration'], '3.4'),
    ('recordInfo', ['recordInfoNote'], '3.6'),
    ('recordInfo', ['@displayLabel', '@lang', '@{%(xml)s}lang' % NAMESPACES,
                    '@script', '@transliteration'], '3.4'),
    ('recordInfo', ['holdingExternal'], '3.3'),
    ('relatedItem', ['@otherType', '@otherTypeAuth', '@otherTypeAuthURI',
                     '@otherTypeURI'], '3.6'),
    ('relatedItem', ['@ID'], '3.2'),
    ('subject', ['@usage', '@displayLabel', '@lang',
                 '@{%(xml)s}lang' % NAMESPACES, '@script', '@transliteration'],
     '3.4'),
    ('subject', ['genre'], '3.2'),
    ('tableOfContents', ['@altFormat', '@contentType'], '3.5'),
    ('tableOfContents', ['@lang', '@{%(xml)s}lang' % NAMESPACES,
                         '@script', '@transliteration'], '3.4'),
    ('targetAudience', ['@displayLabel', '@lang',
                        '@{%(xml)s}lang' % NAMESPACES,
                        '@script', '@transliteration'], '3.4'),
    ('temporal', ['@authority'], '3.4'),
    ('titleInfo', ['@otherType', '@altFormat', '@contentType'], '3.5'),
    ('titleInfo', ['@usage', '@lang', '@{%(xml)s}lang' % NAMESPACES,
                   '@script', '@transliteration'], '3.4'),
    ('typeOfResource', ['@usage', '@displayLabel'], '3.4'),
    ('url', ['@note', '@access', '@usage'], '3.2'),
    ('xxx', ['@shareable', '@altRepGroup', '@authorityURI', '@valueURI',
             '@supplied'], '3.4')
])
def test_disallowed_field(
        schematron_fx, context_element, disallowedlist, version):
    """Various elements and attributes have been added to newer MODS versions.
    Test the checks that disallow the use of new element/attribute in an old
    MODS version.

    :schematron_fx: Schematron compile fixture
    :context_element: Context element, which may contain new elements or
                      attributes.
    :disallowedlist: List of new elements and attributes
    :version: Earliest MODS version where the list apply
    """
    (mods, elem_context, elem_version) = prepare_xml(context_element, version)
    for disallowed in disallowedlist:
        if disallowed[0] == '@':
            elem_context.set_attribute(disallowed[1:], 'mods', 'default')
        else:
            elem_context.set_element(disallowed, 'mods')

    # The elements/attributes are allowed in the given MODS version
    elem_version.set_attribute('MDTYPEVERSION', 'mets', version)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # The elements/attributes are disallowed in the previous MODS version
    elem_version.set_attribute(
        'MDTYPEVERSION', 'mets', '%.1f' % (float(version)-0.1))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == len(disallowedlist)

    # No errors, if the disallowed items are removed
    elem_context.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize(
    "context_element, context_attribute, disallowed_value, version", [
        ('issuance', None, 'single unit', '3.4'),
        ('issuance', None, 'multipart monograph', '3.4'),
        ('issuance', None, 'serial', '3.4'),
        ('issuance', None, 'integrating resource', '3.4'),
        ('typeOfResource', None, '', '3.3'),
        ('digitalOrigin', None, 'digitized microfilm', '3.2'),
        ('digitalOrigin', None, 'digitized other analog', '3.2'),
        ('languageTerm', 'authority', 'rfc5646', '3.5'),
        ('name', 'type', 'family', '3.4'),
        ('relatedItem', 'type', 'references', '3.4'),
        ('relatedItem', 'type', 'reviewOf', '3.4'),
        ('url', 'usage', 'primary', '3.4'),
        ('languageTerm', 'authority', 'rfc4646', '3.3'),
        ('xxx', 'encoding', 'temper', '3.4'),
        ('xxx', 'encoding', 'edtf', '3.4')
    ])
def test_disallowed_value(
        schematron_fx, context_element, context_attribute, disallowed_value,
        version):
    """Various values have been added to newer MODS versions' controlled
    vocabularies. Test the checks that disallow the use of new value in an old
    MODS version.

    :schematron_fx: Schematron compile fixture
    :context_element: Context element, where the test is done.
    :context_attribute: Context attribute that has the value to be tested.
                        If None, the value should be located in the elment.
    :disallowed_value: Value to be tested
    :version: Earliest MODS version where the value applies
    """
    (mods, elem_context, elem_version) = prepare_xml(context_element, version)
    if context_attribute is not None:
        elem_context.set_attribute(context_attribute, 'mods', disallowed_value)
    else:
        elem_context.text = disallowed_value

    # The value is allowed in the current MODS version
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # Disallowed in the previous MODS version
    elem_version.set_attribute(
        'MDTYPEVERSION', 'mets', '%.1f' % (float(version)-0.1))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1

    # Arbitrary value should not give error
    # These are handled in the MODS schema
    if context_attribute is not None:
        elem_context.set_attribute(context_attribute, 'mods', 'default')
    else:
        elem_context.text = 'default'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("container, context, disallowed_attribute, version", [
    ('physicalDescription', 'note', 'typeURI', '3.5'),
    ('physicalDescription', 'extent', 'unit', '3.5'),
    ('physicalDescription', 'note', 'ID', '3.2'),
    ('hierarchicalGeographic', 'xxx', 'level', '3.6'),
    ('hierarchicalGeographic', 'xxx', 'period', '3.6'),
    ('hierarchicalGeographic', 'xxx', 'authority', '3.6'),
    ('hierarchicalGeographic', 'xxx', 'authorityURI', '3.6'),
    ('hierarchicalGeographic', 'xxx', 'valueURI', '3.6'),
])
def test_disallowed_hierarch_attrib(
        schematron_fx, container, context, disallowed_attribute, version):
    """Various attributes have been added to newer MODS versions. Test the
    checks that disallow the use of new element/attribute in an old MODS
    version. Here the context element require container, since MODS has other
    irrelevant context elements with the same name outside the container.

    :schematron_fx: Schematron compile fixture
    :container: Element, where the context exists
    :context: Context element, which may contain new attribute.
    :disallowed_attribute: The new attribute
    :version: Earliest MODS version where the attribute applies
    """
    (mods, elem_context, elem_version) = prepare_xml(container, version)
    elem_context = elem_context.set_element(context, 'mods')
    elem_context.set_attribute(disallowed_attribute, 'mods', 'default')

    # Success with given version
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # Error with earlier versions
    elem_version.set_attribute(
        'MDTYPEVERSION', 'mets', '%.1f' % (float(version)-0.1))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1

    # Success again, if attribute removed
    elem_context.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("elementname, version", [
    ('extension', '3.3'),
    ('accessCondition', '3.3'),
    ('titleInfo', '3.1'),
    ('name', '3.1'),
    ('subject', '3.1')
])
def test_required_subelements(schematron_fx, elementname, version):
    """Some MODS elements require subelements until certain MODS version.

    :elementname: Element which require subelements in earlier MODS versions
    :version: Earliest MODS version, where element may be empty
    :schematron_fx: Schematron compile fixture
    """
    (mods, elem_context, elem_version) = prepare_xml(elementname, version)

    # Element is empty, given MODS version
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # Element is empty, earlier MODS version
    elem_version.set_attribute(
        'MDTYPEVERSION', 'mets', '%.1f' % (float(version)-0.1))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1

    # Success, when we add something
    elem_context.set_element('xxx', None)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


def test_exempt_element(schematron_fx):
    """Element 'cartographics' could not be empty in MODS 3.0.

    :schematron_fx: Schematron compile fixture
    """
    (mods, elem_context, elem_version) = prepare_xml('cartographics', '3.0')

    # Add 'coordinates' to 'cartographics'
    elem_context.set_element('coordinates', 'mods')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # Error, if no subelements
    elem_context.clear()
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1

    # No error, if MODS version changed
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.1')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


def test_removed_element(schematron_fx):
    """Element 'extraterrestrialArea' was removed in MODS 3.6

    :schematron_fx: Schematron compile fixture
    """
    (mods, elem_context, elem_version) = prepare_xml('hierarchicalGeographic',
                                                     '3.6')

    # Success without 'extraterrestrialArea'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0

    # Error, if 'extraterrestrialArea' exists
    elem_context.set_element('extraterrestrialArea', 'mods')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1

    # Success when version changed to 3.5
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.5')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 0


def test_deprecated_element(schematron_fx):
    """Element 'province' was deprecated in MODS 3.6

    :schematron_fx: Schematron compile fixture
    """
    (mods, elem_context, elem_version) = prepare_xml(
        'hierarchicalGeographic', '3.6')

    # Success without 'province'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 0
    elem_context.set_element('province', 'mods')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)

    # Warning, if 'province' exists
    assert svrl.count(SVRL_REPORT) == 1

    # Success when version changed to 3.5
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.5')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 0


def test_deprecated_value(schematron_fx):
    """In 'usage' element, value 'primary display' was deprecated in MODS 3.4
    and 'primary' was given instead.

    :schematron_fx: Schematron compile fixture
    """
    (mods, elem_context, elem_version) = prepare_xml('url', '3.4')

    # Success without 'usage'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 0

    # Warning with 'primary display'
    elem_context.set_attribute('usage', 'mods', 'primary display')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 1

    # No warning with old version 3.3
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.3')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 0

    # No warning with MODS 3.4, when using 'primary'
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.4')
    elem_context.set_attribute('usage', 'mods', 'primary')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_REPORT) == 0

    # New value 'primary' is an error with MODS 3.3
    elem_version.set_attribute('MDTYPEVERSION', 'mets', '3.3')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mods)
    assert svrl.count(SVRL_FAILED) == 1
