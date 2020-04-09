# @summary 
#   Create and manage Clickhouse dictionary.
#
# @see https://clickhouse.yandex/docs/en/query_language/dicts/external_dicts/
#
# @example Create a basic Clickhouse dictionary:
#   clickhouse::server::dictionary { 'countries.xml': 
#     source => 'puppet:///modules/clickhouse/dictionaries',
#   }
#
# @param name
#   Name of the dictionary file in the $source and $dict_dir folders.
# @param dict_dir
#   Path to folder with clickhouse dictionaries. Defaults to '/etc/clickhouse-server/dict'.
# @param dict_file_owner
#   Owner of the dictionary file. Defaults to 'clickhouse'.
# @param dict_file_group
#   Group of the dictionary file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create dictionary. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param source
#   Path to a 'files' folder in puppet, where dictionary file are located. Defaults to 'puppet:///modules/${module_name}'.
# @param datapath
#   Path to dictionary datafile on ClickHouse server. Defaults to undef.
# @param datasource
#   Path to dictionary datafile. Accepts any valid File::source value. Defaults to undef.
#   datasource and datapath MUST be only be used together.
#
define clickhouse::server::dictionary(
  Stdlib::Unixpath $dict_dir        = $clickhouse::server::dict_dir,
  String $dict_file_owner           = $clickhouse::server::clickhouse_user,
  String $dict_file_group           = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure = 'present',
  String $source                    = "${clickhouse::server::dict_source_folder}/${title}",
  String $datapath                  = undef,
  String $datasource                = undef,
) {

  file { "${dict_dir}/${title}":
    ensure => $ensure,
    owner  => $dict_file_owner,
    group  => $dict_file_group,
    mode   => '0664',
    source => $source,
  }

  if ($datapath != undef) and ($datasource != undef) {

    file { $datapath:
      ensure => $ensure,
      owner  => $dict_file_owner,
      group  => $dict_file_group,
      mode   => '0664',
      source => $datasource,
    }

  }
  else
  {

    if !(($datapath != undef) and ($datasource != undef)) {

      fail('$datasource and $datapath must be used both or neither')

    }

  }

}
