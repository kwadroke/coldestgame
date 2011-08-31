<?php
   require_once 'config.inc';

   $endl = "\n";

   function authenticated()
   {
      return $_SESSION['authenticated'];
   }
   
   // Allows only white-listed characters to be used in resulting URL
   // This should be called before ever outputting a URL to an HTML attribute such as a link
   // The list should only include characters legitimately used in the app
   function cleanUrl($url)
   {
      return preg_replace('/[^a-zA-Z0-9:\/?=.]+/', '_', $url);
   }
   
   function reloadPrevious()
   {
      header('Location:' . cleanUrl($_SERVER['HTTP_REFERER']));
   }
   
   function linkToPrevious($text)
   {
      echo '<a href="' . cleanUrl($_SERVER['HTTP_REFERER']) . '">' . $text . '</a>';
   }

   function runAsUser($command)
   {
      global $user;
      return `sudo -u $user $command`;
   }
?>
