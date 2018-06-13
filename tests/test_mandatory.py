"""Tests for mandatory element checks in METS, PREMIS, AudioMD, VideoMD and
MIX. This module tests only the minimum case inside a certain namespace.

.. seealso:: mets_internal.sch, mets_premis.sch, mets_avmd.sch, mets_mix.sch
"""

import pytest
from tests.common import SVRL_FIRED, SVRL_FAILED, parse_xml_file


@pytest.mark.parametrize("testset, namespace, filename, schfile", [
    ([(None, 10, 0), ('mets', 3, 6)], 'mets', 'mets_valid_minimal.xml',
     'mets_root.sch'),
    ([(None, 3, 0), ('agent', 3, 3), ('metsHdr', 2, 3)],
     'mets', 'mets_valid_minimal.xml', 'mets_metshdr.sch'),
    ([(None, 6, 0), ('mdWrap', 3, 0), ('dmdSec', 3, 3)],
     'mets', 'mets_valid_minimal.xml', 'mets_dmdsec.sch'),
    ([(None, 8, 0), ('digiprovMD', 8, 2), ('techMD', 8, 4),
      ('amdSec', 2, 2)], 'mets', 'mets_valid_minimal.xml', 'mets_amdsec.sch'),
    ([(None, 6, 0), ('structMap', 2, 1)],
     'mets', 'mets_valid_minimal.xml', 'mets_structmap.sch'),
    ([(None, 4, 0), ('techMD', 1, 1)],
     'mets', 'mets_valid_minimal.xml', 'mets_techmd.sch'),
    ([(None, 5, 0), ('digiprovMD', 1, 1)], 'mets', 'mets_valid_minimal.xml',
     'mets_digiprovmd.sch'),
    ([(None, 9, 3), ('mdWrap', 9, 5), ('mdWrap', 9, 5), ('mdWrap', 9, 5)],
     'mets', 'mets_valid_minimal.xml', 'mets_mdwrap.sch'),
    ([(None, 8, 0), ('creatingApplication', 8, 1), ('format', 6, 2),
      ('objectCharacteristics', 3, 2)], 'premis', 'premis_valid_minimal.xml',
     'mets_premis_techmd.sch'),
    ([(None, 4, 0), ('compression', 4, 4), ('audioInfo', 4, 6),
      ('fileData', 3, 8), ('AUDIOMD', 1, 2)], 'audiomd',
     'audiomd_valid_minimal.xml', 'mets_audiomd.sch'),
    ([(None, 4, 0), ('frame', 4, 4), ('compression', 4, 8),
      ('fileData', 2, 11), ('VIDEOMD', 1, 1)], 'videomd',
     'videomd_valid_minimal.xml', 'mets_videomd.sch'),
    ([(None, 10, 0), ('BitsPerSample', 10, 2),
      ('PhotometricInterpretation', 9, 3), ('ImageColorEncoding', 8, 3),
      ('BasicImageCharacteristics', 7, 5), ('Compression', 7, 6),
      ('ImageAssessmentMetadata', 6, 5), ('BasicImageInformation', 5, 3),
      ('BasicDigitalObjectInformation', 4, 3), ('mix', 1, 3)], 'mix',
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
        svrl = schematron_fx(schematronfile=schfile, xmltree=mets, params=False)
        assert svrl.count(SVRL_FIRED) == fired
        assert svrl.count(SVRL_FAILED) == failed

        svrl = schematron_fx(schematronfile=schfile, xmltree=mets)
        assert svrl.count(SVRL_FAILED) == failed
