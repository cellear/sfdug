#!/usr/bin/env bash
set -euo pipefail

# Script to satisfy Event Platform's expectation for filter formats, field storage,
# roles, and module dependencies before enabling the full suite. Run it from the
# repo root while the DDEV project is running.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DDEV_ROOT="$ROOT_DIR/drupalcms"

cd "$ROOT_DIR"

run_ddev() {
  (cd "$DDEV_ROOT" && ddev "$@")
}

echo "1/5 Creating basic HTML text format if missing..."
run_ddev drush php:eval "$(cat <<'PHP'
use Drupal\filter\Entity\FilterFormat;

if (!FilterFormat::load('basic_html')) {
  FilterFormat::create([
    'format' => 'basic_html',
    'name' => 'Basic HTML',
    'weight' => 0,
    'filters' => [
      'filter_html' => [
        'status' => 1,
        'weight' => 0,
      ],
      'filter_htmlcorrector' => [
        'status' => 1,
        'weight' => 1,
      ],
      'filter_autop' => [
        'status' => 0,
        'weight' => 2,
      ],
      'filter_url' => [
        'status' => 1,
        'weight' => 3,
      ],
      'filter_html_escape' => [
        'status' => 0,
        'weight' => 4,
      ],
    ],
    'status' => 1,
    'cache' => 1,
  ])->save();
}
PHP
)"

echo "2/5 Creating restricted HTML text format..."
run_ddev drush php:eval "$(cat <<'PHP'
use Drupal\filter\Entity\FilterFormat;

if (!FilterFormat::load('restricted_html')) {
  FilterFormat::create([
    'format' => 'restricted_html',
    'name' => 'Restricted HTML',
    'weight' => 1,
    'roles' => ['anonymous'],
    'filters' => [
      'filter_html' => [
        'status' => 1,
        'weight' => -10,
        'settings' => [
          'allowed_html' => '<a href hreflang> <em> <strong> <cite> <blockquote cite> <code> <ul type> <ol start type> <li> <dl> <dt> <dd> <h2 id> <h3 id> <h4 id> <h5 id> <h6 id>',
          'filter_html_help' => 1,
          'filter_html_nofollow' => 0,
        ],
      ],
      'filter_autop' => [
        'status' => 1,
        'weight' => 0,
        'settings' => [],
      ],
      'filter_url' => [
        'status' => 1,
        'weight' => 0,
        'settings' => [
          'filter_url_length' => 72,
        ],
      ],
    ],
    'status' => 1,
    'cache' => 1,
  ])->save();
}
PHP
)"

echo "3/5 Ensuring node.body field storage exists..."
run_ddev drush php:eval "$(cat <<'PHP'
use Drupal\field\Entity\FieldStorageConfig;

if (!FieldStorageConfig::loadByName('node', 'body')) {
  FieldStorageConfig::create([
    'field_name' => 'body',
    'entity_type' => 'node',
    'type' => 'text_with_summary',
    'settings' => [
      'max_length' => 0,
      'default_value' => NULL,
      'default_value_callback' => NULL,
      'display_summary' => TRUE,
    ],
    'cardinality' => 1,
    'translatable' => FALSE,
    'locked' => FALSE,
  ])->save();
}
PHP
)"

echo "4/5 Preparing toolbar and cleaning stale configs..."
run_ddev drush role:delete session_moderator --yes >/dev/null 2>&1 || true
run_ddev drush config:delete field.storage.node.field_description field.field.node.field_description user.role.session_moderator >/dev/null 2>&1 || true
run_ddev drush en toolbar -y >/dev/null

echo "5/5 Enabling Event Platform modules (this may take a moment)..."
run_ddev drush en event_platform -y

echo "Event Platform bootstrap complete."
