<?php

use Drupal\views\Entity\View;

$view_id = 'sfdug_people';
if (!View::load($view_id)) {
  $view_config = [
    'id' => $view_id,
    'label' => 'People',
    'module' => 'views',
    'tag' => 'SFDUG',
    'base_table' => 'node_field_data',
    'base_field' => 'nid',
    'display' => [
      'default' => [
        'id' => 'default',
        'display_title' => 'Default',
        'display_plugin' => 'default',
        'display_options' => [
          'title' => 'People',
          'fields' => [
            'field_photo' => [
              'id' => 'field_photo',
              'table' => 'node__field_photo',
              'field' => 'field_photo',
              'plugin_id' => 'field',
              'label' => '',
              'settings' => ['image_style' => 'thumbnail'],
            ],
            'title' => [
              'id' => 'title',
              'table' => 'node_field_data',
              'field' => 'title',
              'plugin_id' => 'field',
              'label' => '',
              'settings' => ['link_to_entity' => true],
            ],
            'field_organization' => [
              'id' => 'field_organization',
              'table' => 'node__field_organization',
              'field' => 'field_organization',
              'plugin_id' => 'field',
              'label' => '',
            ],
          ],
          'filters' => [
            'status' => ['id' => 'status', 'table' => 'node_field_data', 'field' => 'status', 'value' => '1', 'plugin_id' => 'boolean'],
            'type' => ['id' => 'type', 'table' => 'node_field_data', 'field' => 'type', 'value' => ['person' => 'person'], 'plugin_id' => 'bundle'],
          ],
          'style' => ['type' => 'grid', 'options' => ['columns' => 4]],
          'row' => ['type' => 'fields'],
          'access' => ['type' => 'none'],
          'cache' => ['type' => 'tag'],
          'query' => ['type' => 'views_query'],
          'exposed_form' => ['type' => 'basic'],
          'pager' => ['type' => 'full'],
        ],
      ],
      'page_1' => [
        'id' => 'page_1',
        'display_title' => 'Page',
        'display_plugin' => 'page',
        'display_options' => ['path' => 'people'],
      ],
    ],
  ];
  $view = View::create($view_config);
  $view->save();
  echo "View $view_id created.\n";
}

$view_id = 'sfdug_videos';
if (!View::load($view_id)) {
  $view_config = [
    'id' => $view_id,
    'label' => 'Videos',
    'module' => 'views',
    'tag' => 'SFDUG',
    'base_table' => 'node_field_data',
    'base_field' => 'nid',
    'display' => [
      'default' => [
        'id' => 'default',
        'display_title' => 'Default',
        'display_plugin' => 'default',
        'display_options' => [
          'title' => 'Videos',
          'fields' => [
            'field_session_video' => [
              'id' => 'field_session_video',
              'table' => 'node__field_session_video',
              'field' => 'field_session_video',
              'plugin_id' => 'field',
              'label' => '',
            ],
            'title' => [
              'id' => 'title',
              'table' => 'node_field_data',
              'field' => 'title',
              'plugin_id' => 'field',
              'label' => '',
              'settings' => ['link_to_entity' => true],
            ],
          ],
          'filters' => [
            'status' => ['id' => 'status', 'table' => 'node_field_data', 'field' => 'status', 'value' => '1', 'plugin_id' => 'boolean'],
            'type' => ['id' => 'type', 'table' => 'node_field_data', 'field' => 'type', 'value' => ['session' => 'session'], 'plugin_id' => 'bundle'],
            'field_session_video_target_id' => [
              'id' => 'field_session_video_target_id',
              'table' => 'node__field_session_video',
              'field' => 'field_session_video_target_id',
              'plugin_id' => 'numeric',
              'operator' => 'not empty',
            ],
          ],
          'sorts' => [
            'created' => ['id' => 'created', 'table' => 'node_field_data', 'field' => 'created', 'order' => 'DESC', 'plugin_id' => 'date'],
          ],
          'style' => ['type' => 'default'],
          'row' => ['type' => 'fields'],
          'access' => ['type' => 'none'],
          'cache' => ['type' => 'tag'],
          'query' => ['type' => 'views_query'],
          'exposed_form' => ['type' => 'basic'],
          'pager' => ['type' => 'full'],
        ],
      ],
      'page_1' => [
        'id' => 'page_1',
        'display_title' => 'Page',
        'display_plugin' => 'page',
        'display_options' => ['path' => 'videos'],
      ],
    ],
  ];
  $view = View::create($view_config);
  $view->save();
  echo "View $view_id created.\n";
}

