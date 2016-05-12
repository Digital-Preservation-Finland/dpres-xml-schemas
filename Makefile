MOCK_CONFIG=stable-6-x86_64

test:
	true

clean:
	rm -rf rpmbuild

rpm: clean
	create-archive.sh
	preprocess-spec-m4-macros.sh include/rhel6
	build-rpm.sh ${MOCK_CONFIG}
