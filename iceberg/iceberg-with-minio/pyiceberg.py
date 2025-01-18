#!/usr/bin/env python3
# Python script showing how to create and populate a table in Iceberg. 

import sys
print(sys.path)

import pyarrow
from pyiceberg.catalog import load_catalog

catalog = load_catalog(
    "rest", 
    **{
        "uri": "http://localhost:8181/",
        "warehouse": "warehouse"
    }  
)

ns_list = catalog.list_namespaces()
for ns in ns_list:
    print(ns)
