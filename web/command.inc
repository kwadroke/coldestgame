<?php
   require_once 'util.inc';
   
   $socket = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
   $data = "c\n0\n" . $_POST['command'] . "\n";
   socket_sendto($socket, $data, strlen($data), 0, '127.0.0.1', $port);
   socket_close($socket);
?>