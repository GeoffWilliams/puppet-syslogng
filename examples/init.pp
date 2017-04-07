#@PDQTest
class { "syslogng":
  log_destination => "localhost",
  managed         => true,
}
