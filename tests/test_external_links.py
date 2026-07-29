from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit
import unittest


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "www"
SITE_HOST = "reviewnudgeindustries.etal.solutions"


class LinkParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.anchors = []

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            self.anchors.append(dict(attrs))


class ExternalLinkTests(unittest.TestCase):
    def test_external_links_open_safely_in_a_new_tab(self):
        checked = 0

        for path in SITE.rglob("*.html"):
            parser = LinkParser()
            parser.feed(path.read_text(encoding="utf-8"))

            for anchor in parser.anchors:
                destination = urlsplit(anchor.get("href", ""))
                if destination.scheme not in {"http", "https"} or destination.hostname == SITE_HOST:
                    continue

                checked += 1
                with self.subTest(path=path.relative_to(ROOT), href=anchor["href"]):
                    self.assertEqual(anchor.get("target"), "_blank")
                    rel = set(anchor.get("rel", "").split())
                    self.assertTrue({"noopener", "noreferrer"}.issubset(rel))

        self.assertGreater(checked, 0)


if __name__ == "__main__":
    unittest.main()
