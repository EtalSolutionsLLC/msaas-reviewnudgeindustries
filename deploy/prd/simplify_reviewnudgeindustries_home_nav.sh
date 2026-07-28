#!/usr/bin/env bash
set -euo pipefail

cd "${1:-.}"

if [ ! -d www ]; then
  echo "ERROR: run this from the ReviewNudge Industries repo root, or pass the repo path as the first argument." >&2
  exit 1
fi

python3 <<'PY'
from pathlib import Path
import html
import re

SITE = 'https://reviewnudgeindustries.etal.solutions'
APP = 'https://reviewnudge.etal.solutions'
SETUP = 'https://reviewnudge.etal.solutions/setup'

industries = {
    'plumbers': ('Plumbers', 'Review workflows for plumbing repairs, drain cleaning, water heaters, and urgent service calls.'),
    'hvac': ('HVAC Companies', 'Review timing for AC repair, furnace repair, tune-ups, installations, and maintenance visits.'),
    'electricians': ('Electricians', 'Review guidance for electrical repairs, lighting, panels, troubleshooting, and installations.'),
    'landscapers': ('Landscapers', 'Review ideas for lawn care, cleanups, landscape refreshes, and recurring outdoor service.'),
    'handymen': ('Handyman Businesses', 'Simple review workflows for punch lists, small repairs, installs, and local maintenance work.'),
    'house-cleaning': ('House Cleaning Services', 'Review workflows for recurring cleaning, deep cleaning, move-out cleaning, and turnovers.'),
    'pressure-washing': ('Pressure Washing', 'Review guidance for driveways, patios, siding, decks, and visible before-and-after work.'),
    'roofing': ('Roofing Companies', 'Review workflows for roof repairs, leak fixes, inspections, replacements, and storm damage work.'),
    'painting': ('Painting Contractors', 'Review ideas for interior painting, exterior painting, cabinet painting, and refresh projects.'),
    'pool-service': ('Pool Service Companies', 'Review follow-up for cleaning, weekly service, equipment repair, and clear-water improvements.'),
}

resources = [
    ('review-request-email-templates', 'Review Request Email Templates'),
    ('review-request-sms-templates', 'Review Request SMS Templates'),
    ('how-to-ask-for-google-reviews', 'How To Ask for Google Reviews'),
    ('best-time-to-ask-for-a-review', 'Best Time To Ask for a Review'),
]

NAV = f'''<div class="nav-links">
      <a href="{APP}">About ReviewNudge</a>
      <a class="btn btn-primary" href="{SETUP}">Try ReviewNudge</a>
    </div>'''

HEADER = f'''<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    {NAV}
  </nav>
</header>'''

FOOTER = f'''<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="{APP}">About ReviewNudge</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>'''

def card_grid():
    return '\n'.join(f'''      <article class="guide-card">
        <a class="guide-card-link" href="/industries/{slug}/">
          <h3>{html.escape(title)}</h3>
          <p>{html.escape(desc)}</p>
          <span>Open guide -></span>
        </a>
      </article>''' for slug, (title, desc) in industries.items())

def page(title, desc, canonical, body, schema=''):
    return f'''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{html.escape(title)}</title>
  <meta name="description" content="{html.escape(desc)}">
  <link rel="canonical" href="{html.escape(canonical)}">
  <link rel="stylesheet" href="/styles.css">
{schema}</head>
<body>
{HEADER}
<main id="main">
{body}
</main>
{FOOTER}
</body>
</html>
'''

home_schema = '''  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"CollectionPage",
    "name":"ReviewNudge Industries",
    "url":"https://reviewnudgeindustries.etal.solutions/",
    "description":"Industry-specific review management guides for local service businesses."
  }
  </script>
'''

home_body = f'''  <section class="directory-hero home-hub-hero">
    <div>
      <div class="eyebrow">Industry review guides</div>
      <h1>Review management guides for local service businesses</h1>
      <p class="lead compact-lead">Choose an industry to find practical review-request timing, customer follow-up ideas, and sample wording tailored to the way that service business actually works.</p>
    </div>
  </section>

  <section class="directory-section home-hub-section" aria-labelledby="industry-guides-title">
    <h2 id="industry-guides-title" class="visually-hidden">Industry guides</h2>
    <div class="guide-grid compact-guide-grid">
{card_grid()}
    </div>
  </section>'''

Path('www/index.html').write_text(page(
    'ReviewNudge Industries | Review Management Guides for Local Service Businesses',
    'Choose an industry for practical review management guidance tailored to plumbers, HVAC companies, electricians, landscapers, cleaners, roofers, painters, pool service companies, and more.',
    SITE + '/',
    home_body,
    home_schema
), encoding='utf-8')

Path('www/industries').mkdir(parents=True, exist_ok=True)
industries_body = '''  <section class="directory-hero home-hub-hero">
    <div>
      <div class="eyebrow">Industry guide directory</div>
      <h1>Industry guides have moved to the home page</h1>
      <p class="lead compact-lead">The ReviewNudge Industries home page is now the main hub for all industry guides.</p>
      <p><a class="btn btn-primary" href="/">Browse industry guides</a></p>
    </div>
  </section>'''
Path('www/industries/index.html').write_text(page(
    'Industry Guides | ReviewNudge Industries',
    'The ReviewNudge Industries home page is the main hub for industry-specific review management guides.',
    SITE + '/industries/',
    industries_body
), encoding='utf-8')

for path in Path('www').rglob('*.html'):
    text = path.read_text(encoding='utf-8', errors='ignore')
    text = re.sub(r'<div class="nav-links">.*?</div>', NAV, text, count=1, flags=re.S)
    text = text.replace('href="https://reviewnudge.etal.solutions/billing"', f'href="{SETUP}"')
    text = text.replace('href="https://reviewnudge.etal.solutions/"', f'href="{APP}"')
    path.write_text(text, encoding='utf-8')

css_path = Path('www/styles.css')
css = css_path.read_text(encoding='utf-8', errors='ignore') if css_path.exists() else ''
start = '/* RN Industries simplified home/nav start */'
end = '/* RN Industries simplified home/nav end */'
block = f'''{start}
.home-hub-hero {{
  padding-top: 34px;
  padding-bottom: 12px;
  grid-template-columns: 1fr;
}}
.home-hub-hero h1 {{
  max-width: 920px;
}}
.home-hub-section {{
  padding-top: 12px;
}}
.visually-hidden {{
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}}
.nav-links {{
  gap: 16px;
}}
.guide-card {{
  min-height: 168px;
}}
.guide-card-link {{
  min-height: 168px;
  padding: 16px;
}}
.guide-card h3 {{
  font-size: 19px;
}}
.guide-card p {{
  font-size: 14px;
  line-height: 1.36;
}}
{end}
'''
if start in css and end in css:
    css = re.sub(re.escape(start) + r'.*?' + re.escape(end), block, css, flags=re.S)
else:
    css = css.rstrip() + '\n\n' + block
css_path.write_text(css, encoding='utf-8')

urls = [SITE + '/', SITE + '/industries/']
urls += [SITE + f'/industries/{slug}/' for slug in industries]
urls += [SITE + f'/resources/{slug}/' for slug, _ in resources]
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for url in urls:
    sitemap += ['  <url>', f'    <loc>{url}</loc>', '  </url>']
sitemap.append('</urlset>')
Path('www/sitemap.xml').write_text('\n'.join(sitemap) + '\n', encoding='utf-8')
Path('www/robots.txt').write_text('User-agent: *\nAllow: /\n\nSitemap: https://reviewnudgeindustries.etal.solutions/sitemap.xml\n', encoding='utf-8')
PY

echo "Simplified homepage/nav: homepage is now the hub, nav only has About ReviewNudge and Try ReviewNudge, and Try points to /setup."
