import vitaldb
import pandas as pd
from scipy.io import savemat
import numpy as np
import os

# 1. Define Parameters and Case Selection
# Input (U): Norepinephrine Infusion Rate (from Orchestra pump)
NE_RATE_TRACK_NAME = 'Orchestra/NEPI_RATE' 
# Output (Y): Mean Arterial Pressure 
MAP_TRACK_NAME = 'Solar8000/ART_MBP' 
# List of tracks to load
track_names = [MAP_TRACK_NAME, NE_RATE_TRACK_NAME]
CASE_ID = 5478
# Define the sampling time
SAMPLE_INTERVAL = 1

# 2. Load and Process Data
print(f"Loading tracks from VitalDB Case ID: {CASE_ID}...")
print(f"Tracks: {track_names}")

# 2. Load and Process Data
data_array = vitaldb.load_case(
    CASE_ID,
    track_names,
    interval=SAMPLE_INTERVAL
)

# Check if data was loaded successfully
if data_array is None or len(data_array) == 0:
    print("\nFailed to load data or no data points found for these tracks.")
    print("This means the selected CASE_ID does not contain both signals. Please try another verified CASE_ID.")
else:
    print(f"\nSuccessfully loaded {len(data_array)} data points.")

# 3. Restructure the data in a matrix format
    # Create a Time array (T)
    # We generate a time vector based on the sample interval and data length
    data_points = len(data_array)
    T = np.arange(0, data_points * SAMPLE_INTERVAL, SAMPLE_INTERVAL).reshape(-1, 1)

    # Extract MAP and NOR values
    mean_arterial_pressure = data_array[:, 0]
    norepinephrine_rate = data_array[:, 1]

# 4. Save to MATLAB .mat file 
    # Define the data structure for MATLAB
    folder_name = "nor_map_cases"
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)
        
    mat_data = {
        'T': T,                                              # Time vector (s)
        'Y_MAP': mean_arterial_pressure.reshape(-1, 1),      # Output: Mean Arterial Pressure (mmHg)
        'U_NE': norepinephrine_rate.reshape(-1, 1),          # Input: Norepinephrine Rate (mL/hr)
        'track_info': f"Data extracted from VitalDB Case {CASE_ID}. Ts={SAMPLE_INTERVAL}s. Y={MAP_TRACK_NAME}, U={NE_RATE_TRACK_NAME}."
    }
    # Save the dataset as a MATLAB file
    filename = os.path.join(folder_name, f"vitaldb_case_{CASE_ID}.mat")
    savemat(filename, mat_data, do_compression=True)

    print(f"\nData extraction complete. File saved: **{filename}**")
    print(f"This file can be loaded in Matlab using: load('{filename}')")