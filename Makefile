MOCK_CONFIG=stable-6-x86_64
ROOT=/
PREFIX=/usr
SHAREDIR=${PREFIX}/share/information-package-tools
XMLCATALOGDIR=/etc/xml/information-package-tools
PYTHONDIR=${PREFIX}/lib/python2.6/site-packages
SHELLDIR=${PREFIX}/bin

MODULES=fileutils mets schematron sip xml xmllint

all: info

info:
	@echo
	@echo "digital-object-catalog"
	@echo
	@echo "Usage:"
	@echo "  make test 			- Run all unit tests"
	@echo "  make install		- Install information-package-tools"
	@echo "  make devinstall	- Quick and Dirty development installation"
	@echo "  make install_deps	- Install required packages with yum"
	@echo

install:
	# Cleanup temporary files
	rm -f INSTALLED_FILES

	# XML Schema catalogs
	mkdir -p "${ROOT}${XMLCATALOGDIR}/digital-object-catalog"
	cp -r --preserve=timestamp digital_object_catalog/* "${ROOT}${XMLCATALOGDIR}/digital-object-catalog"
	rm -rf "${XMLCATALOGDIR}"/.git*

	chmod -R 755 "${ROOT}${XMLCATALOGDIR}"
	find "${ROOT}${XMLCATALOGDIR}" -type f -exec chmod 644 \{\} \;
	chmod -R 755 "${ROOT}${SHAREDIR}"
	find "${ROOT}${SHAREDIR}" -type f -exec chmod 644 \{\} \;

	# write version module
	#python version.py > "kdk_mets_catalog/version.py"

	# Use Python setuptools
	python setup.py build ; python ./setup.py install -O1 --prefix="${PREFIX}" --root="${ROOT}" --record=INSTALLED_FILES
	cat INSTALLED_FILES | sed 's/^/\//g' >> INSTALLED_FILES

	# setup.py seems to be unable to create directories,
	# create them here if needed

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip
	
test:
	echo '<testsuite tests="1"><testcase classname="none" name="DummyTest"/></testsuite>' > digital-object-catalog.xml

docs:
	make -C doc html
	make -C doc pdf

docserver:
	make -C doc docserver

killdocserver:
	make -C doc killdocserver

coverage:
	mkdir htmlcov
	touch htmlcov/index.html

clean: clean-rpm
	find . -iname '*.pyc' -type f -delete
	find . -iname '__pycache__' -exec rm -rf '{}' \; | true

clean-rpm:
	rm -rf rpmbuild

rpm: clean-rpm
	create-archive.sh
	preprocess-spec-m4-macros.sh include/rhel6
	build-rpm.sh ${MOCK_CONFIG}
