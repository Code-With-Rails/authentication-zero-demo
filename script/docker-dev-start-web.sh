#!/usr/bin/env bash

set -xeuo pipefail

./script/wait-for-tcp.sh db 5432
./script/wait-for-tcp.sh redis 6379

if [[ -f ./tmp/pids/server.pid ]]; then
  rm ./tmp/pids/server.pid
fi

bundle

if ! [[ -f .db-created ]]; then
  bin/rails db:drop db:create
  touch .db-created
fi

bin/rails db:create
bin/rails db:migrate
bin/rails db:fixtures:load

if ! [[ -f .db-seeded ]]; then
  bin/rails db:seed
  touch .db-seeded
fi

foreman start -f Procfile.dev
