MOCK_CONFIG=stable-6-x86_64

test:
	echo '<testsuite tests="1"><testcase classname="none! name="DummyTest"/></testsuite>' > junit-preservation-schemas.xml

clean:
	rm -rf rpmbuild

rpm-sources:
	create-archive.sh
	preprocess-spec-m4-macros.sh include/rhel6

rpm-package:
	build-rpm.sh ${MOCK_CONFIG}

coverage:
	mkdir htmlcov
	touch htmlcov/index.html
	
rpm: rpm-sources rpm-package
