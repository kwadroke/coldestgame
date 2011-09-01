<?php
   $filename = "$home/.coldest/autoexec.cfg";
   $file = fopen($filename, 'r');
   
   while (!feof($file))
   {
      $line = fgets($file);
      if (strpos($line, "serverpwd") !== false)
      {
         $pieces = explode(' ', $line);
         if ($_POST['password'] == trim($pieces[2]))
            $_SESSION['authenticated'] = true;
         else
            echo 'Authentication failed<br><br>';
      }
   }
?>