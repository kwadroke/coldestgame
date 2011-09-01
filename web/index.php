<html>

<head>
   <title>Coldest WebAdmin Interface</title>
   <link href="default.css" rel="stylesheet" type="text/css"/>
   
   <script type="text/javascript">
      function scrollLogToBottom()
      {
         serverLog = document.getElementById('serverLog');
         if (serverLog)
            serverLog.scrollTop = serverLog.scrollHeight;
      }
   </script>
</head>

<body onload="scrollLogToBottom()">
   <center>
   <h1><a href="index.php">Coldest WebAdmin Interface</a></h1>
   
   <?php
      require_once 'config.inc';
      require_once 'util.inc';
      
      session_start();
      
      if (!array_key_exists("authenticated", $_SESSION) || array_key_exists('logout', $_POST))
      {
         $_SESSION['authenticated'] = false;
      }
      
      if (array_key_exists("password", $_POST))
      {
         include 'authenticate.inc';
      }
      
      if (!authenticated())
      {
         include 'login.inc';
      }
      
      if (authenticated())
      {
         if (array_key_exists("start", $_POST))
         {
            include 'start.inc';
         }
         else if (array_key_exists("stop", $_POST))
         {
            include 'stop.inc';
         }
         else if (array_key_exists("command", $_POST))
         {
            include 'command.inc';
         }
         
         include 'home.inc';
      }
      
      echo '</center>';
   ?>
</body>
