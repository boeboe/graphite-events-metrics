#!/usr/bin/env python

from sys import argv
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import pickle
import time
import socket
import struct

class RequestHandler(BaseHTTPRequestHandler):
    print('WTF!!!!', flush=True)

    def do_POST(self):
        print('Data reived', flush=True)
        content_len = int(self.headers['content-length'])
        post_body = self.rfile.read(content_len)
        data = json.loads(post_body)
        pickle_tuples = self.find_numerical_data(data, "bigip", ([]), time.time())
        self.send_pickle(pickle_tuples)
        self.send_response(200)
        self.end_headers()
        return

    def find_numerical_data(self, data, path, tuples, timestamp):
        for (key, value) in data.items():
            if isinstance(value, int):
                tuples.append((self.clean_path(path + '.' + key), (timestamp, value)))
            elif isinstance(value, dict):
                self.find_numerical_data(value, path + '.' + key, tuples, timestamp)
            else:
                pass
        return tuples

    def clean_path(self, path):
        """Transform path."""
        return path.replace('/', '.').replace('..', '.')

    def send_pickle(self, tuples):
        package = pickle.dumps(tuples, 1)
        size = struct.pack('!L', len(package))
        sock = socket.socket()
        sock.connect((GRAPHITE_ADDRESS, GRAPHITE_PICKLE_PORT))
        sock.sendall(size)
        sock.sendall(package)
        sock.shutdown(socket.SHUT_RDWR)
        sock.close()
        print('Data sent', flush=True)

if __name__ == '__main__':

    if len(argv) == 3:
        GRAPHITE_ADDRESS = str(argv[1])
        GRAPHITE_PICKLE_PORT = int(argv[2])
        print("GRAPHITE_ADDRESS     : {}".format(GRAPHITE_ADDRESS), flush=True)
        print("GRAPHITE_PICKLE_PORT : {}".format(GRAPHITE_PICKLE_PORT), flush=True)
    else:
        print("Missing arguments. Try jsontopickle.py <GRAPHITE_ADDRESS> <GRAPHITE_PICKLE_PORT>", flush=True)

    SERVER = HTTPServer(('0.0.0.0', 8000), RequestHandler)
    print('Starting server at http://localhost:8000', flush=True)
    SERVER.serve_forever()
