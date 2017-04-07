# Syslogng::Params
#
# Params pattern for syslogng
class syslogng::params {
  $comment      = '# !!! Puppet managed elements, be cautious editing !!!'
  $managed      = false
  $enabled      = true
  $port         = 514

  # OS specific parameters seem to be the same on all platforms, epel is needed
  # on RHEL/CentOS though...
  $service      = 'syslog'
  $package      = 'syslog-ng'
  $config_file  = '/etc/syslog-ng/syslog-ng.conf'

  if $facts['os']['family'] == 'Suse' {
    $log_reference = "src"
  } else {
    $log_reference = "s_sys"
  }

}
