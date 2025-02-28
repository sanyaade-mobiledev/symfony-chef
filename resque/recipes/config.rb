node[:deploy].each do |app_name, deploy|
    if node[app_name].present? and node[app_name][:resque].present?
        if platform?("ubuntu")
            user = "www-data"
        elsif platform?("amazon")
            user = "apache"
        end

        host = node[:resque][:host]
        port = node[:resque][:port]
        if node[app_name][:resque][:redis].present?
            host = node[app_name][:resque][:redis][:host] || host
            port = node[app_name][:resque][:redis][:port] || port
        end

        template "/etc/supervisor/conf.d/#{app_name}.conf" do
            source "process.conf.erb"
            mode 0644
            variables(
                :name => app_name,
                :command => "#{deploy[:deploy_to]}/current/#{node[app_name][:resque][:bin] || node[:resque][:resque_bin]}",
                :number => node[app_name][:resque][:workers] || node[:resque][:workers],
                :user => user,
                :queue => node[app_name][:resque][:queue] || node[:resque][:queue],
                :backend => "#{host}:#{port}"
            )
        end
        if node[app_name][:resque][:scheduler]
            template "/etc/supervisor/conf.d/#{app_name}-scheduler.conf" do
                source "process.conf.erb"
                mode 0644
                variables(
                    :name => "#{app_name}-scheduler",
                    :command => "#{deploy[:deploy_to]}/current/#{node[app_name][:resque][:scheduler_bin] || node[:resque][:resque_scheduler_bin]}",
                    :number => 1,
                    :user => user,
                    :backend => "#{host}:#{port}"
                )
            end
        end
    end
end
