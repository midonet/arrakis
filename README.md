Arrakis
=======

Puppet modules to deploy MidoNet on top of OpenStack.

If you are creating modules, please try to mirror the actual target system directory structure in the /files and /templates folder.

An example for this can be found in the module midonet api.
What you can see here is that the template is used from the same location in the /templates folder where it is used on the target system.  This avoids problems in the future that may appear with overlapping file names.
```
  file {"/usr/share/midonet-api/WEB-INF/web.xml":
            ensure => "file",
            path => "/usr/share/midonet-api/WEB-INF/web.xml",
            content => template("midonet_api/usr/share/midonet-api/WEB-INF/web.xml.erb"),
            mode => "0644",
            owner => "root",
            group => "root",
          }
```
Note that the file in puppet contains the suffix .erb.

This is the corresponding example for a puppet file resource:
```
  file {"/etc/tomcat6/Catalina/localhost/midonet-api.xml":
            ensure => "file",
            path => "/etc/tomcat6/Catalina/localhost/midonet-api.xml",
            source => "puppet:///modules/midonet_api/etc/tomcat6/Catalina/localhost/midonet-api.xml",
            mode => "0644",
            owner => "root",
            group => "root",
          }
```

