<?php
   require_once 'util.inc';
   
   $f = fopen('/tmp/.coldest/pid', 'r');
   $pid = fgets($f);
   $command = "kill $pid";
   `$command`;
   
   echo "Server stopped<br><br>";
?>