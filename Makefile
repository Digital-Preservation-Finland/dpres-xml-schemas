SHAREDIR=/usr/share/dpres-xml-schemas
XMLCATALOGDIR=/etc/xml/dpres-xml-schemas

all: info

info:
	@echo
	@echo "dpres-xml-schemas"
	@echo
	@echo "Usage:"
	@echo "  make test 			- Run all unit tests"
	@echo "  make install		- Install dpres-xml-schemas"
	@echo

install:
	# XML Schema catalogs
	mkdir -p "${XMLCATALOGDIR}/schema_catalogs"
	cp -r --preserve=timestamp xml_catalogs/* "${XMLCATALOGDIR}/schema_catalogs"
	rm -rf "${XMLCATALOGDIR}"/.git*

	# Common data files
	mkdir -p "${SHAREDIR}/schematron"
	cp -r --preserve=timestamp xml_schematron/mets/* "${SHAREDIR}/schematron"
	rm -rf "${SHAREDIR}"/.git*

	chmod -R 755 "${XMLCATALOGDIR}"
	find "${XMLCATALOGDIR}" -type f -exec chmod 644 \{\} \;
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

test:
	py.test --junitprefix=dpres-xml-schemas --junitxml=junit.xml tests

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
