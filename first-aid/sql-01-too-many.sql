DROP USER IF EXISTS tm1;
DROP USER IF EXISTS tm2;
DROP SETTINGS PROFILE IF EXISTS too_many;

CREATE SETTINGS PROFILE IF NOT EXISTS `too_many` SETTINGS
  max_concurrent_queries_for_user = 15,
  max_concurrent_queries_for_all_users = 20
;
CREATE USER IF NOT EXISTS tm1 
  IDENTIFIED WITH sha256_password BY 'topsecret'
  HOST LOCAL
  SETTINGS PROFILE 'too_many'
;
CREATE USER IF NOT EXISTS tm2 
  IDENTIFIED WITH sha256_password BY 'topsecret'
  HOST LOCAL
  SETTINGS PROFILE 'too_many'
;
