#!/usr/bin/env python3
# Python script showing how to create and populate a table in Iceberg. 

import sys
print(sys.path)

import pyarrow
import pyiceberg
from pyiceberg.catalog import load_catalog

catalog = load_catalog(
    "rest", 
    **{
        "uri": "http://localhost:8181/",
        #"warehouse": "warehouse"
        "type": "rest",
        "s3.endpoint": f"http://localhost:8999",
        "s3.access-key-id": "admin",
        "s3.secret-access-key": "password",
    }  
)

# Set up a namespace. 
print("Create namespace iceberg_demo")
try:
    catalog.create_namespace("iceberg_demo")
    print("--Created")
except pyiceberg.exceptions.NamespaceAlreadyExistsError:
    print("--Already exists")

print("List namespaces")
ns_list = catalog.list_namespaces()
for ns in ns_list:
    print(ns)

# See if table exists. 
print("List tables")
tab_list = catalog.list_tables("iceberg_demo")
for tab in tab_list:
    print(tab)

# Now create a table. 
from pyiceberg.schema import Schema
from pyiceberg.types import (
    TimestampType,
    FloatType,
    DoubleType,
    StringType,
    NestedField,
    StructType,
)

schema = Schema(
    NestedField(field_id=1, name="datetime", field_type=TimestampType(), required=True),
    NestedField(field_id=2, name="symbol", field_type=StringType(), required=True),
    NestedField(field_id=3, name="bid", field_type=FloatType(), required=False),
    NestedField(field_id=4, name="ask", field_type=DoubleType(), required=False),
    NestedField(
        field_id=5,
        name="details",
        field_type=StructType(
            NestedField(
                field_id=4, name="created_by", field_type=StringType(), required=False
            ),
        ),
        required=False,
    ),
)

from pyiceberg.partitioning import PartitionSpec, PartitionField
from pyiceberg.transforms import DayTransform

partition_spec = PartitionSpec(
    PartitionField(
        source_id=1, field_id=1000, transform=DayTransform(), name="datetime_day"
    )
)

from pyiceberg.table.sorting import SortOrder, SortField
from pyiceberg.transforms import IdentityTransform

# Sort on the symbol
sort_order = SortOrder(SortField(source_id=2, transform=IdentityTransform()))

catalog.create_table(
    identifier="iceberg_demo.bids",
    schema=schema,
    location="s3://pyiceberg",
    partition_spec=partition_spec,
    sort_order=sort_order,
)
