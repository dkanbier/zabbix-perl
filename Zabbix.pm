package Zabbix;
################################################################################
# module: Zabbix.pm - Simple Perl module to interact with the Zabbix API
################################################################################
#
# Original script by: https://github.com/sjohnston
#
################################################################################

use strict;
use JSON;
use LWP::UserAgent;

sub new {
    my ($class, $url, $user, $password) = @_;

    my $self = {};

    bless $self, $class;
		
    my $ua = LWP::UserAgent->new;
    $ua->agent("Zabbix");

    my $req = HTTP::Request->new(POST => "$url/api_jsonrpc.php");
    $req->content_type('application/json-rpc');

    $req->content(encode_json( {
        jsonrpc => "2.0",
        method => "user.login",
        params => {
            user => $user,
            password => $password,
        },
        id => 1,
    }));

    my $res = $ua->request($req);

    unless ($res->is_success) {
      die "Can't connect to Zabbix" . $res->status_line;
    }

    my $auth = decode_json($res->content)->{'result'};


        $self->{'UserAgent'} = $ua;
        $self->{'Request'} = $req;
        $self->{'Count'} = 1;
        $self->{'Auth'} = $auth;

   return $self;
}

sub ua {
    return shift->{'UserAgent'};
}

sub req {
    return shift->{'Request'};
}

sub auth {
    return shift->{'Auth'};
}

sub next_id {
    return ++shift->{'Count'};
}

sub go {
    my ($self, $object,$action, $params) = @_;
	
    my $req = $self->req;
    $req->content(encode_json( {
        jsonrpc => "2.0",
        method => $object.".".$action,
        params => $params,
        auth => $self->auth,
        id => $self->next_id,
    }));

    my $res = $self->ua->request($req);
	
    unless ($res->is_success) {
      die "Can't connect to Zabbix" . $res->status_line;
    }

    return decode_json($res->content);
}

1;
