Podcast To Playlist
===================

This is a Perl programme which parses podcast rss feeds and prints out a list of the media files published in that feed, in order of publication date.
Output is in m3u format by default, but you can set command line options to get CSV,JSON, pipe-delimited etc.

Dependencies
------------

You will need the following modules from CPAN (pr elsewhere) to use podcast2playlist:

 * LWP::UserAgent
 * XML::RSS::Parser
 * Date::Parse

Usage
-----



### Output an m3u from a podcast

	podcast2playlist.pl user "you@email.example" url http://test.test/podcast.xml > playlist.m3u

### Output an m3u from a local podcast file
	podcast2playlist.pl url localfile.xml > playlist.m3u

### Output a CSV from a podcast
	podcast2playlist.pl user "you@email.example" url http://test.test/podcast.xml delim "," > playlist.csv

### Output a simple (most recent) item from a podcast
	podcast2playlist.pl user "you@email.example" url http://test.test/podcast.xml limit 1 > single-item-playlist.m3u

### Output the 5 most recent items from a podcast as a playlist in JSON(!)
	podcast2playlist.pl user "you@email.example" url http://test.test/podcast.xml limit 5 delim '","url":"' output_start '[{"url":"' output_end '"}]'  > playlist.json


Note
----

Playlists are sorted by date, newest item first. Other sorting methods will appear some time when I can be bothered.
