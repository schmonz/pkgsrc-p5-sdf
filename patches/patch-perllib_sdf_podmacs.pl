$NetBSD$

--- perllib/sdf/podmacs.pl.orig	2023-10-09 15:57:16.851477102 +0000
+++ perllib/sdf/podmacs.pl
@@ -238,7 +238,7 @@ sub cut_Macro {
     local(@text);
 
     # Update the parser state
-    $'sdf_cutting = 1;
+    $::sdf_cutting = 1;
 
     # Return result
     return ();
@@ -298,4 +298,4 @@ sub end_Macro {
 }
 
 # package return value
-1;
\ No newline at end of file
+1;
