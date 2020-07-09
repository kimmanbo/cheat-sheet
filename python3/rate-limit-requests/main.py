import argparse
import sys
import signal
import time
import multiprocessing

from concurrent.futures import ProcessPoolExecutor

import requests # pip install requests

def signal_handler(signal, frame):
    sys.exit(0)

def request(params):
    domain = "http://target-domain.com" + params
    response = requests.get(domain)

    if response.status_code != 200:
        print("[ERR][REQUEST] Return code not 200: ({})".format(response.status_code))

def main(args):
    signal.signal(signal.SIGINT, signal_handler)

    # Use ProcessPoolExecutor for high rate requests
    executor = ProcessPoolExecutor(max_workers=multiprocessing.cpu_count)

    count = 0
    anchor_time = time.time()

    # Set break point in the loop by your needs
    while True:
        params = "/your/request/parameters"
        executor.submit(request, params)

        count += 1

        # Token Bucket method may better for distribute requets widely for small time frame.
        # Below method still works.
        if count == 100:
            curr_time = time.time()
            time_spent = curr_time - anchor_time
            sleep_time = (100 / int(args.qps)) - time_spent
            if sleep_time > 0:
                time.sleep(sleep_time)
            count = 0
            anchor_time = time.time()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Rate Limit Requests Sample")

    required = parser.add_argument_group('required_argument')
    required.add_argument(
        "-q",
        "--qps",
        help="QPS",
        required=True
    )

    args = parser.parse_args()

    main(args)
