import pandas as pd
from pandas import DataFrame
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from sqlalchemy import (
    Column,
    PrimaryKeyConstraint,
    Table,
)

table_name='test_dataload'
parquet_file='data_0_0_0.snappy.parquet'
clickhouse_url='clickhouse+native://user:password@host:9440/default?secure=true'

def read_from_parquet_file():
    return pd.read_parquet(parquet_file, 'pyarrow')

def process():
    df = read_from_parquet_file()
    print(df.head())
    print("---columns---")
    print(df.columns)
    print("---dtypes---")
    print(df.dtypes)
    print("---info---")
    print(df.info())
    print("---schema---")
    write_to_db(df)

def write_to_db(df:DataFrame):
    engine = create_engine(clickhouse_url)
    with engine.connect() as connection:
        result = connection.execute("select version(), hostName()")
        for row in result:
            print(row)

    session = sessionmaker(bind=engine)()
    df.to_sql(table_name, con=engine, if_exists='append', index=False)

if __name__ == '__main__':
    process()
