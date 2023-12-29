$NetBSD: patch-perllib_sdf_topod.pl,v 1.1 2019/09/10 21:20:35 schmonz Exp $

Use /m instead of $*, no longer available in Perl 5.30.
Patch from Debian: 005_multiline.diff

--- perllib/sdf/topod.pl.orig	1999-04-28 16:39:11.000000000 +0000
+++ perllib/sdf/topod.pl
@@ -202,22 +202,22 @@ sub _PodParaAdd {
     local($indent);
 
     # Set the example flag
-    $_pod_in_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $_pod_in_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     # Get the target format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $para_tag if $para_fmt eq '';
 
     # Map the attributes
-    &SdfAttrMap(*para_attrs, 'pod', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'pod', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
 
     # Build the Table of Contents as we go
     $toc_jump = '';
     if ($para_tag =~ /^[HAP](\d)$/) {
         $hdg_level = $1;
-        if ($hdg_level <= $SDF_USER'var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
+        if ($hdg_level <= $SDF_USER::var{'DOC_TOC'} && !$para_attrs{'notoc'}) {
 
             # Build a plain list in SDF
             $toc_jump = $para_attrs{'id'};
@@ -326,12 +326,12 @@ sub _PodParaText {
             $text = &_PodEscape($text, 1);
 
             # Process formatting attributes
-            &SdfAttrMap(*sect_attrs, 'pod', *SDF_USER'phraseattrs_to,
-              *SDF_USER'phraseattrs_map, *SDF_USER'phraseattrs_attrs,
-              $SDF_USER'phrasestyles_attrs{$char_tag});
+            &SdfAttrMap(*sect_attrs, 'pod', *SDF_USER::phraseattrs_to,
+              *SDF_USER::phraseattrs_map, *SDF_USER::phraseattrs_attrs,
+              $SDF_USER::phrasestyles_attrs{$char_tag});
 
             # Map the font - italics is the default
-            $char_font = $SDF_USER'phrasestyles_to{$char_tag};
+            $char_font = $SDF_USER::phrasestyles_to{$char_tag};
             $char_font = 'I' if $char_font eq '';
 
             # Add the text for this phrase
@@ -389,19 +389,11 @@ sub _PodFinalise {
 sub _PodEscape {
     local($text, $nested) = @_;
 #   local($result);
-    local($old_match_flag);
-
-    # Enable multi-line matching
-    $old_match_flag = $*;
-    $* = 1;
 
     # Escape the symbols
     my $gt = $nested ? 'E<gt>' : '>';
     $text =~ s/([A-Z])\<|\>/length($&) == 1 ? $gt : "$1E<lt>"/eg;
 
-    # Reset multi-line matching flag
-    $* = $old_match_flag;
-
     # Return result
     $text;
 }
