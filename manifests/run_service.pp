# == Class prometheus::service
#
# This class is meant to be called from prometheus
# It ensure the service is running
#
class prometheus::run_service {
  if $prometheus::manage_service == true {
    if $::prometheus::install_method == 'docker' {
      docker::run { 'prometheus':
        image   => 'prom/prometheus',
        command => $::prometheus::docker_command,
        volumes => $::prometheus::docker_volumes,
        ports   => $::prometheus::docker_ports,
        net     => 'prometheus',
      }

    } else {
      $init_selector = $prometheus::init_style ? {
        'launchd' => 'io.prometheus.daemon',
        default   => 'prometheus',
      }

      service { 'prometheus':
        ensure     => $prometheus::service_ensure,
        name       => $init_selector,
        enable     => $prometheus::service_enable,
        hasrestart => true,
        restart    => '/usr/bin/pkill -HUP prometheus',
      }
    }
  }
}
