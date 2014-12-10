go_archive = "#{Chef::Config[:file_cache_path]}/go#{node[:golang][:version]}.#{node[:golang][:ext]}"

remote_file go_archive do
  source node[:golang][:download_uri]
  not_if { File.exists?(node[:golang][:install_dir]) }
end

case node[:os]
when "linux", "freebsd", "darwin"
  directory node[:golang][:install_dir] do
    owner node[:golang][:owner]
    group node[:golang][:group]
    mode  node[:golang][:mode]
  end
  
  bash "install go#{node[:golang][:version]}" do
    code   <<-EOC
#{node[:golang][:uncompress]} #{node[:golang][:uncompress_options]} #{go_archive}
EOC
    not_if { File.exists?("#{node[:golang][:install_dir]}/bin") }
  end
when "windows"
  # some code...
end

file go_archive do
  action  :delete
  only_if { File.exists?(node[:golang][:install_dir]) }
end
