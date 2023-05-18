import pyarrow
import pyarrow.parquet as pq
from pyarrow import fs

table_name='CALL_CENTER'
parquet_file='data_0_0_0.snappy.parquet'
parquet_url='s3://bucket/path/data_0_0_0.snappy.parquet'
parquet_path='bucket/path/MIGRATION/CUSTOMER/'

def process():
    # Open up parquet ds on s3.
    s3 = fs.S3FileSystem(region="us-east-1")
    ds = pq.ParquetDataset(parquet_path, filesystem=s3)
    # Print arrow schema
    print(ds.schema)
    # Grab first fragment and read metadata.
    pq_fragment = ds.fragments[0]
    print(pq_fragment.metadata)

if __name__ == '__main__':
    process()
