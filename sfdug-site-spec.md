# SFDUG Site Spec

This document supersedes `INCOMING/sfdug-content-types.md`.

## Goals

- Keep compatibility with Event Platform where reasonable.
- Maintain separate Event and Session content types.
- Support historical archive and upcoming scheduling.
- People do not require Drupal user accounts.

## Content Types

### Event (Event Platform)

**Machine name:** `event`
**Description:** SFDUG meetings and special events.

Key fields (expected / typical for Event Platform):
- Title
- Date & time (supports single or recurring)
- Summary / description
- Event mode (`in_person`, `virtual`, `hybrid`)
- Location (entity reference to Location)
- Organizer(s) (entity reference to Person)
- Sponsor(s) (entity reference to Sponsor)
- Source URL (historical archive)
- RSVP / capacity (if enabled in Event Platform)
- Related sessions (reverse reference from Session)

Notes:
- Default to one Session per Event; allow multiple sessions for lightning talks.
- Keep Event as the canonical node for archive views and listings.

### Session (Event Platform)

**Machine name:** `session`
**Description:** A talk or agenda item within an Event.

Key fields:
- Title
- Date & time (optional; default to Event time)
- Summary / description
- Speaker(s) (entity reference to Person)
- Session video (media reference: Remote Video)
- Session frames (media reference: Image)
- Slides (file or link)
- Parent Event (entity reference to Event)

Notes:
- For most meetings, create a single Session with the same title as the Event.
- Use multiple Sessions for lightning talks or multi-part agendas.

### Person

**Machine name:** `person`
**Description:** Speakers, organizers, contributors.

Key fields:
- Name
- Photo (media reference: Image)
- Bio
- Organization
- Drupal.org profile (link)
- LinkedIn (link)
- Website (link)
- Roles (taxonomy: Role)

Notes:
- No Drupal user account required.
- If Event Platform requires user-backed speakers, flag and revisit.

### Sponsor

**Machine name:** `sponsor`
**Description:** Organizations supporting SFDUG.

Key fields:
- Name
- Logo (media reference: Image)
- URL
- Description
- Tier (`platinum`, `gold`, `silver`, `bronze`, `in_kind`)
- Active (boolean)
- Active period (daterange)

## Entities / Taxonomies

### Location (Event Platform)

**Machine name:** `location`
**Description:** Dedicated locations for Events.

Key fields:
- Name
- Address
- Notes
- Room / floor (optional)

### Venue (taxonomy)

Optional. If Event Platform Location satisfies the use case, this can be dropped.
If kept, use for legacy import values and map to Location entities.

### Topic (taxonomy)

Used for tagging Events and Sessions.

### Role (taxonomy)

Used for Person roles: `speaker`, `organizer`, `sponsor_rep`, etc.

## Media Types

### Remote Video (YouTube)

**Machine name:** `remote_video`
**Source:** oEmbed

Fields:
- Name
- Video URL (oEmbed)
- Thumbnail override (Image)
- YouTube ID (string)

### Image

Standard image media for:
- Person photos
- Sponsor logos
- Session frames
- Venue/location photos

## Views / Paths

### Archive
- Path: `/archive` or `/meetings`
- Filter: Event date < now
- Sort: date descending

### Upcoming
- Path: `/upcoming`
- Filter: Event date >= now
- Sort: date ascending

### People
- Path: `/people` (filterable by Role)
- Display: grid

### Videos
- Path: `/videos`
- Source: Sessions with video
- Sort: date descending

## Migration Notes (CSV)

### Meetings CSV → Event + Session

- Create Event from row.
- Create one Session per Event by default.
- Link Session to Event.
- Attach video and frames to Session.

Suggested field mapping:
- `title` → Event.title + Session.title
- `event_start` / `created_date` → Event date (Session date if needed)
- `body_html_clean` → Event description (or Session description)
- `venue_name_raw` → Location (create if missing)
- `event_mode` → Event mode
- `speakers_inferred` → Person + Session speakers
- `organizers` → Person + Event organizers
- `drupal_org_url` → Event source URL
- `rsvp_count` → Event RSVP count

### Videos CSV → Remote Video Media

- `video_id` → YouTube ID
- `youtube_url` → Video URL
- Match media to Session by date/title (manual if needed)

## Open Questions / Checks

- Confirm Event Platform’s required fields for Event, Session, Location, and Speaker.
- Validate whether Event Platform requires speakers to be users.
- Decide whether to keep Venue taxonomy once Location is in place.
