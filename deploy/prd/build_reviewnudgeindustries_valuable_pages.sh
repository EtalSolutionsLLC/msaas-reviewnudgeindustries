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

NAV = f'''<div class="nav-links">
      <a href="{APP}">About ReviewNudge</a>
      <a class="btn btn-primary" href="{SETUP}">Try ReviewNudge</a>
    </div>'''

FALLBACK_HEADER = f'''<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    {NAV}
  </nav>
</header>'''

FALLBACK_FOOTER = f'''<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="{APP}">About ReviewNudge</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>'''

def extract_chrome():
    candidates = [Path('www/industries/plumbers/index.html'), Path('www/index.html')]
    for p in candidates:
        if not p.exists():
            continue
        text = p.read_text(encoding='utf-8', errors='ignore')
        body_open = re.search(r'<body[^>]*>', text, flags=re.I)
        main_open = re.search(r'<main[^>]*>', text, flags=re.I)
        main_close = re.search(r'</main>', text, flags=re.I)
        body_close = re.search(r'</body>', text, flags=re.I)
        if body_open and main_open and main_close and body_close:
            header = text[body_open.end():main_open.start()].strip()
            footer = text[main_close.end():body_close.start()].strip()
            if header and footer:
                header = re.sub(r'<div class="nav-links">.*?</div>', NAV, header, count=1, flags=re.S)
                footer = footer.replace('href="https://reviewnudge.etal.solutions/billing"', f'href="{SETUP}"')
                return header, footer
    return FALLBACK_HEADER, FALLBACK_FOOTER

HEADER, FOOTER = extract_chrome()

pages = {
    'plumbers': {
        'title': 'The Relief Moment: Review Strategy for Plumbing Companies',
        'meta': 'A useful review management guide for plumbers built around emergency calls, water heater work, leak repairs, customer relief, and practical follow-up timing.',
        'eyebrow': 'Plumbing review strategy',
        'lede': 'Plumbing reviews are written in the moment after stress drops. The pipe is fixed, the water is back, or the leak has stopped spreading. That relief is the real review opportunity.',
        'demo': {'name':'Maria L.', 'job':'Kitchen sink leak', 'status':'Relief window open', 'next':'Send review request after cleanup note'},
        'sections': [
            ('The customer is not reviewing the pipe', 'A homeowner usually cannot judge the technical quality of a plumbing repair. The customer remembers whether the plumber arrived when expected, explained the problem clearly, fixed the issue, protected the home, and left the space usable again.'),
            ('Emergency calls need a softer ask', 'A review request after an emergency should not sound like a victory lap. Give the customer a short message that acknowledges the interruption and keeps the ask optional. The best tone is calm, useful, and human.'),
            ('Water heater work has a different rhythm', 'A water heater replacement or repair often has a clear before-and-after experience: cold showers, disruption, then normal life restored. The right review request can mention that practical restoration without overselling it.'),
            ('What customers actually remember', 'Fast arrival, clear explanation, clean work area, no surprise confusion, and confidence that the repair will hold. Build requests around those remembered details.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, plumbing jobs should show small service notes like “water restored,” “cleanup completed,” or “customer shown shutoff valve.” Those notes make the review request feel grounded in the actual visit.')
        ],
        'sample': 'Thanks again for trusting us with the plumbing repair. If everything is working well and the service helped get the day back to normal, would you mind leaving a quick review? It helps other local customers know who they can call when something urgent happens.'
    },
    'hvac': {
        'title': 'Comfort Restored: Review Strategy for HVAC Companies',
        'meta': 'A practical HVAC review management guide for AC repair, furnace repair, tune-ups, installations, seasonal demand, and maintenance agreement follow-up.',
        'eyebrow': 'HVAC review strategy',
        'lede': 'HVAC customers remember comfort. A good review request connects to the moment the home cooled down, warmed up, quieted down, or became predictable again.',
        'demo': {'name':'James C.', 'job':'AC tune-up', 'status':'Comfort confirmed', 'next':'Ask after service summary'},
        'sections': [
            ('The comfort test', 'The strongest HVAC review moment is not when the invoice is paid. It is when the customer feels the result. The home cools down. The furnace runs. The system sounds right. The thermostat finally makes sense.'),
            ('Repairs and installations are different asks', 'A repair request can be short and immediate. An installation request should usually follow the walkthrough, system explanation, and cleanup. The customer needs enough context to describe the experience.'),
            ('Tune-ups are review opportunities too', 'Tune-ups can create strong reviews when the technician explains what was checked and leaves the customer feeling ready for the season. This is especially useful before summer and winter busy periods.'),
            ('Maintenance agreements build review depth', 'Recurring customers can speak to reliability over time. A review from a maintenance customer can mention consistency, clear communication, and fewer surprises.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, HVAC jobs should show “system running,” “filter note added,” or “seasonal tune-up complete.” That makes the follow-up feel connected to comfort rather than generic marketing.')
        ],
        'sample': 'Thank you for trusting us with your HVAC service. If your home is comfortable again and the visit was helpful, a short review would help other homeowners know what to expect from our team.'
    },
    'electricians': {
        'title': 'Trust More Than Wiring: Review Strategy for Electricians',
        'meta': 'A review management guide for electricians focused on safety, clear explanations, panel upgrades, lighting work, EV chargers, and customer confidence.',
        'eyebrow': 'Electrical review strategy',
        'lede': 'Electrical customers usually cannot inspect the work behind the wall. They review confidence: clear communication, careful work, safety, and whether the home feels right afterward.',
        'demo': {'name':'Renee C.', 'job':'EV charger install', 'status':'Walkthrough complete', 'next':'Ask after first successful charge'},
        'sections': [
            ('The trust gap', 'Most customers cannot evaluate an electrical diagnosis in technical detail. They rely on trust signals: punctuality, clean work, labels, explanations, permits when needed, and confidence that the job was done correctly.'),
            ('Translate technical value into customer language', 'A review request should not ask the customer to comment on amperage, load calculations, or wiring methods. It should invite the customer to talk about clarity, professionalism, safety, and the completed result.'),
            ('Panel upgrades deserve a walkthrough-based request', 'Panel work is high-trust and often more expensive than small repairs. Ask only after the customer understands what changed and has seen the finished panel area.'),
            ('EV charger jobs have a perfect review trigger', 'The first successful charge is a natural customer moment. It is specific, useful, and easy for the customer to describe.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, electrical jobs should include status labels like “tested with customer,” “panel labeled,” or “first charge confirmed.” The demo should feel like an electrician actually used it.')
        ],
        'sample': 'Thanks for choosing us for your electrical work. If the service was clear, careful, and helpful, would you be willing to leave a quick review? It helps neighbors find a reliable electrician.'
    },
    'landscapers': {
        'title': 'The Before-and-After Advantage: Review Strategy for Landscapers',
        'meta': 'A landscaping review management guide built around visible transformations, recurring lawn care, seasonal cleanups, curb appeal, and photo-friendly follow-up.',
        'eyebrow': 'Landscaping review strategy',
        'lede': 'Landscaping has something many service businesses wish they had: visible proof. The customer can see the difference from the curb, the patio, or the first walk outside after the work is done.',
        'demo': {'name':'Owen P.', 'job':'Spring yard cleanup', 'status':'Before/after ready', 'next':'Ask after photo recap'},
        'sections': [
            ('Curb appeal is emotional', 'A cleaned, shaped, or refreshed property changes how the customer feels arriving home. That is more memorable than a list of tasks. Reviews should invite the customer to describe the visible improvement.'),
            ('Recurring lawn care needs milestone asks', 'Do not ask after every visit. Ask after a visible improvement, a seasonal reset, or a stretch of reliable service. That gives the customer something real to say.'),
            ('Seasonal work creates natural review windows', 'Spring cleanups, fall cleanups, planting refreshes, and storm cleanup all create moments when the customer clearly sees the value.'),
            ('Photos can support the request', 'If the business already takes before-and-after photos, the review request can follow the recap. The photo reminds the customer why the work mattered.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, landscaping jobs should show “photo recap sent,” “seasonal cleanup,” or “recurring client milestone.” This makes the product feel useful for outdoor service work.')
        ],
        'sample': 'Thank you for letting us take care of your property. If the yard looks good and the experience has been smooth, a short review would mean a lot to our local team.'
    },
    'handymen': {
        'title': 'Small Jobs, Big Loyalty: Review Strategy for Handyman Businesses',
        'meta': 'A handyman review management guide for punch-list work, small repairs, convenience jobs, repeat customers, and practical review follow-up.',
        'eyebrow': 'Handyman review strategy',
        'lede': 'Handyman work often wins reviews by removing small annoyances. A door closes. A shelf stays up. A list finally gets handled. The customer remembers convenience and relief.',
        'demo': {'name':'Tara B.', 'job':'Four-item punch list', 'status':'All items checked off', 'next':'Ask with completed list summary'},
        'sections': [
            ('The punch-list effect', 'A handyman visit may include several small wins. The review request should remind the customer that multiple nagging problems were solved in one visit.'),
            ('Small jobs create disproportionate gratitude', 'A repair that seems minor to a professional may be the thing that bothered the customer for months. That is why specific, plain review requests work well.'),
            ('Repeat customers are the strongest proof', 'People looking for handyman help often want someone they can call again. Reviews from repeat customers carry a kind of trust that one-off jobs cannot always create.'),
            ('Convenience is the product', 'The customer may not review the repair technique. The customer reviews not having to figure it out, not having to chase anyone, and not having to live with the annoyance anymore.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, handyman jobs should show checklist-style service notes. “Door adjusted,” “shelf anchored,” and “caulk repaired” make the request feel specific.')
        ],
        'sample': 'Thanks again for trusting us with your handyman project. If we made the day easier, would you mind leaving a quick review? It helps other local homeowners find dependable help.'
    },
    'house-cleaning': {
        'title': 'Trust Inside the Home: Review Strategy for Cleaning Services',
        'meta': 'A cleaning service review management guide for recurring cleanings, deep cleans, move-out cleaning, turnovers, trust, and non-intrusive follow-up.',
        'eyebrow': 'Cleaning service review strategy',
        'lede': 'Cleaning reviews are about more than sparkle. Customers are reviewing trust, consistency, care with personal space, and the feeling of walking into a reset home.',
        'demo': {'name':'Nina S.', 'job':'Move-out clean', 'status':'Ready for landlord walkthrough', 'next':'Ask after walkthrough passes'},
        'sections': [
            ('The trust factor', 'A cleaning team enters personal space. That makes reliability, care, and respectful communication central to the review. The request should never feel pushy inside that relationship.'),
            ('Recurring clients need a different cadence', 'A long-term client can write a stronger review after several dependable visits. Ask after a positive pattern, not immediately after the first cleaning unless the experience was clearly exceptional.'),
            ('Move-out cleans have a clear result', 'The space is ready for a landlord, buyer, new tenant, or next step. That clear outcome gives the customer something specific to mention.'),
            ('Short-term rental turnovers are operational reviews', 'For rental owners, reviews may focus on reliability, timing, guest readiness, and reduced worry more than the cleaning itself.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, cleaning jobs should show “deep clean,” “turnover ready,” or “recurring client milestone.” This makes follow-up feel tied to the relationship, not a generic campaign.')
        ],
        'sample': 'Thank you for choosing us for your cleaning service. If the home looked good and the experience was smooth, would you mind leaving a quick Google review? It helps other local customers find dependable cleaning help.'
    },
    'pressure-washing': {
        'title': 'The Most Photogenic Reviews in Home Services: Pressure Washing Strategy',
        'meta': 'A pressure washing review management guide for before-and-after work, driveways, siding, decks, commercial exteriors, and reveal-based review timing.',
        'eyebrow': 'Pressure washing review strategy',
        'lede': 'Pressure washing may have the clearest visual review moment in home services. The customer does not need a technical explanation. The surface looks different.',
        'demo': {'name':'Carlos R.', 'job':'Driveway cleaning', 'status':'Before/after sent', 'next':'Ask while result is visible'},
        'sections': [
            ('The reveal is the review trigger', 'The best pressure washing request should happen after the customer sees the before-and-after result. The transformation does the selling.'),
            ('Driveways are easy to describe', 'A customer can talk about stains, brightness, curb appeal, or finally feeling better about the front of the property. Keep the ask tied to that visible result.'),
            ('Siding and decks need care language', 'Customers may worry about damage. Reviews that mention care, attention, and a good result can reduce that concern for future buyers.'),
            ('Commercial jobs are about presentation', 'For commercial properties, the review may focus on curb appeal, scheduling, minimal disruption, and property readiness.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, pressure washing jobs should show “before photo,” “after photo,” and “result confirmed.” That makes the software feel made for visual trades.')
        ],
        'sample': 'Thanks again for choosing us for your pressure washing project. If the results looked great, would you mind sharing a quick review? It helps other local customers know what kind of results to expect.'
    },
    'roofing': {
        'title': 'High Stakes, High Trust: Review Strategy for Roofing Companies',
        'meta': 'A roofing review management guide for roof replacements, inspections, leak repairs, storm damage, insurance work, final walkthroughs, and trust-building follow-up.',
        'eyebrow': 'Roofing review strategy',
        'lede': 'Roofing reviews carry extra weight because the decision is expensive, stressful, and tied to protecting the home. A review is often a trust signal before a future customer ever calls.',
        'demo': {'name':'Ellen W.', 'job':'Storm damage repair', 'status':'Final walkthrough complete', 'next':'Ask after photo documentation'},
        'sections': [
            ('The customer is buying confidence', 'A roof customer wants to believe the work was done correctly, the property was protected, and the business will stand behind the job. The review request should respect the seriousness of that decision.'),
            ('The walkthrough is the strongest ask point', 'For roof replacement or major repair, ask after the final walkthrough, cleanup, and documentation. That gives the customer a complete experience to review.'),
            ('Insurance jobs need calmer language', 'Insurance-related work can be confusing. A review request should not add pressure. It should invite the customer to comment on communication, clarity, and care.'),
            ('Cleanup deserves its own mention', 'Many roofing customers remember nails, debris, landscaping, and driveway care. That operational detail often matters as much as the roof itself.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, roofing jobs should show “photos shared,” “cleanup complete,” and “walkthrough done.” Those statuses demonstrate that the review request follows a trustworthy process.')
        ],
        'sample': 'Thank you for trusting us with your roofing project. If the work was completed well and our team took good care of your property, a quick review would mean a lot to our local business.'
    },
    'painting': {
        'title': 'The Emotional Side of Painting Reviews',
        'meta': 'A painting contractor review management guide for interior painting, exterior painting, cabinet refinishing, final walkthroughs, color anxiety, and professionalism.',
        'eyebrow': 'Painting review strategy',
        'lede': 'Painting changes how a space feels. The customer remembers the finished room, the cleaned-up edges, the care taken with the home, and the relief that the color choice worked.',
        'demo': {'name':'Priya M.', 'job':'Cabinet painting', 'status':'Final walkthrough done', 'next':'Ask after touchup confirmation'},
        'sections': [
            ('Customers review the experience around the finish', 'A paint job is visual, but the review often mentions communication, preparation, cleanup, punctuality, and respect for the space.'),
            ('Color anxiety is real', 'Customers may spend a lot of mental energy choosing a color. A good review moment happens when the finished space confirms that the decision worked.'),
            ('Cabinet painting has a reveal moment', 'Cabinets transform a kitchen without a full remodel. That reveal can create a strong review opportunity if touchups and curing instructions are handled first.'),
            ('Exterior projects sell curb appeal', 'Exterior painting reviews often help future customers imagine the impact on the whole property, not just the paint surface.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, painting jobs should show “walkthrough complete,” “touchups resolved,” and “customer saw final color.” That makes the ask feel earned.')
        ],
        'sample': 'Thanks again for choosing us for your painting project. If you are happy with the finished look, would you be willing to leave a quick review? It helps other local customers choose a painter with confidence.'
    },
    'pool-service': {
        'title': 'The Reliability Business: Review Strategy for Pool Service Companies',
        'meta': 'A pool service review management guide for weekly service, green pool recovery, equipment repairs, seasonal openings, closings, and recurring customer follow-up.',
        'eyebrow': 'Pool service review strategy',
        'lede': 'Great pool service often becomes invisible. The water is clear, the equipment works, and the customer does not have to think about the pool as much. That reliability is the review story.',
        'demo': {'name':'Devon K.', 'job':'Green pool recovery', 'status':'Water clear', 'next':'Ask after customer sees result'},
        'sections': [
            ('Reliability is the product', 'A pool customer may not know every chemical detail. The customer knows whether the pool is clear, usable, and handled without constant reminders.'),
            ('Green pool recovery creates a story', 'A recovery job has a visible arc: problem, process, result. That makes it one of the strongest pool-service review opportunities.'),
            ('Weekly service reviews should come from patterns', 'For recurring service, ask after consistent reliability or after a successful seasonal transition, not after every weekly visit.'),
            ('Equipment repair reviews are about fewer surprises', 'When pumps, filters, heaters, or automation are fixed, the customer wants confidence that the issue is understood and under control.'),
            ('Demo workflow idea', 'In the ReviewNudge demo, pool jobs should show “water clear,” “equipment running,” or “route milestone.” Those statuses connect the review request to visible reliability.')
        ],
        'sample': 'Thank you for choosing us for your pool service. If the pool looks good and the service has been reliable, would you mind leaving a quick review? It helps other local pool owners find dependable help.'
    }
}

order = list(pages.keys())

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
{HEADER}
<main id="main">
{body}
</main>
{FOOTER}
</body>
</html>
'''

def card_grid():
    parts = []
    for slug in order:
        p = pages[slug]
        card_title = p['title'].split(':')[0]
        parts.append(f'''      <article class="guide-card">
        <a class="guide-card-link" href="/industries/{slug}/">
          <h3>{html.escape(card_title)}</h3>
          <p>{html.escape(p['meta'])}</p>
          <span>Open guide -></span>
        </a>
      </article>''')
    return '\n'.join(parts)

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
Path('www/index.html').write_text(shell('ReviewNudge Industries | Review Management Guides for Local Service Businesses', 'Choose an industry for practical review management guidance tailored to service businesses including plumbers, HVAC companies, electricians, landscapers, cleaners, roofers, painters, pool service companies, and more.', SITE + '/', home_body, home_schema), encoding='utf-8')

Path('www/industries').mkdir(parents=True, exist_ok=True)
Path('www/industries/index.html').write_text(shell('Industry Guides | ReviewNudge Industries', 'The ReviewNudge Industries home page is the main hub for industry-specific review management guides.', SITE + '/industries/', '''  <section class="directory-hero home-hub-hero">
    <div>
      <div class="eyebrow">Industry guide directory</div>
      <h1>Industry guides live on the home page</h1>
      <p class="lead compact-lead">Use the ReviewNudge Industries home page to browse all industry-specific review management guides.</p>
      <p><a class="btn btn-primary" href="/">Browse industry guides</a></p>
    </div>
  </section>'''), encoding='utf-8')

for slug, p in pages.items():
    sections_html = []
    for heading, text in p['sections']:
        sections_html.append(f'''  <section class="story-section">
    <h2>{html.escape(heading)}</h2>
    <p>{html.escape(text)}</p>
  </section>''')
    sections_html = '\n'.join(sections_html)
    demo = p['demo']
    schema = f'''  <script type="application/ld+json">
  {{
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"{html.escape(p['title'])}",
    "description":"{html.escape(p['meta'])}",
    "url":"{SITE}/industries/{slug}/",
    "publisher":{{"@type":"Organization","name":"ReviewNudge Industries"}}
  }}
  </script>
'''
    body = f'''<article class="story-page story-{slug}">
  <section class="story-hero">
    <div class="breadcrumb"><a href="/">Home</a> / {html.escape(p['title'])}</div>
    <div class="eyebrow">{html.escape(p['eyebrow'])}</div>
    <h1>{html.escape(p['title'])}</h1>
    <p class="lead">{html.escape(p['lede'])}</p>
  </section>

  <section class="demo-strip" aria-label="ReviewNudge demo scenario">
    <div class="demo-card">
      <span class="demo-label">Demo customer</span>
      <strong>{html.escape(demo['name'])}</strong>
      <p>{html.escape(demo['job'])}</p>
    </div>
    <div class="demo-card">
      <span class="demo-label">Status</span>
      <strong>{html.escape(demo['status'])}</strong>
      <p>ReviewNudge keeps the follow-up visible.</p>
    </div>
    <div class="demo-card">
      <span class="demo-label">Next nudge</span>
      <strong>{html.escape(demo['next'])}</strong>
      <p>The request is tied to a real service moment.</p>
    </div>
  </section>

{sections_html}

  <section class="sample-request">
    <h2>Sample review request</h2>
    <div class="callout"><p>{html.escape(p['sample'])}</p></div>
  </section>

  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Turn the good service moment into a follow-up habit.</h2><p>ReviewNudge helps small service teams keep review requests, customer status, and follow-up organized in one simple workspace.</p></div>
      <a class="btn btn-primary" href="{SETUP}">Try ReviewNudge</a>
    </div>
  </section>
</article>'''
    d = Path('www/industries') / slug
    d.mkdir(parents=True, exist_ok=True)
    d.joinpath('index.html').write_text(shell(p['title'] + ' | ReviewNudge Industries', p['meta'], SITE + f'/industries/{slug}/', body, schema), encoding='utf-8')

for path in Path('www').rglob('*.html'):
    text = path.read_text(encoding='utf-8', errors='ignore')
    text = re.sub(r'<div class="nav-links">.*?</div>', NAV, text, count=1, flags=re.S)
    text = text.replace('href="https://reviewnudge.etal.solutions/billing"', f'href="{SETUP}"')
    path.write_text(text, encoding='utf-8')

css_path = Path('www/styles.css')
css = css_path.read_text(encoding='utf-8', errors='ignore') if css_path.exists() else ''
start = '/* RN valuable industry pages start */'
end = '/* RN valuable industry pages end */'
block = f'''{start}
.story-page {{ max-width: 960px; margin: 0 auto; padding: 36px 20px 64px; }}
.story-hero {{ margin-bottom: 26px; }}
.story-hero h1 {{ font-size: clamp(40px, 6vw, 70px); line-height: .96; letter-spacing: -.06em; margin: 12px 0 18px; }}
.story-hero .lead {{ max-width: 840px; }}
.demo-strip {{ display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; margin: 26px 0 34px; }}
.demo-card {{ background: white; border: 1px solid var(--line); border-radius: 20px; padding: 18px; box-shadow: 0 12px 32px rgba(19,32,51,.08); }}
.demo-card strong {{ display:block; font-size: 20px; line-height:1.15; margin: 5px 0; }}
.demo-card p {{ margin: 0; color: var(--muted); font-size: 15px; line-height:1.42; }}
.demo-label {{ color: var(--green); font-weight: 900; font-size: 12px; text-transform: uppercase; letter-spacing: .09em; }}
.story-section {{ margin: 28px 0; padding: 24px; background: rgba(255,255,255,.76); border: 1px solid var(--line); border-radius: 22px; }}
.story-section h2 {{ font-size: clamp(26px, 3.3vw, 38px); margin-bottom: 10px; }}
.story-section p {{ font-size: 18px; color: var(--muted); margin: 0; }}
.sample-request {{ margin: 34px 0; }}
.story-cta {{ margin-top: 38px; }}
.story-plumbers .demo-card {{ border-color: #c8e0ff; }}
.story-hvac .demo-card {{ border-color: #d5e7ff; }}
.story-electricians .demo-card {{ border-color: #eadbff; }}
.story-landscapers .demo-card {{ border-color: #cbead9; }}
.story-handymen .demo-card {{ border-color: #f0dfc8; }}
.story-house-cleaning .demo-card {{ border-color: #d8eef5; }}
.story-pressure-washing .demo-card {{ border-color: #cce7ff; }}
.story-roofing .demo-card {{ border-color: #dedede; }}
.story-painting .demo-card {{ border-color: #efd6f5; }}
.story-pool-service .demo-card {{ border-color: #cceef2; }}
@media (max-width: 760px) {{ .demo-strip {{ grid-template-columns: 1fr; }} .story-page {{ padding-top: 26px; }} }}
{end}
'''
if start in css and end in css:
    css = re.sub(re.escape(start) + r'.*?' + re.escape(end), block, css, flags=re.S)
else:
    css = css.rstrip() + '\n\n' + block
css_path.write_text(css, encoding='utf-8')

resources = ['review-request-email-templates','review-request-sms-templates','how-to-ask-for-google-reviews','best-time-to-ask-for-a-review']
urls = [SITE + '/']
urls += [SITE + f'/industries/{slug}/' for slug in order]
urls += [SITE + f'/resources/{slug}/' for slug in resources]
sitemap = ['<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for url in urls:
    sitemap += ['  <url>', f'    <loc>{url}</loc>', '  </url>']
sitemap.append('</urlset>')
Path('www/sitemap.xml').write_text('\n'.join(sitemap) + '\n', encoding='utf-8')
Path('www/robots.txt').write_text('User-agent: *\nAllow: /\n\nSitemap: https://reviewnudgeindustries.etal.solutions/sitemap.xml\n', encoding='utf-8')
PY

echo "Built 10 valuable, distinct ReviewNudge Industries pages and updated homepage, sitemap, robots, nav, and CSS."
