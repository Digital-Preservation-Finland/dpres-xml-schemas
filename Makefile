PREFIX=/usr
ROOT=
SOURCE=iso-schematron-xslt1
SHAREDIR=${ROOT}${PREFIX}/share/${SOURCE}

install:
	mkdir -p "${SHAREDIR}"
	cp -r "${SOURCE}"/* "${SHAREDIR}/"
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;
