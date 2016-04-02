import argparse
import dnsclient
import socket

#	arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--dnsip", required=False, help="ip of dns")
ap.add_argument("-d", "--dnsport", required=False, help="port of dns")
ap.add_argument("-r", "--dbport", required=False, help="port of db")
args = vars(ap.parse_args())

if args.get("dnsip"):
	dns_ip = args["dnsip"]
else:
	dns_ip = "127.0.0.1"

if args.get("dnsport"):
	dns_port = int(args["dnsport"])
else:
	dns_port = 10000

if args.get("dbport"):
	db_port = args["dbport"]
else:
	db_port = 3000

dnsclient.set_ip(dns_ip, dns_port, "DBbackend", socket.gethostbyname(socket.gethostname()), db_port)

