#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use XML::RSS::Parser;
use FileHandle;
use Date::Parse;
use URI;

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $self = {
        url => 'http://test.example/rss.xml',
	delim => "\n",
	output_start => "",
	output_end => "",
	limit => '100',
	user => 'info@conor.net',
        @ARGV
};

my $p = XML::RSS::Parser->new;
my $feed;

if (URI->new($self->{url})->scheme ){
	my $ua = LWP::UserAgent->new;
	$ua->agent('Podcast To Playlist');
	$ua->from($self->{user});
	$ua->timeout('60');

	my $r = $ua->get($self->{url});
	if($r->is_error){
		die "error ". $r->status_line . "\n";
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
#my $count = $feed->item_count;

if ( ! $feed ){
  die "Cannot parse feed.";
 }
 my @podcasts;
 foreach my $i ( $feed->query('//item') ) { 
     my $podcast;
     if ( $i->query('enclosure') ){
     	$podcast->{url} = $i->query('enclosure')->attributes()->{'{}url'};
     } elsif ( $i->query('link') ){
     	$podcast->{url} = $i->query('link')->text_content;
     } else {
     	next;
	#$podcast->{url} = "";
	##$i->query('guid')->text_content;
     }
     $podcast->{date} = str2time($i->query('pubDate')->text_content);
     push @podcasts, $podcast;
}

#improve sorting at some point
my @playlist = sort { $b->{date} <=> $a->{date} } @podcasts;

my $feed_size = scalar @playlist;
my $count=0;
print "$self->{output_start}";
foreach my $pod (@playlist){
	print $pod->{url} if ($count<$self->{limit});
	$count++;
	print $self->{delim} if (($count<$feed_size) && ( $count <$self->{limit} ));
}
print "$self->{output_end}";
