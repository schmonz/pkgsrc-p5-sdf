$NetBSD$

--- perllib/sdf/post_mf6.pl.orig	2023-10-09 16:27:41.557592446 +0000
+++ perllib/sdf/post_mf6.pl
@@ -165,7 +165,7 @@ sub Get_Client_Dets {
     local( @client_array, $client_dir, $client_list, $found_sw);
 
     # Get the client code
-    $CLIENT = $SDF_USER'var{'MIMS_CLIENT_CODE'};
+    $CLIENT = $SDF_USER::var{'MIMS_CLIENT_CODE'};
     if ( $CLIENT eq '') {
         &AppExit('fatal', "MIMS_CLIENT_CODE variable must be specified");
     }
