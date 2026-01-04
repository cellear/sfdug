<?php

use Drupal\editor\Entity\Editor;
use Drupal\filter\Entity\FilterFormat;

$format_id = 'basic_html';

// Ensure the format exists.
if (!FilterFormat::load($format_id)) {
  echo "Format $format_id not found.\n";
  return;
}

// Create or load the editor configuration.
$editor = Editor::load($format_id);
if (!$editor) {
  $editor = Editor::create([
    'format' => $format_id,
    'editor' => 'ckeditor5',
  ]);
}

// Basic CKEditor 5 configuration with Source Editing.
$settings = [
  'toolbar' => [
    'items' => [
      'heading',
      '|',
      'bold',
      'italic',
      'link',
      '|',
      'bulletedList',
      'numberedList',
      '|',
      'blockQuote',
      'uploadImage',
      'insertTable',
      '|',
      'sourceEditing', // This is the "View Source" button
      '|',
      'undo',
      'redo',
    ],
  ],
  'plugins' => [
    'ckeditor5_heading' => [
      'enabled_headings' => [
        'heading2',
        'heading3',
        'heading4',
        'heading5',
        'heading6',
      ],
    ],
    'ckeditor5_sourceEditing' => [
      'allowed_tags' => [],
    ],
  ],
];

$editor->setSettings($settings);
$editor->save();

echo "CKEditor 5 with Source Editing enabled for $format_id.\n";

