class consul::windows_service(
  $nssm_version = '2.24',
  $nssm_download_url = undef,
  $nssm_download_url_base = 'https://nssm.cc/release',
) {

$real_download_url = pick($nssm_download_url, "${nssm_download_url_base}/nssm-${nssm_version}.zip")

$install_path = $::consul_downloaddir

case $::architecture {
  'x32': {
    $nssm_exec = "${install_path}/nssm-${nssm_version}/win32/nssm.exe"
  }
  'x64': {
    $nssm_exec = "${install_path}/nssm-${nssm_version}/win64/nssm.exe"
  }
  default: {
    fail("Unknown architecture for windows - ${::architecture}")
  }
}

# $app_dir = unix2dos(dos2unix($consul::bin_dir))
# $app_exec = unix2dos(dos2unix("${app_dir}\\consul.exe"))
# $configdir_args = unix2dos(dos2unix($consul::config_dir))
# $datadir_args = unix2dos(dos2unix($consul::data_dir))
# $app_args = "agent -config-dir=${configdir_args} -data-dir=${datadir_args}"
# $app_log =unix2dos(dos2unix("${app_dir}\\logs\\consul.log"))

archive { "${install_path}/nssm-${nssm_version}.zip":
  ensure => present,
  source => $real_download_url,
  extract => true,
  extract_path => $install_path,
  creates => [
    "${install_path}/nssm-${nssm_version}/win32/nssm.exe",
    "${install_path}/nssm-${nssm_version}/win64/nssm.exe",
  ]
}

# file { "${consul::bin_dir}/set_service_parameters.ps1":
#   ensure  => 'present',
#   content => template('consul/set_service_parameters.ps1.erb'),
#   notify  => Exec['consul_service_set_parameters']
# } ->
# exec { 'consul_service_set_parameters':
#   cwd         => $consul::bin_dir,
#   command     => "& \"${consul::bin_dir}/set_service_parameters.ps1\"",
#   refreshonly => true,
#   logoutput   => true,
#   provider    => 'powershell',
# }

}
