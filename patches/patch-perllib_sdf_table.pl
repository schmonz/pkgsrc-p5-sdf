$NetBSD$

--- perllib/sdf/table.pl.orig	1999-04-26 14:24:43.000000000 +0000
+++ perllib/sdf/table.pl
@@ -915,7 +915,7 @@ sub _TablePackStr {
     local($packfmt);
 
     $packfmt = '';
-    while ($format =~ s/\w+\s+//e) {
+    while ($format =~ s/\w+\s+//) {
         $packfmt .= 'A' . length($&);
     }
     $packfmt .= 'A*';
