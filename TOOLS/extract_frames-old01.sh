#!/bin/bash

# SFDUG Video Frame Extractor
# Extracts 5-10 frames from each video for use in slideshow
#
# Prerequisites:
#   brew install yt-dlp ffmpeg
#
# Usage:
#   ./extract_frames.sh [video_id]
#   
#   If video_id is provided, processes just that video.
#   If no argument, processes all videos in VIDEO_IDS array.

# Configuration
OUTPUT_DIR="./video_frames"
TEMP_DIR="./temp_videos"
FRAMES_PER_VIDEO=8           # How many frames to extract
SKIP_FIRST_SECONDS=30        # Skip intro/title card
SKIP_LAST_SECONDS=60         # Skip outro/Q&A
FRAME_INTERVAL=60            # Seconds between frame grabs (adjusted dynamically)

# All SFDUG video IDs
VIDEO_IDS=(
  g0p9RlXXXWU
  ZgxL3MNs6y4
  1gXleQbsMZA
  RvJlS2c3e9c
  wnEFUrB8ZFI
  j9g319DAJAQ
  mLCjXDV81N0
  uW8oI4teYb4
  h9oXGTa1D0I
  GtYkPKqnWp0
  rl-vkZUtjuw
  mPtGyO3mNrI
  WCgXhyKGqSE
  fclv2eb9jpg
  aV4QKud1sxU
  r6bguPj46sM
  0bva_8J-ghs
  ewUpmzY29C8
  jS6vooX0l-E
  rpTn3uiYIHY
  OHyY0vv6r8U
  d9IPx7ujitg
  5n3VEz_8-b8
  XBnOhNCcCJw
  mW9bneDOekA
  pESm09RjhOg
  DwN6WJK4yvk
  NLITPI7x_6s
  JN2Zm_pe19k
  SvON0iuA_L8
  ozaklnMQyGA
  KM6Z2JHZu0M
  Fg0ZClITg_8
  yX-PBBMjM_4
  PMST_gl4C4A
  KALrVf0cvBI
  34qkSIcfvrs
  du5FK7NJkcE
  QutbbUNK71Y
  vVpKCQZKNtM
  NAIxkuSHCho
  zND-1GqAWYk
  pdh8trqWd30
  BjXiaAko4AQ
)

# Create directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TEMP_DIR"

extract_frames() {
  local video_id="$1"
  local video_url="https://www.youtube.com/watch?v=${video_id}"
  local video_file="${TEMP_DIR}/${video_id}.mp4"
  local frame_dir="${OUTPUT_DIR}/${video_id}"
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Processing: $video_id"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Skip if frames already extracted
  if [ -d "$frame_dir" ] && [ "$(ls -A $frame_dir 2>/dev/null)" ]; then
    echo "  ⏭  Frames already exist, skipping. Delete $frame_dir to re-extract."
    return 0
  fi
  
  mkdir -p "$frame_dir"
  
  # Download video (720p max to save time/space, or best available)
  echo "  📥 Downloading..."
  if ! yt-dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best" \
       --merge-output-format mp4 \
       -o "$video_file" \
       "$video_url" 2>/dev/null; then
    echo "  ❌ Download failed for $video_id"
    return 1
  fi
  
  # Get video duration
  local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file" 2>/dev/null)
  duration=${duration%.*}  # Remove decimal
  
  if [ -z "$duration" ] || [ "$duration" -lt 120 ]; then
    echo "  ⚠️  Video too short or duration unknown: ${duration}s"
    rm -f "$video_file"
    return 1
  fi
  
  echo "  ⏱  Duration: ${duration}s"
  
  # Calculate frame extraction points
  local usable_duration=$((duration - SKIP_FIRST_SECONDS - SKIP_LAST_SECONDS))
  local interval=$((usable_duration / FRAMES_PER_VIDEO))
  
  # Ensure minimum interval of 30 seconds
  if [ "$interval" -lt 30 ]; then
    interval=30
  fi
  
  echo "  🎞  Extracting $FRAMES_PER_VIDEO frames (every ${interval}s)..."
  
  # Extract frames
  local frame_num=1
  local timestamp=$SKIP_FIRST_SECONDS
  
  while [ $frame_num -le $FRAMES_PER_VIDEO ] && [ $timestamp -lt $((duration - SKIP_LAST_SECONDS)) ]; do
    local output_file="${frame_dir}/frame_$(printf '%02d' $frame_num)_${timestamp}s.jpg"
    
    ffmpeg -y -ss "$timestamp" -i "$video_file" \
           -vframes 1 -q:v 2 \
           "$output_file" 2>/dev/null
    
    if [ -f "$output_file" ]; then
      echo "    ✓ Frame $frame_num at ${timestamp}s"
    fi
    
    frame_num=$((frame_num + 1))
    timestamp=$((timestamp + interval))
  done
  
  # Clean up video file to save space
  rm -f "$video_file"
  
  local extracted=$(ls "$frame_dir"/*.jpg 2>/dev/null | wc -l | tr -d ' ')
  echo "  ✅ Extracted $extracted frames to $frame_dir"
}

# Main execution
echo ""
echo "╔═══════════════════════════════════════════════════════╗"
echo "║     SFDUG Video Frame Extractor                       ║"
echo "╠═══════════════════════════════════════════════════════╣"
echo "║  Frames: $FRAMES_PER_VIDEO per video                            ║"
echo "║  Output: $OUTPUT_DIR/                          ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Check dependencies
if ! command -v yt-dlp &> /dev/null; then
  echo "❌ yt-dlp not found. Install with: brew install yt-dlp"
  exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
  echo "❌ ffmpeg not found. Install with: brew install ffmpeg"
  exit 1
fi

# Process single video or all
if [ -n "$1" ]; then
  extract_frames "$1"
else
  echo "Processing ${#VIDEO_IDS[@]} videos..."
  echo ""
  
  processed=0
  failed=0
  
  for video_id in "${VIDEO_IDS[@]}"; do
    if extract_frames "$video_id"; then
      processed=$((processed + 1))
    else
      failed=$((failed + 1))
    fi
    echo ""
  done
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Done! Processed: $processed, Failed: $failed"
  echo "Frames saved to: $OUTPUT_DIR/"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# Cleanup temp directory if empty
rmdir "$TEMP_DIR" 2>/dev/null
