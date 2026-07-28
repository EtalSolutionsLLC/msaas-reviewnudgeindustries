#!/usr/bin/env bash
set -euo pipefail

cd "${1:-.}"

if [ ! -d www ]; then
  echo "ERROR: run this from the ReviewNudge Industries repo root, or pass the repo path as the first argument." >&2
  exit 1
fi

mkdir -p 'www/resources'
cat > 'www/resources/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Resources | ReviewNudge Industries</title>
  <meta name="description" content="A directory of review management resources, templates, response examples, and follow-up guides for local service businesses.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"CollectionPage",
    "name":"ReviewNudge Industries Resources",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/",
    "description":"A directory of review management resources for local service businesses."
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
  <section class="directory-hero resources-hub-hero">
    <div>
      <div class="eyebrow">Review management resources</div>
      <h1>Resources</h1>
      <p class="lead compact-lead">A directory of practical review-request guides, templates, response examples, and follow-up ideas for local service businesses.</p>
    </div>
  </section>
  <section class="directory-section resources-directory" aria-labelledby="resources-directory-title">
    <h2 id="resources-directory-title" class="visually-hidden">Resource directory</h2>
    <div class="resource-list-grid">
      <article class="resource-list-card">
        <a href="/resources/review-request-email-templates/">
          <span class="resource-type">Resource</span>
          <h3>Review Request Email Templates</h3>
          <p>Copy-ready email examples for polite review requests after completed service work.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/review-request-sms-templates/">
          <span class="resource-type">Resource</span>
          <h3>Review Request SMS Templates</h3>
          <p>Short, respectful text-message examples for asking customers to leave a review.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/how-to-ask-for-google-reviews/">
          <span class="resource-type">Resource</span>
          <h3>How To Ask for Google Reviews</h3>
          <p>A practical guide to asking for Google reviews without sounding pushy.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/best-time-to-ask-for-a-review/">
          <span class="resource-type">Resource</span>
          <h3>Best Time To Ask for a Review</h3>
          <p>When service businesses should ask so the request feels natural and timely.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/how-many-reviews-does-a-local-business-need/">
          <span class="resource-type">Resource</span>
          <h3>How Many Reviews Does a Local Business Need?</h3>
          <p>A practical guide to how many reviews local service businesses need before reviews start helping with trust, clicks, and customer confidence.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/google-review-qr-codes/">
          <span class="resource-type">Resource</span>
          <h3>Google Review QR Codes for Service Businesses</h3>
          <p>How local service businesses can use Google review QR codes without making the review request feel awkward or impersonal.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/how-to-respond-to-positive-reviews/">
          <span class="resource-type">Resource</span>
          <h3>How To Respond to Positive Reviews</h3>
          <p>A practical guide for local service businesses responding to positive Google reviews without sounding canned or robotic.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/how-to-respond-to-negative-reviews/">
          <span class="resource-type">Resource</span>
          <h3>How To Respond to Negative Reviews</h3>
          <p>A calm, practical guide for local service businesses responding to negative reviews without escalating the situation.</p>
        </a>
      </article>
      <article class="resource-list-card">
        <a href="/resources/review-request-follow-up-templates/">
          <span class="resource-type">Resource</span>
          <h3>Review Request Follow-Up Templates</h3>
          <p>Copy-ready follow-up examples for local service businesses that want to ask for reviews politely without chasing customers.</p>
        </a>
      </article>
    </div>
  </section>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

mkdir -p 'www/resources/how-many-reviews-does-a-local-business-need'
cat > 'www/resources/how-many-reviews-does-a-local-business-need/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>How Many Reviews Does a Local Business Need? | ReviewNudge Industries</title>
  <meta name="description" content="A practical guide to how many reviews local service businesses need before reviews start helping with trust, clicks, and customer confidence.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/how-many-reviews-does-a-local-business-need/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"How Many Reviews Does a Local Business Need?",
    "description":"A practical guide to how many reviews local service businesses need before reviews start helping with trust, clicks, and customer confidence.",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/how-many-reviews-does-a-local-business-need/",
    "publisher":{"@type":"Organization","name":"ReviewNudge Industries"}
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / How Many Reviews Does a Local Business Need?</div>
    <div class="eyebrow">Review count strategy</div>
    <h1>How Many Reviews Does a Local Business Need?</h1>
    <p class="lead">There is no magic review count that makes a local business trusted overnight. A better goal is to build enough recent, specific reviews that a stranger can understand what kind of service experience to expect.</p>
  </section>
  <section class="resource-section">
    <h2>A useful review count depends on the buying decision</h2>
    <p>A customer choosing a roofer, plumber, HVAC company, or cleaner is not only counting stars. The customer is looking for proof that the business has helped people in similar situations. A small business does not need thousands of reviews to look credible, but it does need enough recent detail to reduce hesitation.</p>
  </section>
  <section class="resource-section">
    <h2>Recent reviews matter more than old volume</h2>
    <p>A business with older reviews can still look established, but recent reviews show that the business is active and consistent now. ReviewNudge should help the business avoid long quiet gaps by making review follow-up part of the service rhythm.</p>
  </section>
  <section class="resource-section">
    <h2>Different industries need different signals</h2>
    <p>Emergency trades benefit from reviews that mention response and clarity. Recurring services benefit from reviews that mention consistency. High-ticket services benefit from reviews that mention communication, cleanup, and trust.</p>
  </section>
  <section class="resource-section">
    <h2>A practical operating target</h2>
    <p>Instead of chasing a single number, aim for a steady stream: a few new reviews each month, spread across different job types, from customers who can describe real service moments.</p>
  </section>
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>If everything went well, would you mind leaving a quick review about your experience? It helps future customers understand what to expect from our local team.</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </section>
</article>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

mkdir -p 'www/resources/google-review-qr-codes'
cat > 'www/resources/google-review-qr-codes/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Google Review QR Codes for Service Businesses | ReviewNudge Industries</title>
  <meta name="description" content="How local service businesses can use Google review QR codes without making the review request feel awkward or impersonal.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/google-review-qr-codes/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"Google Review QR Codes for Service Businesses",
    "description":"How local service businesses can use Google review QR codes without making the review request feel awkward or impersonal.",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/google-review-qr-codes/",
    "publisher":{"@type":"Organization","name":"ReviewNudge Industries"}
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / Google Review QR Codes for Service Businesses</div>
    <div class="eyebrow">QR code review strategy</div>
    <h1>Google Review QR Codes for Service Businesses</h1>
    <p class="lead">A QR code can make leaving a review easier, but it should not replace a thoughtful request. The QR code is the shortcut. The service experience is still the reason someone responds.</p>
  </section>
  <section class="resource-section">
    <h2>Use QR codes at the right moment</h2>
    <p>QR codes work best after the customer has seen the result and understands what was completed. A card, invoice, leave-behind, or follow-up note can include the code, but the ask should still feel personal.</p>
  </section>
  <section class="resource-section">
    <h2>Do not make the QR code the whole strategy</h2>
    <p>A QR code sitting on a counter does not create a review habit. The business still needs a process for deciding who to ask, when to ask, and whether a polite reminder is appropriate.</p>
  </section>
  <section class="resource-section">
    <h2>Pair QR codes with service-specific wording</h2>
    <p>A cleaning company, roofer, electrician, and pool service company should not use exactly the same request. The QR code can be the same mechanism, while the message changes based on the job.</p>
  </section>
  <section class="resource-section">
    <h2>Track the request, not just the link</h2>
    <p>The operational problem is usually not generating the review link. The problem is remembering who was asked, what was sent, and whether follow-up is still pending.</p>
  </section>
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>Thanks again for choosing us. If the service was helpful, you can scan this code to leave a quick Google review. It helps other local customers find reliable help.</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </section>
</article>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

mkdir -p 'www/resources/how-to-respond-to-positive-reviews'
cat > 'www/resources/how-to-respond-to-positive-reviews/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>How To Respond to Positive Reviews | ReviewNudge Industries</title>
  <meta name="description" content="A practical guide for local service businesses responding to positive Google reviews without sounding canned or robotic.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/how-to-respond-to-positive-reviews/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"How To Respond to Positive Reviews",
    "description":"A practical guide for local service businesses responding to positive Google reviews without sounding canned or robotic.",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/how-to-respond-to-positive-reviews/",
    "publisher":{"@type":"Organization","name":"ReviewNudge Industries"}
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / How To Respond to Positive Reviews</div>
    <div class="eyebrow">Positive review response guide</div>
    <h1>How To Respond to Positive Reviews</h1>
    <p class="lead">A positive review is not the end of the customer interaction. A thoughtful response reinforces trust for the person who left the review and for the next customer reading it.</p>
  </section>
  <section class="resource-section">
    <h2>A good response sounds like a person</h2>
    <p>Thank the customer directly, mention the type of work when appropriate, and keep the response short. The goal is not to write a speech. The goal is to show that the business pays attention.</p>
  </section>
  <section class="resource-section">
    <h2>Specific beats generic</h2>
    <p>A reply that says “Thanks for trusting us with the water heater replacement” is stronger than “Thanks for the review.” Specificity helps future customers connect the review to their own need.</p>
  </section>
  <section class="resource-section">
    <h2>Do not overdo the keywords</h2>
    <p>Review responses can naturally mention services, but stuffing keywords into every response makes the business sound less trustworthy. Use plain language first.</p>
  </section>
  <section class="resource-section">
    <h2>Use positive reviews as operational feedback</h2>
    <p>Positive reviews tell the business what customers notice: communication, cleanup, punctuality, transformation, reliability, or comfort restored. Those details can shape future review requests.</p>
  </section>
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>Thank you for the kind review. We are glad the service visit went smoothly and appreciate you taking the time to share your experience with our local team.</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </section>
</article>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

mkdir -p 'www/resources/how-to-respond-to-negative-reviews'
cat > 'www/resources/how-to-respond-to-negative-reviews/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>How To Respond to Negative Reviews | ReviewNudge Industries</title>
  <meta name="description" content="A calm, practical guide for local service businesses responding to negative reviews without escalating the situation.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/how-to-respond-to-negative-reviews/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"How To Respond to Negative Reviews",
    "description":"A calm, practical guide for local service businesses responding to negative reviews without escalating the situation.",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/how-to-respond-to-negative-reviews/",
    "publisher":{"@type":"Organization","name":"ReviewNudge Industries"}
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / How To Respond to Negative Reviews</div>
    <div class="eyebrow">Negative review response guide</div>
    <h1>How To Respond to Negative Reviews</h1>
    <p class="lead">A negative review is public, but the response should not become a public argument. The best response is calm, brief, accountable where appropriate, and focused on moving the issue to a direct conversation.</p>
  </section>
  <section class="resource-section">
    <h2>Do not argue with the reviewer</h2>
    <p>Future customers are watching the response as much as the complaint. A defensive response can make the business look harder to work with, even when the business has context the review does not include.</p>
  </section>
  <section class="resource-section">
    <h2>Acknowledge without over-admitting</h2>
    <p>It is possible to acknowledge concern without making detailed public admissions. Keep the response respectful and invite direct contact when appropriate.</p>
  </section>
  <section class="resource-section">
    <h2>Protect private details</h2>
    <p>Avoid discussing customer details, invoices, addresses, disputes, or private service history in the public response. The goal is to show professionalism, not litigate the job in public.</p>
  </section>
  <section class="resource-section">
    <h2>Use the pattern as a process signal</h2>
    <p>One negative review may be an outlier. Repeated themes may reveal a real workflow issue: arrival windows, cleanup, communication, quoting, or follow-up.</p>
  </section>
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>Thank you for sharing this. We are sorry the experience did not meet expectations. Please contact us directly so we can better understand what happened and look for a practical next step.</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </section>
</article>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

mkdir -p 'www/resources/review-request-follow-up-templates'
cat > 'www/resources/review-request-follow-up-templates/index.html' <<'EOF_HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Review Request Follow-Up Templates | ReviewNudge Industries</title>
  <meta name="description" content="Copy-ready follow-up examples for local service businesses that want to ask for reviews politely without chasing customers.">
  <link rel="canonical" href="https://reviewnudgeindustries.etal.solutions/resources/review-request-follow-up-templates/">
  <link rel="stylesheet" href="/styles.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Article",
    "headline":"Review Request Follow-Up Templates",
    "description":"Copy-ready follow-up examples for local service businesses that want to ask for reviews politely without chasing customers.",
    "url":"https://reviewnudgeindustries.etal.solutions/resources/review-request-follow-up-templates/",
    "publisher":{"@type":"Organization","name":"ReviewNudge Industries"}
  }
  </script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<header class="site-header">
  <nav class="nav" aria-label="Primary navigation">
    <a class="brand" href="/">ReviewNudge <span>Industries</span></a>
    <div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </nav>
</header>
<main id="main">
<article class="resource-page">
  <section class="resource-hero">
    <div class="breadcrumb"><a href="/">Home</a> / <a href="/resources/">Resources</a> / Review Request Follow-Up Templates</div>
    <div class="eyebrow">Follow-up template library</div>
    <h1>Review Request Follow-Up Templates</h1>
    <p class="lead">The follow-up is where many businesses get awkward. A good reminder is short, optional, and respectful. One gentle nudge is usually enough.</p>
  </section>
  <section class="resource-section">
    <h2>The one-reminder rule</h2>
    <p>A follow-up should make the review easier to complete, not make the customer feel pursued. For most local service businesses, one polite reminder is the right default.</p>
  </section>
  <section class="resource-section">
    <h2>Tie the reminder to the job</h2>
    <p>A reminder that references the completed service feels more human than a generic automation message. Mention the repair, cleanup, installation, tune-up, or project when possible.</p>
  </section>
  <section class="resource-section">
    <h2>Use different language for different service types</h2>
    <p>A roofer should not sound exactly like a cleaner. A handyman should not sound exactly like an HVAC company. The best follow-up sounds like the business and the job.</p>
  </section>
  <section class="resource-section">
    <h2>Keep the door open without pressure</h2>
    <p>The customer should feel free to ignore the request. That makes the ask more respectful and protects the relationship.</p>
  </section>
  <section class="sample-request">
    <h2>Reusable example</h2>
    <div class="callout"><p>Just a quick follow-up from our team. If the service was helpful and you have a minute, your review would mean a lot: [Review Link]</p></div>
  </section>
  <section class="story-cta">
    <div class="cta-band">
      <div><h2>Make review follow-up easier to remember.</h2><p>ReviewNudge keeps requests, customer status, and follow-up organized without turning reviews into a marketing platform project.</p></div>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>
  </section>
</article>
</main>
<footer class="site-footer">
  <div class="footer-inner">
    <div><strong>ReviewNudge Industries</strong><br>Review management guides for local service businesses.</div>
    <div><a href="https://reviewnudge.etal.solutions">About ReviewNudge</a> &middot; <a href="/resources/">Resources</a> &middot; <a href="/sitemap.xml">Sitemap</a></div>
  </div>
</footer>
</body>
</html>
EOF_HTML

python3 <<'PY'
from pathlib import Path
import re
NAV = '''<div class="nav-links">
      <a href="/resources/">Resources</a>
      <a href="https://reviewnudge.etal.solutions">About ReviewNudge</a>
      <a class="btn btn-primary" href="https://reviewnudge.etal.solutions/setup">Try ReviewNudge</a>
    </div>'''
for path in Path('www').rglob('*.html'):
    text = path.read_text(encoding='utf-8', errors='ignore')
    text = re.sub(r'<div class="nav-links">.*?</div>', NAV, text, count=1, flags=re.S)
    text = text.replace('href="https://reviewnudge.etal.solutions/billing"', 'href="https://reviewnudge.etal.solutions/setup"')
    path.write_text(text, encoding='utf-8')
css_path=Path('www/styles.css')
css=css_path.read_text(encoding='utf-8', errors='ignore') if css_path.exists() else ''
start='/* RN resource cluster start */'
end='/* RN resource cluster end */'
block='''/* RN resource cluster start */
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
    css=re.sub(re.escape(start)+r'.*?'+re.escape(end), block, css, flags=re.S)
else:
    css=css.rstrip()+'

'+block+'
'
css_path.write_text(css, encoding='utf-8')
site='https://reviewnudgeindustries.etal.solutions'
industry_slugs=['plumbers', 'hvac', 'electricians', 'landscapers', 'handymen', 'house-cleaning', 'pressure-washing', 'roofing', 'painting', 'pool-service']
resource_slugs=['review-request-email-templates', 'review-request-sms-templates', 'how-to-ask-for-google-reviews', 'best-time-to-ask-for-a-review', 'how-many-reviews-does-a-local-business-need', 'google-review-qr-codes', 'how-to-respond-to-positive-reviews', 'how-to-respond-to-negative-reviews', 'review-request-follow-up-templates']
urls=[site+'/']+[site+f'/industries/{s}/' for s in industry_slugs]+[site+'/resources/']+[site+f'/resources/{s}/' for s in resource_slugs]
xml=['<?xml version="1.0" encoding="UTF-8"?>','<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for url in urls:
    xml += ['  <url>', f'    <loc>{url}</loc>', '  </url>']
xml.append('</urlset>')
Path('www/sitemap.xml').write_text('
'.join(xml)+'
', encoding='utf-8')
Path('www/robots.txt').write_text('User-agent: *
Allow: /

Sitemap: https://reviewnudgeindustries.etal.solutions/sitemap.xml
', encoding='utf-8')
PY

echo "Added Resources hub, 5 resource-cluster pages, nav Resources link, sitemap, robots, and CSS."
