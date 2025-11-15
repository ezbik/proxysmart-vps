#!/usr/bin/env python3

#!/usr/bin/env python3
import argparse
import socket
import time
import sys

def check_latency(host, port, num, warn_latency , crit_latency ):
    total_latency = 0
    res=[]
    for _ in range(num):
        start_time = time.time()
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        try:
            s.connect((host, port))
            msg='hi!\r\n'.encode()
            #print(f'=> {msg}')
            s.send( msg )
            msg = s.recv(4096)
            #print(f'<= {msg}')
            end_time = time.time()
            latency = round( (end_time - start_time) * 1000 )  # Convert to milliseconds
            total_latency += latency
        except socket.error as e:
            print(f"CRITICAL: Unable to connect to {host}:{port} - {e}")
            return 2  # Critical exit code
        res.append( latency )
    average_latency = round( total_latency / num )

    # Parse the warn and crit thresholds

    crit_latency=int(crit_latency)
    warn_latency=int(warn_latency)

    # Compare latency against thresholds
    if average_latency >= crit_latency :
        STATUS="CRITICAL"
        code=2  # Critical exit code
    elif average_latency >= warn_latency :
        STATUS="WARNING"
        code=1  # Warning exit code
    else:
        STATUS="OK"
        code=0  # OK exit code

    print(f"Latency {STATUS}. Average Latency to {host}:{port} is {average_latency} ms.\n  Results: {res}")
    return code

def main():
    parser = argparse.ArgumentParser(description="Nagios Plugin for latency measurement")
    parser.add_argument('-H', '--host', required=True, help='Host to check')
    parser.add_argument('-p', '--port', required=True, type=int, help='Port to check')
    parser.add_argument('-n', '--num', required=True, type=int, help='Number of times to check latency')
    parser.add_argument('-w', '--warn', required=True, type=int, help='Warning level: latency in ms')
    parser.add_argument('-c', '--critical', required=True, type=int, help='Critical level: latency in ms')

    args = parser.parse_args()

    exit_code = check_latency(args.host, args.port, args.num, args.warn, args.critical)
    sys.exit(exit_code)

if __name__ == "__main__":
    main()


