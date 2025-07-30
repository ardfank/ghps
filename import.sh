#!/bin/bash

set -e

export BITBUCKET_USER="user"
export BITBUCKET_APP_PASSWORD="password"
export BITBUCKET_WORKSPACE="forca"
export BITBUCKET_PROJECT_KEY="FC"  # all caps usually

export GITLAB_TOKEN="token"
export GITLAB_API="https://bug-free-funicular-wrrpp559rj9fgq59-8080.app.github.dev/api/v4"
export GITLAB_GROUP_ID="35"  # or use curl to look up group


# Get all repos in the Bitbucket project
function fetch_bitbucket_repos() {
  local url="https://api.bitbucket.org/2.0/repositories/$BITBUCKET_WORKSPACE?q=project.key=\"$BITBUCKET_PROJECT_KEY\""
  while [ -n "$url" ]; do
    echo "Fetching: $url"
    response=$(curl -s -u "$BITBUCKET_USER:$BITBUCKET_APP_PASSWORD" "$url")
    echo "$response" | jq -c '.values[]' |
    while read -r repo; do
      name=$(echo "$repo" | jq -r '.name')
      slug=$(echo "$repo" | jq -r '.slug')
    #   clone_url=$(echo "$repo" | jq -r '.links.clone[] | select(.name=="https") | .href')
      clone_url=$(echo "$repo" | jq -r '.links.clone[] | select(.name=="https") | .href' | sed -E 's#https://[^@]+@#https://#')


      # Ensure .git extension
      [[ "$clone_url" != *.git ]] && clone_url="${clone_url}.git"

      echo "Importing $name from $clone_url"
      import_repo_to_gitlab "$name" "$slug" "$clone_url"
    done
    url=$(echo "$response" | jq -r '.next // empty')
  done
}

# Import a single repo into GitLab
function import_repo_to_gitlab() {
  local name="$1"
  local slug="$2"
  local clone_url="$3"

  # URL encode username and password (basic safety for special characters)
  local encoded_user=$(printf %s "$BITBUCKET_USER" | jq -s -R -r @uri)
  local encoded_pass=$(printf %s "$BITBUCKET_APP_PASSWORD" | jq -s -R -r @uri)

  # Inject credentials into URL
  local auth_clone_url=${clone_url/https:\/\//https:\/\/$encoded_user:$encoded_pass@}

  echo "Using import URL: $auth_clone_url"
#   echo "User: $encoded_user"
#   echo "Pass: $encoded_pass"
#   echo "clone_url: $clone_url"

  payload=$(jq -n \
    --arg name "$slug" \
    --arg import_url "$auth_clone_url" \
    --argjson namespace_id "$GITLAB_GROUP_ID" \
    '{name: $name, import_url: $import_url, namespace_id: $namespace_id}')

  response=$(curl -s -w "\n%{http_code}" -X POST "$GITLAB_API/projects" \
    -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$payload")

  body=$(echo "$response" | head -n 1)
  status=$(echo "$response" | tail -n 1)

  if [ "$status" = "201" ]; then
    echo "✅ Imported $name"
  else
    echo "❌ Failed to import $name (HTTP $status)"
    echo "↪️ GitLab response: $body"
  fi
  echo "--"
  echo "--"
  echo "--"
}

# Run it
fetch_bitbucket_repos