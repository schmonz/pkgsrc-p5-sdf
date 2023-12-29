$NetBSD$

--- perllib/sdf/subs.pl.orig	1999-05-12 12:39:14.000000000 +0000
+++ perllib/sdf/subs.pl
@@ -28,7 +28,7 @@
 
 
 # Make sure we can call the Value function from the main package
-sub Value {&SDF_USER'Value;}
+sub Value {&SDF_USER::Value;}
 
 # Switch to the user package
 package SDF_USER;
@@ -193,12 +193,12 @@
     my @dirs = ('.');
     my $dir = $var{'DOC_DIR'};
     push(@dirs, $dir) if $dir ne cwd();
-    push(@dirs, @include_path, $'sdf_lib);
+    push(@dirs, @include_path, $::sdf_lib);
 
     # Do the search
     if ($image) {
         my $context = $var{'OPT_TARGET'};
-        my @exts = @{$'SDF_IMAGE_EXTS{$context} || $'SDF_IMAGE_EXTS{'ps'}};
+        my @exts = @{$::SDF_IMAGE_EXTS{$context} || $::SDF_IMAGE_EXTS{'ps'}};
         &'AppTrace("user", 5, "searching for image '$filename' in directories (" .
           join(",", @dirs) . ") with $context extensions (" .
           join(",", @exts) . ")");
@@ -231,7 +231,7 @@
     my @dirs = ('.');
     my $dir = $var{'DOC_DIR'};
     push(@dirs, $dir) if $dir ne cwd();
-    push(@dirs, @module_path, $'sdf_lib, "$'sdf_lib/stdlib");
+    push(@dirs, @module_path, $::sdf_lib, "$::sdf_lib/stdlib");
 
     # Do the search
     &'AppTrace("user", 4, "searching for module '$filename' in directories (" .
@@ -260,14 +260,14 @@
     my @dirs = ('.');
     my $dir = $var{'DOC_DIR'};
     push(@dirs, $dir) if $dir ne cwd();
-    push(@dirs, @library_path, $'sdf_lib);
+    push(@dirs, @library_path, $::sdf_lib);
 
     # Do the search
     &'AppTrace("user", 3, "searching for library '$lib' in directories (" .
       join(",", @dirs) . ")");
     $fullname = '';
     for $dir (@dirs) {
-        $lib_path = $dir eq $'NAME_DIR_SEP ? "$dir$lib" : "$dir$'NAME_DIR_SEP$lib";
+        $lib_path = $dir eq $::NAME_DIR_SEP ? "$dir$lib" : "$dir$::NAME_DIR_SEP$lib";
         if (-d $lib_path) {
             $fullname = $lib_path;
             last;
@@ -300,12 +300,12 @@
     local($macro_fn);
 
     # Set the context for messages
-    $'app_context = 'macro on ' unless $'sdf_sections;
+    $::app_context = 'macro on ' unless $::sdf_sections;
 
     # Activate event processing
-    &ReportEvents('macro') if @'sdf_report_names;
+    &ReportEvents('macro') if @::sdf_report_names;
     &ExecEventsNameMask(*evcode_macro, *evmask_macro) if @evcode_macro;
-    &ReportEvents('macro', 'Post') if @'sdf_report_names;
+    &ReportEvents('macro', 'Post') if @::sdf_report_names;
 
     # Macros implemented in Perl have a subroutine which can be called
     $macro_fn = $name . "_Macro";
@@ -319,8 +319,8 @@
         # increment within the generated output.
         return ()    unless @text;
         return @text if $name =~ /^_/ || $text[0] =~ /^\!_bof/;
-        return ("!_bos_ $'app_lineno;macro on ", @text,
-                "!_eos_ $'app_lineno;$'app_context");
+        return ("!_bos_ $::app_lineno;macro on ", @text,
+                "!_eos_ $::app_lineno;$::app_context");
     }
 
     # For macros implemented in SDF, the macro is stored in %macro
@@ -330,8 +330,8 @@
         &'AppMsg("warning", "ignoring arguments for macro '$name'") if $args ne '';
 
         # Return the data
-        return ("!_bos_ $'app_lineno;macro on ", split("\n", $macro{$name}),
-                "!_eos_ $'app_lineno;$'app_context");
+        return ("!_bos_ $::app_lineno;macro on ", split("\n", $macro{$name}),
+                "!_eos_ $::app_lineno;$::app_context");
     }
 
     # If we reach here, macro is unknown
@@ -361,17 +361,17 @@
     return if $name eq '';
 
     # Setup the message parameters, if necessary
-    $orig_lineno   = $'app_lineno;
-    $orig_filename = $'ARGV;
-    $orig_context  = $'app_context;
-    $'app_lineno   = $lineno    if defined $lineno;
-    $'ARGV         = $filename  if defined $filename;
-    $'app_context  = $context   if defined $context;
+    $orig_lineno   = $::app_lineno;
+    $orig_filename = $::ARGV;
+    $orig_context  = $::app_context;
+    $::app_lineno   = $lineno    if defined $lineno;
+    $::ARGV         = $filename  if defined $filename;
+    $::app_context  = $context   if defined $context;
 
     # Activate event processing
-    &ReportEvents('filter') if @'sdf_report_names;
+    &ReportEvents('filter') if @::sdf_report_names;
     &ExecEventsNameMask(*evcode_filter, *evmask_filter) if @evcode_filter;
-    &ReportEvents('filter', 'Post') if @'sdf_report_names;
+    &ReportEvents('filter', 'Post') if @::sdf_report_names;
 
     # If necessary, load the plug-in, if any
     $filter_fn = $name . "_Filter";
@@ -402,9 +402,9 @@
     }
 
     # Restore the message parameters
-    $'app_lineno  = $orig_lineno;
-    $'ARGV        = $orig_filename;
-    $'app_context = $orig_context;
+    $::app_lineno  = $orig_lineno;
+    $::ARGV        = $orig_filename;
+    $::app_context = $orig_context;
 }
 
 #
@@ -602,7 +602,7 @@
     local($rpt);
     local($fn);
 
-    for $rpt (@'sdf_report_names) {
+    for $rpt (@::sdf_report_names) {
         $fn = "${rpt}_ReportEvent${post}";
         &$fn($tag) if defined &$fn;
     }
@@ -620,10 +620,6 @@
     local($event, $action, $mask);
     local($old_match_rule);
 
-    # Ensure multi-line matching is enabled
-    $old_match_rule = $*;
-    $* = 1;
-
     for ($event = $#code; $event >= 0; $event--) {
 
         # get the action to execute, if any
@@ -632,7 +628,7 @@
 
         # Mask out events
         $mask = $mask[$event];
-        next if $mask ne '' && $style !~ /^$mask$/;
+        next if $mask ne '' && $style !~ /^$mask$/m;
         return if $attr{'noevents'};
 
         # execute the action
@@ -640,8 +636,6 @@
         &'AppMsg("warning", "execution of '$action' failed: $@") if $@;
     }
 
-    # Restore the multi-line match flag setting
-    $* = $old_match_rule;
 }
 
 #
@@ -654,11 +648,6 @@
     local(*code, *mask) = @_;
 #   local();
     local($event, $action, $mask);
-    local($old_match_rule);
-
-    # Ensure multi-line matching is enabled
-    $old_match_rule = $*;
-    $* = 1;
 
     for ($event = $#code; $event >= 0; $event--) {
 
@@ -668,15 +657,12 @@
 
         # Mask out events
         $mask = $mask[$event];
-        next if $mask ne '' && $name !~ /^$mask$/;
+        next if $mask ne '' && $name !~ /^$mask$/m;
 
         # execute the action
         eval $action;
         &'AppMsg("warning", "execution of '$action' failed: $@") if $@;
     }
-
-    # Restore the multi-line match flag setting
-    $* = $old_match_rule;
 }
 #
 # >>Description::
@@ -975,7 +961,7 @@
         if (open(CONV_SET, $name)) {
             my $nv_text = join("\n", <CONV_SET>);
             close(CONV_SET);
-            %params = &main'AppSectionValues($nv_text);
+            %params = &main::AppSectionValues($nv_text);
 #print STDERR "nv_text: $nv_text<\n";
 #for $igc (sort keys %params) {
 #print STDERR "$igc: $params{$igc}.\n";
