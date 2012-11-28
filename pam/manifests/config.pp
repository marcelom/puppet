class pam::config {
	File {
  	ensure => present,
  	owner => "root",
  	group => "root",
  	mode => 0644,
  	require => Class["pam::install"],
	}

  # pam_access module will drop the access.conf regardless the OS.
  file { "/etc/security/access.conf":
    source => "puppet:///modules/pam/access.conf",
  }

  # Dropping sudoers file
  file { "/etc/sudoers":
    source => "puppet:///modules/pam/sudoers",
    mode => 0440,
  }
  
  case $operatingsystem {
    /(RedHat|Fedora|Centos)/: {
      
      if $operatingsystemrelease >=6 {    
        #package { "nslcd": 
        #  ensure => installed,
        #}
     
        #service { "nslcd":
        #  ensure =>  running,
        #  hasstatus => true,
        #  hasrestart => true,
        #  enable => true,
        #  require => Class["ldap::nslcd"],
        #}

      	file { "/etc/pam.d/password-auth-ac":
        	source => "puppet:///modules/pam/password-auth-lbre",
        }
        
  			file { "/etc/pam.d/password-auth":
  				ensure => link,
  				target => "/etc/pam.d/password-auth-ac",
  			}	      	  

      	file { "/etc/pam.d/system-auth-lbre":
        	source => "puppet:///modules/pam/system-auth-lbre",
        }

  			file { "/etc/pam.d/system-auth":
        				ensure => link,
        				target => "/etc/pam.d/system-auth-lbre",
        }
        
      } else {
          # RH 5 has its own different pam file.
          file { "/etc/pam.d/system-auth-lbre":
          	source => "puppet:///modules/pam/system-auth-lbre-rh5",
          }

    			file { "/etc/pam.d/system-auth":
    				ensure => link,
    				target => "/etc/pam.d/system-auth-lbre",
    			}	    	
      }
    }
    
    /(Ubuntu|Debian)/: {
      file { "/etc/pam.d/common-account":
        path => "/etc/pam.d/common-account",
      	source => "puppet:///modules/pam/common-account",
    	}
    	
    	file { "/etc/pam.d/common-auth":
      	path => "/etc/pam.d/common-auth",
      	source => "puppet:///modules/pam/common-auth",
    	}
    	
    	file { "/etc/pam.d/common-password":
    	  path => "/etc/pam.d/common-password",
      	source => "puppet:///modules/pam/common-password",
    	}
    	
    	file { "/etc/pam.d/common-session":
    	  path => "/etc/pam.d/common-session",
      	source => "puppet:///modules/pam/common-session",
    	}
    }
  }
}