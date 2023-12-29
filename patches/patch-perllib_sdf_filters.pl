$NetBSD$

--- perllib/sdf/filters.pl.orig	2023-10-09 15:57:16.885150601 +0000
+++ perllib/sdf/filters.pl
@@ -224,7 +224,7 @@ sub InitFilters {
     %jump = ();
     %jump_label = ();
 
-    $validate = $'verbose;
+    $validate = $::verbose;
     %sdf_attrs = ();
     @sdf_attr_stk = ();
 
@@ -760,9 +760,9 @@ sub table_Filter {
     $param{'style'} = $style;
 
     # Activate event processing
-    &ReportEvents('table') if @'sdf_report_names;
+    &ReportEvents('table') if @::sdf_report_names;
     &ExecEventsStyleMask(*evcode_table, *evmask_table);
-    &ReportEvents('table', 'Post') if @'sdf_report_names;
+    &ReportEvents('table', 'Post') if @::sdf_report_names;
 
     # Parse the text into a table
     if (defined $param{'parseline'}) {
@@ -1563,7 +1563,7 @@ sub end_Filter {
     local(*text, %param) = @_;
 
     # We prepend a blank line so that multiple end sections remain separate.
-    unshift(@'sdf_end, '', @text);
+    unshift(@::sdf_end, '', @text);
     @text = ();
 }
 
