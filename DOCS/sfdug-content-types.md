# SFDUG Content Type Specifications

Note: This document has been superseded by `sfdug-site-spec.md`.

## Overview

These content types are designed to support:
- Historical meeting archive (imported from groups.drupal.org)
- Future meeting scheduling
- Video library with frame extracts
- Speaker and organizer profiles
- Eventually: sponsors, resources, job board

---

## Content Type: Meeting

**Machine name:** `meeting`
**Description:** Past and future SFDUG gatherings

### Fields

| Field Label | Machine Name | Type | Required | Notes |
|-------------|--------------|------|----------|-------|
| Title | `title` | String | Yes | Event title |
| Date & Time | `field_meeting_datetime` | Datetime | Yes | Smart Date recommended for recurring |
| Description | `field_meeting_description` | Text (formatted, long) | No | Full description, agenda, etc. |
| Summary | `field_meeting_summary` | Text (plain, long) | No | Short teaser for listings |
| Event Mode | `field_event_mode` | List (text) | Yes | `in_person`, `virtual`, `hybrid` |
| Location/Venue | `field_venue` | Entity reference (Taxonomy: Venue) | No | Where it happened |
| Virtual Link | `field_virtual_link` | Link | No | Zoom/Meet/YouTube Live URL |
| Speaker(s) | `field_speakers` | Entity reference (Content: Speaker) | No | Unlimited cardinality |
| Organizer(s) | `field_organizers` | Entity reference (Content: Organizer) | No | Who ran SFDUG at the time |
| Video | `field_video` | Entity reference (Media: Remote Video) | No | YouTube embed |
| Video Frames | `field_video_frames` | Entity reference (Media: Image) | No | Extracted frames, unlimited |
| Slides | `field_slides` | File / Link | No | Uploaded or linked |
| RSVP Count | `field_rsvp_count` | Integer | No | Historical attendance data |
| Source URL | `field_source_url` | Link | No | Original groups.drupal.org link |
| Sponsor | `field_sponsor` | Entity reference (Content: Sponsor) | No | Meeting sponsor if any |

### Taxonomy: Venue

**Machine name:** `venue`

| Field Label | Machine Name | Type | Notes |
|-------------|--------------|------|-------|
| Name | `name` | String | Pantheon, Chapter Three, etc. |
| Address | `field_address` | Address | Full address |
| Notes | `field_venue_notes` | Text (plain, long) | Parking, access, etc. |

### Taxonomy: Topic

**Machine name:** `topic`

Used for tagging meetings by subject area.

Examples: `Layout Builder`, `Migrations`, `DevOps`, `Accessibility`, `Theming`, `Composer`, `Headless`, `Contrib`

---

## Content Type: Speaker

**Machine name:** `speaker`
**Description:** People who have presented at SFDUG

### Fields

| Field Label | Machine Name | Type | Required | Notes |
|-------------|--------------|------|----------|-------|
| Name | `title` | String | Yes | Full name |
| Photo | `field_speaker_photo` | Entity reference (Media: Image) | No | Action shot preferred |
| Bio | `field_speaker_bio` | Text (formatted, long) | No | About the speaker |
| Organization | `field_speaker_org` | String | No | Company/affiliation |
| Drupal.org Profile | `field_drupalorg_url` | Link | No | |
| LinkedIn | `field_linkedin_url` | Link | No | |
| Website | `field_website_url` | Link | No | Personal site |

**Note:** Meetings where they spoke can be displayed via a View (reverse entity reference).

---

## Content Type: Organizer

**Machine name:** `organizer`
**Description:** People who have organized/led SFDUG

### Fields

| Field Label | Machine Name | Type | Required | Notes |
|-------------|--------------|------|----------|-------|
| Name | `title` | String | Yes | Full name |
| Photo | `field_organizer_photo` | Entity reference (Media: Image) | No | |
| Bio | `field_organizer_bio` | Text (formatted, long) | No | |
| Active Period | `field_active_period` | Daterange | No | When they organized |
| Drupal.org Profile | `field_drupalorg_url` | Link | No | |
| LinkedIn | `field_linkedin_url` | Link | No | |
| Role | `field_organizer_role` | String | No | "Founder", "Co-organizer", etc. |

**Note:** Could also be a taxonomy or even just a flag on a unified "Person" content type. Separate content type gives more flexibility for detailed bios.

---

## Content Type: Sponsor

**Machine name:** `sponsor`
**Description:** Organizations that have sponsored SFDUG

### Fields

| Field Label | Machine Name | Type | Required | Notes |
|-------------|--------------|------|----------|-------|
| Name | `title` | String | Yes | Company name |
| Logo | `field_sponsor_logo` | Entity reference (Media: Image) | Yes | |
| URL | `field_sponsor_url` | Link | Yes | Company website |
| Description | `field_sponsor_description` | Text (plain, long) | No | Short blurb |
| Tier | `field_sponsor_tier` | List (text) | No | `platinum`, `gold`, `silver`, `bronze`, `in_kind` |
| Active | `field_sponsor_active` | Boolean | Yes | Currently sponsoring? |
| Active Period | `field_sponsor_period` | Daterange | No | When they sponsored |

---

## Media Types

### Remote Video (YouTube)

**Machine name:** `remote_video`
**Source:** oEmbed

| Field Label | Machine Name | Type | Notes |
|-------------|--------------|------|-------|
| Name | `name` | String | Video title (correctable) |
| Video URL | `field_media_oembed_video` | String (oEmbed) | YouTube URL |
| Thumbnail Override | `field_thumbnail_override` | Image | If auto-fetch isn't good enough |
| YouTube ID | `field_youtube_id` | String | For building thumbnail URLs |

### Image

Standard Drupal image media type, used for:
- Speaker photos
- Organizer photos  
- Sponsor logos
- Video frame extracts
- Venue photos

---

## Views to Create

### Past Meetings
- Path: `/archive` or `/meetings`
- Filter: Date < now
- Sort: Date descending
- Display: Teaser with thumbnail

### Upcoming Meetings
- Path: `/upcoming`
- Filter: Date >= now
- Sort: Date ascending
- Display: Full details

### Speakers
- Path: `/speakers`
- Sort: Alphabetical or by meeting count
- Display: Photo grid with names

### Videos
- Path: `/videos`
- Source: Meetings with video attached
- Sort: Date descending
- Display: Thumbnail grid, YouTube-style

### Meetings by Speaker
- Contextual filter: Speaker NID
- Embedded on Speaker node

### Meetings by Organizer
- Contextual filter: Organizer NID
- Embedded on Organizer node

---

## Migration Notes

### From sfdug_nodes_parsed.csv → Meeting

| CSV Column | Drupal Field | Transform |
|------------|--------------|-----------|
| `title` | `title` | Clean up, remove "SFDUG - " prefix |
| `created_date` | `field_meeting_datetime` | Parse date |
| `event_start` | `field_meeting_datetime` | Use if available, else created_date |
| `body_html_clean` | `field_meeting_description` | Strip wrapper divs |
| `speakers_inferred` | `field_speakers` | Create/match Speaker nodes |
| `organizers` | `field_organizers` | Create/match Organizer nodes |
| `venue_name_raw` | `field_venue` | Create/match Venue terms |
| `event_mode` | `field_event_mode` | Map `in_person` or default to virtual post-2020 |
| `rsvp_count` | `field_rsvp_count` | Direct |
| `drupal_org_url` | `field_source_url` | Direct |

### From sfdug_videos.csv → Media (Remote Video)

| CSV Column | Drupal Field | Transform |
|------------|--------------|-----------|
| `video_id` | `field_youtube_id` | Direct |
| `youtube_url` | `field_media_oembed_video` | Direct |
| `thumbnail_maxres` | (auto-fetched or manual) | |

Videos need to be matched to Meetings by date/title — may require manual matching or fuzzy search.

---

## Recommended Modules

- **Smart Date** — Better datetime handling, recurring events
- **Address** — For venue addresses
- **Media** — Core, for videos and images
- **Migrate Tools / Migrate Plus / Migrate Source CSV** — For CSV import
- **Pathauto** — Auto URL aliases
- **Metatag** — SEO basics
- **Simple Sitemap** — For search engines
- **Scheduler** — If you want to schedule meeting announcements

---

## Notes

1. **Person unification:** Could merge Speaker and Organizer into a single "Person" content type with role flags. Tradeoff: simpler data model vs. messier forms.

2. **Video frames:** These could be a multi-value image field on Meeting, or a separate "Frame" media type with a reference back. Multi-value field is simpler.

3. **Sponsor per meeting:** The CSV shows Kanopi sponsored many meetings. Could track this per-meeting or just have a general Sponsors page. Per-meeting is more accurate historically.

4. **Future-proofing:** The Meeting type works for both past archive and future scheduling. Just filter by date in Views.
