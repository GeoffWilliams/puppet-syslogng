#@PDQTest
# Check that syslog-ng.conf files with existing stale content are correctly updated
class { "syslogng":
  log_destination => "localhost",
  managed         => true,
}
