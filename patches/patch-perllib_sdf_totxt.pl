$NetBSD$

--- perllib/sdf/totxt.pl.orig	2023-10-09 16:27:41.551339314 +0000
+++ perllib/sdf/totxt.pl
@@ -168,7 +168,7 @@ $_TXT_INCELL  = 3;
 ##### Variables #####
 
 # Right margin position
-$_txt_margin = $SDF_USER'var{'TXT_MARGIN'} || $_TXT_DEFAULT_MARGIN;
+$_txt_margin = $SDF_USER::var{'TXT_MARGIN'} || $_TXT_DEFAULT_MARGIN;
 
 # Counters for ordered lists - index is the level
 @_txt_list_num = 0;
@@ -199,7 +199,7 @@ sub TxtFormat {
     local(@contents);
 
     # Initialise defaults
-    $_txt_margin = $SDF_USER'var{'TXT_MARGIN'} || $_TXT_DEFAULT_MARGIN;
+    $_txt_margin = $SDF_USER::var{'TXT_MARGIN'} || $_TXT_DEFAULT_MARGIN;
 
     # Format the paragraphs
     @contents = ();
@@ -273,7 +273,7 @@ sub _TxtParaAdd {
     local($label);
 
     # Set the example flag
-    $in_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $in_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     # Enumerated lists are the same as list paragraphs at the previous level
     if ($para_tag =~ /^LI(\d)$/) {
@@ -281,20 +281,20 @@ sub _TxtParaAdd {
     }
 
     # Get the target format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $para_tag if $para_fmt eq '';
 
     # Map the attributes
-    &SdfAttrMap(*para_attrs, 'txt', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'txt', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
 
     # Build the Table of Contents as we go
     $toc_jump = '';
     if ($para_tag =~ /^([HAP])(\d)$/) {
         $hdg_level = $2;
         $para_text = &SdfHeadingPrefix($1, $2) . $para_text;
-        if ($hdg_level <= $SDF_USER'var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
+        if ($hdg_level <= $SDF_USER::var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
 
             # Build a plain list in SDF
             $toc_jump = $para_attrs{'id'};
@@ -391,7 +391,7 @@ sub _TxtParaText {
         }
 
         elsif ($sect_type eq 'phrase') {
-            ($text) = &SDF_USER'ExpandLink($text) if $char_tag eq 'L';
+            ($text) = &SDF_USER::ExpandLink($text) if $char_tag eq 'L';
             $para .= $text;
         }
 
@@ -449,7 +449,7 @@ sub _TxtElement {
     # For headings, underline the text unless requested not to
     elsif ($tag =~ /^[HAP](\d)/) {
         $txt = "$text\n";
-        unless ($SDF_USER'var{'TXT_HDG_UL_OFF'}){
+        unless ($SDF_USER::var{'TXT_HDG_UL_OFF'}){
             $char = $1 == 1 ? "=" : "-";
             $txt .= ($char x length($text)) . "\n";
         }
