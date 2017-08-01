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
	cp -r --preserve=timestamp schema_catalogs/* "${XMLCATALOGDIR}/schema_catalogs"
	rm -rf "${XMLCATALOGDIR}"/.git*

	# Common data files
	mkdir -p "${SHAREDIR}/schematron"
	cp -r --preserve=timestamp schematron/* "${SHAREDIR}/schematron"
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
	preprocess-spec-m4-macros.sh include/rhel7
	build-rpm.sh ${MOCK_CONFIG}

e2e-localhost-cleanup: .e2e/ansible-fetch
	cd .e2e/ansible ; ansible-playbook -i inventory/localhost e2e-pre-test-cleanup.yml

.e2e/ansible:
	git clone https://source.csc.fi/scm/git/pas/ansible-preservation-system .e2e/ansible

.e2e/ansible-fetch: .e2e/ansible
	cd .e2e/ansible ; \
		git fetch ; \
		git checkout master ; \
		git reset --hard origin/master ; \
		git clean -fdx ; \
		git status
