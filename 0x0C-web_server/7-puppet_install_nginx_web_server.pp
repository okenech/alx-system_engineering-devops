#!/usr/bin/env bash
# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Start Nginx and ensure it starts on boot
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

# Configure Nginx to listen on port 80
file { '/etc/nginx/sites-available/default':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  content => "
    server {
      listen 80;
      root /var/www/html;
      index index.html;

      location / {
        # Return Hello World! when requesting the root
        add_header Content-Type text/html;
        return 200 'Hello World!';
      }

      location /redirect_me {
        # Perform a 301 redirect
        return 301 https://www.example.com;
      }
    }
  ",
  require => Package['nginx'],
  notify  => Service['nginx'],
}
