#!/usr/bin/python3 
# Simple HTTP server that can show it receives a POST request. 
from http.server import BaseHTTPRequestHandler, HTTPServer
import io

class MyHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"POST request received")
        self.post_data = self.rfile.read(int(self.headers['Content-Length']))
        print(self.post_data)

httpd = HTTPServer(('', 9999), MyHandler)
httpd.serve_forever()
