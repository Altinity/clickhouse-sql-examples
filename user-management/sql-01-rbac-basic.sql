DROP USER IF EXISTS newuser ON CLUSTER '{cluster}';
DROP USER IF EXISTS u_sha256 ON CLUSTER '{cluster}';
DROP USER IF EXISTS u_anyhost ON CLUSTER '{cluster}';
DROP USER IF EXISTS rmt_user ON CLUSTER '{cluster}';
DROP SETTINGS PROFILE IF EXISTS rmt_profile ON CLUSTER '{cluster}';

CREATE USER IF NOT EXISTS newuser ON CLUSTER '{cluster}'
  IDENTIFIED WITH sha256_password BY 'topsecret'
  HOST LOCAL
  SETTINGS PROFILE 'default'
;

CREATE USER IF NOT EXISTS u_sha256 ON CLUSTER '{cluster}'
  IDENTIFIED WITH sha256_hash BY '53336a676c64c1396553b2b7c92f38126768827c93b64d9142069c10eda7a721'
;

CREATE USER IF NOT EXISTS u_anyhost ON CLUSTER '{cluster}'
  IDENTIFIED WITH sha256_password BY 'topsecret'
  HOST ANY 
;

CREATE SETTINGS PROFILE IF NOT EXISTS `rmt_profile` ON CLUSTER '{cluster}' SETTINGS
  log_queries = true,
  final = true,
  do_not_merge_across_partitions_select_final = true, 
  load_balancing = 'nearest_hostname',    
  prefer_localhost_replica = false
;

CREATE USER IF NOT EXISTS rmt_user ON CLUSTER '{cluster}'
  IDENTIFIED WITH sha256_password BY 'topsecret'
  SETTINGS PROFILE 'rmt_profile'
;


