#-----------------------------------------------------------
# product.pl
# Determine Windows product information
#
# History
#
# References
#    http://support.microsoft.com/kb/181412
#    http://support.microsoft.com/kb/152078
#
#
# copyright 2009 H. Carvey
#-----------------------------------------------------------
package product;
use strict;
my %config = (hive          => "System",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20090727);

sub getConfig{return %config}
sub getShortDescr {
	return "Queries System hive for Windows Product info";	
}
sub getDescr{}
sub getRefs {}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	::logMsg("Launching product v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
	my $current;
	my $key_path = 'Select';
	my $key;
	if ($key = $root_key->get_subkey($key_path)) {
		$current = $key->get_value("Current")->get_data();
		my $ccs = "ControlSet00".$current;
		my $prod_key_path = $ccs."\\Control\\ProductOptions";
		if (my $prod_key = $root_key->get_subkey($prod_key_path)) {
			my $type;
			eval {
				$type = $prod_key->get_value("ProductType")->get_data();
				::rptMsg("Type  = ".$type);
			};
#-----------------------------------------------------------			
# http://technet.microsoft.com/en-us/library/cc784364(WS.10).aspx
#
# http://www.geoffchappell.com/viewer.htm?doc=studies/windows/
#        km/ntoskrnl/api/ex/exinit/productsuite.htm
#
#-----------------------------------------------------------			
			my $suite;
			eval {
				$suite = $prod_key->get_value("ProductSuite")->get_data();
				::rptMsg("Suite = ".$suite);
			};
		}
		else {
			::rptMsg($prod_key_path." not found.");
		}
	}
	else {
		::rptMsg("Select key not found.");
	}
}