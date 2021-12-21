"""Fixtures for Schematron compilation and schema catalog tests"""

import subprocess
import os
import hashlib
import shutil
import tempfile
import pytest

SCH_DIRECTORY = os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..', 'schematron'))
ISO_DIRECTORY = '/usr/share/iso_schematron_xslt1'
CATALOG_DIRECTORY = os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..', 'schema_catalogs'))
SCHEMA_DIRECTORY = os.path.abspath(
    os.path.join(os.path.dirname(__file__),
                 '..', 'schema_catalogs', 'schemas'))
CACHE_DIRECTORY = os.path.expanduser('~/.dpres-xml-schemas/schematron-cache')


# TODO: Could use file-scraper


@pytest.fixture(scope='session', autouse=True)
def schematron_fx(request):
    """Compiles all schematron files and makes the actual schematron validation
    for all tests.

    :request: Pytest request fixture
    :returns: Schematron validation result
    """
    def _fin():
        """Finalize fixture, remove temp directory
        """
        if os.path.isdir(tmp_directory):
            shutil.rmtree(tmp_directory)

    def _validate_schematron(schematronfile=None, xmltree=None, params=True):
        """Schematron validation for a given XML tree.

        :schematronfile: Schematron filename
        :xmltree: XML element tree to be validated
        :returns: Validation result in SVRL XML string
        """
        if not schematronfile:
            return None
        if not xmltree:
            return None

        xmlfile = os.path.join(tmp_directory, 'xmltree_schematron.xml')
        xmltree.write(xmlfile)
        if params:
            ps = subprocess.Popen(['xsltproc', os.path.join(CACHE_DIRECTORY, schematronfile+'.xsl'),
                 xmlfile], stdout=subprocess.PIPE)
            svrl = subprocess.check_output(['xsltproc',
                 os.path.join(ISO_DIRECTORY, 'trim_optimized_result.xsl'), '-'], stdin=ps.stdout)
        else:
            svrl = subprocess.check_output(
                ['xsltproc', os.path.join(CACHE_DIRECTORY, schematronfile+'_full.xsl'),
                 xmlfile])
        os.remove(os.path.join(tmp_directory, 'xmltree_schematron.xml'))
        return svrl

    def _compilestep(isofile, infile, outfile, params):
        """Makes one xslt processor step in schematron compilation.

        :isofile: ISO Schematron xsl file, given as filename
        :infile: File to be compiled, given as path
        :outfile: Result file to be generated, given as filename
        """
        if params:
            step = subprocess.check_output(
                ['xsltproc', '--stringparam', 'outputfilter', 'only_messages', os.path.join(ISO_DIRECTORY, isofile), infile])
        else:
            step = subprocess.check_output(
                ['xsltproc', os.path.join(ISO_DIRECTORY, isofile), infile])
        with open(os.path.join(outfile), 'w') as stepfile:
            stepfile.write(step)

    tmp_directory = tempfile.mkdtemp()
    request.addfinalizer(_fin)

    # Compile all Schematron files, if not cached
    if not os.path.isdir(CACHE_DIRECTORY):
        os.makedirs(CACHE_DIRECTORY)

    hash_md5_abstracts = hashlib.md5()
    for inclfile in os.listdir(os.path.join(SCH_DIRECTORY,'abstracts')):
        if inclfile.endswith('.incl'):
            incl_path = os.path.join(SCH_DIRECTORY, 'abstracts', inclfile)
            with open(incl_path, "rb") as incl_stream:
                for chunk in iter(lambda s=incl_stream: s.read(1024 * 1024),
                                  b""):
                    hash_md5_abstracts.update(chunk)
    abstracts_hash = hash_md5_abstracts.hexdigest().encode('utf-8')
    hash_md5_xslt = hashlib.md5()
    for xslfile in os.listdir(os.path.join(ISO_DIRECTORY)):
        if xslfile.endswith('*.xsl'):
            xsl_path = os.path.join(ISO_DIRECTORY, xslfile)
            with open(xsl_path, "rb") as xsl_stream:
                for chunk in iter(lambda s=xsl_stream: s.read(1024 * 1024),
                                  b""):
                    hash_md5_xslt.update(chunk)
    xslt_hash = hash_md5_abstracts.hexdigest().encode('utf-8')
    for schfile in os.listdir(SCH_DIRECTORY):
        if schfile.endswith('.sch'):
            sch_path = os.path.join(SCH_DIRECTORY, schfile)
            hash_md5 = hashlib.md5()
            with open(sch_path, "rb") as sch_stream:
                for chunk in iter(lambda s=sch_stream: s.read(1024 * 1024),
                                  b""):
                    hash_md5.update(chunk)
            hash_md5.update(abstracts_hash)
            hash_md5.update(xslt_hash)
            sch_hash = hash_md5.hexdigest()
            sch_cache_path = os.path.join(
                CACHE_DIRECTORY, sch_hash+'_'+schfile)

            # Skip compilation, if already cached
            if os.path.isfile(sch_cache_path):
                continue

            # Compile to cache
            _compilestep(
                'iso_dsdl_include.xsl', sch_path,
                os.path.join(tmp_directory, 'step1.sch'), False)
            _compilestep(
                'iso_abstract_expand.xsl',
                os.path.join(tmp_directory, 'step1.sch'),
                os.path.join(tmp_directory, 'step2.sch'), False)
            _compilestep(
                'optimize_schematron.xsl',
                os.path.join(tmp_directory, 'step2.sch'),
                os.path.join(tmp_directory, 'step3.sch'), False)
            _compilestep(
                'iso_svrl_for_xslt1.xsl',
                os.path.join(tmp_directory, 'step3.sch'),
                os.path.join(CACHE_DIRECTORY, schfile+'.xsl'), True)
            _compilestep(
                'iso_svrl_for_xslt1.xsl',
                os.path.join(tmp_directory, 'step3.sch'),
                os.path.join(CACHE_DIRECTORY, schfile+'_full.xsl'), False)

            # After compiling a file, we'll cache the schecksum of sch file
            open(sch_cache_path, 'w').close()
            # Remove all old cached schematron files
            for entry in os.listdir(CACHE_DIRECTORY):
                if entry.endswith(schfile) and not entry.startswith(sch_hash):
                    os.remove(os.path.join(CACHE_DIRECTORY, entry))

    return _validate_schematron


@pytest.fixture(scope='session')
def catalog_fx(request):
    """Makes the actual schema catalog validation for all tests.

    :request: Pytest request fixture
    :returns: Schema validation result
    """
    def _fin():
        """Finalize fixture, remove temp directory
        """
        if os.path.isdir(tmp_directory):
            shutil.rmtree(tmp_directory)

    def _validate_catalog(xmltree=None):
        """Schema catalog validation for a given XML tree.

        :xmltree: XML element tree to be validated
        :returns: Validation result in SVRL XML string
        """
        if not xmltree:
            return None

        xmlfile = os.path.join(tmp_directory, 'xmltree_catalog.xml')
        xmltree.write(xmlfile)
        proc = subprocess.Popen(
            ['xmllint', '--huge', '--nonet', '--noout',
             '--catalogs', '--nowarning', '--schema',
             os.path.join(SCHEMA_DIRECTORY, 'mets', 'mets.xsd'),
             xmlfile],
            env={'SGML_CATALOG_FILES':
                 os.path.join(CATALOG_DIRECTORY, 'catalog_main.xml')},
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
        (stdout, stderr) = proc.communicate()
        returncode = proc.returncode

        return (returncode, stdout, stderr)

    tmp_directory = tempfile.mkdtemp()
    request.addfinalizer(_fin)

    return _validate_catalog
