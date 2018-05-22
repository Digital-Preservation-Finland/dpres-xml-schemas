"""Tests for the schematron rules for MIX metadata, i.e for the
rules located in mets_mix.sch.

.. seealso:: mets_mix.sch
"""

import xml.etree.ElementTree as ET
import pytest
from tests.common import SVRL_FAILED, NAMESPACES, parse_xml_file

SCHFILE = 'mets_mix.sch'


def make_colorprofile(root):
    """Add color profile to MIX XML tree
    :root: XML tree root element
    """
    elem_handler = root.find_element('PhotometricInterpretation', 'mix')
    xml = '''<mix:ColorProfile xmlns:mix="%(mix)s">
               <mix:IccProfile><mix:iccProfileName/></mix:IccProfile>
             </mix:ColorProfile>''' % NAMESPACES
    elem_handler.append(ET.XML(xml))


def make_colorsample(colorspace, sample, addsample, extrasample):
    """ Modifies MIX metadata with given colorspace and sample info.

    :colorspace: Colorspace to be tested
    :sample: Number of samples required by the colorspace
    :addsample: Offset for the required sample
    :extraSample: Boolean, true if extra sample is defined.
    :returns: Modified MIX XML tree
    """
    # Prepare the MIX data for the colorspace and sample test
    (mix, root) = parse_xml_file('mix_valid_minimal.xml')
    make_colorprofile(root)
    elem_handler = root.find_element('ImageColorEncoding', 'mix')
    xml = '''<mix:Colormap xmlns:mix="%(mix)s">
             <mix:colormapReference/></mix:Colormap>''' % NAMESPACES
    elem_handler.append(ET.XML(xml))
    elem_handler = root.find_element('colorSpace', 'mix')
    elem_handler.text = colorspace
    elem_handler = root.find_element('samplesPerPixel', 'mix')
    elem_handler.text = str(sample + addsample)
    elem_handler = root.find_element('ImageColorEncoding', 'mix')
    elem_extra = elem_handler.find_element('extraSamples', 'mix')
    if elem_extra is not None:
        elem_handler.remove(elem_extra)
    if extrasample:
        extra = '{%(mix)s}extraSamples' % NAMESPACES
        elem_handler.insert(2, ET.Element(extra))

    return mix


@pytest.mark.parametrize("elementkey, subelements, condition, newfired", [
    (['BasicDigitalObjectInformation', 'ObjectIdentifier'],
     ['objectIdentifierType', 'objectIdentifierValue'], None, [0, 0]),
    (['BasicDigitalObjectInformation', 'FormatDesignation'], ['formatName'],
     None, [0, 0]),
    (['BasicDigitalObjectInformation', 'Fixity'],
     ['messageDigestAlgorithm', 'messageDigest'], None, [0, 0]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'YCbCr'],
     ['YCbCrSubSampling', 'yCbCrPositioning', 'YCbCrCoefficients'],
     None, [0, 5]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'YCbCr', 'YCbCrSubSampling'],
     ['yCbCrSubsampleHoriz', 'yCbCrSubsampleVert'], None, [2, 2]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'YCbCr', 'YCbCrCoefficients'],
     ['lumaRed', 'lumaGreen', 'lumaBlue'], None, [2, 2]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ReferenceBlackWhite'],
     ['Component'], None, [0, 0]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ColorProfile'],
     ['LocalProfile'], None, [0, 1]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ColorProfile'],
     ['IccProfile'], None, [0, 1]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ColorProfile', 'LocalProfile'],
     ['localProfileName'], None, [0, 0]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ColorProfile', 'IccProfile'],
     ['iccProfileName'], None, [0, 0]),
    (['BasicImageInformation', 'BasicImageCharacteristics',
      'PhotometricInterpretation', 'ColorProfile', 'IccProfile'],
     ['iccProfileURI'], None, [0, 0]),
    (['BasicImageInformation', 'SpecialFormatCharacteristics', 'JPEG2000'],
     ['EncodingOptions'], None, [0, 2]),
    (['BasicImageInformation', 'SpecialFormatCharacteristics', 'JPEG2000',
      'EncodingOptions'], ['qualityLayers', 'resolutionLevels'], None, [0, 0]),
    (['BasicDigitalObjectInformation', 'Compression'],
     ['compressionSchemeLocalList', 'compressionSchemeLocalValue'],
     ['compressionScheme', 'enumerated in local list'], [0, 0]),
    (['ImageAssessmentMetadata', 'SpatialMetrics'],
     ['xSamplingFrequency', 'ySamplingFrequency'],
     ['samplingFrequencyUnit', '2'], [0, 0]),
    (['ImageAssessmentMetadata', 'SpatialMetrics'],
     ['xSamplingFrequency', 'ySamplingFrequency'],
     ['samplingFrequencyUnit', '3'], [0, 0]),
    (['ImageAssessmentMetadata', 'ImageColorEncoding', 'GrayResponse'],
     ['grayResponseUnit'], ['grayResponseCurve', None], [0, 0])
])
def test_mix_optional_element_rules(
        schematron_fx, elementkey, subelements, condition, newfired):
    """Test for checks to elements that become mandatory when optional element
    has been used and optionally some condition in true.

    :schematron_fx: Schematron compile fixture
    :elementkey: Optional element
    :subelements: Subelement
    :condition: Element and value that is needed to make subelements mandatory
                If None, the subelement becomes mandatory with elementkey
    :newfired: Such errors that are expected to be generated, which are
               irrelevant in this test
    """
    (mix, root) = parse_xml_file('mix_valid_minimal.xml')
    found = root
    for iter_elem in elementkey:
        elem_handler = root.find_element(iter_elem, 'mix')
        if elem_handler is None:
            found = found.set_element(iter_elem, 'mix')
        else:
            found = elem_handler
    elem_handler = found
    if condition is not None:
        elem_condition = elem_handler.set_element(condition[0], 'mix')
        if condition[1] is not None:
            elem_condition.text = condition[1]
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == len(subelements) + newfired[0]

    for subelement in subelements:
        elem_handler.set_element(subelement, 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == newfired[1]


def test_icc_profile(schematron_fx):
    """ICC profile test. Color profile is required with ICC.

    :schematron_fx: Schematron compile fixture
    """
    (mix, root) = parse_xml_file('mix_valid_minimal.xml')
    elem_handler = root.find_element('colorSpace', 'mix')

    # ColorProfile missing
    for color in ['ICCLab', 'ICCBased']:
        elem_handler.text = color
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
        assert svrl.count(SVRL_FAILED) == 1

    # ColorProfile added
    make_colorprofile(root)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == 0


def test_palette_profile(schematron_fx):
    """Palette color profile test. Palettte requires Colormap.

    :schematron_fx: Schematron compile fixture
    """
    (mix, root) = parse_xml_file('mix_valid_minimal.xml')
    elem_handler = root.find_element('colorSpace', 'mix')
    elem_handler.text = 'PaletteColor'
    elem_handler = root.find_element('samplesPerPixel', 'mix')
    elem_handler.text = '1'

    # Colormap missing
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == 1

    # Colormap exists, but it requires a reference
    elem_handler = root.find_element('ImageColorEncoding', 'mix')
    elem_handler = elem_handler.set_element('Colormap', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == 1

    # Reference added
    elem_handler.set_element('colormapReference', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == 0


@pytest.mark.parametrize("colorparam, sampleparam", [
    ('WhiteIsZero', 1), ('BlackIsZero', 1), ('RGB', 3), ('CMYK', 4),
    ('YCbCr', 3), ('CIELab', 3), ('DeviceGray', 1), ('DeviceRGB', 3),
    ('DeviceCMYK', 4), ('CalGray', 1), ('Lab', 3), ('sRGB', 3), ('e-sRGB', 3),
    ('sYCC', 3), ('YCCK', 4), ('PaletteColor', 1), ('ICCLab', 3), ('CalRGB', 3)
])
def test_samples_per_pixel(schematron_fx, colorparam, sampleparam):
    """Color sample test with different color spaces. Different colorspaces
    require different number of samples. Extra samples are allowed iff defined
    in XML separately.

    :schematron_fx: Schematron compile fixture
    :colorsample_fx: Schematron fixture
    :colorparam: Color space name
    :sampleparam: Number of samples expected in the color space
    """

    # offset = -1: Less color samples than required
    # offset = 0: Required number of color samples
    # offset = 1: Extra color sample without extraSamples element
    for offset in [-1, 0, 1]:
        mix = make_colorsample(colorparam, sampleparam, offset, False)
        svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
        # missing or extra sample causes error
        assert svrl.count(SVRL_FAILED) == abs(offset)

    # Extra color sample with extraSamples element
    mix = make_colorsample(colorparam, sampleparam, 1, True)
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    if colorparam == 'PaletteColor':
        failures = 1  # extraSamples is not allowed with palette color space
    else:
        failures = 0  # otherwise everything should be ok
    assert svrl.count(SVRL_FAILED) == failures
