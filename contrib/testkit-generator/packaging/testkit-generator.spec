Name:       	testkit-generator
Version:   		1.0.0
Release:    	0
License:    	GPL-2.0
Summary:  		Testkit generator
Group:      	Development/Testing
Source:     	%{name}-%{version}.tar.gz
Source1001: 	%{name}.manifest
BuildRequires:  fdupes
Requires:   	nodejs


%description

A tool to generate a testkit xml file based on json metadata files located
in a directory tree.


%prep
%setup -q
cp %{SOURCE1001} .


%build


%install
install -d %{buildroot}/%{_bindir}
install -d %{buildroot}/%{_prefix}/lib/node
install -m 0755 %{name} %{buildroot}/%{_bindir}
cp -r node_modules/* %{buildroot}/%{_prefix}/lib/node

fdupes %{buildroot}


%files
%manifest %{name}.manifest
%defattr(-,root,root)
%license LICENSE
%{_bindir}/testkit-generator
%{_prefix}/lib/node/*
