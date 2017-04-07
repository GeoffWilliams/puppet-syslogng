# Syslog_ng
#
# Install and configure syslog_ng client
#
# @param log_destination hostname to send logs to
# @param port port to send logs to
# @param managed True to manage syslog-ng with this module otherwise do nothing
# @param enabled True to enable and start the syslog-ng daemon otherwise false
# @param config_file Configuration file to edit
# @param service Name of the service to managed
# @param package Name of the package to install
# @param comment Comment to add before our modification to the syslog config file
# @param log_reference Override the default log_reference (log source)
class syslogng (
    $log_destination,
    $port             = $syslogng::params::port,
    $managed          = $syslogng::params::managed,
    $enabled          = $syslogng::params::enabled,
    $config_file      = $syslogng::params::config_file,
    $service          = $syslogng::params::service,
    $package          = $syslogng::params::package,
    $comment          = $syslogng::params::comment,
    $log_reference    = $syslogng::params::log_reference,
) inherits syslogng::params {

  File_line {
    ensure  => present,
    notify  => Service[$service],
    require => Package[$package],
    path    => $config_file,
  }

  if $managed {
    if $package {
      package { $package:
        ensure => present,
      }
    }

    fm_append { $config_file:
      ensure      => present,
      notify      => Service[$service],
      match_start => "(${comment}|destination d_scwx{ .*\$)",
      data        => [
        $comment,
        "destination d_scwx{ tcp(\"${log_destination}\" port(${port})); };",
        "log { source(${log_reference}); destination(d_scwx); };",
      ],
    }

    # natural order - end of file
    file_line { 'syslog-ng destination':
      match => 'destination d_scwx{ .*$',
      line  => "destination d_scwx{ tcp(\"${log_destination}\" port(${port})); };",
    }

    # specified order - after above
    file_line { 'syslog-ng logger':
      line  => "log { source(${log_reference}); destination(d_scwx); };",
      after => 'destination d_scwx{ .*$',
    }

    $service_ensure = $enabled ? { true => running, false => stopped}

    service { $service:
      ensure  => $service_ensure,
      enable  => $enabled,
      require => Package[$package]
    }
  }
}
