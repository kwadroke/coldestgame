<?php
   require_once 'util.inc';
   
   $descriptors = array(
      0 => array("pipe", "r"),
      1 => array("pipe", "w"),
      2 => array("pipe", "w")
   );
   
   //$command = "sudo -b -u " . $user . " /bin/bash -c \"cd /home/cybertron/source/coldest && " . $executable . "\"&";
   $command = "./startServer.sh $installDir $executable 2>&1";
   exec("$command", $output);
   /*$process = proc_open($command, $descriptors, $pipes, $installDir);
   
   sleep(1);
   stream_set_blocking($pipes[2], 0);
   echo stream_get_contents($pipes[2]);
   
   if (is_resource($process))
   {
      foreach ($pipes as $pipe)
      {
         fclose($pipe);
      }

      proc_close($process);
      echo "Server Started<br><br>";
   }
   else
   {
      echo "Server failed to start<br><br>";
   }*/
   
   $pid = $output[0];
   
   $f = fopen('/tmp/.coldest/pid', 'w');
   fwrite($f, $pid);
   
   echo "Server started as job $pid<br><br>";
   
?>