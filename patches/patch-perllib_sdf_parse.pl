$NetBSD$

--- perllib/sdf/parse.pl.orig	1999-05-25 03:48:29.000000000 +0000
+++ perllib/sdf/parse.pl
@@ -240,16 +240,16 @@
 @_sdf_appendix_counters = ();
 
 # Package SDF_USER contains data exported to the user world
-%SDF_USER'var = ();
-$SDF_USER'style = '';
-$SDF_USER'text = '';
-$SDF_USER'append = '';
-%SDF_USER'attr = ();
-$SDF_USER'level = 0;
-$SDF_USER'prev_style = '';
-$SDF_USER'prev_text = '';
-%SDF_USER'prev_attr = ();
-%SDF_USER'previous_text_for_style = ();
+%SDF_USER::var = ();
+$SDF_USER::style = '';
+$SDF_USER::text = '';
+$SDF_USER::append = '';
+%SDF_USER::attr = ();
+$SDF_USER::level = 0;
+$SDF_USER::prev_style = '';
+$SDF_USER::prev_text = '';
+%SDF_USER::prev_attr = ();
+%SDF_USER::previous_text_for_style = ();
 
 ##### Routines #####
 
@@ -272,7 +272,7 @@
     local($fmt);
 
     # Validate the table
-    &TableValidate(*table, *_SDF_DRIVER_RULES) if $'verbose;
+    &TableValidate(*table, *_SDF_DRIVER_RULES) if $::verbose;
 
     # Load the drivers
     @flds = &TableFields(shift(@table));
@@ -297,7 +297,7 @@
     local($size);
 
     # Validate the table
-    &TableValidate(*table, *_SDF_PAGESIZE_RULES) if $'verbose;
+    &TableValidate(*table, *_SDF_PAGESIZE_RULES) if $::verbose;
 
     # Load the page sizes
     @flds = &TableFields(shift(@table));
@@ -471,10 +471,10 @@
     &InitSubs;
 
     # Initialise the user variables
-    %var = %'var;
-    @include_path = @'sdf_include_path;
-    @library_path = @'sdf_library_path;
-    @module_path = @'sdf_library_path;
+    %var = %::var;
+    @include_path = @::sdf_include_path;
+    @library_path = @::sdf_library_path;
+    @module_path = @::sdf_library_path;
 
     # Initialise global variables within this package
     package main;
@@ -499,7 +499,7 @@
     @sdf_report_names = ();
     @_sdf_heading_counters = ();
     @_sdf_appendix_counters = ();
-    %SDF_USER'previous_text_for_style = ();
+    %SDF_USER::previous_text_for_style = ();
 }
 
 #
@@ -560,7 +560,7 @@
 
             # Detect block ends
             if ($macro eq "end$sdf_block_type" && --$_sdf_block_cnt == 0) {
-                unshift(@sdf, &SDF_USER'ExecMacro($macro, $parameters, 'error'));
+                unshift(@sdf, &SDF_USER::ExecMacro($macro, $parameters, 'error'));
                 if (@sdf_end) {
                     push(@sdf, @sdf_end);
                     @sdf_end = ();
@@ -570,7 +570,7 @@
 
             # Make sure end-of-file processing is not missed
             elsif ($macro eq '_eof_') {
-                unshift(@sdf, &SDF_USER'ExecMacro($macro, $parameters, 'error'));
+                unshift(@sdf, &SDF_USER::ExecMacro($macro, $parameters, 'error'));
                 next record;
             }
 
@@ -597,7 +597,7 @@
 
             # Process the macro - if this macro starts a block, set the
             # nested count and starting character accordingly
-            unshift(@sdf, &SDF_USER'ExecMacro($macro, $parameters, 'warning'));
+            unshift(@sdf, &SDF_USER::ExecMacro($macro, $parameters, 'warning'));
             if (@sdf_end) {
                 push(@sdf, @sdf_end);
                 @sdf_end = ();
@@ -625,7 +625,7 @@
 
         # Convert level 0 headings to the build_title macro
         if ($style =~ /^[HAP]0$/) {
-            $SDF_USER'var{'DOC_NAME'} = $text;
+            $SDF_USER::var{'DOC_NAME'} = $text;
             unshift(@sdf, "!build_title");
             $_sdf_next_lineno--;
             next;
@@ -640,7 +640,7 @@
         return ($text, $style, %attr);
     }
 
-print "lines: $igc_cnt\n" if $SDF_USER'var{'igc'};
+print "lines: $igc_cnt\n" if $SDF_USER::var{'igc'};
     # If we reach here, the buffer is empty
     return ();
 }
@@ -763,35 +763,35 @@
         package SDF_USER;
         local($style, $text, %attr, @_prepend, @_append);
 
-        $'attr{'orig_style'} = $'style;
-        $style = $'style;
-        $text = $'text;
-        %attr = %'attr;
+        $::attr{'orig_style'} = $::style;
+        $style = $::style;
+        $text = $::text;
+        %attr = %::attr;
         @_prepend = ();
         @_append = ();
-        &ReportEvents('paragraph') if @'sdf_report_names;
+        &ReportEvents('paragraph') if @::sdf_report_names;
         &ExecEventsStyleMask(*evcode_paragraph, *evmask_paragraph);
-        &ReportEvents('paragraph', 'Post') if @'sdf_report_names;
-        $'style = $style;
-        $'text = $text;
-        %'attr = %attr;
+        &ReportEvents('paragraph', 'Post') if @::sdf_report_names;
+        $::style = $style;
+        $::text = $text;
+        %::attr = %attr;
         $level = $1 if $style =~ /^[HAP](\d)$/;
         $prev_style = $style;
         $prev_text = $text;
         %prev_attr = %attr;
         $previous_text_for_style{$style} = $text unless $attr{'continued'};
-        unshift(@'rest,
-            "!_bos_ $'app_lineno;text appended to ",
+        unshift(@::rest,
+            "!_bos_ $::app_lineno;text appended to ",
             @_append,
-            "!_eos_ $'app_lineno;$'app_context") if @_append;
+            "!_eos_ $::app_lineno;$::app_context") if @_append;
         if (@_prepend) {
 #printf STDERR "prepending \n\t%s<\n", join("<\n\t", @_prepend);
             $attr{'noevents'} = 1;
-            unshift(@'rest,
-                "!_bos_ $'app_lineno;text prepended to ",
+            unshift(@::rest,
+                "!_bos_ $::app_lineno;text prepended to ",
                 @_prepend,
                 &'SdfJoin($style, $text, %attr),
-                "!_eos_ $'app_lineno;$'app_context");
+                "!_eos_ $::app_lineno;$::app_context");
             return ();
         }
     }
@@ -804,7 +804,7 @@
     &SdfAttrClean(*attr) if %attr;
 
     # Check the style is legal
-    unless (defined($SDF_USER'parastyles_name{$style})) {
+    unless (defined($SDF_USER::parastyles_name{$style})) {
         &AppMsg("warning", "unknown paragraph style '$style'");
     }
 
@@ -918,8 +918,8 @@
 
     # Trim leading space except for examples and internal directives
     # For examples, convert tabs to spaces
-    if ($SDF_USER'parastyles_category{$style} eq 'example') {
-        $tab_size = $SDF_USER'var{'DEFAULT_TAB_SIZE'};
+    if ($SDF_USER::parastyles_category{$style} eq 'example') {
+        $tab_size = $SDF_USER::var{'DEFAULT_TAB_SIZE'};
         1 while $text =~ s/\t+/' ' x (length($&) * $tab_size - length($`) % $tab_size)/e;
     }
     elsif ($style !~ /^__/) {
@@ -1313,7 +1313,7 @@
     $style = 1 if $style eq '';
 
     # Trim leading space except for examples
-    if ($SDF_USER'phrasestyles_category{$style} ne 'example') {
+    if ($SDF_USER::phrasestyles_category{$style} ne 'example') {
         $text =~ s/^\s+//;
     }
 
@@ -1321,7 +1321,7 @@
     %attr = &SdfAttrSplit($attrs);
 
     # Handle special styles
-    if ($SDF_USER'phrasestyles_category{$style} eq 'special') {
+    if ($SDF_USER::phrasestyles_category{$style} eq 'special') {
         $fn = "SDF_USER'${style}_Special";
         if (defined &$fn) {
             &$fn(*style, *text, *attr);
@@ -1334,17 +1334,17 @@
 
     # Activate event processing
     package SDF_USER;
-    $style = $'style;
-    $text = $'text;
+    $style = $::style;
+    $text = $::text;
     $append = '';
-    %attr = %'attr;
-    &ReportEvents('phrase') if @'sdf_report_names;
+    %attr = %::attr;
+    &ReportEvents('phrase') if @::sdf_report_names;
     &ExecEventsStyleMask(*evcode_phrase, *evmask_phrase);
-    &ReportEvents('phrase', 'Post') if @'sdf_report_names;
-    $'style = $style;
-    $'text = $text;
-    $'append = $append;
-    %'attr = %attr;
+    &ReportEvents('phrase', 'Post') if @::sdf_report_names;
+    $::style = $style;
+    $::text = $text;
+    $::append = $append;
+    %::attr = %attr;
     undef $style;
     undef $text;
     undef %attr;
@@ -1367,7 +1367,7 @@
 
     # Check the style is legal
     if ($style !~ /^__/) {
-        unless (defined($SDF_USER'phrasestyles_name{$style})) {
+        unless (defined($SDF_USER::phrasestyles_name{$style})) {
             &AppMsg("warning", "unknown phrase style '$style'");
         }
     }
@@ -1420,7 +1420,7 @@
     local($name) = @_;
 #   local($pts);
 
-    return &SdfPoints($SDF_USER'var{$name});
+    return &SdfPoints($SDF_USER::var{$name});
 }
 
 #
@@ -1433,25 +1433,25 @@
     local($part, $newpage);
 
     if ($category eq 'macro') {
-        if (defined $SDF_USER'macro{"PAGE_${page}_$attr"}) {
-            $info = $SDF_USER'macro{"PAGE_${page}_$attr"};
+        if (defined $SDF_USER::macro{"PAGE_${page}_$attr"}) {
+            $info = $SDF_USER::macro{"PAGE_${page}_$attr"};
         }
         elsif ($page =~ /_/) {
             ($part, $newpage) = ($`, $');
             $newpage = 'RIGHT' if $newpage eq 'FIRST' && $part ne 'FRONT';
 #printf STDERR "$page -> $newpage ($attr)\n";
-            $info = $SDF_USER'macro{"PAGE_${newpage}_$attr"};
+            $info = $SDF_USER::macro{"PAGE_${newpage}_$attr"};
         }
     }
     else {
-        if (defined $SDF_USER'var{"PAGE_${page}_$attr"}) {
-            $info = $SDF_USER'var{"PAGE_${page}_$attr"};
+        if (defined $SDF_USER::var{"PAGE_${page}_$attr"}) {
+            $info = $SDF_USER::var{"PAGE_${page}_$attr"};
         }
         elsif ($page =~ /_/) {
             ($part, $newpage) = ($`, $');
             $newpage = 'RIGHT' if $newpage eq 'FIRST' && $part ne 'FRONT';
 #printf STDERR "$page -> $newpage ($attr)\n";
-            $info = $SDF_USER'var{"PAGE_${newpage}_$attr"};
+            $info = $SDF_USER::var{"PAGE_${newpage}_$attr"};
         }
         if ($category eq 'pt') {
             $info = &SdfPoints($info);
@@ -1484,7 +1484,7 @@
     local($expr, $msg_type, $enum) = @_;
     local($result);
     local($format);
-    local($action, $SDF_USER'_);
+    local($action, $SDF_USER::_);
 
     # Get the format, if any
     $format = $1 if $expr =~ s/^(\w+)://;
@@ -1504,18 +1504,18 @@
 
     # Variables
     elsif ($expr =~ /^\w+$/) {
-        if (!defined($SDF_USER'var{$expr})) {
+        if (!defined($SDF_USER::var{$expr})) {
             if ($msg_type) {
                 &AppMsg($msg_type, "variable '$expr' not defined");
             }
             $result = '';
         }
         else {
-            $result = $SDF_USER'var{$expr};
+            $result = $SDF_USER::var{$expr};
         }
     }
     elsif ($expr =~ /^\!\s*(\w+)$/) {
-        $result = $SDF_USER'var{$1} ? 0 : 1;
+        $result = $SDF_USER::var{$1} ? 0 : 1;
     }
     elsif ($expr =~ /^$/) {
         $result = '';
@@ -1523,13 +1523,13 @@
 
     # Handle implicit calls to Calc
     elsif ($expr =~ /^[=+]\s*(.+)$/) {
-        $result = &SDF_USER'Calc($1);
+        $result = &SDF_USER::Calc($1);
     }
 
     else {
         # evaluate the expression in "user-land"
         package SDF_USER;
-        $main'result = eval $main'expr;
+        $main::result = eval $main::expr;
         package main;
         if ($@) {
             &AppMsg("warning", "evaluation of '$expr' failed: $@");
@@ -1539,14 +1539,14 @@
 
     # Apply the format, if any
     if ($format ne '') {
-        $action = $SDF_USER'var{"FORMAT_$format"};
+        $action = $SDF_USER::var{"FORMAT_$format"};
         if ($action eq '') {
             &AppMsg("warning", "unknown format '$format'");
         }
         else {
             package SDF_USER;
-            $_ = $main'result;
-            $main'result = eval $main'action;
+            $_ = $main::result;
+            $main::result = eval $main::action;
             package main;
             if ($@) {
                 &AppMsg("warning", "format '$format' failed: $@");
@@ -1706,11 +1706,11 @@
     local($name);
 
     # Keep all attributes for raw format
-    $driver = $SDF_USER'var{'OPT_DRIVER'};
+    $driver = $SDF_USER::var{'OPT_DRIVER'};
     return if $driver eq 'raw';
 
     # Delete attributes in 'families' other than the current driver or target
-    $target = $SDF_USER'var{'OPT_TARGET'};
+    $target = $SDF_USER::var{'OPT_TARGET'};
     for $name (keys %attr) {
         delete $attr{$name} if $name =~ /^(\w+)\./ && $1 ne $driver &&
           $1 ne $target;
@@ -1786,7 +1786,7 @@
 
     # Get the new value
     package SDF_USER;
-    $'newvalue = eval $'action;
+    $::newvalue = eval $::action;
     package main;
     &AppMsg("warning", "attribute mapping via '$map' failed: $@ (action: $action)") if $@;
     $value = $newvalue if defined $newvalue;
@@ -1804,18 +1804,18 @@
 
     # check the attribute is known & get the type and rule, if any
     if ($kind eq 'paragraph') {
-        unless ($SDF_USER'paraattrs_name{$name}) {
+        unless ($SDF_USER::paraattrs_name{$name}) {
             &AppMsg("warning", "unknown paragraph attribute '$name'");
         }
-        $type = $SDF_USER'paraattrs_type{$name};
-        $rule = $SDF_USER'paraattrs_rule{$name};
+        $type = $SDF_USER::paraattrs_type{$name};
+        $rule = $SDF_USER::paraattrs_rule{$name};
     }
     else {
-        unless ($SDF_USER'phraseattrs_name{$name}) {
+        unless ($SDF_USER::phraseattrs_name{$name}) {
             &AppMsg("warning", "unknown phrase attribute '$name'");
         }
-        $type = $SDF_USER'phraseattrs_type{$name};
-        $rule = $SDF_USER'phraseattrs_rule{$name};
+        $type = $SDF_USER::phraseattrs_type{$name};
+        $rule = $SDF_USER::phraseattrs_rule{$name};
     }
 
 
@@ -2036,7 +2036,7 @@
     local($cmd) = @_;
     local($exit_code);
 
-    &'AppMsg("object", "executing '$cmd'\n") if $'verbose >= 1;
+    &'AppMsg("object", "executing '$cmd'\n") if $::verbose >= 1;
     $exit_code = system($cmd);
     if ($exit_code) {
         $exit_code = $exit_code / 256;
@@ -2054,7 +2054,7 @@
     # Save the output in a temporary file
     my $tmp_file = "/tmp/sdf$$";
     $cmd .= " > $tmp_file";
-    $cmd .= " 2>&1" if $'NAME_OS eq 'unix';
+    $cmd .= " 2>&1" if $::NAME_OS eq 'unix';
 
     # Execute the command
     $exit_code = &SdfSystem($cmd);
@@ -2140,7 +2140,7 @@
 #   local();
 
     if (-f $file) {
-        &'AppMsg("object", "deleting '$file'") if $'verbose >= 1;
+        &'AppMsg("object", "deleting '$file'") if $::verbose >= 1;
         unless (unlink($file)) {
             &'AppMsg("object", "delete of '$file' failed: $!");
         }
@@ -2156,12 +2156,12 @@
     local(@cannot);
 
     # Leave things alone if verbose mode is on or there is nothing to do
-    return if $'verbose;
-    return unless @'sdf_book_files;
+    return if $::verbose;
+    return unless @::sdf_book_files;
 
     # If an extension is given, use that set of
     # files, rather than the known ones.
-    @files = @'sdf_book_files;
+    @files = @::sdf_book_files;
     if ($ext ne '') {
         for $_ (@files) {
             $_ = &'NameSubExt($_, $ext);
@@ -2184,7 +2184,7 @@
     local($cmd);
 
     # Do nothing unless FrameMaker 5 is being used
-    return unless $'sdf_fmext eq 'fm5';
+    return unless $::sdf_fmext eq 'fm5';
 
     # Wait until the print driver has finished
     &'AppMsg("object", "waiting for the print driver\n");
