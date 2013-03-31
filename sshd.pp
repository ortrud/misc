class jboss::sshd inherits base::sshd {
   #
   # Class with all jboss related ssh changes
   #
 
   $loginGroups += [ "jbossusers", "jbossadmins", "buildusers" ]
 
   # We must redefine the template to force the loginGroups change
   File["/etc/ssh/sshd_config"] {
      content => template($sshd_config_template),
   }
}
 
 
 
class base::sshd {
   #
   # Class with all base system configurations for default install
   #
 
   # Define groups that have access to the server and the template to use
 
   $loginGroups = ["unixadmins", "linuxadmins"]
 
   $sshd_config_template = "base/etc/ssh/sshd_config"
 
   file {
      '/etc/ssh/sshd_config':
#        name   => $operatingsystem ? {
#           default => "/etc/ssh/sshd_config",
#        },
         mode   => 644,
         group  => sys,
         owner  => root,
         content => template($sshd_config_template);
   }
 
   service {
      # Enable remote login services
      "ssh":
#         name => $operatingsystem ? {
#            default => "ssh",
#         },
         ensure    => running,
         subscribe => File["/etc/ssh/sshd_config"];
   }
}
