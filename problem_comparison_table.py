#!/usr/bin/env python3
import os
import pandas as pd
import ast
import re
from tabulate import tabulate

# Set the directory
directory = './generated_metrics/'

# Get all file names in the directory that end with 'sat-hadd.txt'
file_names = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f)) and f.endswith('sat-hadd.txt')]

# Sort the file names based on the problem name
file_names.sort(key=lambda x: re.search(r'_(\w+)_sat-hadd', x).group(1))

optimizer_data_list = []

# Iterate over the file names in the directory
for file_name in file_names:
    with open(os.path.join(directory, file_name), 'r') as file:
        lines = file.readlines()

    # Extract the problem name from the file name
    problem_name = re.search(r'_(\w+)_sat-hadd', file_name).group(1)

    # Dictionary to store the optimizer data, starting with the problem name
    optimizer_data = {'Optimizer': problem_name}

    # Function to extract the mean and standard deviation values
    def extract_values(lines, keyword):
        values_lines = []
        # Find the line with the keyword
        for i, line in enumerate(lines):
            if keyword in line:
                j = i + 1
                while j < len(lines) and '}' not in lines[j]:
                    values_lines.append(lines[j].strip())
                    j += 1
                values_lines.append(lines[j].strip())
                break
        values_str = ''.join(values_lines)
        return ast.literal_eval(values_str)

    # Extract the mean and standard deviation values
    mean_values = extract_values(lines, 'Mean values:')
    std_dev_values = extract_values(lines, 'Standard Deviation values:')

    for key, value in mean_values.items():
        # Get the corresponding standard deviation value for the current key
        std_dev_value = std_dev_values[key]
        if std_dev_value != 0.0:
            optimizer_data[key] = f"{round(value, 2)} +/- {round(std_dev_value, 2)}"
        else:
            optimizer_data[key] = round(value, 2)

    optimizer_data_list.append(optimizer_data)

# Create a dataframe from the optimizer data list
df = pd.DataFrame(optimizer_data_list)
# Transpose the dataframe and rename the columns
df = df.transpose()
# Rename the columns to the problem names
df = df.rename(columns=df.loc['Optimizer']).drop('Optimizer')
print(df.to_string())

# Save the beautified table to CSV file
csv_table = tabulate(df, headers='keys', tablefmt='tsv', numalign='right')
with open('metric_table_problems.csv', 'w') as f:
    f.write(csv_table)

# Save the original table as a CSV file
df.to_csv('optimizer_data_table.csv', index=True)
