#!/usr/bin/env bash
set -euo pipefail

cd "${1:-.}"

if [ ! -d www ]; then
  echo "ERROR: run this from the ReviewNudgeIndustries repo root, or pass the repo path as the first argument." >&2
  exit 1
fi

python3 <<'PY'
from pathlib import Path
import html
import re

SITE = 'https://reviewnudgeindustries.etal.solutions'
APP = 'https://reviewnudge.etal.solutions'
TRY = 'https://reviewnudge.etal.solutions/billing'

industries = {
    'plumbers': {
        'short': 'Plumbers', 'title': 'Review Management for Plumbers',
        'desc': 'Practical review-request guidance for plumbing companies, drain cleaners, emergency plumbers, and water-heater installers.',
        'card': 'Review workflows for plumbing repairs, drain cleaning, water heaters, and urgent service calls.',
        'angle': 'Plumbing reviews are often earned in moments of relief. A customer had water where water should not be, a fixture that failed, a drain that stopped normal life, or a water heater that disrupted the morning. The review request should recognize that the service was not abstract. The customer needed a problem solved clearly, quickly, and without leaving a mess behind.',
        'opportunities': ['Drain cleaning after water is flowing again', 'Water heater replacement after hot water is restored', 'Leak repair after the area is clean and stable', 'Fixture installation after the customer has tested the work', 'Emergency service after the immediate stress has passed'],
        'timing': 'Ask after the repair is complete, the customer understands what was done, and the work area has been cleaned up. For urgent calls, give the customer a little breathing room before asking.',
        'customer': 'A plumbing customer usually wants reliability, speed, clear communication, and confidence that the problem will not immediately return.',
        'sample': 'Thanks again for choosing us for your plumbing service. If everything is working well, would you mind sharing a quick Google review? It helps local customers know who they can trust when something urgent comes up.',
        'faq1': 'Should plumbers ask after emergency calls?', 'faq1a': 'Yes, but timing matters. Ask after the emergency has been resolved and the customer has had a chance to see that the repair is holding.'
    },
    'hvac': {
        'short': 'HVAC', 'title': 'Review Management for HVAC Companies',
        'desc': 'Review-request guidance for HVAC repair, tune-ups, installations, maintenance visits, and seasonal service teams.',
        'card': 'Review timing for AC repair, furnace repair, tune-ups, installations, and maintenance visits.',
        'angle': 'HVAC reviews are tied to comfort. The customer remembers whether the home became cool again, warm again, quieter, safer, or easier to manage. HVAC companies also have seasonal spikes, which means review requests should be consistent before the busy season hides every follow-up opportunity.',
        'opportunities': ['AC repair after cooling is restored', 'Furnace repair after heat is reliable', 'Seasonal tune-up after the system passes checks', 'Installation after the customer understands the new system', 'Maintenance agreement visit after a clear service summary'],
        'timing': 'Ask after the system is running properly and the customer has felt the result. For installations, ask after walkthrough and cleanup instead of during the technical handoff.',
        'customer': 'An HVAC customer often cares about comfort, responsiveness, technical competence, and whether the technician explained the situation clearly.',
        'sample': 'Thank you for trusting us with your HVAC service. If your home is comfortable again and the experience was a good one, a short Google review would help other homeowners know what to expect from our team.',
        'faq1': 'Should HVAC companies ask after tune-ups?', 'faq1a': 'Yes. Tune-ups are good review opportunities when the technician communicates clearly and leaves the customer feeling prepared for the season.'
    },
    'electricians': {
        'short': 'Electricians', 'title': 'Review Management for Electricians',
        'desc': 'A focused review-request process for electricians, lighting installers, panel upgrades, troubleshooting visits, and repair work.',
        'card': 'Review guidance for electrical repairs, lighting, panels, troubleshooting, and installations.',
        'angle': 'Electrical work depends heavily on trust. Many customers cannot evaluate every technical detail, so they remember whether the electrician was careful, clear, safe, punctual, and respectful of the space. Reviews can make that trust visible to the next customer.',
        'opportunities': ['Outlet or switch repair after the customer tests the fixture', 'Lighting installation after the room is functional', 'Panel upgrades after inspection or final walkthrough', 'Troubleshooting visits after the problem is explained', 'EV charger installation after the customer understands operation'],
        'timing': 'Ask after the work has been tested and explained. Electrical customers often appreciate a request that mentions safety, clarity, and clean completion.',
        'customer': 'An electrical customer usually wants safe work, clear explanations, clean installation, and confidence that the issue was correctly diagnosed.',
        'sample': 'Thanks for choosing us for your electrical work. If the service was clear, careful, and helpful, would you be willing to leave a quick Google review? It helps neighbors find a reliable electrician.',
        'faq1': 'Should electricians mention safety in review requests?', 'faq1a': 'The request should not sound scripted, but it can naturally reference clear, careful, reliable service when that matches the customer experience.'
    },
    'landscapers': {
        'short': 'Landscapers', 'title': 'Review Management for Landscapers',
        'desc': 'Review-request guidance for landscapers, lawn care providers, yard cleanups, and recurring outdoor service teams.',
        'card': 'Review ideas for lawn care, cleanups, landscape refreshes, and recurring outdoor service.',
        'angle': 'Landscaping reviews are often visual. The customer can see the difference from the curb, the patio, or the first walk outside after the job. Reviews work best when the request occurs after a visible improvement, seasonal cleanup, or a reliable streak of recurring service.',
        'opportunities': ['Yard cleanup after debris is removed', 'Mulch or planting refresh after the property looks renewed', 'Lawn care after consistent improvement', 'Tree and shrub trimming after shape and clearance are visible', 'Seasonal maintenance after the property is ready for use'],
        'timing': 'Ask when the finished outdoor result is visible. For recurring service, ask after a strong service visit or milestone rather than after every visit.',
        'customer': 'A landscaping customer often cares about appearance, consistency, communication, and whether the property looks cared for without extra supervision.',
        'sample': 'Thank you for letting us take care of your property. If the yard looks good and the experience has been smooth, a short review would mean a lot to our local team.',
        'faq1': 'Should landscapers ask recurring customers for reviews?', 'faq1a': 'Yes. Long-term customers can often write strong reviews because they have seen consistency over time.'
    },
    'handymen': {
        'short': 'Handymen', 'title': 'Review Management for Handyman Businesses',
        'desc': 'A lightweight review workflow for handyman services, punch-list jobs, repairs, installs, and small local service teams.',
        'card': 'Simple review workflows for punch lists, small repairs, installs, and local maintenance work.',
        'angle': 'Handyman reviews often come from trust built through small details. The customer may remember that the loose door finally closes, the shelf is secure, the television is mounted, or a lingering list of annoyances is finally done. The review request should feel personal and not overproduced.',
        'opportunities': ['Punch-list completion after all items are checked off', 'Door and hardware repair after the customer tests the fix', 'Furniture assembly after the item is placed and stable', 'TV mounting after cables and placement are settled', 'Small home repairs after the customer sees the convenience'],
        'timing': 'Ask after the last item is complete and the customer can see that the small problems were handled well.',
        'customer': 'A handyman customer typically values dependability, practical problem solving, respectful communication, and not having to chase the work.',
        'sample': 'Thanks again for trusting us with your handyman project. If we made the day easier, would you mind leaving a quick review? It helps other local homeowners find dependable help.',
        'faq1': 'Can a small handyman business benefit from a review workflow?', 'faq1a': 'Yes. A simple workflow helps small jobs turn into visible trust instead of relying on memory after a busy day.'
    },
    'house-cleaning': {
        'short': 'House Cleaning', 'title': 'Review Management for House Cleaning Services',
        'desc': 'A simple review-request workflow for house cleaners, maid services, move-out cleanings, and recurring residential cleaning teams.',
        'card': 'Review workflows for recurring cleaning, deep cleaning, move-out cleaning, and turnovers.',
        'angle': 'House cleaning reviews are rooted in trust and consistency. Customers invite a service team into personal space, and the review often reflects reliability as much as shine. Strong review requests acknowledge the finished result without making the customer feel pressured inside a recurring relationship.',
        'opportunities': ['Deep cleaning after the customer sees the reset', 'Move-out cleaning after the space is ready', 'Recurring cleaning after several reliable visits', 'Short-term rental turnover after the property is guest-ready', 'Post-renovation cleaning after dust and debris are handled'],
        'timing': 'Ask after the customer can see the finished space. For recurring cleaning, ask after a positive pattern has been established instead of asking too early.',
        'customer': 'A cleaning customer often cares about consistency, trust, care with belongings, communication, and whether the space feels reset.',
        'sample': 'Thank you for choosing us for your cleaning service. If the home looked good and the experience was smooth, would you mind leaving a quick Google review? It helps other local customers find dependable cleaning help.',
        'faq1': 'Should cleaners ask recurring clients for reviews?', 'faq1a': 'Yes, especially after trust and consistency have been demonstrated through multiple visits.'
    },
    'pressure-washing': {
        'short': 'Pressure Washing', 'title': 'Review Management for Pressure Washing Businesses',
        'desc': 'Review request guidance for pressure washing companies, exterior cleaning teams, driveway cleaning, siding cleaning, and property refresh services.',
        'card': 'Review guidance for driveways, patios, siding, decks, and visible before-and-after work.',
        'angle': 'Pressure washing has one major advantage for reviews: visible transformation. The customer can often see the result immediately. A good review request should connect to that before-and-after moment without sounding like a sales pitch.',
        'opportunities': ['Driveway cleaning after stains are visibly reduced', 'House washing after siding looks refreshed', 'Patio or deck cleaning after outdoor space is usable', 'Fence cleaning after the surface is brighter', 'Commercial exterior cleaning after curb appeal improves'],
        'timing': 'Ask after the customer has seen the finished surface. If photos were part of the job, the request can follow the before-and-after reveal.',
        'customer': 'A pressure washing customer usually cares about visible results, care around property, punctuality, and whether the business delivered the difference promised.',
        'sample': 'Thanks again for choosing us for your pressure washing project. If the results looked great, would you mind sharing a quick review? It helps other local customers know what kind of results to expect.',
        'faq1': 'Are before-and-after jobs good review opportunities?', 'faq1a': 'Yes. Visible transformation gives customers a clear reason to explain the value they received.'
    },
    'roofing': {
        'short': 'Roofing', 'title': 'Review Management for Roofing Companies',
        'desc': 'A practical review workflow for roof repairs, inspections, replacements, leak fixes, and local roofing contractors.',
        'card': 'Review workflows for roof repairs, leak fixes, inspections, replacements, and storm damage work.',
        'angle': 'Roofing reviews carry extra weight because roofing decisions are expensive, stressful, and often connected to leaks, storms, insurance, or long-term home protection. A roofing review request should respect that this is a high-trust decision, not a casual purchase.',
        'opportunities': ['Leak repair after the customer understands the fix', 'Roof inspection after findings are explained clearly', 'Roof replacement after cleanup and final walkthrough', 'Storm damage repair after the property is secure', 'Maintenance work after photos or documentation are shared'],
        'timing': 'Ask after the job is complete, cleanup is done, and the customer has received a clear explanation of the work. For large jobs, the walkthrough matters.',
        'customer': 'A roofing customer often cares about trust, documentation, property protection, cleanup, communication, and confidence that the work will last.',
        'sample': 'Thank you for trusting us with your roofing project. If the work was completed well and our team took good care of your property, a quick review would mean a lot to our local business.',
        'faq1': 'Should roofers ask after inspections?', 'faq1a': 'Yes, when the inspection was helpful and clearly explained. Not every review has to follow a full replacement.'
    },
    'painting': {
        'short': 'Painting', 'title': 'Review Management for Painting Contractors',
        'desc': 'Review management guidance for interior painters, exterior painters, cabinet painters, and small painting crews.',
        'card': 'Review ideas for interior painting, exterior painting, cabinet painting, and refresh projects.',
        'angle': 'Painting reviews reflect both the finished look and the experience of getting there. Customers notice preparation, neat edges, protection of surfaces, cleanup, communication, and whether the finished space feels like the promise.',
        'opportunities': ['Interior painting after the room is reset', 'Exterior painting after curb appeal is visible', 'Cabinet painting after the finish is complete', 'Trim and door painting after detail work is inspected', 'Color refresh projects after the customer sees the final light'],
        'timing': 'Ask after the customer has seen the completed work in normal lighting and any touchups have been handled.',
        'customer': 'A painting customer usually cares about finish quality, cleanliness, schedule, respect for the home, and whether the final result matches expectations.',
        'sample': 'Thanks again for choosing us for your painting project. If you are happy with the finished look, would you be willing to leave a quick review? It helps other local customers choose a painter with confidence.',
        'faq1': 'Should painters wait until touchups are complete?', 'faq1a': 'Yes. The best review request comes after the customer has seen the finished work and any punch-list items are resolved.'
    },
    'pool-service': {
        'short': 'Pool Service', 'title': 'Review Management for Pool Service Companies',
        'desc': 'A lightweight review workflow for pool cleaning, pool maintenance, repairs, inspections, and recurring pool service routes.',
        'card': 'Review follow-up for cleaning, weekly service, equipment repair, and clear-water improvements.',
        'angle': 'Pool service reviews often come from visible reliability. The water is clear, the equipment works, the route is consistent, and the customer does not have to think about the pool as much. That makes recurring service and rescue jobs especially strong review moments.',
        'opportunities': ['Weekly service after a consistent service streak', 'Green pool recovery after water is clear', 'Equipment repair after the system is running', 'Filter service after the customer understands the maintenance', 'Opening or seasonal service after the pool is usable'],
        'timing': 'Ask after the water is clear, the equipment is working, or the customer has seen reliable service over time.',
        'customer': 'A pool service customer often cares about consistency, visible water quality, equipment reliability, communication, and fewer surprises.',
        'sample': 'Thank you for choosing us for your pool service. If the pool looks good and the service has been reliable, would you mind leaving a quick review? It helps other local pool owners find dependable help.',
        'faq1': 'Should pool companies ask recurring customers for reviews?', 'faq1a': 'Yes. Recurring customers can describe reliability and consistency better than one-time customers.'
    },
}

resources = [
    ('review-request-email-templates', 'Review Request Email Templates', 'Copy-ready examples for polite review requests after completed service work.'),
    ('review-request-sms-templates', 'Review Request SMS Templates', 'Short, respectful text-message examples for asking customers to leave a review.'),
    ('how-to-ask-for-google-reviews', 'How To Ask for Google Reviews', 'A practical guide to asking for Google reviews without sounding pushy.'),
    ('best-time-to-ask-for-a-review', 'Best Time To Ask for a Review', 'When service businesses should ask so the request feels natural and timely.'),
]

NAV = f'''<div class="nav-links">
      <a href="/industries/">Industry Guides</a>
      <a href="/resources/how-to-ask-for-google-reviews/">Resources</a>
      <a href="{APP}">About ReviewNudge</a>
      <a class="btn btn-primary" href="{TRY}">Try ReviewNudge</a>
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
    <div><strong>ReviewNudge Industries</strong><br>Review management resources for local service businesses.</div>
    <div><a href="{APP}">ReviewNudge</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>'''

def shell(title, desc, canonical, body, schema=''):
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

def compact_cards():
    return '\n'.join(f'''      <article class="guide-card">
        <a class="guide-card-link" href="/industries/{slug}/">
          <h3>{html.escape(data['short'])}</h3>
          <p>{html.escape(data['card'])}</p>
          <span>Open guide -></span>
        </a>
      </article>''' for slug, data in industries.items())

def resource_cards():
    return '\n'.join(f'''      <article class="guide-card resource-card">
        <a class="guide-card-link" href="/resources/{slug}/">
          <h3>{html.escape(title)}</h3>
          <p>{html.escape(desc)}</p>
          <span>Read resource -></span>
        </a>
      </article>''' for slug, title, desc in resources)

home_schema = '''  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebSite",
    "name":"ReviewNudge Industries",
    "url":"https://reviewnudgeindustries.etal.solutions/",
    "description":"Review management resources for local service businesses."
  }
  </script>
'''
home_body = f'''  <section class="directory-hero">
    <div>
      <div class="eyebrow">Review management knowledge base</div>
      <h1>Choose your industry</h1>
      <p class="lead compact-lead">Practical, industry-specific review request guidance for local service businesses. No fluff, no giant marketing maze: just the situations, timing, and wording that fit each kind of work.</p>
    </div>
    <div class="directory-actions">
      <a class="btn btn-primary" href="{TRY}">Try ReviewNudge</a>
      <a class="btn btn-secondary" href="/resources/how-to-ask-for-google-reviews/">Review guide</a>
    </div>
  </section>

  <section class="directory-section" aria-labelledby="industry-guides-title">
    <h2 id="industry-guides-title">Industry guides</h2>
    <div class="guide-grid compact-guide-grid">
{compact_cards()}
    </div>
  </section>

  <section class="directory-section" aria-labelledby="resources-title">
    <h2 id="resources-title">Popular review resources</h2>
    <div class="guide-grid resource-grid">
{resource_cards()}
    </div>
  </section>'''
Path('www/index.html').write_text(shell('ReviewNudge Industries | Review Management Guides for Local Service Businesses', 'Choose an industry and get practical review management guidance for plumbers, HVAC companies, electricians, landscapers, cleaners, roofers, painters, pool service companies, and more.', SITE + '/', home_body, home_schema), encoding='utf-8')

industries_body = f'''  <section class="directory-hero">
    <div>
      <div class="eyebrow">Industry guide directory</div>
      <h1>Review management guides by service type</h1>
      <p class="lead compact-lead">Browse practical guides written around real customer moments: urgent repairs, recurring visits, visible transformations, high-trust projects, and follow-up that does not feel pushy.</p>
    </div>
  </section>
  <section class="directory-section">
    <div class="guide-grid compact-guide-grid">
{compact_cards()}
    </div>
  </section>'''
Path('www/industries').mkdir(parents=True, exist_ok=True)
Path('www/industries/index.html').write_text(shell('Industry Review Management Guides | ReviewNudge Industries', 'Browse industry-specific review management guides for local service businesses, including plumbers, HVAC companies, electricians, landscapers, handymen, cleaners, roofers, painters, pressure washing businesses, and pool service companies.', SITE + '/industries/', industries_body), encoding='utf-8')

for slug, data in industries.items():
    job_items = '\n'.join(f'      <li>{html.escape(x)}</li>' for x in data['opportunities'])
    schema = f'''  <script type="application/ld+json">
  {{
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {{"@type":"Question","name":"{html.escape(data['faq1'])}","acceptedAnswer":{{"@type":"Answer","text":"{html.escape(data['faq1a'])}"}}}},
      {{"@type":"Question","name":"When is the best time to ask for a review?","acceptedAnswer":{{"@type":"Answer","text":"{html.escape(data['timing'])}"}}}},
      {{"@type":"Question","name":"How does ReviewNudge help this business?","acceptedAnswer":{{"@type":"Answer","text":"ReviewNudge keeps review requests, customer status, and follow-up activity organized in one focused workspace."}}}}
    ]
  }}
  </script>
'''
    body = f'''<article class="content industry-article">
  <div class="breadcrumb"><a href="/">Home</a> / <a href="/industries/">Industries</a> / {html.escape(data['title'])}</div>
  <div class="eyebrow">{html.escape(data['title'])}</div>
  <h1>{html.escape(data['title'])}</h1>
  <p class="lead">{html.escape(data['desc'])}</p>

  <section class="industry-focus">
    <h2>What makes reviews different for this business</h2>
    <p>{html.escape(data['angle'])}</p>
  </section>

  <section>
    <h2>Good review moments</h2>
    <p>Not every completed job deserves the same follow-up. These are the moments when a review request is most likely to feel natural because the customer can connect the request to a clear result.</p>
    <ul>
{job_items}
    </ul>
  </section>

  <section>
    <h2>When to ask</h2>
    <p>{html.escape(data['timing'])}</p>
  </section>

  <section>
    <h2>What the customer is really reviewing</h2>
    <p>{html.escape(data['customer'])}</p>
  </section>

  <section>
    <h2>Sample review request</h2>
    <div class="callout"><p>{html.escape(data['sample'])}</p></div>
  </section>

  <section>
    <h2>Use ReviewNudge without overcomplicating the workflow</h2>
    <p>ReviewNudge is built for the few minutes after successful service work: add the customer, send a thoughtful request, and keep follow-up visible. The goal is not to create another marketing platform to manage. The goal is to make sure good customer moments do not disappear at the end of a busy day.</p>
  </section>

  <section class="faq">
    <h2>Frequently asked questions</h2>
    <details><summary>{html.escape(data['faq1'])}</summary><p>{html.escape(data['faq1a'])}</p></details>
    <details><summary>How many times should a business follow up?</summary><p>One polite reminder is usually enough. Review follow-up should make the request easy, not make the customer feel chased.</p></details>
    <details><summary>Does every review request need to be custom-written?</summary><p>No. A reusable message can still feel personal when it references the completed service and arrives at the right time.</p></details>
  </section>

  <section>
    <div class="cta-band">
      <div><h2>Keep review follow-up organized.</h2><p>ReviewNudge gives local service businesses one clean place to manage review requests and follow-up status.</p></div>
      <a class="btn btn-primary" href="{TRY}">Try ReviewNudge</a>
    </div>
  </section>
</article>'''
    p = Path('www/industries') / slug
    p.mkdir(parents=True, exist_ok=True)
    p.joinpath('index.html').write_text(shell(data['title'] + ' | ReviewNudge Industries', data['desc'], SITE + f'/industries/{slug}/', body, schema), encoding='utf-8')

for path in Path('www').rglob('*.html'):
    text = path.read_text(encoding='utf-8', errors='ignore')
    new = re.sub(r'<div class="nav-links">.*?</div>', NAV, text, count=1, flags=re.S)
    if new != text:
        path.write_text(new, encoding='utf-8')

css_path = Path('www/styles.css')
css = css_path.read_text(encoding='utf-8', errors='ignore') if css_path.exists() else ''
start = '/* RN Industries publication refinement start */'
end = '/* RN Industries publication refinement end */'
block = f'''{start}
.directory-hero {{ max-width:1120px; margin:0 auto; padding:38px 20px 18px; display:grid; grid-template-columns:minmax(0,1fr) auto; gap:20px; align-items:end; }}
.directory-hero h1 {{ margin:8px 0 10px; font-size:clamp(38px,5vw,58px); line-height:.98; }}
.compact-lead {{ max-width:820px !important; font-size:18px !important; margin-bottom:0; }}
.directory-actions {{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; justify-content:flex-end; }}
.directory-section {{ max-width:1120px; margin:0 auto; padding:22px 20px 18px; }}
.directory-section h2 {{ font-size:clamp(24px,3vw,34px); margin-bottom:14px; }}
.guide-grid {{ display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:14px; }}
.guide-card {{ background:var(--white); border:1px solid var(--line); border-radius:18px; box-shadow:0 10px 28px rgba(19,32,51,.07); min-height:188px; }}
.guide-card-link {{ display:flex; min-height:188px; flex-direction:column; padding:18px; text-decoration:none; color:inherit; }}
.guide-card h3 {{ font-size:20px; line-height:1.1; letter-spacing:-.025em; margin:0 0 8px; }}
.guide-card p {{ font-size:15px; line-height:1.42; color:var(--muted); margin:0; }}
.guide-card span {{ color:var(--blue); font-weight:900; margin-top:auto; padding-top:12px; }}
.resource-grid {{ grid-template-columns:repeat(4,minmax(0,1fr)); }}
.industry-article h1 {{ font-size:clamp(38px,6vw,64px); }}
.industry-focus {{ background:white; border:1px solid var(--line); border-radius:22px; padding:24px; box-shadow:var(--shadow); }}
@media (max-width:1040px) {{ .guide-grid,.resource-grid {{ grid-template-columns:repeat(3,minmax(0,1fr)); }} }}
@media (max-width:760px) {{ .directory-hero {{ grid-template-columns:1fr; padding-top:28px; }} .directory-actions {{ justify-content:flex-start; }} .guide-grid,.resource-grid {{ grid-template-columns:repeat(2,minmax(0,1fr)); }} }}
@media (max-width:520px) {{ .guide-grid,.resource-grid {{ grid-template-columns:1fr; }} }}
{end}
'''
if start in css and end in css:
    css = re.sub(re.escape(start) + r'.*?' + re.escape(end), block, css, flags=re.S)
else:
    css = css.rstrip() + '\n\n' + block
css_path.write_text(css, encoding='utf-8')

urls = [SITE + '/', SITE + '/industries/']
urls += [SITE + f'/industries/{slug}/' for slug in industries]
urls += [SITE + f'/resources/{slug}/' for slug, _, _ in resources]
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for url in urls:
    sitemap += ['  <url>', f'    <loc>{url}</loc>', '  </url>']
sitemap.append('</urlset>')
Path('www/sitemap.xml').write_text('\n'.join(sitemap) + '\n', encoding='utf-8')
Path('www/robots.txt').write_text('User-agent: *\nAllow: /\n\nSitemap: https://reviewnudgeindustries.etal.solutions/sitemap.xml\n', encoding='utf-8')
PY

echo "Refined ReviewNudge Industries into a compact publication-style SEO site."
