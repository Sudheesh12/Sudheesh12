import pandas as pd
import pytz
from datetime import time

# === Load the CSV ===
df = pd.read_csv(r'D:\Sudheesh12\Pyhton_Scripts\Time_Sheets\tickets.csv', encoding='latin1')


# === Convert 'opened_at' to datetime ===
df['opened_at'] = pd.to_datetime(df['opened_at'])

# === Timezone Conversion: PST to IST (and remove timezone info) ===
pst = pytz.timezone('US/Pacific')
ist = pytz.timezone('Asia/Kolkata')
df['opened_at'] = df['opened_at'].dt.tz_localize(pst).dt.tz_convert(ist).dt.tz_localize(None)

# === Function to determine shift ===
def get_shift(dt):
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
output_file = r'D:\Sudheesh12\Pyhton_Scripts\Time_Sheets\tickets_with_shifts.xlsx'
with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
    df.to_excel(writer, sheet_name='Shift Report', index=False)
