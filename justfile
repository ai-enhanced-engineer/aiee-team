# AIEE Team Plugin

default:
    @just --list

# Run setup script
setup:
    ./scripts/setup.sh

# Validate plugin structure
validate:
    @test -f .claude-plugin/plugin.json && echo "✓ plugin.json" || echo "✗ plugin.json missing"
    @find . -name "*.json" -exec sh -c 'python3 -m json.tool {} > /dev/null 2>&1 && echo "✓ {}" || echo "✗ {} (invalid)"' \;

# List agents
agents:
    @ls -1 agents/*.md 2>/dev/null | xargs -I {} basename {} .md | sort

# List skills
skills:
    @ls -1d skills/*/ 2>/dev/null | xargs -I {} basename {} | sort

# Show version
version:
    @python3 -c "import json; print(json.load(open('.claude-plugin/plugin.json')).get('version', 'unknown'))"
