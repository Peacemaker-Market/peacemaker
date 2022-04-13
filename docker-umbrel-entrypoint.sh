#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

# Remove pre-existing puma/passenger server.pid
rm -f $APP_PATH/tmp/pids/server.pid

#!/usr/bin/env bash
set -eo pipefail

# Check if we need to install new gems
bundle check || bundle install --jobs 20 --retry 5

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

bundle exec ${@}
# run passed commands
