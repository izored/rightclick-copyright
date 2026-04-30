# izored Copyright Tool

Embed EXIF/IPTC/XMP copyright metadata into images via right-click or PowerShell.

---

## Prerequisites — exiftool (required)

Both scripts call `exiftool` bare. It must be on your system PATH or nothing runs.

1. Download **Windows Executable** from https://exiftool.org/
2. Rename `exiftool(-k).exe` → `exiftool.exe`
3. Move to `C:\Windows\` (already in PATH) or any folder that is in your `$env:PATH`
4. Verify install:
   ```
   exiftool -ver
   ```
   Should print a version number like `12.xx`.

---

## Setup

1. Clone the repo
2. Copy `.env.example` to `.env` **one folder above** the repo root:
   ```
   Scripts\
   ├── .env          ← your config lives here
   └── copyright\    ← repo root
       ├── apply-copyright.ps1
       ├── monitor-copyright.ps1
       └── install.ps1
   ```
3. Edit `.env` with your name, copyright string, website, etc.
4. Run `install.ps1` once to add the right-click context menu:
   ```powershell
   .\install.ps1
   ```

---

## Usage

### Right-click a folder
After running `install.ps1`, right-click any folder → **Apply Copyright**.

### Command line
```powershell
.\apply-copyright.ps1 "C:\path\to\images"
```
Processes all supported images recursively. Prints a summary when done.

### Auto-monitor (watch folder)
```powershell
.\monitor-copyright.ps1
```
Watches `WATCH_FOLDER` from `.env`. Tags new images automatically as they land. Press `Ctrl+C` to stop.

---

## Supported Formats

| Category | Extensions |
|----------|-----------|
| JPEG | `.jpg` `.jpeg` |
| PNG | `.png` |
| TIFF | `.tif` `.tiff` |
| Web | `.webp` `.avif` |
| Apple | `.heic` `.heif` |
| Other | `.gif` `.bmp` `.psd` |
| RAW — Canon | `.cr2` `.cr3` |
| RAW — Nikon | `.nef` |
| RAW — Sony | `.arw` |
| RAW — Adobe | `.dng` |
| RAW — Panasonic | `.rw2` |
| RAW — Olympus | `.orf` |
| RAW — Fujifilm | `.raf` |
| RAW — Pentax | `.pef` |
| RAW — Samsung | `.srw` |

> exiftool write support varies by format. JPEG/PNG/TIFF/PSD have full EXIF+IPTC+XMP support. RAW formats typically support XMP sidecar or limited embedded tags.

---

## Configuration (`.env`)

| Key | Used in | Purpose |
|-----|---------|---------|
| `ARTIST_NAME` | both scripts | EXIF Artist field |
| `CREATOR_CREDIT` | both scripts | EXIF Creator field |
| `COPYRIGHT_TEXT` | both scripts | EXIF Copyright + Rights |
| `WEBSITE` | apply only | EXIF URL + Source |
| `IMAGE_DEFAULT_TITLE` | apply only | EXIF Title |
| `IMAGE_DEFAULT_DESCRIPTION` | apply only | EXIF Description + Caption |
| `IMAGE_DEFAULT_KEYWORDS` | apply only | EXIF Keywords |
| `WATCH_FOLDER` | monitor only | Folder path to watch |

See `.env.example` for the full template.
