SHAREDIR=/usr/share/dpres-xml-schemas
XMLCATALOGDIR=/etc/xml/dpres-xml-schemas

PYTHON=python3


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
	cp -r --preserve=timestamp schema_catalogs/* "${XMLCATALOGDIR}/schema_catalogs"
	rm -rf "${XMLCATALOGDIR}"/.git*

	# Common data files
	mkdir -p "${SHAREDIR}/preservation_schemas"
	cp -r ingest_report/* "${SHAREDIR}/preservation_schemas"

	mkdir -p "${SHAREDIR}/schematron"
	cp -r --preserve=timestamp schematron/* "${SHAREDIR}/schematron"
	rm -rf "${SHAREDIR}"/.git*

	chmod -R 755 "${XMLCATALOGDIR}"
	find "${XMLCATALOGDIR}" -type f -exec chmod 644 \{\} \;
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

test:
	${PYTHON} -m pytest tests --junitprefix=dpres-xml-schemas --junitxml=junit.xml

docs:
	make -C doc html
	make -C doc pdf

docserver:
	make -C doc docserver

killdocserver:
	make -C doc killdocserver

clean: clean-rpm
	find . -iname '*.pyc' -type f -delete
	find . -iname '__pycache__' -exec rm -rf '{}' \; | true

clean-rpm:
	rm -rf rpmbuild

