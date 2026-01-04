<?php

use Drupal\views\Entity\View;

$view = View::load('sfdug_meetings');
if (!$view) {
  echo "View sfdug_meetings not found.\n";
  return;
}

$display = &$view->getDisplay('page_archive');
$display['display_options']['title'] = 'Past Meetings';

// Add body field to default display so it's available.
$default_display = &$view->getDisplay('default');
$fields = $default_display['display_options']['fields'];

// Add body field
$fields['body'] = [
  'id' => 'body',
  'table' => 'node__body',
  'field' => 'body',
  'relationship' => 'none',
  'group_type' => 'group',
  'admin_label' => '',
  'plugin_id' => 'field',
  'label' => '',
  'exclude' => false,
  'alter' => [
    'alter_text' => false,
    'make_link' => false,
    'trim' => true,
    'max_length' => 200,
    'word_boundary' => true,
    'ellipsis' => true,
    'strip_tags' => true,
  ],
  'type' => 'text_default',
  'settings' => [],
];

// Add link to node
$fields['view_node'] = [
  'id' => 'view_node',
  'table' => 'node',
  'field' => 'view_node',
  'relationship' => 'none',
  'group_type' => 'group',
  'admin_label' => '',
  'plugin_id' => 'node_link',
  'label' => '',
  'text' => 'Read more',
];

$default_display['display_options']['fields'] = $fields;

$view->save();
echo "View sfdug_meetings updated with new title and fields.\n";
