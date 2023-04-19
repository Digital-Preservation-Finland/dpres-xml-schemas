%define file_prefix M4_FILE_PREFIX
%define file_ext M4_FILE_EXT

%define file_version M4_FILE_VERSION
%define file_release_tag %{nil}M4_FILE_RELEASE_TAG
%define file_release_number M4_FILE_RELEASE_NUMBER
%define file_build_number M4_FILE_BUILD_NUMBER
%define file_commit_ref M4_FILE_COMMIT_REF

Name:       
Version:    %{file_version}
Release:    %{file_release_number}%{file_release_tag}.%{file_build_number}.git%{file_commit_ref}%{?dist}
Summary:    
Group:

License:    LGPLv3+
URL:        https://www.digitalpreservation.fi/
Source0:    %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}.%{file_ext}

BuildArch:  noarch

BuildRequires:


%global _description %{expand:
python3-... tools
}

%description %_description

%package -n python3-...
Summary:    %{summary}
Requires:
%description -n python3-... %_description

%prep
%autosetup -n %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}

%build
%pyproject_wheel

%install
%pyproject_install
%pyproject_save_files

%files -n python3-... -f %{pyproject_files}
%license LICENSE
%doc README.rst

%changelog
