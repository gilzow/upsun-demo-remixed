#!/usr/bin/env bash
storage="file"
evnType="${PLATFORM_ENVIRONMENT_TYPE}"
api="/api/index.json"
# is redis available?
if [[ -n ${REDIS_SESSION_HOST+x} ]]; then
  storage="redis"
fi

printf '{ "session_storage": "%s", "type": "%s" }' "${storage}" "${PLATFORM_ENVIRONMENT_TYPE}" > "${PLATFORM_APP_DIR}${api}"