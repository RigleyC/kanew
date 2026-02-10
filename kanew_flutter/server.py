import os
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse


class SpaFallbackHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path

        # Serve existing files as-is. If the path doesn't exist, fall back to
        # index.html so Flutter's client-side router can handle deep links.
        translated = self.translate_path(path)
        if os.path.exists(translated):
            self.path = path
            return super().do_GET()

        self.path = "/index.html"
        return super().do_GET()

    def do_HEAD(self):
        parsed = urlparse(self.path)
        path = parsed.path

        translated = self.translate_path(path)
        if os.path.exists(translated):
            self.path = path
            return super().do_HEAD()

        self.path = "/index.html"
        return super().do_HEAD()


def main() -> None:
    port = int(os.environ.get("PORT", "8080"))

    # Serve from current working directory (where build/web is copied).
    server = ThreadingHTTPServer(("0.0.0.0", port), SpaFallbackHandler)
    print(f"Serving on 0.0.0.0:{port}")
    server.serve_forever()


if __name__ == "__main__":
    main()

