-- Delete RBAC examples. 
DROP SETTINGS PROFILE IF EXISTS u2_profile;
DROP ROLE IF EXISTS u2_role;
DROP QUOTA IF EXISTS u2_quota;
DROP USER IF EXISTS u2_user;

CREATE SETTINGS PROFILE IF NOT EXISTS u2_profile
SETTINGS
  max_threads = 2 MIN 1 MAX 4,
  max_memory_usage = 10000000 MIN 1000000 MAX 20000000
READONLY
;

CREATE ROLE IF NOT EXISTS u2_role
  SETTINGS PROFILE 'u2_profile'
;

REVOKE ALL FROM u2_role ;
GRANT SHOW DATABASES ON system.* TO u2_role;
GRANT SELECT ON system.* TO u2_role;
GRANT SELECT ON default.* TO u2_role;

CREATE QUOTA IF NOT EXISTS u2_quota
FOR INTERVAL 30 second
  MAX queries 5,
  MAX result_rows 1000000
TO u2_role
;

CREATE USER IF NOT EXISTS u2_user
  IDENTIFIED WITH SHA256_PASSWORD BY 'topsecret'
  HOST ANY
  DEFAULT ROLE u2_role
;
