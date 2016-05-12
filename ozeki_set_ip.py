import dnsclient
import argparse
import socket

#	args
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

if args.get("ozekiport"):
	ozeki_port = args["ozekiport"]
else:
	ozeki_port = 9501

dnsclient.set_ip(dns_ip, dns_port, "Ozeki", socket.gethostbyname(socket.gethostname()), ozeki_port)
