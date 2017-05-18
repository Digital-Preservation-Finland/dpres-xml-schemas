# vim:ft=spec

%define file_prefix M4_FILE_PREFIX
%define file_ext M4_FILE_EXT

%define file_version M4_FILE_VERSION
%define file_release_tag %{nil}M4_FILE_RELEASE_TAG
%define file_release_number M4_FILE_RELEASE_NUMBER
%define file_build_number M4_FILE_BUILD_NUMBER
%define file_commit_ref M4_FILE_COMMIT_REF

Name:           preservation-schemas
Version:        %{file_version}
Release:        %{file_release_number}%{file_release_tag}.%{file_build_number}.git%{file_commit_ref}%{?dist}
Summary:        Premis report valdiation schemas for PAS-system
Group:          XML-schemas
License:        AGPL
URL:            http://www.csc.fi
Source0:        %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}.%{file_ext}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch


%description
Premis report valdiation schemas for PAS-system.

%prep
find %{_sourcedir}
%setup -n %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}

%build

%install
PREFIX=/usr
ROOT=
SHAREDIR=${ROOT}${PREFIX}/share/preservation-schemas
# Common data files
[ -d "%{buildroot}/${SHAREDIR}" ] || mkdir -p "%{buildroot}/${SHAREDIR}"

mkdir -p "%{buildroot}/${SHAREDIR}"
cp -r ingest-report/* "%{buildroot}/${SHAREDIR}/"

chmod -R 755 "%{buildroot}/${SHAREDIR}"
find "%{buildroot}/${SHAREDIR}" -type f -exec chmod 644 \{\} \;

%post

%clean

%files
%defattr(-,root,root,-)
/usr/share/preservation-schemas/*

# TODO: For now changelog must be last, because it is generated automatically
# from git log command. Appending should be fixed to happen only after %changelog macro
%changelog



