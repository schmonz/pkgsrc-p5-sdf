$NetBSD$

--- perllib/sdf/app.pl.orig	2023-10-09 16:27:41.558970614 +0000
+++ perllib/sdf/app.pl
@@ -1707,7 +1707,7 @@ sub AppShowCallTree {
     local($i,$p,$f,$l,$s,$h,$a,@a,@sub);
 
     for ($i = 1; ($p,$f,$l,$s,$h,$w) = caller($i); $i++) {
-        @a = @DB'args;
+        @a = @DB::args;
         for (@a) {
             if (/^StB\000/ && length($_) == length($_main{'_main'})) {
                 $_ = sprintf("%s",$_);
