<?php

/**
* Trusted host configuration.
*/
$settings['trusted_host_patterns'] = array(
  '^danpayne\.lxc$',
  'localhost'
);

$databases['default']['default'] = array (
  'database' => danpayne,
  'username' => danpayne,
  'password' => danpayne,
  'prefix' => '',
  'host' => 'localhost',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);

$settings['install_profile'] = standard;

$settings['hash_salt'] = 'bfV7NL54GnZQNjtlljoBm3WcfrOGh3AriN_visDsHZWSGh8-VGnXnOzVK-ZHSpKL9uzOQpiXZw';

$config_directories[CONFIG_SYNC_DIRECTORY] = 'sites/default/sync';