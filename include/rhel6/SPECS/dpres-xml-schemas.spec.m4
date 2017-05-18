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
License:        LGPLv3
URL:            http://www.csc.fi
Source0:        %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}.%{file_ext}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch

Requires: python xml-common
Requires: libxslt python-setuptools
BuildRequires:	pytest

%description
XML schema catalogs and schematron rules.

%prep
find %{_sourcedir}
%setup -n %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}

%build
# do nothing

%install
PREFIX=/usr
ROOT=
SHAREDIR=${ROOT}${PREFIX}/share/dpres-xml-schemas/preservation_schemas
# Common data files
[ -d "%{buildroot}/${SHAREDIR}" ] || mkdir -p "%{buildroot}/${SHAREDIR}"

mkdir -p "%{buildroot}/${SHAREDIR}"
cp -r preservation_schemas/* "%{buildroot}/${SHAREDIR}/"

chmod -R 755 "%{buildroot}/${SHAREDIR}"
find "%{buildroot}/${SHAREDIR}" -type f -exec chmod 644 \{\} \;

make install PREFIX="%{_prefix}" ROOT="%{buildroot}"
echo "-- INSTALLED_FILES"
cat INSTALLED_FILES
echo "--"

%post
# Add our catalogs to the system centralised catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/dpres-xml-schemas/xml_catalogs/digital_object_catalog.xml" \
/etc/xml/catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/dpres-xml-schemas/xml_catalogs/mets_catalog.xml" \
/etc/xml/catalog

%postun
# When the package is uninstalled, remove the catalogs
if [ "$1" = 0 ]; then
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/dpres-xml-schemas/xml_catalogs/digital_object_catalog.xml" \
  /etc/xml/catalog
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/dpres-xml-schemas/xml_catalogs/mets_catalog.xml" \
  /etc/xml/catalog
fi

%clean

%files -f INSTALLED_FILES
%defattr(-,root,root,-)
/usr/share/dpres-xml-schemas
/etc/xml/dpres-xml-schemas

# TODO: For now changelot must be last, because it is generated automatically
# from git log command. Appending should be fixed to happen only after %changelog macro
%changelog

