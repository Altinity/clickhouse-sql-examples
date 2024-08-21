-- Delete users. 
DROP USER IF EXISTS newuser ON CLUSTER '{cluster}';
DROP USER IF EXISTS u_sha256 ON CLUSTER '{cluster}';
DROP USER IF EXISTS u_insecure ON CLUSTER '{cluster}';
DROP USER IF EXISTS u_anyhost ON CLUSTER '{cluster}';
DROP USER IF EXISTS rmt_user ON CLUSTER '{cluster}';

-- Delete RBAC examples. 
DROP SETTINGS PROFILE IF EXISTS u2_profile ON CLUSTER '{cluster}';
DROP ROLE IF EXISTS u2_role ON CLUSTER '{cluster}';
DROP QUOTA IF EXISTS u2_quota ON CLUSTER '{cluster}';
DROP USER IF EXISTS u2_user ON CLUSTER '{cluster}';
