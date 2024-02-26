import csv
import sqlite3

conn = sqlite3.connect('asg4.db')
cur = conn.cursor()


with open('data/restaurants.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # 将字符串 'True'/'False' 转换为整数 1/0
        bool = 1 if row['GoodForKids'].lower() == 'true' else 0
        row['GoodForKids'] = bool
        if row['GoodForKids'] == 1:
            print(row['GoodForKids'])
        # insert into restaurants
        fields = ', '.join(row.keys())
        placeholders = ':' + ', :'.join(row.keys())
        sql = f'INSERT INTO restaurants ({fields}) VALUES ({placeholders})'
        # 使用字典直接作为参数执行 SQL 命令
        # cur.execute(sql, row)

conn.commit()
conn.close()
