"""Choose an available iPhone simulator from `simctl list devices available -j`."""
import json
import sys


def select(data):
    candidates = [
        device
        for runtime, devices in sorted(data.get("devices", {}).items(), reverse=True)
        if "iOS" in runtime
        for device in devices
        if device.get("isAvailable") and device.get("name", "").startswith("iPhone")
    ]
    if not candidates:
        raise ValueError("No available iPhone simulator found")
    return candidates[0]["udid"]


if __name__ == "__main__":
    try:
        print(select(json.load(sys.stdin)))
    except (ValueError, KeyError, json.JSONDecodeError) as error:
        print(f"Simulator selection failed: {error}", file=sys.stderr)
        sys.exit(1)
