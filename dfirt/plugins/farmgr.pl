#-----------------------------------------------------------
# FAR Manager info v0.1
# by Adam Blaszczyk ablaszczyk@trustwave.com
#
#-----------------------------------------------------------
package farmgr;
use strict;

my %config = (hive          => "NTUSER\.DAT",
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              osmask        => 22,
              version       => 20091014);
              
sub getConfig
 {
  return %config
 }

sub getShortDescr 
 {
	return "FAR Manager Info";	
 }

 sub getDescr{}

sub getRefs {}

sub getHive 
{
 return $config{hive};
}

sub getVersion 
{
 return $config{version};
}

my $VERSION = getVersion();

sub show_recursively
{
	my $root_key = shift;
	my $key_path = shift;
	my $key;
	if ($key = $root_key->get_subkey($key_path)) 
	{
		::rptMsg($key_path);
		::rptMsg($key_path);
		::rptMsg("LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
		
	    my @subkeys = $key->get_list_of_subkeys();
		if (scalar(@subkeys) > 0) 
		{
			foreach my $s (@subkeys) 
			{
				my $path;
				eval 
				{
					$path = $s->get_value("Application_Prefs")->get_data();
				};
				::rptMsg("Application Name: ".$s->get_name());
				::rptMsg("LastWrite: ".gmtime($s->get_timestamp())." (UTC)");
				}
		}
		else 
		{
			::rptMsg($key_path." has no values.");
			::logMsg($key_path." has no values.");	
		}
	}
	else {
		::rptMsg($key_path." not found.");
		::logMsg($key_path." not found.");
	}
}


sub show_recursively
{
	my $root_key = shift;
	my $key_path = shift;
	my $rec_level = shift;    
	my $sep = "\t" x $rec_level;
	my $key;
	if ($key = $root_key->get_subkey($key_path)) 
	{
		::rptMsg($sep.$key_path);
		::rptMsg($sep.$key_path);
		::rptMsg($sep."LastWrite Time ".gmtime($key->get_timestamp())." (UTC)");
		
	    my @subkeys = $key->get_list_of_subkeys();
		if (scalar(@subkeys) > 0) 
		{		    
			foreach my $s (@subkeys) 
			{			    
			    my $subkey = $s->get_name();
				next if ($subkey =~ /Colors/i);
				show_recursively ($root_key , $key_path."\\".$subkey, $rec_level + 1);
			}			
		}

	    my @vals = $key->get_list_of_values();
		my %ac_vals;
		foreach my $v (@vals) 
		{
				$ac_vals{$v->get_name()} = $v->get_data();
		}
		foreach my $a (sort {$a <=> $b} keys %ac_vals) 
		{
				::rptMsg($sep.$a." -> ".$ac_vals{$a});
		}
	}
	else {
		::rptMsg($sep.$key_path." not found.");
		::logMsg($sep.$key_path." not found.");
	}
}

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	::logMsg("Launching farmgr v.".$VERSION);
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;
	show_recursively ($root_key , "Software\\Far",0);
}

1;