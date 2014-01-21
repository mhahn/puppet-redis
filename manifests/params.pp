# == Class: redis::params
#
# Redis params.
#
# === Parameters
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012 Thomas Van Doren, unless otherwise noted.
#
class redis::params {

  $redis_port = '6379'
  $redis_bind_address = false
  $version = '2.8.3'
  $redis_src_dir = '/opt/redis-src'
  $redis_bin_dir = '/opt/redis'
  $redis_max_memory = '4gb'
  $redis_max_clients = false
  $redis_timeout = 300         # 0 = disabled
  $redis_loglevel = 'notice'
  $redis_databases = 16
  $redis_slowlog_log_slower_than = 10000 # microseconds
  $redis_slowlog_max_len = 1024
  $redis_password = false
  $redis_include_conf_path = false
  $redis_slaveof = false
  $redis_masterauth = false
  $redis_slave_serve_stale_data = 'yes'
  $redis_max_memory_policy = false
  $sentinel_port = '26379'
  $sentinel_master_bind_address = false
  $sentinel_master_port = '6379'
  $sentinel_quorum_size = 1
  $sentinel_loglevel = 'notice'
  $sentinel_master_auth = false
  $sentinel_down_after_milliseconds = 30000
  $sentinel_parallel_syncs = 1
  $sentinel_failover_timeout = 180000
  $sentinel_notification_script = false
  $sentinel_client_reconfig_script = false

}
