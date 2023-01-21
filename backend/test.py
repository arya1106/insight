import psycopg2
import os

conn = psycopg2.connect(os.environ["DATABASE_URL"], dbname="OSMP")

with conn.cursor() as curr:
    curr.execute("insert into osmp_schema.damage_nodes values (1, ST_SetSRID(ST_MakePoint(-71.3, 34.2), 4326), 1, 'asjf', 2)")
    conn.commit()
    curr.execute("select * from osmp_schema.damage_nodes")
    res = curr.fetchall()
    conn.commit()
    print(res)
    
