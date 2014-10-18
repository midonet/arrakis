class midonet_repository::types {

  define t (
    $source = "midonet_repository/${title}.erb",
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

