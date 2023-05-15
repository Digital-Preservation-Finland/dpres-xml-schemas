# vim:ft=spec

%define file_prefix M4_FILE_PREFIX
%define file_ext M4_FILE_EXT

%define file_version M4_FILE_VERSION
%define file_release_tag %{nil}M4_FILE_RELEASE_TAG
%define file_release_number M4_FILE_RELEASE_NUMBER
%define file_build_number M4_FILE_BUILD_NUMBER
%define file_commit_ref M4_FILE_COMMIT_REF

Name:           dpres-xml-schemas
Version:        %{file_version}
Release:        %{file_release_number}%{file_release_tag}.%{file_build_number}.git%{file_commit_ref}%{?dist}
Summary:        XML schema catalogs and schematron rules
Group:          System Environment/Library
License:        LGPLv3+
URL:            https://www.digitalpreservation.fi
Source0:        %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}.%{file_ext}
BuildArch:      noarch

Requires:       xml-common
Requires:       iso-schematron-xslt1
Requires:       libxslt
BuildRequires:  make
BuildRequires:  python3
BuildRequires:  %{py3_dist lxml}
BuildRequires:  %{py3_dist six}


%description
XML schema catalogs and schematron rules.


%prep
%autosetup -n %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}


%build
# do nothing


%install
SHAREDIR=%{buildroot}/%{_datadir}/dpres-xml-schemas/preservation_schemas
# Common data files
[ -d "${SHAREDIR}" ] || mkdir -p "${SHAREDIR}"

mkdir -p "${SHAREDIR}"
cp -r ingest_report/* "${SHAREDIR}/"

chmod -R 755 "${SHAREDIR}"
find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

make install XMLCATALOGDIR=%{buildroot}%{_sysconfdir}/xml/%{name} SHAREDIR=%{buildroot}%{_datadir}/%{name}


%post
# Remove obsolete XML schema entry
%{_bindir}/xmlcatalog --noout --del \
"/etc/xml/information-package-tools/digital-object-catalog/digital-object-catalog.xml" \
/etc/xml/catalog
# Remove any duplicates
%{_bindir}/xmlcatalog --noout --del \
"/etc/xml/dpres-xml-schemas/schema_catalogs/catalog_main.xml" \
/etc/xml/catalog
# Add our catalogs to the system centralised catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/dpres-xml-schemas/schema_catalogs/catalog_main.xml" \
/etc/xml/catalog


%postun
# When the package is uninstalled, remove the catalogs
if [ "$1" = 0 ]; then
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/dpres-xml-schemas/schema_catalogs/catalog_main.xml" \
  /etc/xml/catalog
fi


%files
%{_datadir}/dpres-xml-schemas
%{_sysconfdir}/xml/dpres-xml-schemas


# TODO: For now changelot must be last, because it is generated automatically
# from git log command. Appending should be fixed to happen only after %changelog macro
%changelog
