class midokura_puppet_types::types {

  define t (
    $source = "${module_name}/${title}.erb",
    $mode = '0644',
    $owner = 'root',
    $group = 'root',
    ) {
    file {"t_TEMPLATE_${source}_TO_${title}":
      ensure => "file",
      path => "${title}",
      content => template("${source}"),
      mode => "${mode}",
      owner => "${owner}",
      group => "${group}",
    }
  }

}

