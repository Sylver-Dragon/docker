<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'instanceid' => 'REMOVED',
  'passwordsalt' => 'REMOVED',
  'secret' => 'REMOVED',
  'trusted_domains' =>
  array (
    0 => 'cloud.dragon-bytes.com',
    1 => 'SERVERNAME',
  ),
  'overwwrite.cli.url' => 'https://cloud.dragon-bytes.com',
  'overwritehost' => 'cloud.dragon-bytes.com',
  'overwriteprotocol' => 'https',
  'forwarded_for_headers' =>
  array (
    0 => 'X-Forwarded-For',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'sqlite3',
  'version' => '22.0.0.11',
  'overwrite.cli.url' => 'http://SERVERNAME:8081',
  'installed' => true,
  'logfile' => '/var/log/nextcloud/nextcloud.log',
  'loglevel' => 2,
  'log.condition' =>
  array (
    'apps' =>
    array (
      0 => 'admin_audit',
    ),
  ),
  'maintenance' => false,
  'theme' => '',
);
