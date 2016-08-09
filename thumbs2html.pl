#!/usr/bin/perl -w
# Threejs.org examples thumbnail page creator
#
# Figure out the missing JPEG files and put them in the proper directories.
#
# Steps:
#
# First, do `ls -R * > jpegs.txt` (get Cygwin if you don't have ls).
#
# Do a "diff" (e.g., use the program Beyond Compare) between the three.js's examples/files.js
# file and jpegs.txt. This diff will show new examples added and old examples deleted. You
# will have to futz with "align with" to check the canvas examples and below (which rarely
# change anyway).
#
# First, delete unused examples JPEGs from the directories here.
#
# Run each new example and create a screenshot for it, of size 150x100. Name the JPEG with
# the naming scheme used by other files in the directory and save it to the proper place.
#
# Run this Perl script from the examples directory in the latest three.js distribution:
#
#   `perl thumbs2html.pl`
#
# The index.html file produced is created from the JPEGs you have.
#
# Yes, I thought of automating the JPEG thumbnail creation process. The problem is that many
# examples look a bit boring until you let it really start up or move the view. So, it was
# better to manually create the 150x100 thumbnails manually.
#
# TODO: what would be better is to read the directories and read the files.js file, both, and
# note what's missing and what should be deleted. But, "diff" works fine for me now.

use strict;

use File::Find;

my $translationFile = "index.html";

my $outputTitle = "Three.js Thumbnails";

my $cfnum = 0;

my @codefiles;

&HEADER();

my @finddir;
$finddir[0] = ".";
find( \&READRECURSIVEDIR, @finddir, );
&PROCESSFILES(".");

&FOOTER();

exit 0 ;

sub READRECURSIVEDIR
{
	if ( m/\.(jpg)$/ ) {
		$codefiles[$cfnum] = $File::Find::name;
		$cfnum++;
	}
}

sub HEADER
{
	open( TRANSLATE, ">" . $translationFile ) or die "Can't open $translationFile: $!\n";
	printf TRANSLATE "%s",<<"EOF";
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head><meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"><title>
EOF

		printf TRANSLATE "$outputTitle";
	
		printf TRANSLATE "%s",<<"EOF";
</title>
</head>
<body>
<span style=\"font-family: Lucida Sans;\">
EOF

		printf TRANSLATE "<h1>$outputTitle</h1>\n";
		print TRANSLATE "Thumbnails for <a href=\"http://threejs.org/examples/\">three.js examples</a>\n";
		print TRANSLATE "<div id=\"thumbnails\">\n";
}

sub PROCESSFILES
{
	my $i;
	my @fld;

	#my $addpath = shift(@_);

	my @dirnames = ("webgl", "webgl_advanced", "webvr", "css3d", "css3d_stereo", "misc", "canvas", "raytracing", "software", "svg");
	foreach my $n (@dirnames) {
		my $write_dir = 1;
		for ( $i = 0 ; $i < $cfnum ; $i++ ) {
			@fld = split('/',$codefiles[$i]);	# split
			my $nextfile = $fld[$#fld];

			if ( $codefiles[$i] =~ ($n . "/") && lc($nextfile) =~ /\.jpg/ ) {
				my $fname = $`;

				if ( $write_dir ) {
					$write_dir = 0;
					my $dir_field = $fld[$#fld-1];
					$dir_field =~ tr/_/ /;
					print TRANSLATE "<h1>$dir_field</h1>\n";
				}
				
				my $alt_text = $fname;
				$alt_text =~ s/_/ \/ /g;

				print TRANSLATE "<a href=\"http://threejs.org/examples/#$fname\">\n";
				print TRANSLATE "<img src=\"$codefiles[$i]\" title=\"$alt_text\" alt=\"$alt_text\" height=\"100\" width=\"150\" /></a>\n";
			}
		}
	}
}

sub FOOTER
{
	print TRANSLATE "</div>\n";

	printf TRANSLATE "%s",<<"EOF";
<hr>
<a href="threejs_thumbs.zip">Download this site</a>. Something wrong or missing? Contact <a href="mailto:erich\@acm.org">Eric Haines</a>.
<P>
Go to the <b><a href="http://www.realtimerendering.com/webgl.html">WebGL/three.js resources page</a></b>.
<P>
<I>Last updated July 9, 2016</I>
</span>
</body></html>
EOF

	close TRANSLATE;
}