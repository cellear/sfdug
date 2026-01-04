#!/usr/bin/env bash
set -euo pipefail

# Script to satisfy Event Platform's expectation for filter formats, field storage,
# roles, and module dependencies before enabling the full suite. Run it from the
# repo root while the DDEV project is running.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DDEV_ROOT="$ROOT_DIR/drupalcms"

cd "$ROOT_DIR"

run_ddev() {
  (cd "$DDEV_ROOT" && ddev exec "$@")
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
# Uninstall all event_platform modules if partially installed
run_ddev drush pmu event_platform event_platform_details event_platform_sessions event_platform_scheduler event_platform_ratings event_platform_speakers event_platform_sponsors event_platform_job_listings -y >/dev/null 2>&1 || true
# Delete any remaining event_platform configs using PHP - be very aggressive
run_ddev drush php:eval "\$cf = \Drupal::configFactory(); \$patterns = ['event_platform', 'eca\.', 'config_pages\.type\.', 'core\.entity_(form|view)_display\.(config_pages|storage|taxonomy_term)', 'field\.(field|storage)\.(node|user|taxonomy_term|config_pages|storage)', 'node\.type\.(session|bof|sponsor|job_posting|featured_speaker)', 'taxonomy\.vocabulary\.', 'workflows\.workflow\.', 'views\.view\.', 'smart_menu_links\.', 'metatag\.metatag_defaults\.node__', 'pathauto\.pattern\.', 'simple_sitemap\.bundle_settings', 'system\.action\.user_(add|remove)_role_action', 'tvi\.taxonomy_vocabulary', 'user\.role\.(speaker|session_moderator)', 'auto_entitylabel\.settings']; foreach (\$cf->listAll() as \$name) { foreach (\$patterns as \$pattern) { if (preg_match('/' . \$pattern . '/', \$name)) { try { \$cf->getEditable(\$name)->delete(); } catch (\Exception \$e) {} break; } } }" >/dev/null 2>&1 || true
run_ddev drush cr >/dev/null 2>&1 || true
run_ddev drush en toolbar link menu_ui image file -y >/dev/null

echo "4.5/5 Ensuring prerequisites exist..."
run_ddev drush php:eval "$(cat <<'PHP'
use Drupal\node\Entity\NodeType;
use Drupal\user\Entity\Role;
use Drupal\Core\Entity\Entity\EntityViewDisplay;
use Drupal\field\Entity\FieldStorageConfig;

// Create article content type (needed by event_platform_details)
if (!NodeType::load('article')) {
  \$node_type = NodeType::create([
    'type' => 'article',
    'name' => 'Article',
  ]);
  \$node_type->save();
}

// Create administrator role (needed by event_platform_sessions)
if (!Role::load('administrator')) {
  \$role = Role::create([
    'id' => 'administrator',
    'label' => 'Administrator',
  ]);
  // Grant all permissions
  \$role->set('permissions', []);
  \$role->save();
  // Grant all permissions using the permissions service
  \Drupal::service('user.permissions')->getPermissions();
  \$all_permissions = array_keys(\Drupal::service('user.permissions')->getPermissions());
  \$role->set('permissions', \$all_permissions);
  \$role->save();
}

// Create field_image field storage (needed by event_platform_speakers)
if (!FieldStorageConfig::loadByName('node', 'field_image')) {
  FieldStorageConfig::create([
    'field_name' => 'field_image',
    'entity_type' => 'node',
    'type' => 'image',
    'settings' => [],
    'cardinality' => 1,
    'translatable' => FALSE,
    'locked' => FALSE,
  ])->save();
}

// Create user view displays (needed by event_platform_sessions install hook)
\$storage = \Drupal::entityTypeManager()->getStorage('entity_view_display');
foreach (['compact', 'default'] as \$mode) {
  if (!\$storage->load("user.user.{\$mode}")) {
    \$display = \$storage->create([
      'targetEntityType' => 'user',
      'bundle' => 'user',
      'mode' => \$mode,
      'status' => TRUE,
    ]);
    \$display->save();
  }
}

// Create user form display (needed by event_platform_sessions install hook)
\$form_storage = \Drupal::entityTypeManager()->getStorage('entity_form_display');
if (!\$form_storage->load('user.user.default')) {
  \$form_display = \$form_storage->create([
    'targetEntityType' => 'user',
    'bundle' => 'user',
    'mode' => 'default',
    'status' => TRUE,
  ]);
  \$form_display->save();
}
PHP
)" >/dev/null 2>&1 || true

echo "5/5 Enabling Event Platform modules (this may take a moment)..."
run_ddev drush en event_platform -y

echo "Event Platform bootstrap complete."
