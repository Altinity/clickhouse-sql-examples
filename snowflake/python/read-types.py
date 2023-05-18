import pyarrow
import pyarrow.parquet as pq

parquet_file='data_0_0_0.snappy.parquet'

def arrow_to_ch_type(arrow_type):
    if isinstance(arrow_type.type, pyarrow.lib.Decimal128Type):
        precision = arrow_type.type.precision
        scale = arrow_type.type.scale
        if (scale != 0):
            ch_type = "Decimal({0}, {1})".format(precision, scale)
        elif (precision <= 10):
            ch_type = "UInt32"
        elif (precision <= 19):
            ch_type = "UInt64"
        elif (precision <= 38):
            ch_type = "UInt128"
        else:
            ch_type = "UInt256"
    if isinstance(arrow_type.type, pyarrow.lib.Time32Type):
        ch_type = "DateTime"
    elif arrow_type.type == "string":
        ch_type = "String"
    else:
        print(arrow_type, type(arrow_type.type))
        raise Exception(f"Unknown type: {arrow_type.type}")

    if arrow_type.nullable:
        return "Nullable({0})".format(ch_type)
    else:
        return ch_type

def process():
    schema = pq.read_schema(parquet_file)
    print("---schema---")
    print(schema)

    print("CREATE TABLE IF NOT EXISTS foo (")

    for name in schema.names:
        col_type = arrow_to_ch_type(schema.field(name))
        print("  {0} {1},".format(name, col_type))

    print(")")
    print("Engine=MergeTree()")
    print("PARTITION BY tuple()")
    print("ORDER BY tuple()")

    data = pq.ParquetFile(parquet_file)
    print("---file---")
    print(data.read())

if __name__ == '__main__':
    process()
