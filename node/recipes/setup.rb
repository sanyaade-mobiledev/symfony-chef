['nodejs', 'npm', 'nodejs-legacy'].each do |package_name|
    package package_name do
        action :install
    end
end
