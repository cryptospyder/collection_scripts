############################################################
# rootkit_revealer.pl # Plugin for Registry Ripper #
############################################################
# Extracts the EULA value for Sysinternals Rootkit Revealer.
# Copyright (c) 2011-02-04 Brendan Coles <bcoles@gmail.com>
############################################################

# Require #
package rootkit_revealer;
use strict;

# Declarations #
my %config = (hive          => "NTUSER\.DAT",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 1,
              osmask        => 22,
              version       => 20110204);
my $VERSION = getVersion();

# Functions #
sub getDescr {}
sub getConfig {return %config}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}
sub getShortDescr {
	return "Extracts the EULA value for Sysinternals Rootkit Revealer.";
}
sub getRefs {
	my %refs = ("Sysinternals Rootkit Revealer Homepage:" =>
	            "http://technet.microsoft.com/en-us/sysinternals/bb897445");
	return %refs;	
}

############################################################
# pluginmain #
############################################################
sub pluginmain {

	# Declarations #
	my $class = shift;
	my $hive = shift;
	my @interesting_keys = (
		"EulaAccepted"
	);

	# Initialize #
	::logMsg("Launching rootkit_revealer v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
	my $key;
	my $key_path = "Software\\Sysinternals\\RootkitRevealer";

	# If # Rootkit Revealer path exists #
	if ($key = $root_key->get_subkey($key_path)) {

		# Return # plugin name, registry key and last modified date #
		::rptMsg("Rootkit Revealer");
		::rptMsg($key_path);
		::rptMsg("LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
		::rptMsg("");

		# Extract # all keys from Rootkit Revealer registry path #
		my %keys;
		my @vals = $key->get_list_of_values();

		# If # registry keys exist in path #
		if (scalar(@vals) > 0) {

			# Extract # all key names+values for Rootkit Revealer registry path #
			foreach my $v (@vals) {
				$keys{$v->get_name()} = $v->get_data();
			}

			# Return # all key names+values for interesting keys #
			foreach my $var (@interesting_keys) {
				if (exists $keys{$var}) {
					::rptMsg($var." -> ".$keys{$var});
				}
			}

		# Error # key value is null #
		} else {
			::rptMsg($key_path." has no values.");
		}

	# Error # Rootkit Revealer isn't here, try another castle #
	} else {
		::rptMsg($key_path." not found.");
		::logMsg($key_path." not found.");
	}

	# Return # obligatory new-line #
	::rptMsg("");
}

# Error # oh snap! #
1;
