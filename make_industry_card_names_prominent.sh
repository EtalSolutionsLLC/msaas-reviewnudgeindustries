#!/usr/bin/env bash
set -euo pipefail

cd "${1:-.}"

if [ ! -d www ]; then
  echo "ERROR: run this from the ReviewNudge Industries repo root, or pass the repo path as the first argument." >&2
  exit 1
fi

python3 <<'PY'
from pathlib import Path
import re

cards = [
    ("plumbers", "PLUMBERS", "The Relief Moment", "Emergency calls, leak repairs, water heaters, and customer relief."),
    ("hvac", "HVAC", "Comfort Restored", "AC repair, furnace repair, tune-ups, installations, and maintenance follow-up."),
    ("electricians", "ELECTRICIANS", "Trust More Than Wiring", "Safety, confidence, panel upgrades, troubleshooting, lighting, and EV chargers."),
    ("landscapers", "LANDSCAPERS", "The Before-and-After Advantage", "Curb appeal, seasonal cleanups, recurring lawn care, and visible transformation."),
    ("handymen", "HANDYMAN BUSINESSES", "Small Jobs, Big Loyalty", "Punch lists, small repairs, convenience jobs, repeat customers, and local trust."),
    ("house-cleaning", "HOUSE CLEANING", "Trust Inside the Home", "Recurring cleans, deep cleans, move-out work, turnovers, and trust-based follow-up."),
    ("pressure-washing", "PRESSURE WASHING", "The Most Photogenic Reviews", "Driveways, siding, decks, commercial exteriors, and visible before-and-after work."),
    ("roofing", "ROOFING", "High Stakes, High Trust", "Replacements, inspections, storm damage, insurance work, cleanup, and walkthroughs."),
    ("painting", "PAINTING", "The Emotional Side of Painting", "Interior painting, exterior refreshes, cabinet transformations, color anxiety, and walkthroughs."),
    ("pool-service", "POOL SERVICE", "The Reliability Business", "Weekly service, green pool recovery, equipment repairs, clear water, and route trust."),
]

def card_html():
    blocks = []
    for slug, label, title, desc in cards:
        blocks.append("      <article class=\"guide-card industry-guide-card industry-" + slug + "-card\">\n"
                      "        <a class=\"guide-card-link\" href=\"/industries/" + slug + "/\">\n"
                      "          <span class=\"industry-tag\">" + label + "</span>\n"
                      "          <h3>" + title + "</h3>\n"
                      "          <p>" + desc + "</p>\n"
                      "          <span class=\"card-action\">Open guide -&gt;</span>\n"
                      "        </a>\n"
                      "      </article>")
    return "\n".join(blocks)

pattern = r'(<div class="guide-grid compact-guide-grid">)(.*?)(\n\s*</div>)'
new_cards = card_html()

for page in [Path("www/index.html"), Path("www/industries/index.html")]:
    if not page.exists():
        continue
    text = page.read_text(encoding="utf-8", errors="ignore")
    new_text, count = re.subn(pattern, r'\1\n' + new_cards + r'\3', text, count=1, flags=re.S)
    if count:
        page.write_text(new_text, encoding="utf-8")

css_path = Path("www/styles.css")
css = css_path.read_text(encoding="utf-8", errors="ignore") if css_path.exists() else ""
start = "/* RN prominent industry card labels start */"
end = "/* RN prominent industry card labels end */"
block = """/* RN prominent industry card labels start */
.industry-guide-card .guide-card-link { gap: 6px; }
.industry-tag {
  display: block;
  font-size: 0.82rem;
  line-height: 1;
  font-weight: 950;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--blue);
  margin-bottom: 6px;
}
.industry-guide-card h3 { margin-top: 0; margin-bottom: 8px; }
.industry-guide-card .card-action {
  color: var(--blue);
  font-weight: 900;
  margin-top: auto;
  padding-top: 12px;
}
.industry-plumbers-card .industry-tag { color: #0c63b7; }
.industry-hvac-card .industry-tag { color: #0a6cbf; }
.industry-electricians-card .industry-tag { color: #6d49d1; }
.industry-landscapers-card .industry-tag { color: #1f8a70; }
.industry-handymen-card .industry-tag { color: #a76522; }
.industry-house-cleaning-card .industry-tag { color: #287c99; }
.industry-pressure-washing-card .industry-tag { color: #087fbf; }
.industry-roofing-card .industry-tag { color: #555f6f; }
.industry-painting-card .industry-tag { color: #9b3bb5; }
.industry-pool-service-card .industry-tag { color: #087f8f; }
/* RN prominent industry card labels end */"""
if start in css and end in css:
    css = re.sub(re.escape(start) + r'.*?' + re.escape(end), block, css, flags=re.S)
else:
    css = css.rstrip() + "\n\n" + block + "\n"
css_path.write_text(css, encoding="utf-8")

print("Updated industry cards so industry names are prominent.")
PY
