<?php
   require_once 'util.inc';
   
   $f = fopen('/tmp/coldestServer.pid', 'r');
   $pid = fgets($f);
   $command = "kill $pid";
   runAsUser($command);

   echo "Server stopped<br><br>";
?>
