#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use XML::RSS::Parser;
use FileHandle;

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $self = {
        url => 'rss/abc.rss',
	type => 'mp3',
	delim => "\n",
	sort => 'date+',
	limit => '1',
        @ARGV
};

my $p = XML::RSS::Parser->new;
my $feed;

if ($self->{url} =~ m/http/){
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
	$feed = $p->parse_string($content);
}else{

	my $fh = FileHandle->new($self->{url});
	$feed = $p->parse_file($fh);

}

#print $feed->as_xml('utf-8');

my $feed_title = $feed->query('/channel/title');
 print $feed_title->text_content;
 my $count = $feed->item_count;
 print " ($count)\n";
 my @podcasts;

 foreach my $i ( $feed->query('//item') ) { 
     #my $node = $i->query('title');
     #print ' '.$node->text_content;
     #print "\n";
     my $podcast;
     $podcast->{url} = $i->query('enclosure')->attributes()->{'{}url'};
     $podcast->{pubdate} = $i->query('pubDate')->text_content;
     push @podcasts, $podcast;
     print $podcast->{pubdate}." ".$podcast->{url}.$self->{delim};
}


