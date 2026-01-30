#!/usr/bin/env bash
set -e

# Usage: ./git_commands.sh [remote_url]
# If remote_url provided, will add origin and push to main

# Initialize git if needed
if [ -d .git ]; then
  echo ".git exists"
else
  git init
fi

git add .
# Create commit only if there are staged changes
if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  git commit -m "Prepare project for GitHub"
fi

if [ -n "$1" ]; then
  git remote remove origin 2>/dev/null || true
  git remote add origin "$1"
  git branch -M main || true
  git push -u origin main
else
  echo "No remote URL provided. To push, run: ./git_commands.sh git@github.com:USERNAME/REPO.git"
fi
