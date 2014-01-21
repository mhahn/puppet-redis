# == Define: redis::sentinel
#
# Configure redis sentinel on an arbitrary port.
#
# === Parameters
#
# [*sentinel_port*]
#   Run redis sentinel on this port.
#   Default: 26379
#
# [*sentinel_master_name*]
#   Name of the master the sentinel is monitoring
#
# [*sentinel_master_bind_address*]
#   The address the master is bound to.
#
# [*sentinel_master_port*]
#   The port the master is listening on.
#
# [*sentinel_quorum_size*]
#   Only consider a master O_DOWN if at least this number of sentinels agree.
#   Default: 2
#
# [*sentinel_loglevel*]
#   Set the redis config value loglevel. Valid values are debug,
#   verbose, notice, and warning.
#   Default: notice
#
# [*sentinel_master_auth*]
#   The password to AUTH with a redis master.
#   Default: false
#
# [*sentinel_down_after_milliseconds*]
#   Number of milliseconds the master should be unreachable in order to
#   consider it S_DOWN.
#   Default: 30 seconds
#
# [*sentinel_parallel_syncs*]
#   How many slaves we can reconfigure to point to the new slave simultaneously
#   during the failover.
#   Default: 1
#
# [*sentinel_failover_timeout*]
#   Specify the failover timeout in milliseconds.
#   Default: 3 minutes
#
# [*sentinel_notification_script*]
#   Path to a notification script to be called on any sentinel event that is
#   generated in the WARNING level.
#   Default: nil
#
# [*sentinel_client_reconfig_script*]
#   Path to a reconfig script to be called when the master changed because of a
#   failover.
#   Default: nil
#
# === Examples
#
# redis::sentinel { 'redis-sentinel':
#   sentinel_port                => '26379',
#   sentinel_master_bind_address => '127.0.0.1',
#   sentinel_master_port         => '6379',
#   sentinel_quorum_size         => 2,
# }
#
define redis::sentinel (
  $sentinel_master_name,
  $sentinel_port = $redis::params::sentinel_port,
  $sentinel_loglevel = $redis::params::sentinel_loglevel,
  $sentinel_master_bind_address = $redis::params::sentinel_bind_address,
  $sentinel_master_port = $redis::params::sentinel_master_port,
  $sentinel_quorum_size = $redis::params::sentinel_quorum_size,
  $sentinel_loglevel = $redis::params::sentinel_loglevel,
  $sentinel_master_auth = $redis::params::sentinel_master_auth,
  $sentinel_down_after_milliseconds = $redis::params::sentinel_down_after_milliseconds,
  $sentinel_parallel_syncs = $redis::params::sentinel_parallel_syncs,
  $sentinel_failover_timeout = $redis::params::sentinel_failover_timeout,
  $sentinel_notification_script = $redis::params::sentinel_notification_script,
  $sentinel_client_reconfig_script = $redis::params::sentinel_client_reconfig_script,
  ) {

  # Using Exec as a dependency here to avoid dependency cyclying when doing
  # Class['redis'] -> Redis::Sentinel[$name]
  Exec['install-redis'] -> Redis::Sentinel[$name]
  include redis

  file { "redis-lib-port-${sentinel_port}":
    ensure => directory,
    path   => "/var/lib/redis/${sentinel_port}",
  }

  file { "sentinel-init-${sentinel_port}":
    ensure  => present,
    path    => "/etc/init.d/sentinel_${sentinel_port}",
    mode    => '0755',
    content => template('redis/sentinel.init.erb'),
    notify  => Service["sentinel-${sentinel_port}"],
  }
  file { "sentinel_port_${sentinel_port}.conf":
    ensure  => present,
    path    => "/etc/redis/${sentinel_port}.conf",
    mode    => '0644',
    content => template('redis/sentinel_port.conf.erb'),
  }

  service { "sentinel-${sentinel_port}":
    ensure    => running,
    name      => "sentinel_${sentinel_port}",
    enable    => true,
    require   => [
      File["sentinel_port_${sentinel_port}.conf"],
      File["sentinel-init-${sentinel_port}"],
      File["redis-lib-port-${sentinel_port}"],
    ],
    subscribe => File["sentinel_port_${sentinel_port}.conf"],
  }

}
