#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use XML::RSS::Parser;

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $self = {
        url => 'http://some.example/rss',
	type => 'mp3',
	delim => ' ',
	sort => 'date+',
	limit => '1',
        @ARGV
};

#get rss file
my $ua = LWP::UserAgent->new;
$ua->agent('Primitive Podcast Parser');
$ua->from('info@conor.net');
$ua->timeout('60');

my $r = $ua->get($self->{url});
#my $feed="";
if($r->is_error){
	#open (LOG, ">>".$self->{logFile}) || die "oh no! can't open ".$self->{logFile}."\n";
	#select(LOG); $| = 1;
        #print LOG "$geturl => " . $r->status_line . "\n";
        #close (LOG);
        #return $ERROR_MSG;
print "error ". $r->status_line . "\n";
}


my $content = $r->content;
my $encoding = 'utf8'; # assume this is the default
if($content =~ /encoding="([^"]+)"/) {
$encoding = $1;
}
$content = $r->decoded_content((charset => $encoding));

my $p = XML::RSS::Parser->new;
my $feed = $p->parse_string($content);
#print "$feed";

my $feed_title = $feed->query('/channel/title');
 print $feed_title->text_content;
 my $count = $feed->item_count;
 print " ($count)\n";
 foreach my $i ( $feed->query('//item') ) { 
     my $node = $i->query('title');
     print ' '.$node->text_content;
     print "\n"; 
 }




#work out format
#parse
#return urls

