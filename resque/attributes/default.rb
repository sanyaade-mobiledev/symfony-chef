default[:resque][:packages] = ['supervisor']
default[:resque][:resque_bin] = 'bin/resque'
default[:resque][:resque_scheduler_bin] = 'bin/resque-scheduler'
default[:resque][:workers] = node['cpu']['total']
default[:resque][:queue] = 'default'
default[:resque][:host] = 'localhost'
default[:resque][:port] = 'localhost'
