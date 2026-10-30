"""Choose available iPhone simulators for standard and larger layout checks."""
import json
import sys


def select(data, large=False):
    candidates = [
        device
        for runtime, devices in sorted(data.get("devices", {}).items(), reverse=True)
        if "iOS" in runtime
        for device in devices
        if device.get("isAvailable") and device.get("name", "").startswith("iPhone")
    ]
    preferred = [device for device in candidates if ("Max" in device["name"] or "Plus" in device["name"]) == large]
    if not preferred:
        raise ValueError("No available " + ("large" if large else "standard") + " iPhone simulator found")
    return preferred[0]["udid"]


if __name__ == "__main__":
    try:
        print(select(json.load(sys.stdin), large="--large" in sys.argv[1:]))
    except (ValueError, KeyError, json.JSONDecodeError) as error:
        print(f"Simulator selection failed: {error}", file=sys.stderr)
        sys.exit(1)
