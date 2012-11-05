#!/usr/bin/env tclsh
# MOTD script original? / mod mewbies.com

# * Variables
set var(user) $env(USER)
set var(path) $env(PWD)
set var(home) $env(HOME)

# * Check if we're somewhere in /home
#if {![string match -nocase "/home*" $var(path)]} {
if {![string match -nocase "/home*" $var(path)] && ![string match -nocase "/usr/home*" $var(path)] } {
  return 0
}

# * Calculate last login
set lastlog [exec -- lastlog -u $var(user)]
set ll(1)  [lindex $lastlog 7]
set ll(2)  [lindex $lastlog 8]
set ll(3)  [lindex $lastlog 9]
set ll(4)  [lindex $lastlog 10]
set ll(5)  [lindex $lastlog 6]

# * Calculate current system uptime
set uptime    [exec -- /usr/bin/cut -d. -f1 /proc/uptime]
set up(days)  [expr {$uptime/60/60/24}]
set up(hours) [expr {$uptime/60/60%24}]
set up(mins)  [expr {$uptime/60%60}]
set up(secs)  [expr {$uptime%60}]

# * Calculate usage of home directory
set usage [lindex [exec -- /usr/bin/du -msh $var(home)] 0]

# * Calculate SSH logins:
set logins     [exec -- w -s | wc -l]

# * Calculate processes
set psu [lindex [exec -- ps U $var(user) h | wc -l] 0]
set psa [lindex [exec -- ps -A h | wc -l] 0]

# * Calculate current system load
set loadavg     [exec -- /bin/cat /proc/loadavg]
set sysload(1)  [lindex $loadavg 0]
set sysload(5)  [lindex $loadavg 1]
set sysload(15) [lindex $loadavg 2]

# * Calculate Memory
set memory  [exec -- free -m]
set mem(t)  [lindex $memory 7]
set mem(u)  [lindex $memory 8]
set mem(f)  [lindex $memory 9]
set mem(c)  [lindex $memory 16]
set mem(s)  [lindex $memory 19]

# * Calculate disk temperature from hddtemp
set hddtemp [lindex [exec -- sudo /usr/sbin/hddtemp /dev/sda -uC -n] 0]
set hddtemp2 [lindex [exec -- sudo /usr/sbin/hddtemp /dev/sdb -uC -n] 0]

# * Calculate temperature from lm-sensors
set temperature    [exec -- sensors | grep -A 0 "Core 0" | cut -c15-21]
set temperature2    [exec -- sensors | grep -A 0 "Core 2" | cut -c15-21]

# * ascii head
set head {
                     _          _  _                   
                    | |        | |(_)                  
           ____   __| | ____   | | _ ____  _   _ _   _ 
          |  _ \ / _  |/ _  |  | || |  _ \| | | ( \ / )
          | |_| ( (_| | |_| |  | || | | | | |_| |) X ( 
          |  __/ \____|\__  |   \_)_|_| |_|____/(_/ \_)
          |_|             |_|                          


}

# * Print Results
puts "\033\[01;32m$head\033\[0m"
puts "  Last Login....: $ll(1) $ll(2) $ll(3) $ll(4) from $ll(5)"
puts "  Uptime........: $up(days)days $up(hours)hours $up(mins)minutes $up(secs)seconds"
puts "  Load..........: $sysload(1) (1minute) $sysload(5) (5minutes) $sysload(15) (15minutes)"
puts "  Memory MB.....: $mem(t)  Used: $mem(u)  Free: $mem(f)  Free Cached: $mem(c)  Swap In Use: $mem(s)"
puts "  Temperature...: CPU0: $temperature CPU2: $temperature2 Disks: ${hddtemp}°C/${hddtemp2}°C"
puts "  Disk Usage....: You're using ${usage} in $var(home)"
puts "  Logins....: There are currently $logins users logged in."
puts "  Processes.....: You're running ${psu} which makes a total of ${psa} running"
puts "\033\[01;32m ::::::::::::::::::::::::::::::::-STATEMENT-::::::::::::::::::::::::::::::::"
puts "  This is a private system that you are not to give out access to anyone"
puts "                      without permission from an admin!\033\[0m\n"

if {[file exists /etc/changelog]&&[file readable /etc/changelog]} {
  puts " . .. More or less important system informations:\n"
  set fp [open /etc/changelog]
  while {-1!=[gets $fp line]} {
    puts "  ..) $line"
  }
  close $fp
  puts ""
}
