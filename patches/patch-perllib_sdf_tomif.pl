$NetBSD: patch-perllib_sdf_tomif.pl,v 1.1 2019/09/10 21:20:35 schmonz Exp $

Use /m instead of $*, no longer available in Perl 5.30.
Patch from Debian: 005_multiline.diff

--- perllib/sdf/tomif.pl.orig	1999-05-24 06:28:14.000000000 +0000
+++ perllib/sdf/tomif.pl
@@ -584,7 +584,7 @@ sub MifFormat {
     $_mif_component_cursor = 0;
 
     # Initialise things for building a book, if necessary
-    if ($SDF_USER'var{'MIF_BOOK_MODE'}) {
+    if ($SDF_USER::var{'MIF_BOOK_MODE'}) {
         @_mif_component_tbl = ('Part|Type');
     }
 
@@ -606,9 +606,9 @@ sub MifFormat {
     if ($msg_counts{'error'} || $msg_counts{'abort'} || $msg_counts{'fatal'} ) {
         # do nothing
     }
-    elsif ($SDF_USER'var{'MIF_BOOK_MODE'}) {
+    elsif ($SDF_USER::var{'MIF_BOOK_MODE'}) {
         @_mif_component_tbl = &TableParse(@_mif_component_tbl);
-        @result = &_MifBookBuild(*_mif_component_tbl, $SDF_USER'var{'DOC_BASE'});
+        @result = &_MifBookBuild(*_mif_component_tbl, $SDF_USER::var{'DOC_BASE'});
     }
     else {
         @result = &_MifFinalise(*result);
@@ -668,16 +668,12 @@ sub _MifAddSection {
 sub _MifEscape {
     local(*text, $escape_space) = @_;
 #   local();
-    local($orig_linematch_flag);
 
-    $orig_linematch_flag = $*;
-    $* = 1;
     $text =~ s/([\\>])/\\$1/g;
     $text =~ s/\t/\\t/g;
     $text =~ s/'/\\q/g;
     $text =~ s/`/\\Q/g;
     $text =~ s/ /\\ /g if $escape_space;
-    $* = $orig_linematch_flag;
 }
 
 #
@@ -736,16 +732,16 @@ sub _MifParaAdd {
     local($index, $index_code);
 
     # Get the example flag
-    $is_example = $SDF_USER'parastyles_category{$para_tag} eq 'example';
+    $is_example = $SDF_USER::parastyles_category{$para_tag} eq 'example';
 
     # After headings, use a FIRST tag instead of a normal tag
     if ($prev_tag =~ /^[HAP]\d$/ && $para_tag eq 'N' &&
-      $SDF_USER'parastyles_to{'FIRST'} ne '') {
+      $SDF_USER::parastyles_to{'FIRST'} ne '') {
         $para_tag = 'FIRST';
     }
 
     # Get the Frame format name
-    $para_fmt = $SDF_USER'parastyles_to{$para_tag};
+    $para_fmt = $SDF_USER::parastyles_to{$para_tag};
     $para_fmt = $para_tag if $para_fmt eq '';
     $para_fmt .= 'NoTOC' if $para_attrs{'notoc'};
     $_mif_parastyle_used{$para_fmt}++;
@@ -776,9 +772,9 @@ sub _MifParaAdd {
     }
 
     # Get the format overrides
-    &SdfAttrMap(*para_attrs, 'mif', *SDF_USER'paraattrs_to,
-      *SDF_USER'paraattrs_map, *SDF_USER'paraattrs_attrs,
-      $SDF_USER'parastyles_attrs{$para_tag});
+    &SdfAttrMap(*para_attrs, 'mif', *SDF_USER::paraattrs_to,
+      *SDF_USER::paraattrs_map, *SDF_USER::paraattrs_attrs,
+      $SDF_USER::parastyles_attrs{$para_tag});
     $para_override = &_MifParaSdfAttr(*para_attrs, "  ");
 
     # Build the paragraph header
@@ -825,10 +821,10 @@ sub _MifParaAdd {
 
     # If this paragraph is in a generated list, add a cross reference,
     # unless we're in book mode
-    unless ($SDF_USER'var{'MIF_BOOK_MODE'}) {
+    unless ($SDF_USER::var{'MIF_BOOK_MODE'}) {
         if ($para_tag =~ /^[HAP](\d)$/) {
             $hdg_level = $1;
-            if ($hdg_level <= $SDF_USER'var{'DOC_TOC'} &&
+            if ($hdg_level <= $SDF_USER::var{'DOC_TOC'} &&
               !$para_attrs{'notoc'}) {
                 &_MifAddListXref(*para, $para_fmt, *_mif_toc_list, 'TOC');
             }
@@ -1242,7 +1238,7 @@ sub _MifParasToText {
     &_MifBuildAttrInfo();
 
     # Decide on the styles to output
-    @styles = $SDF_USER'var{'MIF_ALL_STYLES'} ? sort keys %paras :
+    @styles = $SDF_USER::var{'MIF_ALL_STYLES'} ? sort keys %paras :
                 sort keys %_mif_parastyle_used;
 
     # Build the result
@@ -1375,7 +1371,7 @@ sub _MifTblsToText {
     local($name, %attr);
 
     # Decide on the styles to output
-    @styles = $SDF_USER'var{'MIF_ALL_STYLES'} ? sort keys %tbls :
+    @styles = $SDF_USER::var{'MIF_ALL_STYLES'} ? sort keys %tbls :
                 sort keys %_mif_tblstyle_used;
 
     # Build the result
@@ -1409,7 +1405,7 @@ sub _MifTblFormat {
 
     # Add the attributes
     for $id (sort keys %attr) {
-        $type = $SDF_USER'tableparams_type{"mif.$id"};
+        $type = $SDF_USER::tableparams_type{"mif.$id"};
         $value = &_MifAttrFromText($attr{$id}, $type);
         push(@text, " <Tbl$id $value>");
     }
@@ -1475,7 +1471,7 @@ sub _MifCtrlsToText {
 
         # Get the matching variable name and type
         $var_name = "MIF_" . &MiscMixedToUpper(substr($name, 1));
-        $type = $SDF_USER'variables_type{$var_name};
+        $type = $SDF_USER::variables_type{$var_name};
 
         # format the value
         $value = &_MifAttrFromText($ctrls{$name}, $type);
@@ -1634,10 +1630,10 @@ sub _MifParaSdfAttr {
 
         # get the attribute value & type
         $value = $attrs{$attr};
-        $type = $SDF_USER'paraattrs_type{$attr};
+        $type = $SDF_USER::paraattrs_type{$attr};
 
         # Get the Frame prefix
-        $fm_prefix = $SDF_USER'phraseattrs_name{$attr} ? 'F' : 'Pgf';
+        $fm_prefix = $SDF_USER::phraseattrs_name{$attr} ? 'F' : 'Pgf';
 
         # Check it's a Frame attribute 
         next unless $attr =~ s/^mif\.//;
@@ -1680,7 +1676,7 @@ sub _MifBuildAttrInfo {
     return if @_mif_paraattr_name;
 
     # Add the attribute information
-    for $name (sort keys %SDF_USER'paraattrs_type) {
+    for $name (sort keys %SDF_USER::paraattrs_type) {
         next unless $name =~ /^mif\./;
 
         # Skip attributes we don't weant to output
@@ -1703,7 +1699,7 @@ sub _MifBuildAttrInfo {
         # Store the information
         push(@_mif_paraattr_name, $short_name);
         push(@_mif_paraattr_full, $new_name);
-        push(@_mif_paraattr_type, $SDF_USER'paraattrs_type{$name});
+        push(@_mif_paraattr_type, $SDF_USER::paraattrs_type{$name});
     }
 }
 
@@ -1782,7 +1778,7 @@ sub _MifFontFormat {
         $short_name =~ s/^mif\.//;
 
         # get the attribute type and value
-        $type = $SDF_USER'phraseattrs_type{"mif.$short_name"};
+        $type = $SDF_USER::phraseattrs_type{"mif.$short_name"};
         $value = $attr{$attr};
 
         # For MIF font definitions, an empty value implies "as-is"
@@ -1820,7 +1816,7 @@ sub _MifCharFont {
     for $attr (sort keys %attr) {
 
         # get the attribute type and value
-        $type = $SDF_USER'phraseattrs_type{$attr};
+        $type = $SDF_USER::phraseattrs_type{$attr};
         $value = $attr{$attr};
 
         # Check it's a Frame attribute and map it to a MIF name
@@ -1861,7 +1857,7 @@ sub _MifParaText {
 
         # Escape any special characters
         if ($sect_type eq 'phrase') {
-            ($text) = &SDF_USER'ExpandLink($text) if $char_tag eq 'L';
+            ($text) = &SDF_USER::ExpandLink($text) if $char_tag eq 'L';
             &_MifEscape(*text, $is_example);
         }
         elsif ($sect_type eq 'string') {
@@ -1890,10 +1886,10 @@ sub _MifParaText {
             }
 
             # Process formatting attributes
-            &SdfAttrMap(*sect_attrs, 'mif', *SDF_USER'phraseattrs_to,
-              *SDF_USER'phraseattrs_map, *SDF_USER'phraseattrs_attrs,
-              $SDF_USER'phrasestyles_attrs{$char_tag});
-            $char_font = &_MifCharFont($SDF_USER'phrasestyles_to{$char_tag}, "  ",
+            &SdfAttrMap(*sect_attrs, 'mif', *SDF_USER::phraseattrs_to,
+              *SDF_USER::phraseattrs_map, *SDF_USER::phraseattrs_attrs,
+              $SDF_USER::phrasestyles_attrs{$char_tag});
+            $char_font = &_MifCharFont($SDF_USER::phrasestyles_to{$char_tag}, "  ",
               %sect_attrs);
             push(@char_fonts, $char_font);
             $para .= $char_font;
@@ -1997,7 +1993,7 @@ sub _MifAddLink {
 #   local();
 
     if ($link) {
-        $link = &_MifLink($link, $SDF_USER'var{'MIF_EXT'});
+        $link = &_MifLink($link, $SDF_USER::var{'MIF_EXT'});
         $para .= "  <Marker\n" .
             "   <MType 8>\n" .
             "   <MText `$link'>\n" .
@@ -2021,24 +2017,24 @@ sub _MifFinalise {
     local(@out_result);
     local($pwidth, $pheight);
     local($component_prefix);
-    local(%offset, $old_match_rule);
+    local(%offset);
     local(%merged_ctrls, %merged_vars, %merged_xrefs);
     local(%merged_paras, %merged_fonts, %merged_tbls);
     local($mainflow);
 
     # Process document control settings
-    &_MifProcessControls(*SDF_USER'var, $component_type);
+    &_MifProcessControls(*SDF_USER::var, $component_type);
 
     # Get the page width and height
-    $pwidth = $SDF_USER'var{'DOC_PAGE_WIDTH'};
-    $pheight = $SDF_USER'var{'DOC_PAGE_HEIGHT'};
+    $pwidth = $SDF_USER::var{'DOC_PAGE_WIDTH'};
+    $pheight = $SDF_USER::var{'DOC_PAGE_HEIGHT'};
 
     # Generate the master pages
     $component_prefix = $component_type eq '' ? '' : $component_type . "_";
     &_MifAddMasterPage('First', $component_prefix . "FIRST", $pwidth, $pheight,
       $_MIF_TEXTFLOW_MAIN);
     &_MifAddMasterPage('Right', $component_prefix . "RIGHT", $pwidth, $pheight);
-    if ($SDF_USER'var{'DOC_TWO_SIDES'}) {
+    if ($SDF_USER::var{'DOC_TWO_SIDES'}) {
         &_MifAddMasterPage('Left', $component_prefix . "LEFT", $pwidth, $pheight);
     }
 
@@ -2131,17 +2127,14 @@ $igc_start = time;
         "<TFAutoConnect Yes>",
         "<TFSideheads Yes>",
         "<TFSideheadPlacement Left>",
-        "<TFSideheadGap $SDF_USER'var{OPT_SIDEHEAD_GAP}>",
-        "<TFSideheadWidth $SDF_USER'var{OPT_SIDEHEAD_WIDTH}>",
+        "<TFSideheadGap $SDF_USER::var{OPT_SIDEHEAD_GAP}>",
+        "<TFSideheadWidth $SDF_USER::var{OPT_SIDEHEAD_WIDTH}>",
         "<Notes ",
         "> # end of Notes",
         @text);
-    $old_match_rule = $*;
-    $* = 1;
     $mainflow =~ s/\<ParaLine/$&\n  <TextRectID $_MIF_TEXTFLOW_MAIN>/;
     $mainflow =~ s/\n/\n /g;
     $mainflow .= "\n> # end of TextFlow";
-    $* = $old_match_rule;
 
     # Add the text flows to the  import table
     push(@out_result, join("\n", @_mif_textflows, $mainflow));
@@ -2198,12 +2191,12 @@ sub _MifProcessControls {
         $_mif_ctrls{'DPageNumStyle'} = 'Arabic';
         if ($component_type eq 'CHAPTER') {
             $sdf_tag = $vars{'OPT_COMPONENT_COVER'} ? 'H1NUM' : 'H1';
-            $mif_tag = $SDF_USER'parastyles_to{$sdf_tag};
+            $mif_tag = $SDF_USER::parastyles_to{$sdf_tag};
             $prefix = "<\$paranumonly[$mif_tag]>";
         }
         elsif ($component_type eq 'APPENDIX') {
             $sdf_tag = $vars{'OPT_COMPONENT_COVER'} ? 'A1NUM' : 'A1';
-            $mif_tag = $SDF_USER'parastyles_to{$sdf_tag};
+            $mif_tag = $SDF_USER::parastyles_to{$sdf_tag};
             $prefix = "<\$paranumonly[$mif_tag]>";
         }
         elsif ($component_type eq 'IX') {
@@ -2287,7 +2280,7 @@ sub _MifAddMasterPage {
     $prefix    = $sdf_type =~ /^IX/ ? 'OPT_IX' : 'OPT';
     $sh_width  = &SdfVarPoints("${prefix}_SIDEHEAD_WIDTH");
     $sh_gap    = &SdfVarPoints("${prefix}_SIDEHEAD_GAP");
-    $col_count = $SDF_USER'var{"${prefix}_COLUMNS"};
+    $col_count = $SDF_USER::var{"${prefix}_COLUMNS"};
     $col_gap   = &SdfVarPoints("${prefix}_COLUMN_GAP");
 
     # Add the main section
@@ -2352,7 +2345,7 @@ sub _MifAddTextFlow {
     local(*text, $tag, $mif) = @_;
     local($id);
     local(@hdr, @flow);
-    local($textflow, $old_match_rule);
+    local($textflow);
 
     # Get the next text flow id
     $id = $_mif_textflow_cnt++;
@@ -2377,12 +2370,9 @@ sub _MifAddTextFlow {
     # Convert to a text flow
     if (@flow) {
         $textflow = join("\n", @flow);
-        $old_match_rule = $*;
-        $* = 1;
         $textflow =~ s/\<ParaLine/$&\n  <TextRectID $id>/;
         $textflow =~ s/\n/\n /g;
         $textflow .= "\n> # end of TextFlow";
-        $* = $old_match_rule;
     }
 
     # If nothing was generated, build the text flow with a dummy paragraph
@@ -2575,7 +2565,7 @@ sub _MifAddPageBackground {
     #$bg_ext = 'bg' . substr($sdf_fmext, -1);
     $bg_ext = 'mif';
     $bg_short = &NameJoin('', $background, $bg_ext);
-    $bg_file = &SDF_USER'FindFile($bg_short);
+    $bg_file = &SDF_USER::FindFile($bg_short);
     if ($bg_file eq '') {
         &AppMsg("warning", "unable to find background file '$bg_short'");
         return;
@@ -2647,7 +2637,7 @@ sub _MifAddRefPages {
     for $name (sort keys %_mif_frames) {
         %attr = &_MifAttrSplit($_mif_frames{$name});
         $width  = $attr{'Width'};
-        $width  = $SDF_USER'var{'DOC_FULL_WIDTH'} if $width eq '';
+        $width  = $SDF_USER::var{'DOC_FULL_WIDTH'} if $width eq '';
         $height = $attr{'Height'};
         $page_y += $height + 36;
 
@@ -2716,9 +2706,9 @@ sub _MifAddSpecialTextFlow {
     # we make sure this cannot happen!!!
     @mif_text = ();
     if ($name eq 'TOC') {
-        for ($j = 1; $j <= $SDF_USER'var{'DOC_TOC'}; $j++) {
+        for ($j = 1; $j <= $SDF_USER::var{'DOC_TOC'}; $j++) {
             for $tagtype ('H', 'A', 'P') {
-                $hdgtag = $SDF_USER'parastyles_to{"$tagtype$j"};
+                $hdgtag = $SDF_USER::parastyles_to{"$tagtype$j"};
                 $tag = $hdgtag . $name;
                 $_mif_parastyle_used{$tag}++;
                 $layout = &_MifFixLayout($attr{'Layout'}, $hdgtag);
@@ -2733,7 +2723,7 @@ sub _MifAddSpecialTextFlow {
         }
 
         # Ensure the index makes it into the contents
-        $hdgtag = $SDF_USER'parastyles_to{"IXT"};
+        $hdgtag = $SDF_USER::parastyles_to{"IXT"};
         $tag = $hdgtag . $name;
         $_mif_parastyle_used{$tag}++;
         $layout = &_MifFixLayout($attr{'Layout'}, $hdgtag);
@@ -2746,7 +2736,7 @@ sub _MifAddSpecialTextFlow {
              "> # end of Para");
     }
     elsif ($name eq 'LOF') {
-        $hdgtag = $SDF_USER'parastyles_to{"FT"};
+        $hdgtag = $SDF_USER::parastyles_to{"FT"};
         $tag = $hdgtag . $name;
         $_mif_parastyle_used{$tag}++;
         $layout = &_MifFixLayout($attr{'Layout'}, $hdgtag);
@@ -2759,7 +2749,7 @@ sub _MifAddSpecialTextFlow {
              "> # end of Para");
     }
     elsif ($name eq 'LOT') {
-        $hdgtag = $SDF_USER'parastyles_to{"TT"};
+        $hdgtag = $SDF_USER::parastyles_to{"TT"};
         $tag = $hdgtag . $name;
         $_mif_parastyle_used{$tag}++;
         $layout = &_MifFixLayout($attr{'Layout'}, $hdgtag);
@@ -2842,10 +2832,10 @@ sub _MifAddLists {
     local(%attr);
     local($layout);
     local($i);
-    local($old_match_rule, $toc_offset);
+    local($toc_offset);
 
     # Set some flags based on the output ultimately generated
-    $target = $SDF_USER'var{'OPT_TARGET'};
+    $target = $SDF_USER::var{'OPT_TARGET'};
     $soft = $target eq 'help' || $target eq 'html';
 
     # Process the list definitions (add xrefs, etc.)
@@ -2870,8 +2860,6 @@ sub _MifAddLists {
     # Insert the generated lists before the first level 1 heading
     push(@_mif_toc_list, @_mif_lof_list, @_mif_lot_list);
     if (@_mif_toc_list) {
-        $old_match_rule = $*;
-        $* = 1;
         $toc_offset = 0;
         para:
         for ($i = 0; $i <= $#text; $i++) {
@@ -2880,7 +2868,6 @@ sub _MifAddLists {
                 last para;
             }
         }
-        $* = $old_match_rule;
         splice(@text, $toc_offset, 0, @_mif_toc_list);
     }
 }
@@ -2900,16 +2887,16 @@ sub _MifListTitle {
     # If we're building component covers, make sure that the relevant SDF
     # macro gets called
     $mif = '';
-    if ($SDF_USER'var{'OPT_COMPONENT_COVER'} &&
+    if ($SDF_USER::var{'OPT_COMPONENT_COVER'} &&
         ($type eq 'TOC' || $type eq 'IX')) {
         @sdf_data = ('!DOC_COMPONENT_COVER_BEGIN');
         &_MifAddSection(*mif_data, *sdf_data);
         $mif = join("\n", @mif_data) . "\n";
     }
 
-    $tag = $SDF_USER'parastyles_to{$type . 'T'};
+    $tag = $SDF_USER::parastyles_to{$type . 'T'};
     $_mif_parastyle_used{$tag}++;
-    $title = $SDF_USER'var{"DOC_${type}_TITLE"};
+    $title = $SDF_USER::var{"DOC_${type}_TITLE"};
     $title = $default_title if $title eq '';
     &_MifEscape(*title);
     $mif .=
@@ -2938,15 +2925,9 @@ sub _MifMerge {
     local(*template, *import, %offset) = @_;
     local(@new);
     local($record, $obj);
-    local($old_match_rule);
     local($merged_pages, $merged_textflows, %ref_textflow);
     local($side_width);
     local($page_type, $page_name, $page_size, $cover_rect);
-    
-    # To permit multi-line matching, save the old state here and
-    # restore it later      
-    $old_match_rule = $*;
-    $* = 1;
 
     #
     # Do the merge. We ignore BookComponent objects
@@ -2963,14 +2944,14 @@ sub _MifMerge {
     while($record = shift(@template)) {
     
         # Find the object 'name'
-        unless ($record =~ /^\<(\w+)/) {
+        unless ($record =~ /^\<(\w+)/m) {
             &AppExit("fatal", "MIF template error - expecting object");
         }       
         $obj = $1;
 
         # Patch the comment to claim responsibility
         if ($obj eq 'MIFFile') {
-            $record =~ s/\>.*$/>/;
+            $record =~ s/\>.*$/>/m;
             $record .= " # Generated by $app_product_name $app_product_version";
         }
         
@@ -3030,7 +3011,6 @@ sub _MifMerge {
     }
     
     # Return result
-    $* = $old_match_rule;
     return @new;    
 }
 
@@ -3054,7 +3034,7 @@ sub _MifHandlerTuning {
     # Find the template file. A template file is searched for by
     # looking for {{tuning}}.{{fmver}} along the SDF include
     # path, where {{sdfver}} is fm4 or fm5 (typically).
-    $template_file = &SDF_USER'FindFile(&NameJoin('', $tuning, $sdf_fmext));
+    $template_file = &SDF_USER::FindFile(&NameJoin('', $tuning, $sdf_fmext));
     if ($template_file eq '') {
         #&AppMsg("warning", "unable to find template '$tuning'");
         return;
@@ -3112,7 +3092,7 @@ sub _MifHandlerTable {
 
     # Get the style
     $style = $attr{'style'};
-    $style_tag = $SDF_USER'tablestyles_to{$style};
+    $style_tag = $SDF_USER::tablestyles_to{$style};
     if ($style_tag eq '') {
         &AppMsg("warning", "unknown table style '$style'");
         $style_tag = $style;
@@ -3148,10 +3128,10 @@ sub _MifHandlerTable {
 
     # Get the table width and 1% (i.e. unit) width
     if ($attr{'wide'}) {
-        $tbl_width = $SDF_USER'var{'DOC_FULL_WIDTH'} - $indent;
+        $tbl_width = $SDF_USER::var{'DOC_FULL_WIDTH'} - $indent;
     }
     else {
-        $tbl_width = $SDF_USER'var{'DOC_TEXT_WIDTH'} - $indent;
+        $tbl_width = $SDF_USER::var{'DOC_TEXT_WIDTH'} - $indent;
     }
     $unit_width = $tbl_width / 100;
 
@@ -3181,7 +3161,7 @@ sub _MifHandlerTable {
 
     # If we're ultimately going to rtf or hlp, output a simple set of
     # column widths
-    $target = $SDF_USER'var{'OPT_TARGET'};
+    $target = $SDF_USER::var{'OPT_TARGET'};
     if ($target eq 'hlp' || $target eq 'rtf') {
         push(@outbuffer, "  <TblNumColumns $columns>");
         @widths = split(/,/, $attr{'format'});
@@ -3911,7 +3891,7 @@ sub _MifRunningHF {
         # Convert the SDF tag names to Frame ones
         @tags = split(/,/, $tags);
         for $tag (@tags) {
-            $fmtag = $SDF_USER'parastyles_to{$tag};
+            $fmtag = $SDF_USER::parastyles_to{$tag};
             $tag =  $fmtag if $fmtag ne '';
         }
         $defn = "<\$$type\[" . join(",", @tags) . "]>";
@@ -4062,7 +4042,7 @@ sub _MifAddRef {
     #if (! &NameIsAbsolute($name) && $attr{'root'} ne '') {
         #$name = &NameJoin($attr{'root'}, $name);
     #}
-    if ($SDF_USER'var{'OPT_TARGET'} eq 'hlp') {
+    if ($SDF_USER::var{'OPT_TARGET'} eq 'hlp') {
         $mif_path = &_MifPathName($name);
     }
     else {
@@ -4149,7 +4129,7 @@ sub _MifUpdateMainFlow {
 
     # Get the paragraph tag: 'Title' or 'Body'?
     if ($title ne '') {
-        $tag = $SDF_USER'parastyles_to{$_MIF_TITLE_TAG{$what}};
+        $tag = $SDF_USER::parastyles_to{$_MIF_TITLE_TAG{$what}};
 
         # Escape special characters
         $title =~ s/([\>\\])/\\$1/g;
@@ -4158,7 +4138,7 @@ sub _MifUpdateMainFlow {
         $title =~ s/([`])/\\Q/g;
     }
     else {
-        $tag = $SDF_USER'parastyles_to{$_MIF_NOTITLE_TAG{$what}};
+        $tag = $SDF_USER::parastyles_to{$_MIF_NOTITLE_TAG{$what}};
     }
 
     # Build the paragraph
@@ -4303,12 +4283,12 @@ sub _MifAddNestedText {
     # The height is calculated as a percentage of the text column
     # height. We also need an "adjusted height" for the embedded
     # text rectangle, otherwise Frame crops the table border.
-    $width = $SDF_USER'var{'DOC_TEXT_WIDTH'};
+    $width = $SDF_USER::var{'DOC_TEXT_WIDTH'};
     if ($nested == 1) {
-        $height = $SDF_USER'var{'DOC_TEXT_HEIGHT'};
+        $height = $SDF_USER::var{'DOC_TEXT_HEIGHT'};
     }
     elsif ($nested =~ /^(\d+)\%?$/) {
-        $height = $SDF_USER'var{'DOC_TEXT_HEIGHT'} * $1 / 100;
+        $height = $SDF_USER::var{'DOC_TEXT_HEIGHT'} * $1 / 100;
     }
     else {
         $height = &SdfPoints($nested);
@@ -4336,7 +4316,7 @@ sub _MifAddNestedText {
     push(@_mif_figure, join("\n", @frame));
 
     # Build the new text
-    $tag = $SDF_USER'parastyles_to{'N'};
+    $tag = $SDF_USER::parastyles_to{'N'};
     $_mif_parastyle_used{$tag}++;
     @result = (
         "<Para\n" .
@@ -4479,7 +4459,7 @@ sub _MifEscapeNewlink {
     # strip backquotes 
     $link =~ s/\`//g;
 
-    1 while $link =~ s/{{.:([^}]*)}}/$1/e;
+    1 while $link =~ s/\{\{.:([^}]*)\}\}/$1/e;
 
     $link =~ s/^\s+//;
 
@@ -4498,7 +4478,7 @@ sub MifNewComponent {
     local($cname);
 
     # Save away the component details (so a book can be constructed later)
-    $cname = &_MifComponentName($SDF_USER'var{'DOC_BASE'});
+    $cname = &_MifComponentName($SDF_USER::var{'DOC_BASE'});
     $type = 'chapter' if $type eq '1';
     push(@_mif_component_tbl, "$cname|$type");
     push(@_mif_component_type, "\U$type");
@@ -4506,7 +4486,7 @@ sub MifNewComponent {
     # Ensure that each component gets placed into its own output file.
     # (stdlib/mif.sdt takes care of the first part, so ignore it)
     if (scalar(@_mif_component_tbl) > 2) {
-        &SDF_USER'PrependText(
+        &SDF_USER::PrependText(
             "!DOC_COMPONENT_END",
             "!output '-'",
             "!output '$cname'",
@@ -4514,7 +4494,7 @@ sub MifNewComponent {
             "!DOC_COMPONENT_BEGIN");
     }
     else {
-        $SDF_USER'var{'DOC_COMPONENT'} = $type;
+        $SDF_USER::var{'DOC_COMPONENT'} = $type;
     }
 
     # Return the component name (needed for stdlib/mif.sdt)
@@ -4531,7 +4511,7 @@ sub _MifComponentName {
     local($cname);
 
     $_mif_component_cntr++;
-    $cname = $SDF_USER'var{'MIF_COMPONENT_PATTERN'};
+    $cname = $SDF_USER::var{'MIF_COMPONENT_PATTERN'};
     $cname = '$b_$n.$o' if $cname eq '';
     $cname =~ s/\$b/$base/g;
     $cname =~ s/\$n/$_mif_component_cntr/;
@@ -4568,17 +4548,17 @@ sub _MifBookBuild {
         %values = &TableRecSplit(*flds, $book[$i]);
         $type = $values{'Type'};
         if ($added_toc == 0 && $type ne 'front' && $type ne 'pretoc') {
-            if ($SDF_USER'var{'DOC_TOC'}) {
+            if ($SDF_USER::var{'DOC_TOC'}) {
                 $mif_file = &_MifBookDerived($base, 'toc', 'Table of Contents');
                 &_MifBookAddPart(*newbook, *batch, $mif_file, 'toc');
                 push(@sdf_book_files, $mif_file);
             }
-            if ($SDF_USER'var{'DOC_LOF'}) {
+            if ($SDF_USER::var{'DOC_LOF'}) {
                 $mif_file = &_MifBookDerived($base, 'lof', 'List of Figures');
                 &_MifBookAddPart(*newbook, *batch, $mif_file, 'lof');
                 push(@sdf_book_files, $mif_file);
             }
-            if ($SDF_USER'var{'DOC_LOT'}) {
+            if ($SDF_USER::var{'DOC_LOT'}) {
                 $mif_file = &_MifBookDerived($base, 'lot', 'List of Tables');
                 &_MifBookAddPart(*newbook, *batch, $mif_file, 'lot');
                 push(@sdf_book_files, $mif_file);
@@ -4591,7 +4571,7 @@ sub _MifBookBuild {
         &_MifBookAddPart(*newbook, *batch, $mif_file, $type);
         push(@sdf_book_files, $mif_file);
     }
-    if ($SDF_USER'var{'DOC_IX'}) {
+    if ($SDF_USER::var{'DOC_IX'}) {
         $mif_file = &_MifBookDerived($base, 'ix', 'Index');
         &_MifBookAddPart(*newbook, *batch, $mif_file, 'ix');
         push(@sdf_book_files, $mif_file);
@@ -4601,10 +4581,10 @@ sub _MifBookBuild {
     &_MifRunBatch(*batch, $verbose);
 
     # Cleanup the MIF for each part
-    &SDF_USER'SdfBookClean();
+    &SDF_USER::SdfBookClean();
 
     # Return result
-    return &MifBook(*newbook, $SDF_USER'var{'OPT_NUMBER_PER_COMPONENT'});
+    return &MifBook(*newbook, $SDF_USER::var{'OPT_NUMBER_PER_COMPONENT'});
 }
 
 #
@@ -4624,7 +4604,7 @@ sub _MifBookDerived {
     # Build the sdf
     $upper_type = "\U$type";
     $tag = $upper_type . 'T';
-    $title = $SDF_USER'var{"DOC_${upper_type}_TITLE"};
+    $title = $SDF_USER::var{"DOC_${upper_type}_TITLE"};
     $title = $default_title if $title eq '';
     @sdf_text = ("$tag:$title");
 
@@ -4730,22 +4710,22 @@ sub MifBook {
         if ($type eq 'toc') {
             $suffix = 'TOC';
             @tags = ();
-            for ($j = 1; $j <= $SDF_USER'var{'DOC_TOC'}; $j++) {
-                push(@tags, $SDF_USER'parastyles_to{"H$j"},
-                  $SDF_USER'parastyles_to{"A$j"}, $SDF_USER'parastyles_to{"P$j"});
+            for ($j = 1; $j <= $SDF_USER::var{'DOC_TOC'}; $j++) {
+                push(@tags, $SDF_USER::parastyles_to{"H$j"},
+                  $SDF_USER::parastyles_to{"A$j"}, $SDF_USER::parastyles_to{"P$j"});
             }
-            push(@tags, $SDF_USER'parastyles_to{"LOFT"});
-            push(@tags, $SDF_USER'parastyles_to{"LOTT"});
-            push(@tags, $SDF_USER'parastyles_to{"IXT"});
+            push(@tags, $SDF_USER::parastyles_to{"LOFT"});
+            push(@tags, $SDF_USER::parastyles_to{"LOTT"});
+            push(@tags, $SDF_USER::parastyles_to{"IXT"});
         }
         elsif ($type eq 'lof') {
             $suffix = 'LOF';
-            @tags = ($SDF_USER'parastyles_to{"FT"});
+            @tags = ($SDF_USER::parastyles_to{"FT"});
             $settings{'StartPageSide'} = 'NextAvailableSide';
         }
         elsif ($type eq 'lot') {
             $suffix = 'LOT';
-            @tags = ($SDF_USER'parastyles_to{"TT"});
+            @tags = ($SDF_USER::parastyles_to{"TT"});
             $settings{'StartPageSide'} = 'NextAvailableSide';
         }
         elsif ($type eq 'ix') {
