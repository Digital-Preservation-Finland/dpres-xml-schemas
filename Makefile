PREFIX=/usr
ROOT=
PYROOT=${ROOT}/
ETC=${ROOT}/etc
ETCMONGO=${ROOT}/etc/mongodb
SHAREDIR=${ROOT}${PREFIX}/share/preservation-schemas
PYTHONDIR=${ROOT}${PREFIX}/lib/python2.6/site-packages
SHELLDIR=${ROOT}${PREFIX}/bin


all: info

info:
		@echo
		@echo "Digital preservation Premis-report validation schemas"
		@echo
		@echo "Usage:"
		@echo "  make install           - Install preservation-schemas"
		@echo 

install:
		# Cleanup temporary files
		rm -f INSTALLED_FILES
		rm -f INSTALLED_FILES.in

		# Common data files
		[ -d "${SHAREDIR}" ] || mkdir -p "${SHAREDIR}"

		mkdir -p "${SHAREDIR}"
		cp -r include/share/* "${SHAREDIR}/"

		chmod -R 755 "${SHAREDIR}"
		find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

		# SIP_python package is using Python setuptools
		python setup.py build ; python ./setup.py install -O1 --prefix="${PREFIX}" --root="${PYROOT}" --record=INSTALLED_FILES.in
		cat INSTALLED_FILES.in | sed 's/^/\//g' >> INSTALLED_FILES
		echo "-- INSTALLED_FILES"
		cat INSTALLED_FILES
		echo "--"

post_install:
		"${SHAREDIR}/post_install.sh"
