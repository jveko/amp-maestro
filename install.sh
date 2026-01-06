#!/bin/bash

set -e

# Configuration: Update these if forking/modifying
GITHUB_USER="lleewwiiss"
GITHUB_REPO="amp-maestro"
BRANCH="main"

echo "🚀 Installing Amp Maestro..."

# 1. Install Dependencies
if ! command -v mise &> /dev/null; then
    echo "❌ mise not found. Please install it: https://mise.jdx.dev"
    exit 1
fi

echo "📦 Installing dependencies via mise..."

# Install bd (beads) via go
if ! command -v bd &> /dev/null; then
    echo "📦 Installing Beads (bd)..."
    mise use -g go:github.com/beads-dev/beads/cmd/bd@latest
else
    echo "✅ Beads (bd) already installed."
fi

# Install wtp (worktree plus) via Homebrew
if ! command -v wtp &> /dev/null; then
    echo "📦 Installing wtp (worktree plus)..."
    if command -v brew &> /dev/null; then
        brew install satococoa/tap/wtp
    else
        echo "❌ Homebrew not found. Please install wtp manually: https://github.com/satococoa/wtp"
        exit 1
    fi
else
    echo "✅ wtp already installed."
fi

# 2. Setup Directories
mkdir -p .agents/commands
mkdir -p .beads/artifacts
mkdir -p .beads/kb

# 3. Initialize wtp for project-scoped worktree management
echo "🌳 Initializing wtp (worktree plus)..."
if [ ! -f ".wtp.yml" ]; then
    wtp init
    echo "   Created .wtp.yml - customize base_dir and hooks as needed."
else
    echo "✅ .wtp.yml already exists."
fi

# 4. Copy Slash Commands
echo "📂 Installing Slash Commands..."

BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}/templates/.agents/commands"
FILES="bd-create.md bd-next.md bead-notes.md wtp-from-bead.md context.md implement.md land-plane.md plan.md research.md review.md spec.md split.md kb-build.md"

for file in $FILES; do
    # If we are running locally (cloned repo), copy from templates
    if [ -d "./templates/.agents/commands" ]; then
        cp "./templates/.agents/commands/$file" ".agents/commands/"
    else
        # Fetch from remote
        # Check if YOUR_USERNAME is still set
        if [ "$GITHUB_USER" == "YOUR_USERNAME" ]; then
             echo "❌ Error: You are trying to install from remote, but GITHUB_USER is still 'YOUR_USERNAME'."
             echo "   Please edit install.sh to set your GitHub username or clone the repo locally."
             exit 1
        fi
        curl -sSL "$BASE_URL/$file" -o ".agents/commands/$file"
    fi
done

# 5. Install Protocol Docs
echo "📜 Installing Workflows..."
if [ -d "./templates" ]; then
    cp "./templates/AGENTIC_WORKFLOW.md" "./AGENTIC_WORKFLOW.md"
else
    if [ "$GITHUB_USER" != "YOUR_USERNAME" ]; then
        curl -sSL "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}/templates/AGENTIC_WORKFLOW.md" -o "AGENTIC_WORKFLOW.md"
    fi
fi

# 6. Update AGENTS.md
echo "🤖 Checking AGENTS.md..."

# Function to get template content (either from local file or curl)
get_template_agents() {
    if [ -d "./templates" ]; then
        cat "./templates/AGENTS.md"
    else
         curl -sSL "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}/templates/AGENTS.md"
    fi
}

if [ ! -f "AGENTS.md" ]; then
    echo "   Creating new AGENTS.md from template..."
    get_template_agents > "AGENTS.md"
else
    echo "   AGENTS.md exists. Checking for updates..."
fi

# Append Workflow if missing
if ! grep -q "Agentic Workflow" "AGENTS.md"; then
        echo "   Appending Agentic Workflow to existing AGENTS.md..."
        cat >> "AGENTS.md" <<EOL

## Agentic Workflow
See [AGENTIC_WORKFLOW.md](./AGENTIC_WORKFLOW.md) for the full protocol.

**Quick Protocol:**
1. **Start**: \`/context <id>\`
2. **Research**: \`/research <id>\`
3. **Plan**: \`/plan <id>\` (Uses Oracle)
4. **Work**: \`/implement <id>\` (Uses Subagents)
5. **Review**: \`/review <id>\`
6. **Finish**: \`/land-plane\`

**Optional helpers:**
- \`/kb-build\` to refresh shared knowledge before research.
- \`/spec\` to formalize requirements on larger beads.
- \`/split\` when a plan reveals multiple independent child beads.
- \`/bead-notes\` to capture session summaries back into Beads.

**Source of Truth**: \`bd\` issues for **WHAT**, \`.beads/artifacts/\` for **HOW**.

### Rules
- **NEVER** put long plans in Bead descriptions.
- **ALWAYS** use slash commands to manage lifecycle.
- **ALWAYS** run \`bd sync\` before ending.
EOL
fi

echo "✅ Installation Complete!"
echo "👉 Run 'amp' and type '/bd-create' to get started."
