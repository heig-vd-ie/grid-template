#!/usr/bin/env bash
# One-time bootstrap for a repository created from psrl-template.
# Personalises the project, resets the changelog, then deletes itself and its
# workflow so it never runs again. Driven by .github/workflows/template-bootstrap.yml.
set -euo pipefail

PROJECT_NAME="${PROJECT_NAME:?PROJECT_NAME is required}"   # new repository name
AUTHOR="${AUTHOR:?AUTHOR is required}"                     # creator's GitHub login
EMAIL="${EMAIL:-${AUTHOR}@users.noreply.github.com}"
TODAY="$(date +%Y-%m-%d)"

# README: remove the template badge, set the title and author, strip the template
# markers, and drop the "How to Run" (Use this template) section, now irrelevant.
sed -i '/<!-- template-badge:start -->/,/<!-- template-badge:end -->/d' README.md
sed -i \
  -e "1s|^# .*|# ${PROJECT_NAME}|" \
  -e "s|^Author:.*|Author: ${AUTHOR}|" \
  -e "s| (Replace this section)||g" \
  -e "s| (Replace the name)||g" \
  README.md
sed -i "/^## How to Run/,/^---$/d" README.md

# pyproject.toml: package name and author.
sed -i \
  -e "s|^name = \".*\"|name = \"${PROJECT_NAME}\"|" \
  -e "s|^authors = .*|authors = [{name = \"${AUTHOR}\", email = \"${EMAIL}\"}]|" \
  pyproject.toml

# Makefile: project name placeholder.
sed -i "s|{{PROJECT_NAME}}|${PROJECT_NAME}|g" Makefile

# CHANGELOG.md: a fresh initial entry.
cat > CHANGELOG.md <<EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.0] - ${TODAY}

### Added

- Initial project generated from the psrl-template.
EOF

# Remove the template-only reference docs (group best practices) and its README link.
# The per-OS install guides under docs/install/ are kept, they apply to every project.
rm -rf docs/best-practices
sed -i '/docs\/best-practices\//d' README.md

# Remove the bootstrap itself so it runs only once.
rm -f .github/workflows/template-bootstrap.yml scripts/template-bootstrap.sh

echo "Bootstrapped '${PROJECT_NAME}' by ${AUTHOR}."
