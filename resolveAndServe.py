# File: simplehttpserver-example-1.py

import SimpleHTTPServer
import SocketServer

import dnsclient
import argparse

#	arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--dnsip", required=False, help="ip of dns")
ap.add_argument("-d", "--dnsport", required=False, help="port of dns")
ap.add_argument("-o", "--ozeki", required=False, help="port of ozeki")
args = vars(ap.parse_args())

if args.get("dnsip"):
	dns_ip = args["dnsip"]
else:
	dns_ip = "127.0.0.1"

if args.get("dnsport"):
	dns_port = int(args["dnsport"])
else:
	dns_port = 10000

if args.get("ozeki"):
	ozeki_port = args["ozeki"]
else:
	ozeki_port = 9501

#	get the IP of Ozeki server
ozeki_resolved = dnsclient.resolve_ip(dns_ip, dns_port, "Ozeki")
ozeki_resolved = ozeki_resolved.split(" ")
ozeki_IP_Port = ozeki_resolved[0] + ":" + ozeki_resolved[1]
print "Writing to file: " + ozeki_IP_Port
# Open a file
fo = open("OzekiIP.txt", "w")
fo.write(ozeki_IP_Port)
fo.close()


# minimal web server.  serves files relative to the
# current directory.

PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()

## $ python simplehttpserver-example-1.py
## serving at port 8000
## localhost - - [11/Oct/1999 15:07:44] code 403, message Directory listing
## not supported
## localhost - - [11/Oct/1999 15:07:44] "GET / HTTP/1.1" 403 -
## localhost - - [11/Oct/1999 15:07:56] "GET /samples/sample.htm HTTP/1.1" 200 -
