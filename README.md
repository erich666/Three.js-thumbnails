Threejs.org examples thumbnail page project
===========================================

The results of this script is **[here](http://www.realtimerendering.com/threejs/)**, linked from [here](http://www.realtimerendering.com/webgl.html).

Note: some of the examples may not exist, either because three.js has removed them, or the demos are in the develop branch and not yet in the master.

The thumbs2html.pl file makes the thumbnails index page.

You, however, need to figure out the missing JPEG files and put them in the proper directories for it to work properly.

Steps:

First, do `ls -R * > jpegs.txt` (get [Cygwin](https://www.cygwin.com/) if you don't have ls).

Do a "diff" (e.g., use the program Beyond Compare) between the three.js's examples/files.js
file and jpegs.txt. This diff will show new examples added and old examples deleted. You
will have to futz with "align with" to check the canvas examples and below (which rarely
change anyway).

First, delete unused examples JPEGs from the directories here.

Run each new example and create a screenshot for it, of size 150x100. Name the JPEG with
the naming scheme used by other files in the directory and save it to the proper place.

Run this Perl script from the examples directory in the latest three.js distribution:

  `perl thumbs2html.pl`

The index.html file produced is created from the JPEGs you have.

Yes, I thought of automating the JPEG thumbnail creation process. The problem is that many
examples look a bit boring until you let it really start up or move the view. So, it was
better to manually create the 150x100 thumbnails manually.

License: [MIT License](https://en.wikipedia.org/wiki/MIT_License#License_terms)

TODO: what would be better is to read the directories and read the files.js file, both, and
note what's missing and what should be deleted. But, "diff" works fine for me now.