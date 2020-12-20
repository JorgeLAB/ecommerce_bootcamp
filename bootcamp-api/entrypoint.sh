#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
<<<<<<< HEAD
rm -f /bootcamp9/tmp/pids/server.pid
=======
rm -f /myapp/tmp/pids/server.pid
>>>>>>> Setup Refactoting

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"