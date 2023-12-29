$NetBSD$

--- perllib/sdf/macros.pl.orig	1999-05-24 06:28:10.000000000 +0000
+++ perllib/sdf/macros.pl
@@ -181,7 +181,7 @@
 
     %readonly = ();
     %restricted = ();
-    for $name (keys %'sdf_target) {
+    for $name (keys %::sdf_target) {
         $name =~ tr/a-z/A-Z/;
         $restricted{$name} = 1;
     }
@@ -553,13 +553,13 @@
 sub block_Macro {
     local(%arg) = @_;
     local(@text);
-#print STDERR "sb1 file: $'ARGV, lineno: $'app_lineno<\n";
+#print STDERR "sb1 file: $::ARGV, lineno: $::app_lineno<\n";
 
     # Update the parser state
-    $'sdf_block_start = $'app_lineno;
-    $'sdf_block_type = 'block';
-    @'sdf_block_text = ();
-    %'sdf_block_arg = %arg;
+    $::sdf_block_start = $::app_lineno;
+    $::sdf_block_type = 'block';
+    @::sdf_block_text = ();
+    %::sdf_block_arg = %arg;
 
     # Return result
     return ();
@@ -572,27 +572,27 @@
     local(@text);
 
     # Check the state
-    if ($'sdf_block_type ne 'block') {
+    if ($::sdf_block_type ne 'block') {
         &'AppMsg("error", "endblock macro not expected");
         return ();
     }
 
     # Update the parser state
-    $'sdf_block_type = '';
+    $::sdf_block_type = '';
 
     # Filter the text
-    &ExecFilter($'sdf_block_arg{'filter'}, *'sdf_block_text,
-      $'sdf_block_arg{'params'}, $'sdf_block_start, $'ARGV, 'filter on ');
+    &ExecFilter($::sdf_block_arg{'filter'}, *::sdf_block_text,
+      $::sdf_block_arg{'params'}, $::sdf_block_start, $::ARGV, 'filter on ');
 
     # Mark the text as a section, if necessary
-    if (@'sdf_block_text) {
-        unshift(@'sdf_block_text,
-          "!_bos_ $'sdf_block_start;block on ");
-        push(@'sdf_block_text, "!_eos_ $'app_lineno;$'app_context");
+    if (@::sdf_block_text) {
+        unshift(@::sdf_block_text,
+          "!_bos_ $::sdf_block_start;block on ");
+        push(@::sdf_block_text, "!_eos_ $::app_lineno;$::app_context");
     }
 
     # Return result
-    return @'sdf_block_text;
+    return @::sdf_block_text;
 }
 
 # include - include another file
@@ -1134,10 +1134,10 @@
     local(@text);
 
     # Update the parser state
-    $'sdf_block_start = $'app_lineno;
-    $'sdf_block_type = 'macro';
-    @'sdf_block_text = ();
-    %'sdf_block_arg = %arg;
+    $::sdf_block_start = $::app_lineno;
+    $::sdf_block_type = 'macro';
+    @::sdf_block_text = ();
+    %::sdf_block_arg = %arg;
 
     # Return result
     return ();
@@ -1150,16 +1150,16 @@
     local(@text);
 
     # Check the state
-    if ($'sdf_block_type ne 'macro') {
+    if ($::sdf_block_type ne 'macro') {
         &'AppMsg("error", "endmacro macro not expected");
         return ();
     }
 
     # Update the parser state
-    $'sdf_block_type = '';
+    $::sdf_block_type = '';
 
     # Save the definition
-    $macro{$'sdf_block_arg{'name'}} = join("\n", @'sdf_block_text);
+    $macro{$::sdf_block_arg{'name'}} = join("\n", @::sdf_block_text);
 
     # Return result
     return ();
@@ -1352,7 +1352,7 @@
     local(@text);
 
     ## Check the state
-    #if ($'sdf_block_type ne 'macro') {
+    #if ($::sdf_block_type ne 'macro') {
     #    &'AppMsg("warning", "enddiv macro not expected");
     #    return ();
     #}
@@ -1376,19 +1376,19 @@
 
     # If we are nested inside a section of an if macro which is not
     # to be included, we exclude all sections of this macro.
-    push(@'sdf_if_start, $'app_lineno);
-    if (@'sdf_if_now && ! $'sdf_if_now[$#main'sdf_if_now]) {
-        push(@'sdf_if_now, 0);
-        push(@'sdf_if_yet, 1);
-        push(@'sdf_if_else, 0);
+    push(@::sdf_if_start, $::app_lineno);
+    if (@::sdf_if_now && ! $::sdf_if_now[$#main::sdf_if_now]) {
+        push(@::sdf_if_now, 0);
+        push(@::sdf_if_yet, 1);
+        push(@::sdf_if_else, 0);
     }
 
     # Otherwise, evaluate the expression and process accordingly.
     else {
         $expr_value = $arg{'value'};
-        push(@'sdf_if_now, $expr_value);
-        push(@'sdf_if_yet, $expr_value);
-        push(@'sdf_if_else, 0);
+        push(@::sdf_if_now, $expr_value);
+        push(@::sdf_if_yet, $expr_value);
+        push(@::sdf_if_else, 0);
     }
 
     # Return result
@@ -1407,28 +1407,28 @@
     local($expr_value);
 
     # elsif not permitted outside an if macro
-    unless (@'sdf_if_now) {
+    unless (@::sdf_if_now) {
         &'AppMsg("error", "!elsif not expected");
         return ();
     }
 
     # Get the current nesting level
-    $level = $#main'sdf_if_yet;
+    $level = $#main::sdf_if_yet;
 
     # elsif after an else is not permitted
-    if ($'sdf_if_else[$level]) {
+    if ($::sdf_if_else[$level]) {
         &'AppMsg("error", "!elsif found after else macro");
         return ();
     }
 
     # Only evaluate the expression if we haven't included a section yet
-    if (! $'sdf_if_yet[$level]) {
+    if (! $::sdf_if_yet[$level]) {
         $expr_value = $arg{'value'};
-        $'sdf_if_now[$level] = $expr_value;
-        $'sdf_if_yet[$level] = $expr_value;
+        $::sdf_if_now[$level] = $expr_value;
+        $::sdf_if_yet[$level] = $expr_value;
     }
     else {
-        $'sdf_if_now[$level] = 0;
+        $::sdf_if_now[$level] = 0;
     }
 
     # Return result
@@ -1452,25 +1452,25 @@
     local($level);
 
     # else not permitted outside an if macro
-    unless (@'sdf_if_now) {
+    unless (@::sdf_if_now) {
         &'AppMsg("error", "!else not expected");
         return ();
     }
 
     # Get the current nesting level
-    $level = $#main'sdf_if_yet;
+    $level = $#main::sdf_if_yet;
 
     # record that we have encountered the else
     # (this is needed for checking that an elsif does not follow it)
-    $'sdf_if_else[$level] = 1;
+    $::sdf_if_else[$level] = 1;
 
     # Only include this section if we haven't included a section yet
-    if (! $'sdf_if_yet[$level]) {
-        $'sdf_if_now[$level] = 1;
-        $'sdf_if_yet[$level] = 1;
+    if (! $::sdf_if_yet[$level]) {
+        $::sdf_if_now[$level] = 1;
+        $::sdf_if_yet[$level] = 1;
     }
     else {
-        $'sdf_if_now[$level] = 0;
+        $::sdf_if_now[$level] = 0;
     }
 
     # Return result
@@ -1484,15 +1484,15 @@
     local(@text);
 
     # endif not permitted outside an if macro
-    unless (@'sdf_if_now) {
+    unless (@::sdf_if_now) {
         &'AppMsg("error", "!endif not expected");
         return ();
     }
 
-    pop(@'sdf_if_start);
-    pop(@'sdf_if_now);
-    pop(@'sdf_if_yet);
-    pop(@'sdf_if_else);
+    pop(@::sdf_if_start);
+    pop(@::sdf_if_now);
+    pop(@::sdf_if_yet);
+    pop(@::sdf_if_else);
 
     # Return result
     return ();
@@ -1542,8 +1542,8 @@
     local($col, $unspecified);
 
     # Update the state
-    push(@'sdf_tbl_state, 1);
-    push(@'sdf_tbl_start, $'app_lineno);
+    push(@::sdf_tbl_state, 1);
+    push(@::sdf_tbl_start, $::app_lineno);
 
     # Validate and clean the parameters
     %param = &SdfTableParams('table', $arg{'params'}, *tableparams_name,
@@ -1616,7 +1616,7 @@
     local(%param);
 
     # Check the state
-    unless (@'sdf_tbl_state) {
+    unless (@::sdf_tbl_state) {
         &'AppMsg("error", "!row not expected");
         return ();
     }
@@ -1646,7 +1646,7 @@
     local(%param);
 
     # Check the state
-    unless (@'sdf_tbl_state) {
+    unless (@::sdf_tbl_state) {
         &'AppMsg("error", "!cell not expected");
         return ();
     }
@@ -1672,14 +1672,14 @@
     local(@text);
 
     # Check the state
-    unless (@'sdf_tbl_state) {
+    unless (@::sdf_tbl_state) {
         &'AppMsg("error", "!endtable not expected");
         return ();
     }
 
     # Update the state
-    pop(@'sdf_tbl_state);
-    pop(@'sdf_tbl_start);
+    pop(@::sdf_tbl_state);
+    pop(@::sdf_tbl_start);
 
     # Build the result
     @text = (&'SdfJoin("__endtable", ''));
@@ -1996,19 +1996,19 @@
     local(@text);
 
     # Update the message variables
-    $'app_lineno = $arg{'lineno'};
-    $'app_context = $arg{'context'};
-    $'app_context .= " " unless $'app_context =~ / $/;
+    $::app_lineno = $arg{'lineno'};
+    $::app_context = $arg{'context'};
+    $::app_context .= " " unless $::app_context =~ / $/;
     if ($arg{'filename'} ne '') {
-        $'ARGV = $arg{'filename'};
-        $var{'FILE_PATH'} = &'NameAbsolute($'ARGV);
+        $::ARGV = $arg{'filename'};
+        $var{'FILE_PATH'} = &'NameAbsolute($::ARGV);
         @var{'FILE_DIR', 'FILE_BASE', 'FILE_EXT', 'FILE_SHORT'} =
           &'NameSplit($var{'FILE_PATH'});
 
         # Update the file and document modified times. Note that
         # we use a constant (1e9 = 09-Sep-2001) during regression
         # testing to minimise file differences.
-        $var{'FILE_MODIFIED'} = $var{'SDF_TEST'} ? 1e9 : (stat($'ARGV))[9];
+        $var{'FILE_MODIFIED'} = $var{'SDF_TEST'} ? 1e9 : (stat($::ARGV))[9];
         $var{'DOC_MODIFIED'} = $var{'FILE_MODIFIED'} if
           $var{'DOC_MODIFIED'} < $var{'FILE_MODIFIED'};
 
@@ -2196,8 +2196,8 @@
     local($new_file);
 
     # Push the state stack
-    push(@_file_info, join("\000", $'ARGV, $'app_lineno, $'app_context,
-      scalar(@'sdf_if_now), scalar(@'sdf_tbl_state)));
+    push(@_file_info, join("\000", $::ARGV, $::app_lineno, $::app_context,
+      scalar(@::sdf_if_now), scalar(@::sdf_tbl_state)));
 
     # Update the message state
     $new_file = $arg{'filename'};
@@ -2223,42 +2223,42 @@
       split(/\000/, pop(@_file_info));
 
     # Adjust the line number & set the context for messages
-    $'app_lineno--;
-    $'app_context = "EOF at ";
+    $::app_lineno--;
+    $::app_context = "EOF at ";
 
     # Check not in a block or macro
-    if ($'sdf_block_type ne '') {
-        $start = $'sdf_block_start;
-        &'AppMsg("error", "!end$'sdf_block_type missing for !$'sdf_block_type on line $start");
+    if ($::sdf_block_type ne '') {
+        $start = $::sdf_block_start;
+        &'AppMsg("error", "!end$::sdf_block_type missing for !$::sdf_block_type on line $start");
 
         # restore the state to something safe
-        $'sdf_block_type = '';
+        $::sdf_block_type = '';
     }
 
     # Check if nesting level is ok
-    $missing = scalar(@'sdf_if_now) - $if_level;
+    $missing = scalar(@::sdf_if_now) - $if_level;
     if ($missing != 0) {
-        $start = $'sdf_if_start[$#main'sdf_if_start];
+        $start = $::sdf_if_start[$#main::sdf_if_start];
         &'AppMsg("error", "!endif missing for !if on line $start");
 
         # pop unexpected ones so that things resync
         $last_index = $if_level - 1;
-        $#main'sdf_if_start = $last_index;
-        $#main'sdf_if_now = $last_index;
-        $#main'sdf_if_yet = $last_index;
-        $#main'sdf_if_else = $last_index;
+        $#main::sdf_if_start = $last_index;
+        $#main::sdf_if_now = $last_index;
+        $#main::sdf_if_yet = $last_index;
+        $#main::sdf_if_else = $last_index;
     }
 
     # Check table nesting level is ok
-    $missing = scalar(@'sdf_tbl_state) - $tbl_level;
+    $missing = scalar(@::sdf_tbl_state) - $tbl_level;
     if ($missing != 0) {
-        $start = $'sdf_tbl_start[$#main'sdf_tbl_start];
+        $start = $::sdf_tbl_start[$#main::sdf_tbl_start];
         &'AppMsg("error", "!endtable missing for !table on line $start");
 
         # pop unexpected ones so that things resync
         $last_index = $tbl_level - 1;
-        $#main'sdf_tbl_start = $last_index;
-        $#main'sdf_tbl_state = $last_index;
+        $#main::sdf_tbl_start = $last_index;
+        $#main::sdf_tbl_state = $last_index;
     }
 
     # Restore the message state
@@ -2274,10 +2274,10 @@
     local($args) = @_;
 
     # Update the line number and context
-    ($'app_lineno, $'app_context) = split(/\;/, $args, 2);
+    ($::app_lineno, $::app_context) = split(/\;/, $args, 2);
 
     # Update the section counter
-    $'sdf_sections++;
+    $::sdf_sections++;
 }
 
 # _eos_ - end of section
@@ -2286,10 +2286,10 @@
     local($args) = @_;
 
     # Update the line number and context
-    ($'app_lineno, $'app_context) = split(/\;/, $args, 2);
+    ($::app_lineno, $::app_context) = split(/\;/, $args, 2);
 
     # Update the section counter
-    $'sdf_sections--;
+    $::sdf_sections--;
 }
 
 # _bor_ - beginning of report processing
@@ -2307,7 +2307,7 @@
 
     # Update the state
     $name = $arg{'name'};
-    push(@'sdf_report_names, $name);
+    push(@::sdf_report_names, $name);
 
     # Load the report
     $rpt_file = &FindModule(&'NameJoin('', $name, 'sdr'));
@@ -2341,7 +2341,7 @@
     local($end_fn);
 
     # Update the state
-    $name = pop(@'sdf_report_names);
+    $name = pop(@::sdf_report_names);
 
     # End the report
     $end_fn = $name . "_ReportEnd";
@@ -2453,7 +2453,7 @@
 #   local(@text);
     local($page_size, $page_width, $page_height);
 
-    $page_size = $'sdf_pagesize{$var{'OPT_PAGE_SIZE'}};
+    $page_size = $::sdf_pagesize{$var{'OPT_PAGE_SIZE'}};
     if ($page_size ne '') {
         ($page_width, $page_height) = split(/\000/, $page_size, 2);
     }
