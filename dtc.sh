#!/bin/bash

# Check the OPENAI_API_KEY. If it is not set, then exit.
if [[ -z "${OPENAI_API_KEY}" ]]; then
  echo "Please, declare the envvar OPENAI_API_KEY (see https://platform.openai.com/account/api-keys)."
  exit 1
fi

# Check jq and curl. If they are not installed, then exit.
command -v jq >/dev/null 2>&1 || { echo >&2 "Please, install 'jq'."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo >&2 "Please, install 'curl'."; exit 1; }

# Check arguments.
if [[ $# -eq 0 ]]; then
  echo -n "Description of the command: "
  read -r
  DESCRIPTION=$REPLY
else
  DESCRIPTION="'$*'"
fi

# Call OpenAI API.
SHELL=$(basename "$SHELL")
OS=$(uname -s)
RESULT=$(curl https://api.openai.com/v1/completions \
  --silent \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
  \"model\": \"text-davinci-003\",
  \"prompt\": \"Translate one question to a minimal number of shell command in ${SHELL} for the ${OS} operating system.\nQuestion: ${DESCRIPTION}\nCommand:\",
  \"temperature\": 0,
  \"max_tokens\": 150,
  \"top_p\": 1,
  \"frequency_penalty\": 0,
  \"presence_penalty\": 0,
  \"best_of\": 1
}")

# Print the result if you need to debug.
#echo "$RESULT"

# Extract the command and clean the result.
COMMAND=$(echo "$RESULT" | jq -r '.choices[0].text' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^<code>//' -e 's/<\/code>$//' | grep -v '^$')

# Keep date, description, and command in a ~/.dtc_history.md file with Markdown structure.
printf "## %s\n### Description\n%s\n### Command\n%s\n" "$(date)" "${DESCRIPTION}" "${COMMAND}" >> ~/.dtc_history.md

# Print the command.
echo "$COMMAND"