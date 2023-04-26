#!/usr/bin/env python3
import sys
import pprint
from math import sqrt
# import matplotlib.pyplot as plt

plan_metrics = {
    'Grounding Time': [],
    '|F|': [],
    '|X|': [],
    '|A|': [],
    '|P|': [],
    '|E|': [],
    'Metric (Search)': [],
    'Planning Time (msec)': [],
    'Heuristic Time (msec)': [],
    'Search Time (msec)': [],
    'Expanded Nodes': [],
    'States Evaluated': [],
    'Number of Dead-Ends detected': [],
    'Number of Duplicates detected': []
}

mean_dict = {}
mean_squared_error_dict = {}

filename = sys.argv[1]
plan_file = open(filename, 'r')

observations = 0

for line in plan_file:
    for metric in plan_metrics.keys():
        if line.startswith(metric):
            val = float(line.split(':')[1])
            plan_metrics[metric].append(float(line.split(':')[1]))
    if "-------------------" in line:
        observations += 1

for metric in plan_metrics.keys():
    # calculate the mean of every metric key
    mean_dict[metric] = sum(plan_metrics[metric]) / len(plan_metrics[metric])
    # Mean squared error
    mean_squared_error_dict[metric] = 0
    for data in plan_metrics[metric]:
        mean_squared_error_dict[metric] += (data - mean_dict[metric]) ** 2
    mean_squared_error_dict[metric] = sqrt(mean_squared_error_dict[metric] / len(plan_metrics[metric]))

# Print the results
print("\n")
print("Number of observations: ", observations)
print("")
print('Mean values: ')
pprint.pprint(mean_dict)
print("\n")
print("Standard Deviation values: ")
pprint.pprint(mean_squared_error_dict)

# xm, ym = zip(*sorted(mean_dict.items()))
# plt.plot(xm, ym)
# plt.xticks(rotation='vertical')
# plt.show()

# xsq, ysq = zip(*sorted(mean_squared_error_dict.items()))
# plt.plot(xsq, ysq)
# plt.xticks(rotation='vertical')
# plt.show()
