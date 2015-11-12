test:
	true

rpm:
	rm -rf rpmbuild
	[ -d include/rhel6/SOURCES ] || mkdir -p include/rhel6/SOURCES
	build-rpm.sh include/rhel6
