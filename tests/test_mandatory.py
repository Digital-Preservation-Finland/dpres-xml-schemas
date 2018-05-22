"""Tests for mandatory element checks in METS, PREMIS, AudioMD, VideoMD and
MIX. This module tests only the minimum case inside a certain namespace.

.. seealso:: mets_internal.sch, mets_premis.sch, mets_avmd.sch, mets_mix.sch
"""

import pytest
from tests.common import SVRL_FIRED, SVRL_FAILED, parse_xml_file


@pytest.mark.parametrize("testset, namespace, filename, schfile", [
    ([(None, 19, 0), ('mets', 12, 6)], 'mets', 'mets_valid_minimal.xml',
     'mets_root.sch'),
    ([(None, 7, 0), ('agent', 7, 3), ('metsHdr', 5, 3)],
     'mets', 'mets_valid_minimal.xml', 'mets_metshdr.sch'),
    ([(None, 11, 0), ('mdWrap', 6, 0), ('dmdSec', 6, 3)],
     'mets', 'mets_valid_minimal.xml', 'mets_dmdsec.sch'),
    ([(None, 11, 0), ('digiprovMD', 11, 2), ('techMD', 11, 4),
      ('amdSec', 3, 2)], 'mets', 'mets_valid_minimal.xml', 'mets_amdsec.sch'),
    ([(None, 8, 0), ('structMap', 4, 1)],
     'mets', 'mets_valid_minimal.xml', 'mets_structmap.sch'),
    ([(None, 8, 0), ('techMD', 2, 1)],
     'mets', 'mets_valid_minimal.xml', 'mets_techmd.sch'),
    ([(None, 8, 0), ('digiprovMD', 1, 1)], 'mets', 'mets_valid_minimal.xml',
     'mets_digiprovmd.sch'),
    ([(None, 24, 3), ('mdWrap', 24, 5), ('mdWrap', 24, 5), ('mdWrap', 24, 5)],
     'mets', 'mets_valid_minimal.xml', 'mets_mdwrap.sch'),
    ([(None, 9, 0), ('creatingApplication', 9, 1), ('format', 7, 2),
      ('objectCharacteristics', 4, 2)], 'premis', 'premis_valid_minimal.xml',
     'mets_premis_techmd.sch'),
    ([(None, 14, 0), ('compression', 14, 4), ('audioInfo', 14, 6),
      ('fileData', 10, 8), ('AUDIOMD', 2, 2)], 'audiomd',
     'audiomd_valid_minimal.xml', 'mets_audiomd.sch'),
    ([(None, 20, 0), ('frame', 20, 4), ('compression', 20, 8),
      ('fileData', 12, 11), ('VIDEOMD', 1, 1)], 'videomd',
     'videomd_valid_minimal.xml', 'mets_videomd.sch'),
    ([(None, 16, 0), ('BitsPerSample', 16, 2),
      ('PhotometricInterpretation', 15, 3), ('ImageColorEncoding', 13, 3),
      ('BasicImageCharacteristics', 12, 5), ('Compression', 12, 6),
      ('ImageAssessmentMetadata', 10, 5), ('BasicImageInformation', 7, 3),
      ('BasicDigitalObjectInformation', 6, 3), ('mix', 3, 3)], 'mix',
     'mix_valid_minimal.xml', 'mets_mix.sch')
])
def test_mandatory_elements(
        schematron_fx, testset, namespace, filename, schfile):
    """Test mandatory element checks for metadata. Here we practically give a
    minimal XML, which is valid in a certain namespace. Then we start to remove
    elements from it one by one (until nothing remains). With every loop the
    number of fired schematron rules and failures are different. Since the
    next loop is dependent on the previous loop, the whole looping is done
    inside one test run.

    :schematron_fx: Schematron compile fixture
    :testset: A list of tuples containing the element to be removed, number of
              expected schematron checks, and number of expected failures.
    :namespace: Namespace key, where the test is done.
    :filename: File name containing the valid minimal METS
    :schfile: Schematron file to use in the test
    """
    (mets, root) = parse_xml_file(filename)
    for testcase in testset:
        (leafelement, fired, failed) = testcase
        if leafelement is not None:
            elem_handler = root.find_element(leafelement, namespace)
            elem_handler.clear()
        svrl = schematron_fx(schematronfile=schfile, xmltree=mets)
        assert svrl.count(SVRL_FIRED) == fired
        assert svrl.count(SVRL_FAILED) == failed
