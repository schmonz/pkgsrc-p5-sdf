$NetBSD$

--- perllib/sdf/tolatex.pl.orig	2023-10-09 16:27:41.549513937 +0000
+++ perllib/sdf/tolatex.pl
@@ -169,7 +169,7 @@ $_LATEX_INCELL  = 3;
 ##### Variables #####
 
 # Right margin position
-$_latex_margin = $SDF_USER'var{'LATEX_MARGIN'} || $_LATEX_DEFAULT_MARGIN;
+$_latex_margin = $SDF_USER::var{'LATEX_MARGIN'} || $_LATEX_DEFAULT_MARGIN;
 
 # Counters for ordered lists - index is the level
 @_latex_list_num = 0;
@@ -216,7 +216,7 @@ sub LatexFormat {
     local(@contents);
 
     # Initialise defaults
-    $_latex_margin = $SDF_USER'var{'LATEX_MARGIN'} || $_LATEX_DEFAULT_MARGIN;
+    $_latex_margin = $SDF_USER::var{'LATEX_MARGIN'} || $_LATEX_DEFAULT_MARGIN;
 
     # Format the paragraphs
     @contents = ();
@@ -291,7 +291,7 @@ sub _LatexParaAdd {
     local($label);
 
     # Set the example flag
-    $in_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $in_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     if ($in_example) {
        if ($_latex_in_example eq 0) {
@@ -312,13 +312,13 @@ sub _LatexParaAdd {
     }
 
     # Get the target format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $para_tag if $para_fmt eq '';
 
     # Map the attributes
-    &SdfAttrMap(*para_attrs, 'latex', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'latex', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
 
     # Build the Table of Contents as we go
 
@@ -410,17 +410,17 @@ sub _LatexParaText {
    
 
 	    if ($char_tag eq 'L') {
-                ($text, $url) = &SDF_USER'ExpandLink($text);
+                ($text, $url) = &SDF_USER::ExpandLink($text);
                 $sect_attrs{'jump'} = $url;
             }
 
             if ($char_tag ne 'E' 
-                && $SDF_USER'phrasestyles_to{$char_tag} ne 'SDF_VERBATIM') {
+                && $SDF_USER::phrasestyles_to{$char_tag} ne 'SDF_VERBATIM') {
 	      # Escape any special characters
 	      $text = &_LatexEscape($text);
 	    }
 
-	  if ( $SDF_USER'phrasestyles_to{$char_tag} eq 'SDF_VERBATIM') {
+	  if ( $SDF_USER::phrasestyles_to{$char_tag} eq 'SDF_VERBATIM') {
 	    _LatexCheckVerbatim($text);
 	      $text = $_latex_verbatim_open . $text;
 	  }
@@ -432,13 +432,13 @@ sub _LatexParaText {
 	  
 	  
 	  # Process formatting attributes
-            &SdfAttrMap(*sect_attrs, 'latex', *SDF_USER'phraseattrs_to,
-	       *SDF_USER'phraseattrs_map, *SDF_USER'phraseattrs_attrs,
-	       $SDF_USER'phrasestyles_attrs{$char_tag});
+            &SdfAttrMap(*sect_attrs, 'latex', *SDF_USER::phraseattrs_to,
+	       *SDF_USER::phraseattrs_map, *SDF_USER::phraseattrs_attrs,
+	       $SDF_USER::phrasestyles_attrs{$char_tag});
 
 
             # Map the font
-            $char_font = $SDF_USER'phrasestyles_to{$char_tag};
+            $char_font = $SDF_USER::phrasestyles_to{$char_tag};
 
 
             # Add the text for this phrase
@@ -513,8 +513,8 @@ sub _LatexElement {
 	$close_list .= "\\end\{$_LATEX_LISTTYPES[$_LATEX_LISTLEVEL]\}\n";
 	$_LATEX_LISTLEVEL--;
       }
-        $latex = $close_list . "\n" . "$SDF_USER'parastyles_to{$tag}\{$text\}\n"; 
-#	    . ($char x length("$SDF_USER'parastyles_to{$tag}\{$text\}\n")) . "\n";
+        $latex = $close_list . "\n" . "$SDF_USER::parastyles_to{$tag}\{$text\}\n"; 
+#	    . ($char x length("$SDF_USER::parastyles_to{$tag}\{$text\}\n")) . "\n";
     }
 
 
@@ -994,12 +994,12 @@ sub _LatexFinalise {
     local($rec, @html_contents, $toc_posn);
 
     # Convert the title
-    $title = $SDF_USER'var{'DOC_NAME'};
-    $author = $SDF_USER'var{'DOC_AUTHOR'};
-    $date   = $SDF_USER'var{'DOC_DATE'};
+    $title = $SDF_USER::var{'DOC_NAME'};
+    $author = $SDF_USER::var{'DOC_AUTHOR'};
+    $date   = $SDF_USER::var{'DOC_DATE'};
 
     # Build the HEAD element (and append BODY opening)
-    $version = $SDF_USER'var{'SDF_VERSION'};
+    $version = $SDF_USER::var{'SDF_VERSION'};
     @head = (
         '%%% This file was generated using SDF $version by',
         '%%% Ian Clatworthy (ianc@mincom.com) and the 2latex_ driver', 
