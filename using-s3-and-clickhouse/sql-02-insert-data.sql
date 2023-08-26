insert into test select number, number, '2023-01-01' from numbers(1e9);

insert into test_s3_direct select number, number, '2023-01-01' from numbers(1e9);

insert into test_s3_cached select number, number, '2023-01-01' from numbers(1e9);
