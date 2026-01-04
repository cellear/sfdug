<?php

use Drupal\node\Entity\Node;

$meetings = [
  [
    'title' => 'Drupal 11 Launch Party & SFDUG 20th Anniversary Planning',
    'date' => '2025-10-15T18:30:00',
    'description' => 'We gathered at the Mission District community center to celebrate Drupal 11 and start planning our big 20th anniversary event. Great pizza and even better conversations.',
  ],
  [
    'title' => 'The Future of AI in Drupal: Claude and Beyond',
    'date' => '2025-11-12T19:00:00',
    'description' => 'A deep dive into how large language models are transforming the Drupal development experience. Featuring live demos of AI-powered site building.',
  ],
  [
    'title' => 'SFDUG End of Year Social & Lightning Talks',
    'date' => '2025-12-10T18:00:00',
    'description' => 'Our annual holiday gathering with five lightning talks ranging from performance optimization to modern CSS techniques.',
  ],
];

foreach ($meetings as $m) {
  $node = Node::create([
    'type' => 'event',
    'title' => $m['title'],
    'field_event_date' => [
      'value' => $m['date'],
    ],
    'body' => [
      'value' => $m['description'],
      'format' => 'basic_html',
    ],
    'status' => 1,
    'uid' => 1,
  ]);
  $node->save();
  echo "Created meeting: " . $m['title'] . "\n";
}

