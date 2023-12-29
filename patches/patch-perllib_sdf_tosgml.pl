$NetBSD: patch-perllib_sdf_tosgml.pl,v 1.1 2019/09/10 21:20:35 schmonz Exp $

Use /m instead of $*, no longer available in Perl 5.30.
Patch from Debian: 005_multiline.diff

--- perllib/sdf/tosgml.pl.orig	1999-04-28 16:39:46.000000000 +0000
+++ perllib/sdf/tosgml.pl
@@ -197,7 +197,7 @@ sub _SgmlParaAdd {
     local($list_tag);
 
     # Get the example flag
-    $is_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $is_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     # Enumerated lists are the same as list paragraphs at the previous level,
     # except that we bold the text
@@ -207,13 +207,13 @@ sub _SgmlParaAdd {
     }
 
     # Get the target format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $is_example ? 'tscreen' : 'p' if $para_fmt eq '';
 
     # Map the attributes
-    &SdfAttrMap(*para_attrs, 'sgml', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'sgml', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
 
     # Handle headings
     if ($para_tag =~ /^[HAP](\d)$/) {
@@ -326,7 +326,7 @@ sub _SgmlParaText {
 
             # Expand out link phrases
             if ($char_tag eq 'L') {
-                ($text, $url) = &SDF_USER'ExpandLink($text);
+                ($text, $url) = &SDF_USER::ExpandLink($text);
                 $sect_attrs{'jump'} = $url;
             }
 
@@ -342,12 +342,12 @@ sub _SgmlParaText {
             $added_anchors = &_SgmlAddAnchors(*text, *sect_attrs);
 
             # Process formatting attributes
-            &SdfAttrMap(*sect_attrs, 'sgml', *SDF_USER'phraseattrs_to,
-              *SDF_USER'phraseattrs_map, *SDF_USER'phraseattrs_attrs,
-              $SDF_USER'phrasestyles_attrs{$char_tag});
+            &SdfAttrMap(*sect_attrs, 'sgml', *SDF_USER::phraseattrs_to,
+              *SDF_USER::phraseattrs_map, *SDF_USER::phraseattrs_attrs,
+              $SDF_USER::phrasestyles_attrs{$char_tag});
 
             # Map the font
-            $char_font = $SDF_USER'phrasestyles_to{$char_tag};
+            $char_font = $SDF_USER::phrasestyles_to{$char_tag};
             $char_font = 'em' if $char_font eq '' && !$added_anchors;
 
             # Add the text for this phrase
@@ -416,11 +416,6 @@ sub _SgmlFinalise {
 sub _SgmlEscape {
     local($text) = @_;
 #   local($result);
-    local($old_match_flag);
-
-    # Enable multi-line matching
-    $old_match_flag = $*;
-    $* = 1;
 
     # Escape the special symbols. Note that it isn't exactly clear
     # from the SGML-Tools and/or QWERTZ DTD documentation as to
@@ -438,9 +433,6 @@ sub _SgmlEscape {
     $text =~ s/\|/&verbar;/g;
     $text =~ s/\[/&ftag;/g;
 
-    # Reset multi-line matching flag
-    $* = $old_match_flag;
-
     # Return result
     $text;
 }
@@ -528,15 +520,10 @@ sub _SgmlAddAnchors {
     local($result);
     local($value);
     local($user_ext);
-    local($old_match_flag);
 
     # Skip this routine for now
     return 0;
 
-    # Enable multi-line matching
-    $old_match_flag = $*;
-    $* = 1;
-
     # For hypertext jumps, surround the text. If the
     # text contains a jump, the existing jump is removed.
     if ($attr{'jump'} ne '') {
@@ -545,7 +532,7 @@ sub _SgmlAddAnchors {
         # requested, change the jump value accordingly. Also,
         # we make sure than any special characters are escaped.
         $value = $attr{'jump'};
-        $user_ext = $SDF_USER'var{'SGML_EXT'};
+        $user_ext = $SDF_USER::var{'SGML_EXT'};
         if ($user_ext) {
             $value =~ s/\.sgml/.$user_ext/;
         }
@@ -572,9 +559,6 @@ sub _SgmlAddAnchors {
         $result++;
     }
 
-    # Reset multi-line matching flag
-    $* = $old_match_flag;
-
     # Return result
     return $result;
 }
