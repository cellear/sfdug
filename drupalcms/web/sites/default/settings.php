<?php

/**
 * @file
 * Pantheon and DDEV compatible settings.php
 */

// Private file path configuration.
if (isset($_SERVER['PANTHEON_ENVIRONMENT'])) {
    $settings['file_private_path'] = '/files/private';
} else {
    $settings['file_private_path'] = '../private';
}

$databases = [];
$settings['hash_salt'] = 'sfdug-2025-anniversary-salt-change-me';
$settings['update_free_access'] = FALSE;
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];
$settings['entity_update_batch_size'] = 50;
$settings['entity_update_backup'] = TRUE;
$settings['state_cache'] = TRUE;
$settings['migrate_node_migrate_type_classic'] = FALSE;

$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';

// Include Pantheon settings if they exist.
if (isset($_SERVER['PANTHEON_ENVIRONMENT']) && file_exists(__DIR__ . '/settings.pantheon.php')) {
    include __DIR__ . '/settings.pantheon.php';
}

// Automatically generated include for settings managed by ddev.
if (getenv('IS_DDEV_PROJECT') == 'true' && file_exists(__DIR__ . '/settings.ddev.php')) {
    include __DIR__ . '/settings.ddev.php';
}
