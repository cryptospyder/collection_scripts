#-----------------------------------------------------------
# termserv.pl
# Plugin for Registry Ripper; 
# 
# Change history
#   20100119 - updated
#   20090727 - created
#
# References
#   Change TS listening port number - http://support.microsoft.com/kb/187623
#   Examing TS key - http://support.microsoft.com/kb/243215
#   Win2K8 TS stops listening - http://support.microsoft.com/kb/954398
#   XP/Win2K3 TSAdvertise value - http://support.microsoft.com/kb/281307
#   AllowTSConnections value - http://support.microsoft.com/kb/305608
#   TSEnabled value - http://support.microsoft.com/kb/222992
#
# copyright 2010 Quantum Analytics Research, LLC
#-----------------------------------------------------------
package termserv;
use strict;

my %config = (hive          => "System",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20100119);

sub getConfig{return %config}
sub getShortDescr {
	return "Gets fDenyTSConnections value from System hive";	
}
sub getDescr{}
sub getRefs {}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	::logMsg("Launching termserv v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
# First thing to do is get the ControlSet00x marked current...this is
# going to be used over and over again in plugins that access the system
# file
	my $current;
	my $key_path = 'Select';
	my $key;
	if ($key = $root_key->get_subkey($key_path)) {
		$current = $key->get_value("Current")->get_data();
		my $ccs = "ControlSet00".$current;
		my $ts_path = $ccs."\\Control\\Terminal Server";
		my $ts;
		if ($ts = $root_key->get_subkey($ts_path)) {
			::rptMsg($ts_path." key, fDenyTSConnections value");
			::rptMsg("LastWrite Time ".gmtime($ts->get_timestamp())." (UTC)");
			my $fdeny;
			eval {
				$fdeny = $ts->get_value("fDenyTSConnections")->get_data();
				::rptMsg("  fDenyTSConnections = ".$fdeny);
			};
			::rptMsg("fDenyTSConnections value not found.") if ($@);
		}
		else {
			::rptMsg($ts_path." not found.");
			::logMsg($ts_path." not found.");
		}
	}
	else {
		::rptMsg($key_path." not found.");
		::logMsg($key_path." not found.");
	}
}
1;