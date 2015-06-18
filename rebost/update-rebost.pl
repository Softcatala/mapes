#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Encode;
use Encode::Guess;
use Data::Dumper;
use MediaWiki::API;

use Config::JSON;
use 5.010;

my $obf_path = shift // "/path/to/obf";
my $config_json = shift // "config.json";

my $config = Config::JSON->new( $config_json );

# Username and password.
my $user = $config->get("mw/username") // "";
my $pass = $config->get("mw/password") // "";
my $host = $config->get("mw/host") // "www.softcatala.org";
my $protocol = $config->get("mw/protocol") // "https";
my $path = $config->get("mw/path") // "w";

# Name of page
my $rebostpage = "Mapa_català_per_a_l'OsmAnd";
my $urlpath = "https://gent.softcatala.org/albert/mapa";

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

# Let's initialize bot

my $mw = MediaWiki::API->new( { api_url =>  $protocol."://".$host."/".$path."/api.php" }  );

#log in to the wiki
$mw->login( {lgname => $user, lgpassword => $pass } )
  || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};


# Detec if path exist
if ( ! -d $obf_path ) {
	die "Path does not exist\n";
}

# Read files
opendir( DIR, $obf_path ) || die "Cannot open $obf_path";

my @obf_files = grep { $_=~/\.obf/ } readdir ( DIR ); 

if ( $#obf_files < 1 ) {
	die "Not enough files! :O";
}

my $filedata = prepareFiles( \@obf_files, $urlpath );

# TODO: Send stuff to wiki

send2wiki( $mw, $filedata, $rebostpage );

sub prepareFiles {

	my $files = shift;
	my $urlpath = shift;

	@{$files} = sort( @{$files} );
	
	my %filedata;

	my $i = 0;
	foreach my $file ( @{$files} ) {
		$filedata{$file} = $urlpath."/".$file;
		
		$i++;
		if ( $i > 1 ) {
			last;
		}	
	}

	return \%filedata;
}

# TODO: To adapt
sub send2wiki {
	
	my $mw = shift;
	my $data = shift;
	my $nomrebost = shift;
	
	my $page = $mw->get_page( { title => 'Rebost:'.$nomrebost } );
	my $wikitext = $page->{'*'};
	
	my @sections = split(/\{\{Fitxa programa/, $wikitext);
	
	if ( $#sections != 2 ) {
		die "Different num of sections.\n";
	}
	
	my @keys = sort keys %{$data} ; 
	
	for ( my $i=1; $i < 3; $i++ ) {
		if ( $sections[$i]=~/DARRERA/ ) {
			$sections[$i]=~s/\|URL programa=(\S+)\b/|URL programa=$data->{$keys[1]}/g;
		}
		if ( $sections[$i]=~/ANTERIOR/ ) {
			$sections[$i]=~s/\|URL programa=(\S+)\b/|URL programa=$data->{$keys[0]}/g;
		}
	}

	my $wikitext2 = join( "{{Fitxa programa", @sections );
	print $wikitext2;
	
	#foreach my $wikiline (@wikilines) {
	#	
	#	if ($wikiline=~/^\s*\|Versi\S+\s*\=/) {
	#		
	#		$wikiline = "|Versió=$version";
	#		
	#	}
	#	
	#	else {
	#		foreach my $platkey (@platkeys) {
	#			
	#			if ($wikiline=~/$platkey/) {
	#				$wikiline = "|URL programa=$platforms{$platkey}";
	#			}
	#		} 
	#	}
	#	
	#	$wikitext2 .= $wikiline. "\n";
	#}
	#
	#my $enc = guess_encoding($wikitext2);
	#my $utf8 = "";
	#if(ref($enc)) {
	#
	#		if ($enc->name eq 'utf8') {
	#			$utf8 = $wikitext2;
	#	
	#		}
	#		else {
	#			
	#			$utf8 = $wikitext2;   
	#			
	#		}
	#	}
	#
	
	#print $wikitext2
	#my $nompage="Rebost:".$nomrebost;
	#my $edit_summary = "Actualitzat a darrera versió";
	#
	#if ($utf8 ne '') {
	#	
	#	my $ref = $mw->get_page( { title => $nompage } );
	#	unless ( $ref->{missing} ) {
	#		my $timestamp = $ref->{timestamp};
	#		$mw->edit( {
	#			action => 'edit',
	#			title => $nompage,
	#			summary => $edit_summary,
	#			basetimestamp => $timestamp, # to avoid edit conflicts
	#			text => $utf8 } )
	#		|| die $mw->{error}->{code} . ': ' . $mw->{error}->{details};
	#	}
	#}
}

