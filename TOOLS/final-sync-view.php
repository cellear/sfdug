<?php

use Drupal\views\Entity\View;

$view = View::load('sfdug_meetings');
if (!$view) {
  echo "View sfdug_meetings not found.\n";
  return;
}

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
    'entity_type' => 'node',
    'entity_field' => 'body',
    'label' => '',
    'type' => 'text_summary_or_trimmed',
    'settings' => ['trim_length' => 400],
  ],
];

$view->getDisplay('default')['display_options']['fields'] = $fields;
$view->getDisplay('page_archive')['display_options']['fields'] = $fields;

$view->save();
echo "View sfdug_meetings final sync.\n";

