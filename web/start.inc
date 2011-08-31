<?php
   require_once 'util.inc';
   
   $descriptors = array(
      0 => array("pipe", "r"),
      1 => array("pipe", "w"),
      2 => array("pipe", "w")
   );
   
   //$command = "sudo -b -u " . $user . " /bin/bash -c \"cd /home/cybertron/source/coldest && " . $executable . "\"&";
   $command = "./startServer.sh $installDir $executable 2>&1";
   $pid = runAsUser($command); 
   
   $f = fopen('/tmp/coldestServer.pid', 'w');
   fwrite($f, $pid);
   
   echo "Server started as job $pid<br><br>";
   
?>
