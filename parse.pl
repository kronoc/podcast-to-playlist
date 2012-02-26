#!/usr/bin/perl -Tw

use strict;
use warnings;
use LWP::UserAgent;
use XML::RSS::Parser;

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
$ua->agent('Punctual Podcast Parser');
$ua->from('info@conor.net');
$ua->timeout('60');

my $r = $ua->get($self->url);
my $feed="";
if($r->is_error){
	#open (LOG, ">>".$self->{logFile}) || die "oh no! can't open ".$self->{logFile}."\n";
	#select(LOG); $| = 1;
        #print LOG "$geturl => " . $r->status_line . "\n";
        #close (LOG);
        #return $ERROR_MSG;
	}
else {
	$feed = $r->content;
}

my $feed_title = $feed->query('/channel/title');
 print $feed_title->text_content;
 my $count = $feed->item_count;
 print " ($count)\n";
 foreach my $i ( $feed->query('//item') ) { 
     my $node = $i->query('title');
     print '  '.$node->text_content;
     print "\n"; 
 }




#work out format
#parse
#return urls

