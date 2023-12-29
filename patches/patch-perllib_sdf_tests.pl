$NetBSD$

--- perllib/sdf/tests.pl.orig	1998-10-23 22:59:44.000000000 +0000
+++ perllib/sdf/tests.pl
@@ -37,7 +37,7 @@
 # * checking that additional files were not generated.
 #
 
-!require "ctime.pl";
+use POSIX qw(ctime);
 
 ######### Constants #########
 
