#!/usr/bin/env python3
"""Exercise the override's transcript builder without importing Hermes."""

import ast
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List


source_path = (
    Path(__file__).resolve().parents[1]
    / "overrides/hermes/plugins/memory/hindsight/__init__.py"
)
tree = ast.parse(source_path.read_text(encoding="utf-8"))

method = None
for node in tree.body:
    if isinstance(node, ast.ClassDef) and node.name == "HindsightMemoryProvider":
        method = next(
            (
                item
                for item in node.body
                if isinstance(item, ast.FunctionDef)
                and item.name == "_build_turn_messages"
            ),
            None,
        )
        break

if method is None:
    raise RuntimeError("_build_turn_messages not found")

namespace = {
    "datetime": datetime,
    "timezone": timezone,
    "Dict": Dict,
    "List": List,
}
exec(compile(ast.Module(body=[method], type_ignores=[]), str(source_path), "exec"), namespace)
build_turn_messages = namespace["_build_turn_messages"]


class Provider:
    _retain_user_prefix = "User"
    _retain_assistant_prefix = "Assistant"
    _retain_assistant_content = False


provider = Provider()
messages = build_turn_messages(provider, "I prefer concise answers.", "You use PyTorch.")
assert [message["role"] for message in messages] == ["user"]
assert "PyTorch" not in str(messages)

provider._retain_assistant_content = True
messages = build_turn_messages(provider, "Hello", "Hello back")
assert [message["role"] for message in messages] == ["user", "assistant"]

print("Hindsight retention isolation passed")
