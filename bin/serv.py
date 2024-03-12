#!/usr/bin/env python
# -*- coding: utf-8 -*-
# python >= 3.6

# TODO: implement new class to allow forced stop
import sys
import http.server
import socketserver

class SimpleHTTPRequestHandlerNoCache(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.no_cache_headers()
        http.server.SimpleHTTPRequestHandler.end_headers(self)

    def no_cache_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")


if __name__ == '__main__':
    if sys.argv[1:]:
        PORT = int(sys.argv[1])
    else:
        PORT = 9091
    # Handler = http.server.SimpleHTTPRequestHandler # Default
    Handler = SimpleHTTPRequestHandlerNoCache

    Handler.extensions_map={
        '.css': 'text/css',
        '.html': 'text/html',
        '.jpg': 'image/jpg',
        '.js': 'application/x-javascript',
        '.manifest': 'text/cache-manifest',
        '.png': 'image/png',
        '.svg': 'image/svg+xml',
        '.webapp': 'application/x-web-app-manifest+json',
        '': 'application/octet-stream', # Default
    }
    httpd = socketserver.TCPServer(("", PORT), Handler)

    print("Server started at http://localhost:" + str(PORT))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("Stopping http server...")
        httpd.shutdown()
        httpd.server_close()
