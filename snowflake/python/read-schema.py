import pyarrow
import pyarrow.parquet as pq

table_name='CALL_CENTER'
parquet_file='data_0_0_0.snappy.parquet'
parquet_url='s3://bucket/path/data_0_0_0.snappy.parquet'

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

    elif pq_type.logical_type.type == "STRING":
        ch_type = "String"

    elif pq_type.logical_type.type == "DATE":
        ch_type = "Date"

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

def process():
    #metadata = pq.read_metadata(parquet_file)
    metadata = pq.read_metadata(parquet_url)

    # Generate CREATE TABLE command. 
    ch_columns = pq_columns_to_ch_columns(metadata)

    print("CREATE TABLE IF NOT EXISTS {0} (".format(table_name))
    for ch_column in ch_columns[0:-1]:
        print("  " + ch_column + ",")
    print(ch_columns[-1])
    print(")")
    print("Engine=MergeTree()")
    print("PARTITION BY tuple()")
    print("ORDER BY tuple()")
    print("")

    # Generate INSERT with SELECT from S3 URL. 
    print("INSERT INTO {0}".format(table_name))
    print("SELECT *")
    print("FROM s3('https://s3.us-east-1.amazonaws.com/bucket/path/data_0_0_0.snappy.parquet', Parquet,")
    print("'", end='')
    for ch_column in ch_columns[0:-1]:
        print(ch_column + ", ", end='')
    print(ch_columns[-1] + "')")

if __name__ == '__main__':
    process()
