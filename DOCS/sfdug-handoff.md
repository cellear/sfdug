# SFDUG Site Build — Handoff Document for Coding Assistant

## Project Overview

Building **sfdug.org**, the website for the San Francisco Drupal Users Group. The group has been running since April 2006 and is approaching its **20th anniversary in April 2026**.

The site serves two purposes:
1. **Archive** — Celebrating 20 years of meetings, speakers, and community
2. **Future** — Scheduling and promoting upcoming monthly sessions

### Immediate Goal

Launch a "coming soon" page that showcases the history while we build out the full site.

### Tech Stack

- **Drupal CMS** (latest — leveraging new features)
- **Base theme:** TBD (exploring options beyond FLDC)
- **Hosting:** Drupito (Ashraf Abed)
- **Local dev:** DDEV

### Modules to Explore

- **[Event Platform](https://www.drupal.org/project/event_platform)** — Event management distribution
- **[Member](https://www.drupal.org/project/member)** — Membership/community features (Luke is a contributor)

These may provide a head start on Meeting content type and related functionality.

---

## Brand Identity

### Voice & Positioning

SFDUG is repositioning from "casual meetup" to "professional venue." Think DrupalCon-caliber sessions, monthly. The tagline direction (not finalized):

> "Twenty years of Bay Area Drupal. A new format for the next twenty."

### Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Deep Navy | `#1a1a2e` | Primary background, header |
| Midnight | `#16213e` | Secondary background |
| Bay Blue | `#0f3460` | Accent sections, credibility blocks |
| Coral | `#e94560` | Primary accent, CTAs, highlights |
| Off-white | `#f8f8f8` | Light backgrounds, text on dark |
| Muted | `#888888` | Secondary text |

### Visual Direction

- Dark theme (differentiates from FLDC's light/warm palette)
- Geometric lines suggesting bridge cables / urban / fog aesthetic
- No literal Golden Gate imagery — just the vibe
- Heavy use of video thumbnails and extracted frames as visual content

---

## Content Architecture

### Content Types

| Type | Machine Name | Purpose |
|------|--------------|---------|
| Meeting | `meeting` | Past and future gatherings |
| Person | `person` | Speakers, organizers, contributors |
| Sponsor | `sponsor` | Supporting organizations |

### Taxonomies

| Vocabulary | Machine Name | Purpose |
|------------|--------------|---------|
| Venue | `venue` | Meeting locations |
| Topic | `topic` | Subject tags |
| Role | `role` | Speaker, Organizer, Videographer, etc. |

### Media Types

| Type | Purpose |
|------|---------|
| Remote Video | YouTube embeds |
| Image | Photos, logos, video frames |

**Full field definitions in:** `sfdug-site-spec.md` (Appendix A-C)

---

## File Assets Available

### In Project Directory

```
├── sfdug-brand-guide.md          # Voice, messaging, sample copy
├── sfdug-site-spec.md            # Content types, fields, migrations
├── sfdug-coming-soon.html        # Working HTML prototype
├── sfdug-coming-soon-v2.md       # Copy variations
├── sfdug_nodes_parsed.csv        # ~80 historical meetings from groups.drupal.org
├── sfdug_videos.csv              # 44 YouTube videos with thumbnail URLs
├── extract_frames.sh             # Script used to extract video frames
├── temp_videos/                  # Downloaded MP4s (44 videos)
└── video_frames/                 # Extracted frames (~8 per video)
    ├── BjXiaAko4AQ/
    │   ├── frame_01_30s.jpg
    │   ├── frame_02_90s.jpg
    │   └── ...
    └── [video_id]/
        └── ...
```

### YouTube Thumbnails

Available at:
```
https://img.youtube.com/vi/[VIDEO_ID]/maxresdefault.jpg
https://img.youtube.com/vi/[VIDEO_ID]/hqdefault.jpg  (fallback)
```

Video IDs are in `sfdug_videos.csv`.

---

## Homepage Design

### Structure

```
┌─────────────────────────────────────────────────────────────┐
│  Header: SFDUG + rotating year badges (06, 11, 15, 20, 26)  │
├─────────────────────────────────────────────────────────────┤
│  Hero:                                                      │
│    "Twenty Years of Bay Area Drupal"                        │
│    Est. April 2006                                          │
│    Origin story paragraph (Zack Rosen, first camp)          │
│    [Join mailing list button]                               │
├─────────────────────────────────────────────────────────────┤
│  Video Slideshow:                                           │
│    YouTube thumbnails with extracted frames layered on top  │
│    "Falling pile" or "scattered stack" effect               │
│    Auto-advances, pausable                                  │
├─────────────────────────────────────────────────────────────┤
│  Crawl: Organizers (with photos)                            │
│    → Zack Rosen · John Faber · Mark Ferree · ...            │
├─────────────────────────────────────────────────────────────┤
│  Crawl: Speakers (with photos)                              │
│    ← Dries Buytaert · Alex Pott · Jen Lampton · ...         │
├─────────────────────────────────────────────────────────────┤
│  Crawl: Topics                                              │
│    → Headless · Twig · Layout Builder · Migrations · ...    │
├─────────────────────────────────────────────────────────────┤
│  Venues section (Bay Blue background)                       │
│    Pantheon · Chapter Three · Compumentor · UCSF · ...      │
│    "(and your living room, 2020–present)"                   │
├─────────────────────────────────────────────────────────────┤
│  20th Anniversary callout                                   │
│    "April 2026 marks 20 years"                              │
├─────────────────────────────────────────────────────────────┤
│  BADCamp connection + Footer                                │
└─────────────────────────────────────────────────────────────┘
```

### Crawl Behavior

- Horizontal scrolling marquees
- Alternate directions (organizers right→, speakers ←left)
- Pause on hover
- Seamless loop (content duplicated)
- People crawls include circular photo thumbnails

### Video Slideshow Concept

Each slide shows:
1. Base layer: YouTube thumbnail (title card with speaker info)
2. Top layers: 3-5 extracted frames scattered/stacked on top
3. Frames could animate in (falling, sliding, fanning)
4. Click goes to that meeting's page or YouTube video

---

## Key People

### Organizers (for crawl)

Zack Rosen · John Faber · Mark Ferree · Anne Stefanyk · Anne Bonham · Eric Guirren · AmyJune Hineline · Annabella · Sean Dietrich · Mark Casias · James Kealy · Gregory Heller

### Notable Speakers (for crawl)

Dries Buytaert · Alex Pott · Jen Lampton · Cathy Theys · Matt Glaman · Mike Herchel · Martin Anderson-Clutz · Mario Hernandez · Danny Englander · Greg Anderson · Josh Koenig · David Hwang · Mauricio Dinarte · Jürgen Haas · Jeff Robbins · Tearyne Almendariz

### Topics (for crawl)

Headless Drupal · Twig · Layout Builder · Configuration Management · Composer · Backdrop CMS · Accessibility · WCAG · Migrations · DevOps · Responsive Images · PHPStan · Solr · Views · Theming · Gift of Open Source · React · Tailwind CSS · DDEV · Multisite · Performance · Security · Contrib · Core

### Venues

Pantheon · Chapter Three · Compumentor · UCSF Mission Center · (and your living room, 2020–present)

---

## Origin Story (for hero text)

> In April 2006, Zack Rosen and Gregory Heller organized the first Drupal Camp SF — a two-day training at Compumentor's offices with Jeff Robbins from Lullabot. It sold out in five days. Half the attendees flew in from out of state.
>
> That was the beginning. We're still here.

Source: https://www.drupal.org/node/58182

---

## Data Migration

### Phase 1: Import Meetings

Source: `sfdug_nodes_parsed.csv`

1. Create Meeting nodes from CSV
2. Extract and create Person nodes from `speakers_inferred` and `organizers` columns
3. Create Venue terms from `venue_name_raw`
4. Link source URLs to original groups.drupal.org pages

### Phase 2: Import Videos

Source: `sfdug_videos.csv`

1. Create Remote Video media entities
2. Match to Meeting nodes by date/title (may need manual mapping)
3. Import extracted frames as Image media
4. Attach frames to corresponding Meetings

### Phase 3: Enhance People

1. Add photos (manual — action shots preferred)
2. Add bios
3. Add role terms (Speaker, Organizer, etc.)
4. Link drupal.org and LinkedIn profiles

---

## Related Resources

- **BADCamp:** https://www.badcamp.org
- **BADCamp YouTube:** https://www.youtube.com/@bayareadrupal
- **Event Platform module:** https://www.drupal.org/project/event_platform
- **Member module:** https://www.drupal.org/project/member
- **Drupal CMS:** https://www.drupal.org/drupal-cms
- **Drupito hosting:** (Ashraf Abed's platform)
- **BADCamp GitHub:** https://github.com/badcamp
- **Original SFDUG on groups.drupal.org:** https://groups.drupal.org/bay-area

---

## Build Priorities

### Now (Coming Soon Page)

1. [ ] Set up Drupal site with FLDC theme fork
2. [ ] Implement dark color scheme
3. [ ] Build homepage with crawls and video slideshow
4. [ ] Connect mailing list signup
5. [ ] Deploy to production URL

### Next (Content Foundation)

1. [ ] Create content types (Meeting, Person, Sponsor)
2. [ ] Create taxonomies (Venue, Topic, Role)
3. [ ] Configure media types and file organization
4. [ ] Import meetings from CSV
5. [ ] Import videos and frames

### Later (Full Site)

1. [ ] Meeting archive pages
2. [ ] People directory
3. [ ] Sponsor recognition pages
4. [ ] Upcoming meetings / scheduling
5. [ ] Job board
6. [ ] Resources section
7. [ ] Links to other user groups

---

## Notes

- **Don't publish empty placeholder pages** — Build the infrastructure, but only publish pages with real content
- **Sponsor emphasis** — Give generous attention to past sponsors; makes future sponsorship easier to sell
- **Video thumbnails have errors** — Some titles are wrong; will need correction (tracked in separate spreadsheet)
- **20th anniversary is April 2026** — Major milestone to build toward

---

## Questions for Luke

1. First session speaker confirmed? (Matt Glaman tentatively)
2. Mailing list provider? (Mailchimp, Buttondown, etc.)
3. Domain ready? (sfdug.org)
4. Event Platform vs. custom content types — use as-is, adapt, or build fresh?
5. Member module integration — what features to leverage?
6. Theme direction — Olivero-based? Contrib theme? Custom?

Document created by Claude on Jan 3, 2026
