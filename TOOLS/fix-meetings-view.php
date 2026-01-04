<?php

use Drupal\views\Entity\View;

$view = View::load('sfdug_meetings');
if (!$view) {
  echo "View sfdug_meetings not found.\n";
  return;
}

$display = &$view->getDisplay('page_archive');
if ($display) {
  $display['display_options']['title'] = 'Past Meetings';
  
  // Explicitly set all fields for this display to ensure they are present and in order
  $display['display_options']['fields'] = [
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
      'element_type' => 'h2',
    ],
    'body' => [
      'id' => 'body',
      'table' => 'node__body',
      'field' => 'body',
      'plugin_id' => 'field',
      'label' => '',
      'type' => 'text_summary_or_trimmed',
      'settings' => ['trim_length' => 400],
    ],
  ];
  
  echo "Corrected fields for 'page_archive'.\n";
}

$view->save();
echo "View sfdug_meetings saved.\n";

