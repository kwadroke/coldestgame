<?php
   require_once 'util.inc';
   
   echo '<form action="index.php" method="post" class="button">';
   echo '<input type="hidden" name="logout"/>';
   echo '<input type="submit" value="Logout"/>';
   echo '</form><br><br>';
   
   echo 'Server Controls: ';
   echo '<form action="index.php" method="post" class="button">';
   echo '<input type="hidden" name="start"/>';
   echo '<input type="submit" value="Start"/>';
   echo '</form>';
   
   echo '<form action="index.php" method="post" class="button">';
   echo '<input type="hidden" name="stop"/>';
   echo '<input type="submit" value="Stop"/>';
   echo '</form>';
   echo '<br><br>';
   
   echo '<textarea id="serverLog" class="styledInput textarea">';
   $command = "sudo -u $user tail -n $logLines $home/.coldest/server.log";
   echo `$command`;
   echo '</textarea><br>';
   echo '<form action="index.php" method="post">';
   echo 'Command: <input type="text" name="command" class="styledInput commandEntry"/>';
   echo '<input type="submit" value="Send"/>';
   echo '</form>';
?>
