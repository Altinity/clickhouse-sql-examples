import os
import pyarrow
import pyarrow.fs as fs
import pyarrow.parquet as pq
import re

def pq_to_ch_type(pq_type):
    """Convert parquet schema type to ClickHouse column definition"""
    if pq_type.logical_type.type == "DECIMAL":
        length = pq_type.length
        precision = pq_type.precision
        scale = pq_type.scale
        if (scale != 0):
            ch_type = "Decimal({0}, {1})".format(precision, scale)
        elif (length <= 2):
            ch_type = "Int16"
        elif (length <= 4):
            ch_type = "Int32"
        elif (length <= 8):
            ch_type = "Int64"
        elif (length <= 16):
            ch_type = "Int128"
        else:
            ch_type = "Int256"

    elif pq_type.logical_type.type == "INT" and pq_type.physical_type == "INT32":
        ch_type = "Int32"

    elif pq_type.logical_type.type == "STRING":
        ch_type = "String"

    elif pq_type.logical_type.type == "DATE":
        ch_type = "Date"

    elif pq_type.logical_type.type == "NONE" and pq_type.physical_type == "BOOLEAN":
        ch_type = "Bool"

    elif pq_type.logical_type.type == "NONE" and pq_type.physical_type == "DOUBLE":
        ch_type = "Float64"

    elif pq_type.logical_type.type == "NONE" and pq_type.physical_type == "INT32":
        ch_type = "Int32"

    elif pq_type.logical_type.type == "NONE" and pq_type.physical_type == "INT64":
        ch_type = "Int64"

    elif pq_type.logical_type.type == "NONE" and pq_type.physical_type == "INT96":
        ch_type = "DateTime64"

    else:
        print(pq_type, type(pq_type))
        raise Exception(f"Unknown type: {pq_type}")

    return ch_type

def pq_columns_to_ch_columns(parquet_metadata):
    """Scan Parquet schema and return a list of ClickHouse column definitions"""
    arrow_schema = parquet_metadata.schema.to_arrow_schema()
    ch_columns = []

    for parquet_col in parquet_metadata.schema:
        ch_base_type_def = pq_to_ch_type(parquet_col)
        is_nullable = arrow_schema.field(parquet_col.name).nullable
        if is_nullable:
            ch_base_type_def = "Nullable({0})".format(ch_base_type_def)
        ch_columns.append("{0} {1}".format(parquet_col.name, ch_base_type_def))

    return ch_columns

def fail(msg):
    """Print an error message and die horribly"""
    print(msg)
    exit(1)

def process():
    # Print a header.
    print("-- Automatically generated DDL and INSERT for Parquet data")

    # We need region to read S3 and generate URLs.
    AWS_REGION = os.environ.get('AWS_REGION')
    if not AWS_REGION:
        fail("AWS_REGION environment variable not set")
    print("-- AWS_REGION: " + AWS_REGION)

    # The AWS access key and secret key are optional for loading into S3.
    # You can also use a bucket with open permissions.
    AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')

    # We need the dataset path to locate Parquet files.
    S3_DATASET_PATH = os.environ.get('S3_DATASET_PATH')
    if not S3_DATASET_PATH:
        fail("S3_DATASET_PATH environment variable not set")
    print("-- S3_DATASET_PATH: " + S3_DATASET_PATH)

    # We need to get the table from the path. It is the last whole word
    # in the path before the trailing /.
    regex_match = re.search('([A-Za-z0-9_]+)/$', S3_DATASET_PATH)
    if not regex_match:
        fail("S3_DATASET_PATH must have form bucket/dir/.../dir/table_name/")
    table_name = regex_match.group(1)
    print("-- Table name: " + table_name)

    # Open up the parquet dataset in S3.
    s3 = fs.S3FileSystem(region=AWS_REGION)
    pq_dataset = pq.ParquetDataset(S3_DATASET_PATH, filesystem=s3)

    # Get schema from the first Parquet fragment (i.e., file) in the dataset.
    # For now we hope the other fragments have the same schema!
    if len(pq_dataset.fragments) == 0:
        fail("S3_DATASET_PATH does not have any Parquet files!")
    pq_fragment = pq_dataset.fragments[0]

    # Generate CREATE TABLE command.
    ch_columns = pq_columns_to_ch_columns(pq_fragment.metadata)

    print("CREATE TABLE IF NOT EXISTS {0} (".format(table_name))
    for ch_column in ch_columns[0:-1]:
        print("  " + ch_column + ",")
    print("  " + ch_columns[-1])
    print(")")
    print("Engine=MergeTree()")
    print("PARTITION BY tuple()")
    print("ORDER BY tuple()")
    print("")

    # Generate INSERT with SELECT from S3 URL.
    if AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY:
        aws_credentials = "'{0}', '{1}',".format(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    else:
        aws_credentials = ""
    s3_path_for_ch = "https://s3.{0}.amazonaws.com/{1}/*.parquet".format(
        AWS_REGION, S3_DATASET_PATH)
    print("INSERT INTO {0}".format(table_name))
    print("SELECT *")
    print("FROM s3('{0}', {1}".format(s3_path_for_ch, aws_credentials))
    print("Parquet,".format(s3_path_for_ch))
    print("'", end='')
    for ch_column in ch_columns[0:-1]:
        print(ch_column + ", ", end='')
    print(ch_columns[-1] + "')")

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    process()
