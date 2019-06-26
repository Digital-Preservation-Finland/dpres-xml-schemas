"""Test that all schematrons are valid"""
import pytest
import lxml.etree as ET
from lxml.isoschematron import Schematron


@pytest.mark.parametrize("schematron", [
    'schematron/mets_addml.sch',
    'schematron/mets_amdsec.sch',
    'schematron/mets_audiomd.sch',
    'schematron/mets_digiprovmd.sch',
    'schematron/mets_dmdsec.sch',
    'schematron/mets_ead3.sch',
    'schematron/mets_filesec.sch',
    'schematron/mets_mdwrap.sch',
    'schematron/mets_metshdr.sch',
    'schematron/mets_mix.sch',
    'schematron/mets_mods.sch',
    'schematron/mets_premis_digiprovmd.sch',
    'schematron/mets_premis_rightsmd.sch',
    'schematron/mets_premis.sch',
    'schematron/mets_premis_techmd.sch',
    'schematron/mets_rightsmd.sch',
    'schematron/mets_root.sch',
    'schematron/mets_sourcemd.sch',
    'schematron/mets_structmap.sch',
    'schematron/mets_techmd.sch',
    'schematron/mets_videomd.sch'
])
def test_schematron_validation(schematron):
    """Test that the schematron is valid."""
    Schematron(ET.parse(schematron))
