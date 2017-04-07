@test "stale content removed 1" {
  ! grep 'destination d_scwx{ STALE' /etc/syslog-ng/syslog-ng.conf
}

@test "stale content removed 2" {
  ! grep 'BAD1' /etc/syslog-ng/syslog-ng.conf
}

@test "stale content removed 3" {
  ! grep 'BAD2' /etc/syslog-ng/syslog-ng.conf
}

@test "Last 3 lines match requested config data" {
  FOOTER=$(tail -3 /etc/syslog-ng/syslog-ng.conf)
  # must use literal LF - bash won't match \n
  WANTED='# !!! Puppet managed elements, be cautious editing !!!
destination d_scwx{ tcp("localhost" port(514)); };
log { source(s_sys); destination(d_scwx); };'
  [ "$FOOTER" = "$WANTED" ]
}
