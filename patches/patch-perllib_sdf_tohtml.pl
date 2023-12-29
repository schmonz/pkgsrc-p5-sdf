$NetBSD: patch-perllib_sdf_tohtml.pl,v 1.1 2019/09/10 21:20:35 schmonz Exp $

Use /m instead of $*, no longer available in Perl 5.30.
Patch from Debian: 005_multiline.diff

--- perllib/sdf/tohtml.pl.orig	1999-05-24 08:44:27.000000000 +0000
+++ perllib/sdf/tohtml.pl
@@ -191,7 +191,7 @@ sub HtmlFormat {
     @_html_title_div = ();
 
     # If we're building topics, save the data for a second pass later
-    if ($SDF_USER'var{'HTML_TOPICS_MODE'}) {
+    if ($SDF_USER::var{'HTML_TOPICS_MODE'}) {
         @data2 = @data;
 
         # Get the current message cursor - we skip the second pass
@@ -221,28 +221,28 @@ sub HtmlFormat {
     if ($msg_counts{'error'} || $msg_counts{'abort'} || $msg_counts{'fatal'} ) {
         # do nothing
     }
-    elsif ($SDF_USER'var{'HTML_TOPICS_MODE'}) {
+    elsif ($SDF_USER::var{'HTML_TOPICS_MODE'}) {
 
-        $main = $SDF_USER'var{'DOC_BASE'};
+        $main = $SDF_USER::var{'DOC_BASE'};
         @topics_table = ();
         @jumps_table = ();
         &_HtmlBuildTopicsData($main, *topics_table, *jumps_table);
 
         # Save the topics and jump data, so users can (eventually) rebuild
         # just a single topic.
-        if ($SDF_USER'var{'HTML_SDJ'}) {
+        if ($SDF_USER::var{'HTML_SDJ'}) {
             &_HtmlSaveTopicsData($main, *topics_table, *jumps_table);
         }
 
         # Initialise things ready for the next pass
         %var2 = %convert_var;      # get the original set of variables
-        $var2{'HTML_MAIN_TITLE'} = $SDF_USER'var{'DOC_TITLE'};
-        $var2{'HTML_URL_CONTENTS'} = $SDF_USER'var{'DOC_BASE'} . ".html";
+        $var2{'HTML_MAIN_TITLE'} = $SDF_USER::var{'DOC_TITLE'};
+        $var2{'HTML_URL_CONTENTS'} = $SDF_USER::var{'DOC_BASE'} . ".html";
         $var2{'HTML_TOPICS_MODE'} = 0;
         $var2{'HTML_SUBTOPICS_MODE'} = 1;
         &SdfInit(*var2);
-        &SDF_USER'topics_Filter(*topics_table, 'data', 1);
-        &SDF_USER'jumps_Filter(*jumps_table, 'data', 1);
+        &SDF_USER::topics_Filter(*topics_table, 'data', 1);
+        &SDF_USER::jumps_Filter(*jumps_table, 'data', 1);
 
         # Build the sub-topics
         @contents2 = ();
@@ -271,26 +271,26 @@ sub _HtmlBuildTopicsData {
     local($jump, $physical);
 
     # Ensure that the main topic is first and that it has the highest level
-    #if ($SDF_USER'topics[0] eq $main) {
-    #    $SDF_USER'levels[0] = 0;
+    #if ($SDF_USER::topics[0] eq $main) {
+    #    $SDF_USER::levels[0] = 0;
     #}
     #else {
-    #    unshift(@SDF_USER'topics, pop(@SDF_USER'topics));
-    #    pop(@SDF_USER'levels);
-    #    unshift(@SDF_USER'levels, 0);
+    #    unshift(@SDF_USER::topics, pop(@SDF_USER::topics));
+    #    pop(@SDF_USER::levels);
+    #    unshift(@SDF_USER::levels, 0);
     #}
-    unshift(@SDF_USER'topics, $main);
-    unshift(@SDF_USER'levels, 0);
+    unshift(@SDF_USER::topics, $main);
+    unshift(@SDF_USER::levels, 0);
 
     # Build the topics table
     @topics_table = ("Topic|Label|Level|Next|Prev|Up");
-    $prev = $SDF_USER'topics[$#SDF_USER'topics];
+    $prev = $SDF_USER::topics[$#SDF_USER::topics];
     %last_at = ();
-    for ($i = 0; $i <= $#SDF_USER'topics; $i++) {
-        $topic = $SDF_USER'topics[$i];
-        $level = $SDF_USER'levels[$i];
-        $label = $SDF_USER'topic_label{$topic};
-        $next  = $i < $#SDF_USER'topics ? $SDF_USER'topics[$i + 1] : $SDF_USER'topics[0];
+    for ($i = 0; $i <= $#SDF_USER::topics; $i++) {
+        $topic = $SDF_USER::topics[$i];
+        $level = $SDF_USER::levels[$i];
+        $label = $SDF_USER::topic_label{$topic};
+        $next  = $i < $#SDF_USER::topics ? $SDF_USER::topics[$i + 1] : $SDF_USER::topics[0];
         $up    = $last_at{$level - 1};
         push(@topics_table, "$topic|$label|$level|$next|$prev|$up");
 
@@ -301,8 +301,8 @@ sub _HtmlBuildTopicsData {
 
     # Build the jumps table
     @jumps_table = ("Jump|Physical");
-    for $jump (sort keys %SDF_USER'jump) {
-        $physical = $SDF_USER'jump{$jump};
+    for $jump (sort keys %SDF_USER::jump) {
+        $physical = $SDF_USER::jump{$jump};
         push(@jumps_table, "$jump|$physical");
     }
 }
@@ -423,7 +423,7 @@ sub _HtmlParaAdd {
     local($note_attrs);
 
     # Get the example flag
-    $is_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $is_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     # Enumerated lists are the same as list paragraphs at the previous level,
     # except that we bold the text
@@ -433,13 +433,13 @@ sub _HtmlParaAdd {
     }
 
     # Get the target format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $is_example ? 'PRE' : 'P' if $para_fmt eq '';
 
     # Map the attributes
-    &SdfAttrMap(*para_attrs, 'html', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'html', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
 
     # Build the Table of Contents as we go
     $toc_jump = '';
@@ -447,22 +447,22 @@ sub _HtmlParaAdd {
         $hdg_level = $2;
         my $orig_para_text = $para_text;
         $para_text = &SdfHeadingPrefix($1, $2) . $para_text;
-        if ($SDF_USER'var{'HTML_SUBTOPICS_MODE'}) {
+        if ($SDF_USER::var{'HTML_SUBTOPICS_MODE'}) {
             $para_fmt = "H" . substr($para_attrs{'orig_style'}, 1);
         }
         else {
             $para_fmt = "H" . $hdg_level;
         }
-        if ($hdg_level <= $SDF_USER'var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
+        if ($hdg_level <= $SDF_USER::var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
 
             # Build a plain list in SDF. If we're building topics and we're
             # building the contents, make sure the jumps go to the right spot.
-            if ($SDF_USER'var{'HTML_TOPICS_MODE'}) {
-                #$toc_jump = &NameJoin('', $SDF_USER'var{'FILE_BASE'}, "html");
-                #if ($SDF_USER'topic_label{$SDF_USER'var{'FILE_BASE'}} ne $para_text) {
+            if ($SDF_USER::var{'HTML_TOPICS_MODE'}) {
+                #$toc_jump = &NameJoin('', $SDF_USER::var{'FILE_BASE'}, "html");
+                #if ($SDF_USER::topic_label{$SDF_USER::var{'FILE_BASE'}} ne $para_text) {
                 #    $toc_jump .= "#" . $para_attrs{'id'};
                 #}
-                $toc_jump = $_html_jump_id{$SDF_USER'var{'FILE_BASE'},$orig_para_text};
+                $toc_jump = $_html_jump_id{$SDF_USER::var{'FILE_BASE'},$orig_para_text};
             }
             else {
                 $toc_jump = "#" . $para_attrs{'id'};
@@ -606,7 +606,7 @@ sub _HtmlParaText {
 
             # Expand out link phrases
             if ($char_tag eq 'L') {
-                ($text, $url) = &SDF_USER'ExpandLink($text);
+                ($text, $url) = &SDF_USER::ExpandLink($text);
                 $sect_attrs{'jump'} = $url;
             }
 
@@ -631,14 +631,14 @@ sub _HtmlParaText {
             $added_anchors = &_HtmlAddAnchors(*text, *sect_attrs);
 
             # Process formatting attributes
-            &SdfAttrMap(*sect_attrs, 'html', *SDF_USER'phraseattrs_to,
-              *SDF_USER'phraseattrs_map, *SDF_USER'phraseattrs_attrs,
-              $SDF_USER'phrasestyles_attrs{$char_tag});
+            &SdfAttrMap(*sect_attrs, 'html', *SDF_USER::phraseattrs_to,
+              *SDF_USER::phraseattrs_map, *SDF_USER::phraseattrs_attrs,
+              $SDF_USER::phrasestyles_attrs{$char_tag});
             $char_attrs = &_HtmlAttr(*sect_attrs);
 #print STDERR "char_attrs is $char_attrs<\n";
 
             # Map the font
-            $char_font = $SDF_USER'phrasestyles_to{$char_tag};
+            $char_font = $SDF_USER::phrasestyles_to{$char_tag};
             $char_font = $char_tag if $char_font eq '' && !$added_anchors;
 
             # If attributes are specified for an SDF font, use a SPAN
@@ -693,21 +693,21 @@ sub _HtmlFinalise {
 
     # Build the BODY opening stuff
     $body = "BODY";
-    $body .= sprintf(' BACKGROUND="%s"', $SDF_USER'var{"HTML_BG_IMAGE"}) if
-                                  defined($SDF_USER'var{"HTML_BG_IMAGE"});
-    $body .= sprintf(' BGPROPERTIES="FIXED"') if $SDF_USER'var{"HTML_BG_FIXED"};
-    $body .= sprintf(' BGCOLOR="%s"', $SDF_USER'var{"HTML_BG_COLOR"}) if
-                               defined($SDF_USER'var{"HTML_BG_COLOR"});
-    $body .= sprintf(' TEXT="%s"',    $SDF_USER'var{"HTML_TEXT_COLOR"}) if
-                               defined($SDF_USER'var{"HTML_TEXT_COLOR"});
-    $body .= sprintf(' LINK="%s"',    $SDF_USER'var{"HTML_LINK_COLOR"}) if
-                               defined($SDF_USER'var{"HTML_LINK_COLOR"});
-    $body .= sprintf(' VLINK="%s"',   $SDF_USER'var{"HTML_VLINK_COLOR"}) if
-                               defined($SDF_USER'var{"HTML_VLINK_COLOR"});
+    $body .= sprintf(' BACKGROUND="%s"', $SDF_USER::var{"HTML_BG_IMAGE"}) if
+                                  defined($SDF_USER::var{"HTML_BG_IMAGE"});
+    $body .= sprintf(' BGPROPERTIES="FIXED"') if $SDF_USER::var{"HTML_BG_FIXED"};
+    $body .= sprintf(' BGCOLOR="%s"', $SDF_USER::var{"HTML_BG_COLOR"}) if
+                               defined($SDF_USER::var{"HTML_BG_COLOR"});
+    $body .= sprintf(' TEXT="%s"',    $SDF_USER::var{"HTML_TEXT_COLOR"}) if
+                               defined($SDF_USER::var{"HTML_TEXT_COLOR"});
+    $body .= sprintf(' LINK="%s"',    $SDF_USER::var{"HTML_LINK_COLOR"}) if
+                               defined($SDF_USER::var{"HTML_LINK_COLOR"});
+    $body .= sprintf(' VLINK="%s"',   $SDF_USER::var{"HTML_VLINK_COLOR"}) if
+                               defined($SDF_USER::var{"HTML_VLINK_COLOR"});
 
     # Convert the title, if any, to HTML
-    $title = $SDF_USER'var{'HTML_TITLE'};
-    $title = $SDF_USER'var{'DOC_TITLE'} if !defined($title);
+    $title = $SDF_USER::var{'HTML_TITLE'};
+    $title = $SDF_USER::var{'DOC_TITLE'} if !defined($title);
     if ($title) {
         @sdf_title = ("TITLE:$title");
         @title = &_HtmlFormatSection(*sdf_title, *dummy);
@@ -718,13 +718,13 @@ sub _HtmlFinalise {
 
     # Prepend some useful things to the stylesheet, if applicable
     if ($_html_class_count{'changed'}) {
-        my $changed_color = $SDF_USER'var{'HTML_CHANGED_COLOR'};
+        my $changed_color = $SDF_USER::var{'HTML_CHANGED_COLOR'};
         unshift(@_html_stylesheet,
           ".changed {background-color: $changed_color}");
     }
 
     # Build the HEAD element (and append BODY opening)
-    $version = $SDF_USER'var{'SDF_VERSION'};
+    $version = $SDF_USER::var{'SDF_VERSION'};
     @head = (
         '<!doctype html public "-//W30//DTD W3 HTML 2.0//EN">',
         '',
@@ -752,7 +752,7 @@ sub _HtmlFinalise {
 
     # Build the body contents, unless we're generating an input file for
     # the HTMLDOC package
-    unless ($SDF_USER'var{'HTMLDOC'}) {
+    unless ($SDF_USER::var{'HTMLDOC'}) {
         &_HtmlFinaliseBodyContents(*body, *contents);
     }
 
@@ -782,14 +782,14 @@ sub _HtmlFinaliseBodyContents {
 
         # Finish formatting the table of contents
         # Note: we use a filter so that experts can override things!
-        &SDF_USER'toc_html_Filter(*contents);
+        &SDF_USER::toc_html_Filter(*contents);
 
         # Now convert it to HTML
         @html_contents = &_HtmlFormatSection(*contents, *dummy, 'contents');
 
         # If this is a MAIN document, make the body the contents
         # (i.e. ditch the contents). Otherwise, prepend it.
-        if ($SDF_USER'var{'HTML_TOPICS_MODE'}) {
+        if ($SDF_USER::var{'HTML_TOPICS_MODE'}) {
             @body = @html_contents;
         }
         else {
@@ -798,36 +798,36 @@ sub _HtmlFinaliseBodyContents {
     }
 
     # If this is not a topic, prepend the title division, if any
-    unless ($SDF_USER'var{'HTML_SUBTOPICS_MODE'}) {
+    unless ($SDF_USER::var{'HTML_SUBTOPICS_MODE'}) {
         unshift(@body, @_html_title_div);
     }
 
     # Convert the header, if any, to HTML
     $macro = 'HTML_HEADER';
-    if ($SDF_USER'var{'HTML_SUBTOPICS_MODE'} &&
-        $SDF_USER'macro{'HTML_TOPIC_HEADER'}) {
+    if ($SDF_USER::var{'HTML_SUBTOPICS_MODE'} &&
+        $SDF_USER::macro{'HTML_TOPIC_HEADER'}) {
         $macro = 'HTML_TOPIC_HEADER';
     }
-    if ($SDF_USER'macro{$macro} ne '') {
+    if ($SDF_USER::macro{$macro} ne '') {
         @header = ("!$macro");
         unshift(@body, &_HtmlFormatSection(*header, *dummy, 'header'));
     }
 
     # Convert the footer, if any, to HTML
     $macro = 'HTML_FOOTER';
-    if ($SDF_USER'var{'HTML_SUBTOPICS_MODE'} &&
-        $SDF_USER'macro{'HTML_TOPIC_FOOTER'}) {
+    if ($SDF_USER::var{'HTML_SUBTOPICS_MODE'} &&
+        $SDF_USER::macro{'HTML_TOPIC_FOOTER'}) {
         $macro = 'HTML_TOPIC_FOOTER';
     }
-    if ($SDF_USER'macro{$macro} ne '') {
+    if ($SDF_USER::macro{$macro} ne '') {
         @footer = ("!$macro");
         push(@body, &_HtmlFormatSection(*footer, *dummy, 'footer'));
     }
 
     # Add the pre-header and post-footer, if any
-    my $pre_header = $SDF_USER'var{'HTML_PRE_HEADER'};
+    my $pre_header = $SDF_USER::var{'HTML_PRE_HEADER'};
     unshift(@body, $pre_header) if $pre_header ne '';
-    my $post_footer = $SDF_USER'var{'HTML_POST_FOOTER'};
+    my $post_footer = $SDF_USER::var{'HTML_POST_FOOTER'};
     push(@body, $post_footer) if $post_footer ne '';
 }
 
@@ -840,19 +840,12 @@ sub _HtmlEscape {
 #   local($result);
     local($old_match_flag);
 
-    # Enable multi-line matching
-    $old_match_flag = $*;
-    $* = 1;
-
     # Escape the symbols
     $text =~ s/\&/&amp;/g;
     $text =~ s/\</&lt;/g;
     $text =~ s/\>/&gt;/g;
     $text =~ s/\"/&quot;/g;
 
-    # Reset multi-line matching flag
-    $* = $old_match_flag;
-
     # Return result
     $text;
 }
@@ -980,10 +973,6 @@ sub _HtmlAddAnchors {
     local($user_ext);
     local($old_match_flag);
 
-    # Enable multi-line matching
-    $old_match_flag = $*;
-    $* = 1;
-
     # For hypertext jumps, surround the text. If the
     # text contains a jump, the existing jump is removed.
     if ($attr{'jump'} ne '') {
@@ -992,7 +981,7 @@ sub _HtmlAddAnchors {
         # requested, change the jump value accordingly. Also,
         # we make sure than any special characters are escaped.
         $value = $attr{'jump'};
-        $user_ext = $SDF_USER'var{'HTML_EXT'};
+        $user_ext = $SDF_USER::var{'HTML_EXT'};
         if ($user_ext) {
             $value =~ s/\.html/.$user_ext/;
         }
@@ -1019,9 +1008,6 @@ sub _HtmlAddAnchors {
         $result++;
     }
 
-    # Reset multi-line matching flag
-    $* = $old_match_flag;
-
     # Return result
     return $result;
 }
@@ -1372,7 +1358,7 @@ sub _HtmlHandlerOutput {
     # Update the current topic name (without the extension)
     $this_topic = $_html_topic_file[$#_html_topic_file];
     $this_topic =~ s/\.html$//;
-    $SDF_USER'var{'HTML_TOPIC'} = $this_topic;
+    $SDF_USER::var{'HTML_TOPIC'} = $this_topic;
 #print STDERR "HTML_TOPIC: $this_topic.\n";
 }
 
@@ -1559,39 +1545,39 @@ sub HtmlTopicsModeHeading {
     #   section jumps work as expected
     if ($var{'HTML_TOPICS_MODE'}) {
         if (! $topic_label{$file_base} && $file_base ne $var{'DOC_BASE'}) {
-            $'_html_topic = $file_base;
+            $::_html_topic = $file_base;
             push(@levels, $level);
-            push(@topics, $'_html_topic);
-            $topic_label{$'_html_topic} = $text;
-            $topic_level{$'_html_topic} = $level;
-            $jump = $'_html_topic . ".html";
-            $'_html_topic_start{$file_base,$text} = $'_html_topic;
+            push(@topics, $::_html_topic);
+            $topic_label{$::_html_topic} = $text;
+            $topic_level{$::_html_topic} = $level;
+            $jump = $::_html_topic . ".html";
+            $::_html_topic_start{$file_base,$text} = $::_html_topic;
         }
         elsif ($level <= $var{'OPT_SPLIT_LEVEL'}) {
-            if ($'_html_topic_start{$file_base,$text}) {
+            if ($::_html_topic_start{$file_base,$text}) {
                 &'AppMsg("warning", "file base '$file_base' & topic heading '$text' combination is not unique'");
                 return;
             }
-            $'_html_topic = &HtmlTopicName($var{'DOC_BASE'});
+            $::_html_topic = &HtmlTopicName($var{'DOC_BASE'});
             push(@levels, $level);
-            push(@topics, $'_html_topic);
-            $topic_label{$'_html_topic} = $text;
-            $topic_level{$'_html_topic} = $level;
-            $jump = $'_html_topic . ".html";
-            $'_html_topic_start{$file_base,$text} = $'_html_topic;
+            push(@topics, $::_html_topic);
+            $topic_label{$::_html_topic} = $text;
+            $topic_level{$::_html_topic} = $level;
+            $jump = $::_html_topic . ".html";
+            $::_html_topic_start{$file_base,$text} = $::_html_topic;
         }
         else {
             if ($attr{'id'} ne '') {
-                $jump = $'_html_topic . ".html#" . $attr{"id"};
+                $jump = $::_html_topic . ".html#" . $attr{"id"};
             }
             else {
-                $jump = $'_html_topic . ".html#" . &TextToId($text);
+                $jump = $::_html_topic . ".html#" . &TextToId($text);
             }
         }
 
         # Save the jump for this file/text combination.
         # This is used for TOC generation.
-        $'_html_jump_id{$file_base,$text} = $jump;
+        $::_html_jump_id{$file_base,$text} = $jump;
 
         # Save the place to jump to for this text.
         # The jump table is used to resolve SECT jumps (in topics mode).
@@ -1614,13 +1600,13 @@ sub HtmlTopicsModeHeading {
         # * prepend the necessary output directives
         # * make it the title
         # * prevent a line above it by setting the notoc attribute.
-        $topic_base = $'_html_topic_start{$file_base,$text};
+        $topic_base = $::_html_topic_start{$file_base,$text};
         if ($topic_base) {
             $topic_file = "$topic_base.html";
             @prepend = ();
             $new_level = $topic_level{$topic_base};
-            $close_count = $'_html_topic_level - $new_level + 1;
-            $'_html_topic_level = $new_level;
+            $close_count = $::_html_topic_level - $new_level + 1;
+            $::_html_topic_level = $new_level;
             for ($i = 0; $i < $close_count; $i++) {
                 push(@prepend, "!output '-'");
             }
@@ -1643,11 +1629,11 @@ sub HtmlTopicName {
     local($base) = @_;
     local($tname);
 
-    $'_html_topic_cntr++;
+    $::_html_topic_cntr++;
     $tname = $var{'HTML_TOPIC_PATTERN'};
     $tname = '$b_$n' if $tname eq '';
     $tname =~ s/\$b/$base/g;
-    $tname =~ s/\$n/$'_html_topic_cntr/;
+    $tname =~ s/\$n/$::_html_topic_cntr/;
     return $tname;
 }
 
