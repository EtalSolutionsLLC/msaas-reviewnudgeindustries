#!/usr/bin/env bash
set -euo pipefail

cd "${1:-.}"

if [ ! -d www ]; then
  echo "ERROR: run this from the ReviewNudge Industries repo root, or pass the repo path as the first argument." >&2
  exit 1
fi

python3 <<'PY'

from pathlib import Path
import json, html, re
SITE = 'https://reviewnudgeindustries.etal.solutions'
APP = 'https://reviewnudge.etal.solutions'
SETUP = 'https://reviewnudge.etal.solutions/setup'
resources = json.loads("{\"how-many-reviews-does-a-local-business-need\": {\"title\": \"How Many Reviews Does a Local Business Need?\", \"meta\": \"A practical guide to how many reviews local service businesses need before reviews start helping with trust, clicks, and customer confidence.\", \"eyebrow\": \"Review count strategy\", \"lede\": \"There is no magic review count that makes a local business trusted overnight. A better goal is to build enough recent, specific reviews that a stranger can understand what kind of service experience to expect.\", \"sample\": \"If everything went well, would you mind leaving a quick review about your experience? It helps future customers understand what to expect from our local team.\", \"sections\": [[\"A useful review count depends on the buying decision\", \"A customer choosing a roofer, plumber, HVAC company, or cleaner is not only counting stars. The customer is looking for proof that the business has helped people in similar situations.\"], [\"Recent reviews matter more than old volume\", \"Recent reviews show that the business is active and consistent now. ReviewNudge should help the business avoid long quiet gaps by making review follow-up part of the service rhythm.\"], [\"Different industries need different signals\", \"Emergency trades benefit from reviews that mention response and clarity. Recurring services benefit from reviews that mention consistency. High-ticket services benefit from reviews that mention communication, cleanup, and trust.\"], [\"A practical operating target\", \"Instead of chasing a single number, aim for a steady stream: a few new reviews each month, spread across different job types, from customers who can describe real service moments.\"]]}, \"google-review-qr-codes\": {\"title\": \"Google Review QR Codes for Service Businesses\", \"meta\": \"How local service businesses can use Google review QR codes without making the review request feel awkward or impersonal.\", \"eyebrow\": \"QR code review strategy\", \"lede\": \"A QR code can make leaving a review easier, but it should not replace a thoughtful request. The QR code is the shortcut. The service experience is still the reason someone responds.\", \"sample\": \"Thanks again for choosing us. If the service was helpful, you can scan this code to leave a quick Google review. It helps other local customers find reliable help.\", \"sections\": [[\"Use QR codes at the right moment\", \"QR codes work best after the customer has seen the result and understands what was completed.\"], [\"Do not make the QR code the whole strategy\", \"A QR code sitting on a counter does not create a review habit. The business still needs a process for deciding who to ask and when to ask.\"], [\"Pair QR codes with service-specific wording\", \"A cleaning company, roofer, electrician, and pool service company should not use exactly the same request.\"], [\"Track the request, not just the link\", \"The operational problem is usually remembering who was asked, what was sent, and whether follow-up is still pending.\"]]}, \"how-to-respond-to-positive-reviews\": {\"title\": \"How To Respond to Positive Reviews\", \"meta\": \"A practical guide for local service businesses responding to positive Google reviews without sounding canned or robotic.\", \"eyebrow\": \"Positive review response guide\", \"lede\": \"A positive review is not the end of the customer interaction. A thoughtful response reinforces trust for the person who left the review and for the next customer reading it.\", \"sample\": \"Thank you for the kind review. We are glad the service visit went smoothly and appreciate you taking the time to share your experience with our local team.\", \"sections\": [[\"A good response sounds like a person\", \"Thank the customer directly, mention the type of work when appropriate, and keep the response short.\"], [\"Specific beats generic\", \"A reply that says \u201cThanks for trusting us with the water heater replacement\u201d is stronger than \u201cThanks for the review.\u201d\"], [\"Do not overdo the keywords\", \"Use plain language first. Keyword stuffing makes the business sound less trustworthy.\"], [\"Use positive reviews as operational feedback\", \"Positive reviews tell the business what customers notice: communication, cleanup, punctuality, transformation, reliability, or comfort restored.\"]]}, \"how-to-respond-to-negative-reviews\": {\"title\": \"How To Respond to Negative Reviews\", \"meta\": \"A calm, practical guide for local service businesses responding to negative reviews without escalating the situation.\", \"eyebrow\": \"Negative review response guide\", \"lede\": \"A negative review is public, but the response should not become a public argument. The best response is calm, brief, accountable where appropriate, and focused on moving the issue to a direct conversation.\", \"sample\": \"Thank you for sharing this. We are sorry the experience did not meet expectations. Please contact us directly so we can better understand what happened and look for a practical next step.\", \"sections\": [[\"Do not argue with the reviewer\", \"Future customers are watching the response as much as the complaint. A defensive response can make the business look harder to work with.\"], [\"Acknowledge without over-admitting\", \"It is possible to acknowledge concern without making detailed public admissions.\"], [\"Protect private details\", \"Avoid discussing customer details, invoices, addresses, disputes, or private service history in the public response.\"], [\"Use the pattern as a process signal\", \"Repeated themes may reveal a real workflow issue: arrival windows, cleanup, communication, quoting, or follow-up.\"]]}, \"review-request-follow-up-templates\": {\"title\": \"Review Request Follow-Up Templates\", \"meta\": \"Copy-ready follow-up examples for local service businesses that want to ask for reviews politely without chasing customers.\", \"eyebrow\": \"Follow-up template library\", \"lede\": \"The follow-up is where many businesses get awkward. A good reminder is short, optional, and respectful. One gentle nudge is usually enough.\", \"sample\": \"Just a quick follow-up from our team. If the service was helpful and you have a minute, your review would mean a lot: [Review Link]\", \"sections\": [[\"The one-reminder rule\", \"A follow-up should make the review easier to complete, not make the customer feel pursued.\"], [\"Tie the reminder to the job\", \"A reminder that references the completed service feels more human than a generic automation message.\"], [\"Use different language for different service types\", \"A roofer should not sound exactly like a cleaner. The best follow-up sounds like the business and the job.\"], [\"Keep the door open without pressure\", \"The customer should feel free to ignore the request. That makes the ask more respectful and protects the relationship.\"]]}}")
existing_resources = json.loads("{\"review-request-email-templates\": [\"Review Request Email Templates\", \"Copy-ready email examples for polite review requests after completed service work.\"], \"review-request-sms-templates\": [\"Review Request SMS Templates\", \"Short, respectful text-message examples for asking customers to leave a review.\"], \"how-to-ask-for-google-reviews\": [\"How To Ask for Google Reviews\", \"A practical guide to asking for Google reviews without sounding pushy.\"], \"best-time-to-ask-for-a-review\": [\"Best Time To Ask for a Review\", \"When service businesses should ask so the request feels natural and timely.\"]}")
industry_slugs = json.loads("[\"plumbers\", \"hvac\", \"electricians\", \"landscapers\", \"handymen\", \"house-cleaning\", \"pressure-washing\", \"roofing\", \"painting\", \"pool-service\"]")

def nav():
    return f'''<div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="{APP}">About ReviewNudge</a>
      <a class="btn btn-primary" href="{SETUP}">Try ReviewNudge</a>
    </div>'''

def header():
    return f'''<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    {nav()}
  </nav>
</header>'''

def footer():
    return f'''<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="{APP}">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>'''

def shell(title, meta, canonical, body, schema=''):
    return f'''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{html.escape(title)}</title>
  <meta name="description" content="{html.escape(meta)}">
  <link rel="canonical" href="{html.escape(canonical)}">
  <link rel="stylesheet" href="/styles.css">
{schema}</head>
<body>
{header()}
<main id="main">
{body}
</main>
{footer()}
</body>
</html>
'''

def resource_page(slug, data):
    sections = '\n'.join(f'''  <section class="resource-section">
    <h2>{html.escape(h)}</h2>
    <p>{html.escape(t)}</p>
  </section>''' for h, t in data['sections'])
    schema = f'''  <script type="application/ld+json">
  {{
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"{html.escape(data['title'])}",
    "description":"{html.escape(data['meta'])}",
    "url":"{SITE}/resources/{slug}/",
    "publisher":{{"@type":"Organization","name":"ReviewNudge Industries"}}
  }}
  </script>
'''
    body = f'''<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / {html.escape(data['title'])}</div>
    <div class="eyebrow">{html.escape(data['eyebrow'])}</div>
    <h1>{html.escape(data['title'])}</h1>
    <p class="lead">{html.escape(data['lede'])}</p>
  </section>
{sections}
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>{html.escape(data['sample'])}</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="{SETUP}">Try ReviewNudge</a>
    </div>
  </section>
</article>'''
    return shell(data['title'] + ' | ReviewNudge Industries', data['meta'], SITE + f'/resources/{slug}/', body, schema)

all_resources = dict(existing_resources)
for slug, data in resources.items():
    all_resources[slug] = [data['title'], data['meta']]

cards = '\n'.join(f'''      <article class="resource-list-card">
        <a href="/resources/{slug}/">
          <span class="resource-type">Resource</span>
          <h3>{html.escape(title)}</h3>
          <p>{html.escape(desc)}</p>
        </a>
      </article>''' for slug, (title, desc) in all_resources.items())

index_body = f'''  <section class="directory-hero resources-hub-hero">
    <div>
      <div class="eyebrow">Review management resources</div>
      <h1>Resources</h1>
      <p class="lead compact-lead">A directory of practical review-request guides, templates, response examples, and follow-up ideas for local service businesses.</p>
    </div>
  </section>
  <section class="directory-section resources-directory" aria-labelledby="resources-directory-title">
    <h2 id="resources-directory-title" class="visually-hidden">Resource directory</h2>
    <div class="resource-list-grid">
{cards}
    </div>
  </section>'''
index_schema = '''  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"CollectionPage",
    "name":"ReviewNudge Industries Resources",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/",
    "description":"A directory of review management resources for local service businesses."
  }
  </script>
'''
Path('www/resources').mkdir(parents=True, exist_ok=True)
Path('www/resources/index.html').write_text(shell('Resources | ReviewNudge Industries','A directory of review management resources, templates, response examples, and follow-up guides for local service businesses.', SITE + '/resources/', index_body, index_schema), encoding='utf-8')
for slug, data in resources.items():
    d = Path('www/resources') / slug
    d.mkdir(parents=True, exist_ok=True)
    (d / 'index.html').write_text(resource_page(slug, data), encoding='utf-8')

for path in Path('www').rglob('*.html'):
    text = path.read_text(encoding='utf-8', errors='ignore')
    text = re.sub(r'<div class="nav-links">.*?</div>', nav(), text, count=1, flags=re.S)
    text = text.replace('href="https://reviewnudge.etal.solutions/billing"', f'href="{SETUP}"')
    path.write_text(text, encoding='utf-8')

css_path = Path('www/styles.css')
css = css_path.read_text(encoding='utf-8', errors='ignore') if css_path.exists() else ''
start = '/* RN resource cluster start */'
end = '/* RN resource cluster end */'
block = '''/* RN resource cluster start */
.resource-page { max-width: 920px; margin: 0 auto; padding: 36px 20px 64px; }
.resource-hero h1 { font-size: clamp(40px, 6vw, 68px); line-height: .96; letter-spacing: -.06em; margin: 12px 0 18px; }
.resource-section { margin: 26px 0; padding: 24px; background: rgba(255,255,255,.78); border: 1px solid var(--line); border-radius: 22px; }
.resource-section h2 { font-size: clamp(25px, 3.2vw, 36px); margin-bottom: 10px; }
.resource-section p { font-size: 18px; color: var(--muted); margin: 0; }
.resources-hub-hero { grid-template-columns: 1fr; padding-top: 34px; padding-bottom: 12px; }
.resources-directory { padding-top: 12px; }
.resource-list-grid { display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 14px; }
.resource-list-card { background: white; border: 1px solid var(--line); border-radius: 18px; box-shadow: 0 10px 28px rgba(19,32,51,.07); }
.resource-list-card a { display: flex; flex-direction: column; min-height: 190px; padding: 18px; color: inherit; text-decoration: none; }
.resource-list-card h3 { font-size: 21px; line-height: 1.1; margin: 8px 0; }
.resource-list-card p { color: var(--muted); font-size: 15px; line-height: 1.42; margin: 0; }
.resource-type { color: var(--green); font-weight: 900; font-size: 12px; text-transform: uppercase; letter-spacing: .09em; }
@media (max-width: 900px) { .resource-list-grid { grid-template-columns: repeat(2, minmax(0,1fr)); } }
@media (max-width: 560px) { .resource-list-grid { grid-template-columns: 1fr; } }
/* RN resource cluster end */'''
if start in css and end in css:
    css = re.sub(re.escape(start) + r'.*?' + re.escape(end), block, css, flags=re.S)
else:
    css = css.rstrip() + '\n\n' + block + '\n'
css_path.write_text(css, encoding='utf-8')

urls = [SITE + '/']
urls += [SITE + f'/industries/{s}/' for s in industry_slugs]
urls += [SITE + '/resources/']
urls += [SITE + f'/resources/{s}/' for s in all_resources.keys()]
xml = ['<?xml version="1.0" encoding="UTF-8"?>','<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for url in urls:
    xml += ['  <url>', f'    <loc>{url}</loc>', '  </url>']
xml.append('</urlset>')
Path('www/sitemap.xml').write_text('\n'.join(xml)+'\n', encoding='utf-8')
Path('www/robots.txt').write_text('User-agent: *\nAllow: /\n\nSitemap: https://reviewnudgeindustries.etal.solutions/sitemap.xml\n', encoding='utf-8')
print('Added Resources hub, 5 new resource pages, updated nav, sitemap, robots, and CSS.')

PY
