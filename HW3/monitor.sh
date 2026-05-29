#!/usr/bin/env bash
# monitor.sh - For Assignment 3 Q4 Part 1: background-sample iostat + free, write to logs with the given prefix.
#
# Usage:
#   ./monitor.sh <output_prefix>
#
# Example (run in another terminal while FlexGen is running):
#   ./monitor.sh logs/q4_1_io
#   # produces:
#   #   logs/q4_1_io_iostat.log   <- output of iostat -x 1
#   #   logs/q4_1_io_free.log     <- output of free -m -s 1
#
# Press Ctrl+C to stop sampling.

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <output_prefix>"
    echo "Example: $0 logs/q4_1_io  (produces logs/q4_1_io_iostat.log and logs/q4_1_io_free.log)"
    exit 1
fi

# Check tools exist
for cmd in iostat free; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found. Please install sysstat and procps:"
        echo "  sudo apt install sysstat procps"
        exit 1
    fi
done

PREFIX="$1"
mkdir -p "$(dirname "$PREFIX")"

IOSTAT_LOG="${PREFIX}_iostat.log"
FREE_LOG="${PREFIX}_free.log"

echo "============================================="
echo "Sampling started (Ctrl+C to stop)"
echo "  iostat -x 1   ->  $IOSTAT_LOG"
echo "  free -m -s 1  ->  $FREE_LOG"
echo "============================================="

# Launch both samplers in the background
iostat -x 1 > "$IOSTAT_LOG" &
IOSTAT_PID=$!

free -m -s 1 > "$FREE_LOG" &
FREE_PID=$!

# Clean up child processes on Ctrl+C
cleanup() {
    echo ""
    echo "Stopping sampling..."
    kill -TERM "$IOSTAT_PID" 2>/dev/null || true
    kill -TERM "$FREE_PID" 2>/dev/null || true
    wait "$IOSTAT_PID" 2>/dev/null || true
    wait "$FREE_PID" 2>/dev/null || true
    echo ""
    echo "Logs written:"
    echo "  $IOSTAT_LOG ($(wc -l < "$IOSTAT_LOG") lines)"
    echo "  $FREE_LOG ($(wc -l < "$FREE_LOG") lines)"
    exit 0
}
trap cleanup INT TERM

# Wait until child processes exit (or Ctrl+C)
wait "$IOSTAT_PID"
