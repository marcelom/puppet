class wallet::aptrepos {  
  if $operatingsystem == "Ubuntu" or $operatingsystem =="debian" {
      # Required for wallet-client
      file { "/etc/apt/sources.list.d/stanford.list":
        ensure => present,
        owner => "root",
        group => "root",
        mode => 0644,
        content => "deb http://debian.stanford.edu/debian-stanford stable main",
        notify => File["/etc/apt/preferences.d/stanfordpriority"],	  
      }

      # prefer the version from stanford main repository.
		  file { "/etc/apt/preferences.d/stanfordpriority":
	      ensure => present,
	      content => "Package: *
Pin: release o=Stanford
Pin-Priority: 200

Package: libremctl1
Pin: release o=Stanford
Pin-Priority: 600",
        notify => File["/etc/apt/apt.conf.d/99auth"],
		  }
  
      # It's OK to install unsigned packages
      file { "/etc/apt/apt.conf.d/99auth":       
         owner     => root,
         group     => root,
         content   => "APT::Get::AllowUnauthenticated yes;",
         mode      => 644,
         notify => Exec["aptitude update"],
      }
  
      exec { "aptitude update":
        path => "/usr/bin",
        command => "aptitude update",
      }
  }
}