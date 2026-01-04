<?php

use Drupal\views\Entity\View;

$view_id = 'sfdug_meetings';
if (View::load($view_id)) {
  echo "View $view_id already exists.\n";
  return;
}

$view_config = [
  'id' => $view_id,
  'label' => 'SFDUG Meetings',
  'module' => 'views',
  'description' => 'Archive and upcoming meetings.',
  'tag' => 'SFDUG',
  'base_table' => 'node_field_data',
  'base_field' => 'nid',
  'core' => '8.x',
  'display' => [
    'default' => [
      'id' => 'default',
      'display_title' => 'Default',
      'display_plugin' => 'default',
      'position' => 0,
      'display_options' => [
        'title' => 'Meetings',
        'fields' => [
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
          'field_event_date' => [
            'id' => 'field_event_date',
            'table' => 'node__field_event_date',
            'field' => 'field_event_date',
            'plugin_id' => 'field',
            'label' => '',
          ],
        ],
        'filters' => [
          'status' => [
            'id' => 'status',
            'table' => 'node_field_data',
            'field' => 'status',
            'entity_type' => 'node',
            'entity_field' => 'status',
            'plugin_id' => 'boolean',
            'value' => '1',
            'group' => 1,
          ],
          'type' => [
            'id' => 'type',
            'table' => 'node_field_data',
            'field' => 'type',
            'entity_type' => 'node',
            'entity_field' => 'type',
            'plugin_id' => 'bundle',
            'value' => ['event' => 'event'],
          ],
        ],
        'sorts' => [
          'field_event_date_value' => [
            'id' => 'field_event_date_value',
            'table' => 'node__field_event_date',
            'field' => 'field_event_date_value',
            'plugin_id' => 'datetime',
            'order' => 'DESC',
          ],
        ],
        'row' => ['type' => 'fields'],
        'style' => ['type' => 'default'],
        'access' => ['type' => 'none'],
        'cache' => ['type' => 'tag'],
        'query' => ['type' => 'views_query'],
        'exposed_form' => ['type' => 'basic'],
        'pager' => ['type' => 'full'],
      ],
    ],
    'page_archive' => [
      'id' => 'page_archive',
      'display_title' => 'Archive',
      'display_plugin' => 'page',
      'position' => 1,
      'display_options' => [
        'path' => 'meetings',
        'filters' => [
          'field_event_date_value' => [
            'id' => 'field_event_date_value',
            'table' => 'node__field_event_date',
            'field' => 'field_event_date_value',
            'plugin_id' => 'datetime',
            'operator' => '<',
            'value' => ['type' => 'date', 'value' => 'now'],
            'group' => 1,
          ],
        ],
      ],
    ],
    'page_upcoming' => [
      'id' => 'page_upcoming',
      'display_title' => 'Upcoming',
      'display_plugin' => 'page',
      'position' => 2,
      'display_options' => [
        'path' => 'upcoming',
        'title' => 'Upcoming Meetings',
        'filters' => [
          'field_event_date_value' => [
            'id' => 'field_event_date_value',
            'table' => 'node__field_event_date',
            'field' => 'field_event_date_value',
            'plugin_id' => 'datetime',
            'operator' => '>=',
            'value' => ['type' => 'date', 'value' => 'now'],
            'group' => 1,
          ],
        ],
        'sorts' => [
          'field_event_date_value' => [
            'id' => 'field_event_date_value',
            'table' => 'node__field_event_date',
            'field' => 'field_event_date_value',
            'plugin_id' => 'datetime',
            'order' => 'ASC',
          ],
        ],
      ],
    ],
  ],
];

$view = View::create($view_config);
$view->save();
echo "View $view_id created.\n";
