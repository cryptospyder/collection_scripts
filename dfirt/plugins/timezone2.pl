#-----------------------------------------------------------
# timezone2.pl
# Plugin for Registry Ripper; Access System hive file to get the
# contents of the TimeZoneInformation key
# 
# Change history
# 03-09-2010 fpi: added display of "TimeZoneKeyName" (Vista, 7)
# 19-12-2010 fpi: added references to code
#
# References
#   http://support.microsoft.com/kb/102986
#   http://support.microsoft.com/kb/207563
#   
# 
# copyright 2008 H. Carvey
#-----------------------------------------------------------
package timezone2;
use strict;

my %config = (hive          => "System",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20101219);

sub getConfig{return %config}
sub getShortDescr {
	return "Get TimeZoneInformation key contents";	
}
sub getDescr{}
# 19-12-10 fpi: added references
sub getRefs {
	my %refs = ("ref1" => 
	            "http://support.microsoft.com/kb/102986",
	            "ref2" =>
	            "http://support.microsoft.com/kb/207563");
	return %refs;	
}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	::logMsg("Launching timezone v.".$VERSION);
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
		my $tz_path = $ccs."\\Control\\TimeZoneInformation";
		my $tz;
		if ($tz = $root_key->get_subkey($tz_path)) {
			::rptMsg("TimeZoneInformation key");
			::rptMsg($tz_path);
			::rptMsg("LastWrite Time ".gmtime($tz->get_timestamp())." (UTC)");
			my %tz_vals;
			my @vals = $tz->get_list_of_values();
			if (scalar(@vals) > 0) {
				map{$tz_vals{$_->get_name()} = $_->get_data()}(@vals);
				
				::rptMsg("  DaylightName    -> ".$tz_vals{"DaylightName"});
				::rptMsg("  StandardName    -> ".$tz_vals{"StandardName"});
				
				my $bias   = $tz_vals{"Bias"}/60;
				my $atbias = $tz_vals{"ActiveTimeBias"}/60;
				
				::rptMsg("  Bias            -> ".$tz_vals{"ActiveTimeBias"}." (".$bias." hours)");
				::rptMsg("  ActiveTimeBias  -> ".$tz_vals{"Bias"}." (".$atbias." hours)");
				
				# 03/09/10 fpi: added, TimeZoneKeyName key available on vista and win7
				if (exists $tz_vals{"TimeZoneKeyName"}) {
					# find first null byte
					my $str = (split(/\0/,$tz_vals{"TimeZoneKeyName"}))[0];
					::rptMsg(sprintf "  TimeZoneKeyName -> %s",$str);
				}
				else {
					# not available on windows xp
					::rptMsg("  TimeZoneKeyName -> N/A");
				}
			}
			else {
				::rptMsg($tz_path." has no values.");
				::logMsg($tz_path." has no values.");
			}
		}
		else {
			::rptMsg($tz_path." could not be found.");
			::logMsg($tz_path." could not be found.");
		}
	}
	else {
		::rptMsg($key_path." not found.");
		::logMsg($key_path." not found.");
	}
}
1;