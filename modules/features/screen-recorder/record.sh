#!/usr/bin/env bash
set -euo pipefail

RECORDINGS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}/Recordings"
STATE_FILE="/tmp/screenrecord.state"

# 1. Stop recording if already running
if pgrep -x gpu-screen-recorder >/dev/null 2>&1; then
    pkill -INT -x gpu-screen-recorder 2>/dev/null || true
    
    SAVED_NAME="your Recordings folder"
    if [[ -f "$STATE_FILE" ]]; then
        SAVED_NAME="$(basename "$(cat "$STATE_FILE")")"
        rm -f "$STATE_FILE"
    fi

    if command -v noctalia >/dev/null 2>&1; then
        noctalia msg notification-show "Screen Recording" "Saved $SAVED_NAME" 2>/dev/null || true
    fi
    exit 0
fi

# 2. Ensure destination directory exists
mkdir -p "$RECORDINGS_DIR"

# 3. Handle capture target (Region by default, or Fullscreen if flagged)
REGION=""
if [[ "${1:-}" == "--fullscreen" || "${1:-}" == "-f" ]]; then
    TARGET_FLAG=(-w focused)
else
    # Interactive region selection using slurp (press Esc to abort)
    if ! command -v slurp >/dev/null 2>&1; then
        echo "Error: slurp is not installed." >&2
        exit 1
    fi

    REGION="$(slurp -f "%wx%h+%x+%y" 2>/dev/null || true)"
    if [[ -z "$REGION" ]]; then
        # Selection was cancelled
        exit 0
    fi
    TARGET_FLAG=(-w region -region "$REGION")
fi

# 4. Generate timestamped output file
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
OUTPUT_FILE="$RECORDINGS_DIR/recording_${TIMESTAMP}.mp4"
echo "$OUTPUT_FILE" > "$STATE_FILE"

# 5. Notify user of recording start
if command -v noctalia >/dev/null 2>&1; then
    noctalia msg notification-show "Screen Recording" "🔴 Recording started..." 2>/dev/null || true
fi

# 6. Launch GPU Screen Recorder with hardware acceleration
exec gpu-screen-recorder \
    "${TARGET_FLAG[@]}" \
    -f 60 \
    -k h264 \
    -ac opus \
    -a default_output \
    -o "$OUTPUT_FILE"
