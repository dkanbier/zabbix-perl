zabbix-perl
===========
This is a simple Perl module to wrap API calls to Zabbix so they can be used in Perl scripts.

For more information about the Zabbix API please see [Zabbix API](https://www.zabbix.com/documentation/2.2/manual/api "Zabbix 2.2 API"). 

Examples
--------
Check if a host exists in Zabbix:

```perl
#!/usr/bin/perl

use Zabbix;

my $zabbix = Zabbix::new("Zabbix","http://zabbix-dev.kanbier.lan","apiuser","changeme");

my @params = (
	{
		"host" => "Zabbix Server"
	}
);

my $result = $zabbix->go("host","exists",@params);

if ($result->{'result'}) {
	print "Host exists in Zabbix\n";
} else {
	print "Host doesn't exist in Zabbix\n";
}
