#-----------------------------------------------------------
# elite2
# Plugin to detect presence of EliteKeylogger in System hive
#
# Change History:
#   20091119 - created
#
# References:
#   http://www.symantec.com/security_response/writeup.jsp?docid=2005-071414-1428-99&tabid=2
#
# copyright 2009 H. Carvey, keydet89@yahoo.com
#-----------------------------------------------------------
package elite2;
use strict;

my %config = (hive          => "System",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20091119);

sub getConfig{return %config}
sub getShortDescr {
	return "Detect presence of Elite Keylogger in System hive";	
}
sub getDescr{}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	my $infected = 0;
	::logMsg("Launching elite2 v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
	my $curr;
	::rptMsg("elite1 - Check System hive for indication of Elite Keystroke");
	::rptMsg("logger.");
	::rptMsg("");
	if ($curr = $root_key->get_subkey("Select")->get_value("Current")->get_data()) {
		my $key_path = "ControlSet00".$curr."\\Control\\GroupOrderList";
		my $key;
		if ($key = $root_key->get_subkey($key_path)) {
			my $infected = 0;
			
			eval {
				$infected++ if (my $pnp = $key->get_value("PNP_TDI"));
				::rptMsg("PNP_TDI value found.");
			};
			
			eval {
				$infected++ if (my $filt = $key->get_value("Filter"));
				::rptMsg("Filter value found.");
			};
			
			if ($infected > 0) {
				::rptMsg("");
				::rptMsg($infected." of 2 checks indicate that the system may be infected");
				::rptMsg("with the EliteKeylogger.");
			}
		}
		else {
			::rptMsg($key_path." not found.");
		}
	}
	else {
		::rptMsg("Could not locate Select key or Current value.");
	}
}
1;