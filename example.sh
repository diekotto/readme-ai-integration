#!/bin/bash
set -a
source .env
set +a

readmeai \
    --repository "${REPO_PATH}" \
    --output "${OUTPUT_FILE}" \
    --api "${LLM_API}" \
    --model "${LLM_MODEL}" \
    --align "${ALIGN}" \
    --badge-color "${BADGE_COLOR}" \
    --badge-style "${BADGE_STYLE}" \
    --header-style "${HEADER_STYLE}" \
    --toc-style "${TOC_STYLE}" \
    --temperature "${TEMPERATURE}" \
    --tree-depth "${TREE_DEPTH}" \
    --image "${LOGO_IMAGE}" \
    --emojis
