#!/usr/bin/env bash
set -euo pipefail

# Quick script to enable Event Platform modules. Run from repo root.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DDEV_ROOT="$ROOT_DIR/drupalcms"

cd "$ROOT_DIR"

run_ddev() {
  (cd "$DDEV_ROOT" && ddev exec "$@")
}

echo "Cleaning up stale configs..."
# Uninstall modules first
run_ddev drush pmu event_platform_sessions event_platform_scheduler event_platform_ratings -y >/dev/null 2>&1 || true

# Delete all event_platform_sessions related configs using drush config:delete
# Delete configs in batches to avoid command line length issues
run_ddev drush config:delete -y \
  auto_entitylabel.settings.taxonomy_term.time_slot \
  core.base_field_override.node.session.promote \
  core.entity_form_display.node.bof.default \
  core.entity_form_display.node.session.default \
  core.entity_form_display.taxonomy_term.room.default \
  core.entity_form_display.taxonomy_term.time_slot.default \
  core.entity_view_display.node.bof.default \
  core.entity_view_display.node.bof.teaser \
  core.entity_view_display.node.session.default \
  core.entity_view_display.node.session.teaser \
  core.entity_view_display.taxonomy_term.room.default \
  core.entity_view_display.taxonomy_term.time_slot.default \
  >/dev/null 2>&1 || true

run_ddev drush config:delete -y \
  field.storage.node.field_description \
  field.field.node.field_description \
  field.field.node.bof.field_description \
  field.field.node.bof.field_event \
  field.field.node.bof.field_r \
  field.field.node.bof.field_short_description \
  field.field.node.bof.field_time_slot \
  field.field.node.session.field_audience \
  field.field.node.session.field_description \
  field.field.node.session.field_event \
  field.field.node.session.field_is_non_session \
  field.field.node.session.field_is_training \
  field.field.node.session.field_r \
  >/dev/null 2>&1 || true

run_ddev drush config:delete -y \
  field.field.node.session.field_session_category \
  field.field.node.session.field_short_description \
  field.field.node.session.field_social_media_card \
  field.field.node.session.field_speakers \
  field.field.node.session.field_time_slot \
  field.storage.node.field_audience \
  field.storage.node.field_is_non_session \
  field.storage.node.field_is_training \
  field.storage.node.field_r \
  field.storage.node.field_session_category \
  field.storage.node.field_short_description \
  field.storage.node.field_social_media_card \
  field.storage.node.field_speakers \
  field.storage.node.field_time_slot \
  >/dev/null 2>&1 || true

run_ddev drush config:delete -y \
  field.field.taxonomy_term.room.field_events \
  field.field.taxonomy_term.time_slot.field_event \
  field.field.taxonomy_term.time_slot.field_when \
  field.storage.taxonomy_term.field_when \
  field.field.user.user.field_bio \
  field.field.user.user.field_display_name \
  field.storage.user.field_bio \
  field.storage.user.field_display_name \
  user.role.session_moderator \
  user.role.speaker \
  >/dev/null 2>&1 || true

run_ddev drush config:delete -y \
  node.type.bof \
  node.type.session \
  taxonomy.vocabulary.room \
  taxonomy.vocabulary.session_audience \
  taxonomy.vocabulary.session_category \
  taxonomy.vocabulary.time_slot \
  workflows.workflow.session_acceptance \
  >/dev/null 2>&1 || true

# Delete ECA configs, views, and other configs using PHP (simpler for patterns)
run_ddev drush php:eval "\$cf = \Drupal::configFactory(); foreach (\$cf->listAll() as \$name) { if (preg_match('/^(eca\.(eca|model)\.|metatag\.metatag_defaults\.node__(bof|session)|pathauto\.pattern\.(bofs|sessions)|simple_sitemap\.bundle_settings\.default\.node\.(bof|session)|smart_menu_links\.smart_menu_link\.|system\.action\.user_(add|remove)_role_action\.speaker|tvi\.taxonomy_vocabulary\.event|views\.view\.(bofs|concurrent_sessions|event_term|reference_view_time_slot_date_taxonomy|session_list|session_speakers|sessions_by_state|training_list))/', \$name)) { try { \$cf->getEditable(\$name)->delete(); } catch (\Exception \$e) {} } }" >/dev/null 2>&1 || true

# Delete roles
run_ddev drush role:delete session_moderator speaker --yes >/dev/null 2>&1 || true

run_ddev drush cr >/dev/null 2>&1 || true

echo "Ensuring required field storage exists..."
run_ddev drush php:eval "$(cat <<'PHP'
use Drupal\field\Entity\FieldStorageConfig;

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
PHP
)" >/dev/null 2>&1 || true

echo "Creating required user display modes..."
run_ddev drush php:eval "\$storage = \Drupal::entityTypeManager()->getStorage('entity_view_display'); if (!\$storage->load('user.user.compact')) { \$display = \$storage->create(['targetEntityType' => 'user', 'bundle' => 'user', 'mode' => 'compact', 'status' => TRUE]); \$display->save(); }" >/dev/null 2>&1 || true

echo "Enabling Event Platform modules..."
run_ddev drush en event_platform -y

echo "Done!"

