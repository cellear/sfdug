<?php

use Drupal\node\Entity\Node;

// Create a sample location.
$location = Node::create([
  'type' => 'location',
  'title' => 'Vabu Lounge',
  'field_address' => '123 Drupal Way, San Francisco, CA',
  'field_notes' => 'Great view of the bay.',
]);
$location->save();

$events = [
  [
    'title' => 'October 2025: Drupal CMS Launch Party',
    'date' => '2025-10-15T18:30:00',
    'body' => 'Celebrating the official release of Drupal CMS with the SF community!',
  ],
  [
    'title' => 'November 2025: AI and Drupal',
    'date' => '2025-11-12T18:30:00',
    'body' => 'A deep dive into how AI is changing the way we build with Drupal.',
  ],
  [
    'title' => 'December 2025: Holiday Social',
    'date' => '2025-12-10T18:30:00',
    'body' => 'Annual holiday gathering at the usual spot. Drinks and Drupal talk!',
  ],
];

foreach ($events as $event_data) {
  $node = Node::create([
    'type' => 'event',
    'title' => $event_data['title'],
    'field_event_date' => $event_data['date'],
    'field_event_mode' => 'in_person',
    'field_location' => $location->id(),
    'body' => [
      'value' => $event_data['body'],
      'format' => 'basic_html',
    ],
    'status' => 1,
  ]);
  $node->save();
}

echo "3 sample past events and 1 location created.\n";

