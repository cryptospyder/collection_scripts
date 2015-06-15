#-----------------------------------------------------------
# startmenuinternetapps_lm.pl
# Plugin for Registry Ripper,
# Start Menu Internet Applications settings (HKLM) parser
#
# Change history
# 06-09-2010 fpi: created
# 19-12-2010 fpi: first version
#
# References
#   http://msdn.microsoft.com/en-us/library/dd203067(VS.85).aspx
# 
# copyright 2008 H. Carvey
# plugin written by F. Picasso <fpi AT fpicasso.it>
#-----------------------------------------------------------
package startmenuinternetapps_lm;
use strict;

my %config = (hive          => "SOFTWARE",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 1,
              osmask        => 22,
              version       => 20101219);

sub getConfig{return %config}
sub getShortDescr {
	return "Start Menu Internet Applications info";	
}
sub getDescr{}
sub getRefs {
	my %refs = ("How to Register an Internet Browser or E-mail Client With the Windows Start Menu" => 
	            "http://msdn.microsoft.com/en-us/library/dd203067(VS.85).aspx");
	return %refs;
}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $ntuser = shift;
	::logMsg( "Launching startmenuinternetapps_lm.".$VERSION );
	
	my $reg = Parse::Win32Registry->new( $ntuser );
	my $root_key = $reg->get_root_key;

	my $path = 'Clients';
	my $key;
	
	if ( $key = $root_key->get_subkey( $path ) ) {
		::rptMsg( "Start Menu Internet Applications" );

		my @subkeys = $key->get_list_of_subkeys();	
		if ( ( scalar @subkeys ) > 0 ) {
		
			foreach my $sbk ( @subkeys ) {
				::rptMsg( "\n" );
				my $tmp = $sbk->get_name();
				::rptMsg( " [".gmtime( $sbk->get_timestamp() )." (UTC)] ".$tmp );
				
				my @vals = $sbk->get_list_of_values();
	
				if ( ( scalar @vals ) > 0 ) {
					foreach my $val ( @vals ) {
						$tmp = $val->get_name();
						# print default only
						if ( $tmp eq "" ) {
							::rptMsg( " VALUE: ".$tmp."(default) -> ".$val->get_data() );
						}
						
					}
				}
				else {
					::rptMsg( " VALUE: no values." );
				}
				
				# getting subkeys
				my @subkeys2 = $sbk->get_list_of_subkeys();
				if ( ( scalar @subkeys2 ) > 0 ) {
					foreach my $sbk2 ( @subkeys2 ) {
						$tmp = $sbk2->get_name();
						::rptMsg( " SUBKEY: "." [".gmtime( $sbk2->get_timestamp() )." (UTC)] ".$tmp );
					}
				}
			}
		}
		else {
			::rptMsg( $key->get_name()." has no subkeys." );
			::logMsg( $key->get_name()." has no subkeys." );
		}
	}
	else {
		::rptMsg( $path." not found." );
		::logMsg( $path." not found." );
	}
}

1;