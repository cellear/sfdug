<?php

use Drupal\node\Entity\NodeType;
use Drupal\field\Entity\FieldStorageConfig;
use Drupal\field\Entity\FieldConfig;
use Drupal\taxonomy\Entity\Vocabulary;

// 1. Create Location Node Type.
if (!NodeType::load('location')) {
  NodeType::create([
    'type' => 'location',
    'name' => 'Location',
    'description' => 'Dedicated locations for Events.',
  ])->save();
}

// 2. Create Event Node Type.
if (!NodeType::load('event')) {
  NodeType::create([
    'type' => 'event',
    'name' => 'Event',
    'description' => 'SFDUG meetings and special events.',
  ])->save();
}

// 3. Create Vocabularies if missing.
$vocabs = [
  'topic' => 'Topic',
  'role' => 'Role',
];
foreach ($vocabs as $id => $name) {
  if (!Vocabulary::load($id)) {
    Vocabulary::create([
      'vid' => $id,
      'name' => $name,
    ])->save();
  }
}

// 4. Helper to create fields.
function create_field($entity_type, $bundle, $field_name, $type, $label, $cardinality = 1, $settings = [], $target_type = NULL, $target_bundle = NULL) {
  $field_storage = FieldStorageConfig::loadByName($entity_type, $field_name);
  if (!$field_storage) {
    $storage_data = [
      'field_name' => $field_name,
      'entity_type' => $entity_type,
      'type' => $type,
      'cardinality' => $cardinality,
    ];
    if ($target_type) {
      $storage_data['settings']['target_type'] = $target_type;
    }
    FieldStorageConfig::create($storage_data)->save();
  }

  $field = FieldConfig::loadByName($entity_type, $bundle, $field_name);
  if (!$field) {
    $field_data = [
      'field_name' => $field_name,
      'entity_type' => $entity_type,
      'bundle' => $bundle,
      'label' => $label,
      'settings' => $settings,
    ];
    if ($target_bundle) {
      $field_data['settings']['handler_settings']['target_bundles'] = [$target_bundle => $target_bundle];
    }
    FieldConfig::create($field_data)->save();
  }
}

// 5. Fields for Location.
create_field('node', 'location', 'field_address', 'text_long', 'Address');
create_field('node', 'location', 'field_notes', 'text_long', 'Notes');
create_field('node', 'location', 'field_room_floor', 'string', 'Room / floor');

// 6. Fields for Event.
create_field('node', 'event', 'field_event_date', 'datetime', 'Date & time');
create_field('node', 'event', 'field_event_mode', 'list_string', 'Event mode', 1, ['allowed_values' => ['in_person' => 'In Person', 'virtual' => 'Virtual', 'hybrid' => 'Hybrid']]);
create_field('node', 'event', 'field_location', 'entity_reference', 'Location', 1, [], 'node', 'location');
create_field('node', 'event', 'field_organizers', 'entity_reference', 'Organizer(s)', -1, [], 'node', 'person');
create_field('node', 'event', 'field_sponsors', 'entity_reference', 'Sponsor(s)', -1, [], 'node', 'sponsor');
create_field('node', 'event', 'field_source_url', 'link', 'Source URL');
create_field('node', 'event', 'field_rsvp_count', 'integer', 'RSVP count');

// 7. Update Session - add Parent Event.
create_field('node', 'session', 'field_parent_event', 'entity_reference', 'Parent Event', 1, [], 'node', 'event');

// 8. Update Sponsor - add Active and Period.
create_field('node', 'sponsor', 'field_active', 'boolean', 'Active');
create_field('node', 'sponsor', 'field_active_period', 'daterange', 'Active period');

echo "Content types and fields updated according to spec.\n";

