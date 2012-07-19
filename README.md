Unified Search
==============

This is a search engine which allows users to search under different sections such as books, music, apps, etc. (like google search results). The schema for each data is predetermined as is present in the migration file. You can use your own indexer to generate the SQL queries required to enter all indexed entries into the database or you could use my indexer present at /scripts/file.rb.

In order to use my indexer, go to the root folder which contains all files to be indexed.

>    $ cd /path/to/media/dir/
>
>    $ ruby /path/to/script/file.rb

The above script will index all files and write the sql queries to /tmp/audio.sql. You can use that file to dump the data into your database.

As of now, only the music search is functional. I'll add more search options soon.

Add thumbnail to /public/cache/ folder in the rails app directory, or symlink the thumbnail directory to /public/cache
