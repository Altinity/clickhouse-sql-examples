DROP USER IF EXISTS async ON CLUSTER '{cluster}';

CREATE SETTINGS PROFILE IF NOT EXISTS `async_profile` 
ON CLUSTER '{cluster}' 
SETTINGS
  async_insert = 1,
  wait_for_async_insert=1,
  async_insert_busy_timeout_ms = 10000,
  async_insert_use_adaptive_busy_timeout = 0
;

CREATE USER IF NOT EXISTS async ON CLUSTER '{cluster}'
  IDENTIFIED WITH sha256_password BY 'topsecret'
  HOST ANY
  SETTINGS PROFILE `async_profile`
;

GRANT SELECT, INSERT, UPDATE, DELETE on *.* TO async

INSERT INTO test VALUES (0,0, now(),'reading',43.31,'');

-- Count records. 
SELECT count() from test;

-- Have to login as async user to see delayed insert. 
INSERT INTO test VALUES (0,0, now(),'reading',43.31,'');

-- Count records again.
SELECT count() from test;
