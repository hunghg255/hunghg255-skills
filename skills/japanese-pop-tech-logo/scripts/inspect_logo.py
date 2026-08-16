#!/usr/bin/env python3
"""Report technical properties useful for validating a raster logo."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image


def rgb_hex(rgb: tuple[int, int, int]) -> str:
    return "#" + "".join(f"{value:02X}" for value in rgb)


def inspect(path: Path, color_count: int) -> dict[str, object]:
    with Image.open(path) as image:
        rgba = image.convert("RGBA")
        width, height = rgba.size
        alpha = rgba.getchannel("A")
        alpha_extrema = alpha.getextrema()
        total = width * height
        alpha_histogram = alpha.histogram()
        transparent = sum(count for value, count in enumerate(alpha_histogram) if value < 8)
        partial = sum(count for value, count in enumerate(alpha_histogram) if 8 <= value < 248)
        bbox = alpha.getbbox()

        if bbox:
            occupied_width = bbox[2] - bbox[0]
            occupied_height = bbox[3] - bbox[1]
            occupied_fraction = (occupied_width * occupied_height) / total
        else:
            occupied_fraction = 0.0

        thumbnail = rgba.convert("RGB")
        thumbnail.thumbnail((256, 256))
        quantized = thumbnail.quantize(colors=color_count, method=Image.Quantize.MEDIANCUT)
        palette = quantized.getpalette()
        dominant = []
        for count, index in sorted(quantized.getcolors() or [], reverse=True)[:color_count]:
            offset = index * 3
            rgb = tuple(palette[offset : offset + 3])
            dominant.append({"hex": rgb_hex(rgb), "fraction": round(count / (thumbnail.width * thumbnail.height), 4)})

        return {
            "path": str(path),
            "format": image.format,
            "mode": image.mode,
            "width": width,
            "height": height,
            "aspect_ratio": round(width / height, 4) if height else None,
            "has_alpha": "A" in image.getbands(),
            "alpha_extrema": alpha_extrema,
            "transparent_fraction": round(transparent / total, 4),
            "partially_transparent_fraction": round(partial / total, 4),
            "content_bbox": bbox,
            "bbox_occupied_fraction": round(occupied_fraction, 4),
            "transparent_corners": sum(alpha.getpixel(point) < 8 for point in ((0, 0), (width - 1, 0), (0, height - 1), (width - 1, height - 1))),
            "dominant_colors": dominant,
        }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("images", nargs="+", type=Path)
    parser.add_argument("--colors", type=int, default=6, help="Dominant colors to report (default: 6)")
    args = parser.parse_args()

    results = []
    for path in args.images:
        if not path.is_file():
            parser.error(f"file not found: {path}")
        results.append(inspect(path, max(1, min(args.colors, 16))))

    print(json.dumps(results[0] if len(results) == 1 else results, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
