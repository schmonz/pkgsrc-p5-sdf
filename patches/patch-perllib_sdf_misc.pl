$NetBSD$

--- perllib/sdf/misc.pl.orig	2023-10-09 16:27:41.545396641 +0000
+++ perllib/sdf/misc.pl
@@ -206,7 +206,7 @@ sub MiscDateFormat {
 
     # Get the quantities
     ($second, $minute, $hour, $day, $_month, $syear, $_wday) =
-      localtime($main'time);
+      localtime($main::time);
     $day0 = sprintf("%02d", $day);
     $month = $main::misc_date_strings{"month"}[$_month];
     $smonth = $main::misc_date_strings{"smonth"}[$_month];
@@ -226,7 +226,7 @@ sub MiscDateFormat {
     $second0 = sprintf("%02d", $second);
 
     # format the date-time
-    $main'result = eval '"' . $main'fmt . '"';
+    $main::result = eval '"' . $main::fmt . '"';
     package main;
     if ($msg_type && $@) {
         &AppMsg($msg_type, "bad datetime format '$fmt'");
