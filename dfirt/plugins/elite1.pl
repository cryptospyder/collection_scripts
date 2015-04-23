#-----------------------------------------------------------
# elite1
# Plugin to detect presence of EliteKeylogger in Software hive
#
# Change History:
#   20091119 - created
#
# References:
#   http://www.symantec.com/security_response/writeup.jsp?docid=2005-071414-1428-99&tabid=2
#
# copyright 2009 H. Carvey, keydet89@yahoo.com
#-----------------------------------------------------------
package elite1;
use strict;

my %config = (hive          => "Software",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20091119);

sub getConfig{return %config}
sub getShortDescr {
	return "Detect presence of Elite Keylogger in Software hive";	
}
sub getDescr{}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	my $infected = 0;
	::logMsg("Launching elite1 v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
	my $key_path = 'Licenses';
	my $key;
	::rptMsg("elite1 - Check Software hive for indication of Elite Keystroke");
	::rptMsg("logger.");
	::rptMsg("");
	::rptMsg("Check 1");
	if ($key = $root_key->get_subkey($key_path)) {
		$infected++;
		::rptMsg("");
		::rptMsg($key_path);
		::rptMsg("LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
		::rptMsg("");
		my @vals = $key->get_list_of_values();
		if (scalar(@vals) > 0) {
			foreach my $v (@vals) {
				::rptMsg("  ".$v->get_name());
			}
		}
		else {
			::rptMsg($key_path." has no values.");
		}
	}
	else {
		::rptMsg($key_path." not found.");
		::rptMsg("");
	}
	
	my $key_path = 'Microsoft\\RFC1156Agent';
	my $key;
	::rptMsg("Check 2");
	if ($key = $root_key->get_subkey($key_path)) {
		$infected++;
		::rptMsg("");
		::rptMsg($key_path);
		::rptMsg("LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
		::rptMsg("");
	}
	else {
		::rptMsg($key_path." not found.");
	}
	
	my $key_path = 'Classes\\CLSID\\{0A252B94-2FCD-BBF8-8ADD-AA019F83938E}';
	my $key;
	::rptMsg("Check 3");
	if ($key = $root_key->get_subkey($key_path)) {
		$infected++;
		::rptMsg("");
		::rptMsg($key_path);
		::rptMsg("LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
	}
	else {
		::rptMsg($key_path." not found.");
	}
	
	if ($infected > 0) {
		::rptMsg("");
		::rptMsg($infected." of 3 checks indicate the system may be infected");
		::rptMsg("with EliteKeylogger.");
	}
	
}
1;