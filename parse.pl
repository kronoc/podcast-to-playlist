#!/usr/bin/perl -Tw

use strict;
use warnings;

my $self = {
        url => 'http://some.example/rss',
	type => 'mp3',
	delim => ' ',
	sort => 'date+',
	limit => '1',
        @ARGV
};

#get rss file
#work out format
#parse
#return urls

