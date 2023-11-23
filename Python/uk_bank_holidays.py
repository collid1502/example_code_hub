import pandas as pd
import numpy as np
import datetime
import holidays 

# create list of all years 
years_ = [] 
start =2022 
while start <= 2024:
    years_.append(start)
    start = start + 1

# print future UK bank holidays 
uk_bank_hols = {}
for date in holidays.UnitedKingdom(years=years_).items():
    uk_bank_hols[str(date[0])] = str(date[1])
    
# convert to DF 
uk_bank_holidays = pd.DataFrame(uk_bank_hols.items(), columns=['Date', 'Holiday'])
uk_bank_holidays.sample(5) 

# create DF holding all days between 2022 to 2099 
start_date = datetime.datetime(year=2022, month=1, day=1)
end_date = datetime.datetime(year=2099, month=12, day=31) 
dates_df = pd.DataFrame() 
dates_df['Dates_hold'] = pd.date_range(start_date, end_date) 
dates_df['Date'] = dates_df['Dates_hold'].dt.strftime('%Y-%m-%d') 
dates_df = dates_df.drop('Dates_hold', 1) 

# sample it 
dates_df.sample(5) 
    
# merge the dataframes
new_df = pd.merge(dates_df, uk_bank_holidays, on='Date', how='outer') 

new_df['day_of_week'] = (pd.to_datetime(new_df['Date'])).dt.dayofweek
new_df['day'] = (pd.to_datetime(new_df['Date'])).dt.day_name() 
 

# flag working day or not with a Y or N based on a holiday, or being saturday or sunday 
conditions = [
    (new_df['day'] == 'Saturday') & (new_df['day'] == 'Sunday'),
    (new_df['Holiday'].notnull()) 
]
values = ['N', 'N'] 
new_df['workday'] = np.select(conditions, values, default='Y') 

# output new data frame 
new_df.head(10) 

# send to Excel
new_df.to_excel('UK_bank_holidays.xlsx', sheet_name='UK Bank Holidays', index=False)

# end 