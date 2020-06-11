# FlagWait

FlagWait is a simple shell script that will halt execution until a flag
appears in a directory. This tool was originally written with the intent
of managing the startup sequencing of a group of related Docker containers.

Example:

flagwait database-loaded

This will wait until a file named "database-loaded" appears in the $FLAG_DIR
directory.
