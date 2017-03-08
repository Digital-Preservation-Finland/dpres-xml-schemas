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
    ('ObjectIdentifier', ['objectIdentifierType', 'objectIdentifierValue'],
     None, 0),
    ('FormatDesignation', ['formatName'], None, 0),
    ('Fixity', ['messageDigestAlgorithm', 'messageDigest'], None, 0),
    ('YCbCr', ['YCbCrSubSampling', 'yCbCrPositioning', 'YCbCrCoefficients',
               'ReferenceBlackWhite'], None, 6),
    ('YCbCrSubSampling', ['yCbCrSubsampleHoriz', 'yCbCrSubsampleVert'], None,
     0),
    ('YCbCrCoefficients', ['lumaRed', 'lumaGreen', 'lumaBlue'], None, 0),
    ('ReferenceBlackWhite', ['Component'], None, 0),
    ('ColorProfile', ['LocalProfile'], None, 1),
    ('ColorProfile', ['IccProfile'], None, 1),
    ('LocalProfile', ['localProfileName'], None, 0),
    ('IccProfile', ['iccProfileName'], None, 0),
    ('IccProfile', ['iccProfileURI'], None, 0),
    ('JPEG2000', ['EncodingOptions'], None, 2),
    ('EncodingOptions', ['qualityLayers', 'resolutionLevels'], None, 0),
    ('Compression', ['compressionSchemeLocalList',
                     'compressionSchemeLocalValue'],
     ['compressionScheme', 'enumerated in local list'], 0),
    ('SpatialMetrics', ['xSamplingFrequency', 'ySamplingFrequency'],
     ['samplingFrequencyUnit', '2'], 0),
    ('SpatialMetrics', ['xSamplingFrequency', 'ySamplingFrequency'],
     ['samplingFrequencyUnit', '3'], 0),
    ('GrayResponse', ['grayResponseUnit'], ['grayResponseCurve', None], 0)
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
    elem_handler = root.find_element(elementkey, 'mix')
    if elem_handler is None:
        elem_handler = root.find_element('mix', 'mix')
        elem_handler = elem_handler.set_element(elementkey, 'mix')
    if condition is not None:
        elem_condition = elem_handler.set_element(condition[0], 'mix')
        if condition[1] is not None:
            elem_condition.text = condition[1]
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == len(subelements)

    for subelement in subelements:
        elem_handler.set_element(subelement, 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mix)
    assert svrl.count(SVRL_FAILED) == newfired


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


def test_mix_with_jp2(schematron_fx):
    """Test with JPEG2000 file format and MIX. JPEG2000 requires extra section.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_mix.xml')

    # Works, when format is PNG
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # Extra elements are required with JPEG2000
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/jp2'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 2

    # SpecialFormatCharacteristics added, still requires JPEG2000 element
    elem_handler = root.find_element('BasicImageInformation', 'mix')
    elem_handler = elem_handler.set_element(
        'SpecialFormatCharacteristics', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # JPEG2000 added
    xml = '''<mix:JPEG2000 xmlns:mix="%(mix)s"><mix:EncodingOptions>
               <mix:qualityLayers>4</mix:qualityLayers>
               <mix:resolutionLevels>4</mix:resolutionLevels>
             </mix:EncodingOptions></mix:JPEG2000>'''
    elem_handler.append(ET.XML(xml % NAMESPACES))
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # JPEG2000 element is disallowed with other file formats
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/png'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1


def test_mix_with_tiff_dpx(schematron_fx):
    """Test with tiff and dpx file formats and MIX. These require byteOrder.

    :schematron_fx: Schematron compile fixture
    """
    (mets, root) = parse_xml_file('mets_valid_mix.xml')

    # Works, when format is PNG
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # byteOrder missing with TIFF
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder missing with DPX
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/x-dpx'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 1

    # byteOrder added, success with DPX
    elem_handler = root.find_element('BasicDigitalObjectInformation', 'mix')
    elem_handler.set_element('byteOrder', 'mix')
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0

    # byteOrder added, success with TIFF
    elem_handler = root.find_element('formatName', 'premis')
    elem_handler.text = 'image/tiff'
    svrl = schematron_fx(schematronfile=SCHFILE, xmltree=mets)
    assert svrl.count(SVRL_FAILED) == 0
