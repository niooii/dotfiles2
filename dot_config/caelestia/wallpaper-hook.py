"""caelestia wallpaper postHook (see cli.json) that prefers dark mode.

caelestia's smart mode picks light mode when the wallpaper's average tone is above 60, hardcoded in
caelestia/utils/wallpaper.py. This raises that cutoff to LIGHT_TONE: if smart mode picked light but the tone
is at most LIGHT_TONE, switch to dark and fix caelestia's per-wallpaper cache so the wallpaper (and its
preview in the picker) is dark straight away next time.

Run it with wallpaper paths as arguments to fill the cache for those wallpapers ahead of time instead.
"""

import json
import os
import subprocess
import sys
from pathlib import Path

from materialyoucolor.hct import Hct
from materialyoucolor.utils.color_utils import argb_from_rgb
from PIL import Image

from caelestia.utils.colourfulness import get_variant
from caelestia.utils.paths import compute_hash, wallpapers_cache_dir
from caelestia.utils.wallpaper import convert_gif, get_thumb

LIGHT_TONE = 80  # Light mode only above this average tone (0-100). caelestia's default is 60.


def smart_scheme_enabled() -> bool:
    try:
        shell = json.loads((Path.home() / ".config/caelestia/shell.json").read_text())
    except (OSError, json.JSONDecodeError):
        return True
    return shell.get("services", {}).get("smartScheme", True)


def write_smart_opts(cache: Path, thumb: Path) -> str:
    # Same steps as caelestia's get_smart_opts(), apart from the cutoff
    with Image.open(thumb) as img:
        variant = get_variant(img)
        img.thumbnail((1, 1), Image.Resampling.LANCZOS)
        pixel = img.getpixel((0, 0))

    mode = "light" if Hct.from_int(argb_from_rgb(*pixel[:3])).tone > LIGHT_TONE else "dark"
    (cache / "smart.json").write_text(json.dumps({"variant": variant, "mode": mode}))
    return mode


def hook() -> None:
    if os.environ.get("SCHEME_NAME") != "dynamic" or os.environ.get("SCHEME_MODE") != "light":
        return
    if not smart_scheme_enabled():
        return

    thumb = Path(os.environ["THUMBNAIL_PATH"])
    if write_smart_opts(thumb.parent, thumb) == "dark":
        subprocess.run(["caelestia", "scheme", "set", "-m", "dark"])


def fill_cache(walls: list[str]) -> None:
    for wall in map(Path, walls):
        # Match the cache dir set_wallpaper() uses (GIFs are keyed by their first frame)
        src = convert_gif(wall) if wall.suffix.lower() == ".gif" else wall
        cache = wallpapers_cache_dir / compute_hash(src)
        print(f"{wall.name}: {write_smart_opts(cache, get_thumb(src, cache))}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        fill_cache(sys.argv[1:])
    else:
        hook()
