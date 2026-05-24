from PIL import Image, ImageDraw, ImageFont
import os, math

COLORS = {
    'bg': (28, 92, 53),       # green #1C5C35
    'text': (245, 161, 0),    # amber/yellow #F5A100
}

SIZES = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
}

def create_icon(size, out_path):
    img = Image.new('RGBA', (size, size), COLORS['bg'])
    draw = ImageDraw.Draw(img)

    font_size = int(size * 0.35)
    for attempt in range(10):
        try:
            font = ImageFont.truetype("C:\\Windows\\Fonts\\arialbd.ttf", font_size)
        except:
            try:
                font = ImageFont.truetype("C:\\Windows\\Fonts\\arial.ttf", font_size)
            except:
                font = ImageFont.load_default()
        bbox = draw.textbbox((0, 0), "freshgo", font=font)
        tw = bbox[2] - bbox[0]
        if tw < size * 0.85:
            break
        font_size -= 1

    text = "freshgo"
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (size - tw) / 2 - bbox[0]
    y = (size - th) / 2 - bbox[1]
    draw.text((x, y), text, font=font, fill=COLORS['text'])

    img.save(out_path, 'PNG')
    print(f"  Created {out_path} ({size}x{size})")

base = os.path.join(os.path.dirname(__file__), '..', 'android', 'app', 'src', 'main', 'res')

for density, size in SIZES.items():
    res_dir = os.path.join(base, f'mipmap-{density}')
    if not os.path.exists(res_dir):
        os.makedirs(res_dir)
    create_icon(size, os.path.join(res_dir, 'ic_launcher.png'))
    create_icon(size, os.path.join(res_dir, 'ic_launcher_foreground.png'))

# Also generate for play store (512x512)
out_dir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'icons')
if not os.path.exists(out_dir):
    os.makedirs(out_dir)
create_icon(512, os.path.join(out_dir, 'app_icon.png'))

print("\nDone! All icons generated.")
