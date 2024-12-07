#!/usr/bin/python3 
# Simple HTTP server that can show it receives a POST request
# optionally using chunked transfer encoding. Based on an example
# here: https://stackoverflow.com/questions/60895110/how-to-handle-chunked-encoding-in-python-basehttprequesthandler.
from http.server import BaseHTTPRequestHandler, HTTPServer
import io

class MyHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"POST request received")

        if "Content-Length" in self.headers:
            content_length = int(self.headers["Content-Length"])
            body = self.rfile.read(content_length)
            print(body)
        elif "chunked" in self.headers.get("Transfer-Encoding", ""):
            while True:
                line = self.rfile.readline().strip()
                chunk_length = int(line, 16)

                if chunk_length != 0:
                    chunk = self.rfile.read(chunk_length)
                    print(chunk)

                # Each chunk is followed by an additional empty newline
                # that we have to consume.
                self.rfile.readline()

                # Finally, a chunk size of 0 is an end indication
                if chunk_length == 0:
                    break

httpd = HTTPServer(('', 9999), MyHandler)
httpd.serve_forever()
