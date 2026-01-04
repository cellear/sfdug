<?php

use Drupal\views\Entity\View;

$view = View::load('sfdug_meetings');
if (!$view) {
  echo "View sfdug_meetings not found.\n";
  return;
}

// Update Default display to ensure it has all fields
$default = &$view->getDisplay('default');
$fields = [
  'field_event_date' => [
    'id' => 'field_event_date',
    'table' => 'node__field_event_date',
    'field' => 'field_event_date',
    'plugin_id' => 'field',
    'label' => '',
  ],
  'title' => [
    'id' => 'title',
    'table' => 'node_field_data',
    'field' => 'title',
    'entity_type' => 'node',
    'entity_field' => 'title',
    'plugin_id' => 'field',
    'label' => '',
    'settings' => ['link_to_entity' => true],
  ],
  'body' => [
    'id' => 'body',
    'table' => 'node__body',
    'field' => 'body',
    'plugin_id' => 'field',
    'label' => '',
    'type' => 'text_summary_or_trimmed',
    'settings' => ['trim_length' => 300],
  ],
];
$default['display_options']['fields'] = $fields;

// Ensure page_archive also has them
$archive = &$view->getDisplay('page_archive');
$archive['display_options']['fields'] = $fields;
$archive['display_options']['title'] = 'Past Meetings';

$view->save();
echo "View sfdug_meetings synced.\n";

