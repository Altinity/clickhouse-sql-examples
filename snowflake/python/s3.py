import pyarrow
import pyarrow.parquet as pq
from pyarrow import fs

table_name='CALL_CENTER'
parquet_file='data_0_0_0.snappy.parquet'
parquet_url='s3://bucket/path/data_0_0_0.snappy.parquet'
parquet_path='bucket/path/data_0_0_0.snappy.parquet'

def process():
    s3  = fs.S3FileSystem(region="us-east-1")
    with s3.open_input_file(parquet_path) as pf:
      #pqf = pq.ParquetFile(parquet_path, filesystem=s3)
      metadata = pq.read_metadata(pf)
    print(metadata)

if __name__ == '__main__':
    process()
