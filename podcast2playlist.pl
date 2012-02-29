#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use XML::RSS::Parser;
use FileHandle;
use Date::Parse

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $self = {
        url => 'http://test.example/rss.xml',
	delim => "\n",
	limit => '100',
	user => 'info@conor.net',
        @ARGV
};

my $p = XML::RSS::Parser->new;
my $feed;

if ($self->{url} =~ m/http/){
	my $ua = LWP::UserAgent->new;
	$ua->agent('Podcast To Playlist');
	$ua->from($self->{user});
	$ua->timeout('60');

	my $r = $ua->get($self->{url});
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


#my $feed_title = $feed->query('/channel/title');
 #print $feed_title->text_content;
 #my $count = $feed->item_count;
 #print " ($count)\n";
 my @podcasts;

 foreach my $i ( $feed->query('//item') ) { 
     my $podcast;
     $podcast->{url} = $i->query('enclosure')->attributes()->{'{}url'};
     $podcast->{date} = str2time($i->query('pubDate')->text_content);
     push @podcasts, $podcast;
}

#improve sorting at some point
my @playlist = sort { $b->{date} <=> $a->{date} } @podcasts;

my $count=0;
foreach my $pod (@playlist){
	print $pod->{url}.$self->{delim} if ($count<$self->{limit});
	$count++;
}


