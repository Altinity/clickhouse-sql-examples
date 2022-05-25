import pandas as pd
from pandas import DataFrame
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

table_name='registration'
parquet_file='userdata1.parquet'
clickhouse_url='clickhouse://root:root@localhost/test'

def read_from_parquet_file():
    return pd.read_parquet(parquet_file, 'pyarrow')

def process():
    df = read_from_parquet_file()
    print(df)
    print(df.columns)
    write_to_db(df)

def write_to_db(df:DataFrame):
    engine = create_engine(clickhouse_url)
    session = sessionmaker(bind=engine)()
    df.to_sql(table_name, con=engine, if_exists='append', index=False)

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    process()
