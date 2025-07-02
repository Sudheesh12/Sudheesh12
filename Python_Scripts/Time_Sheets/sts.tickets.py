import pandas as pd
from datetime import time

# === Load the CSV ===
df = pd.read_csv(r'D:\Sudheesh12\Pyhton_Scripts\Time_Sheets\STS_tickets.csv', encoding='latin1')

# === Convert 'Created' to datetime (in IST) ===
df['opened_at'] = pd.to_datetime(df['Created'], errors='coerce')  # Parse datetime safely

# === Function to determine shift ===
def get_shift(dt):
    if pd.isna(dt):
        return 'Unknown'
    t = dt.time()
    if time(6, 30) <= t < time(15, 30):
        return 'A SHIFT'
    elif time(13, 0) <= t < time(22, 0):
        return 'B SHIFT'
    else:
        return 'C SHIFT'

# === Apply shift function ===
df['shift'] = df['opened_at'].apply(get_shift)

# === Export to Excel ===
output_file = r'D:\Sudheesh12\Pyhton_Scripts\Time_Sheets\sts_tickets_with_shifts.xlsx'
with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
    df.to_excel(writer, sheet_name='Shift Report', index=False)
