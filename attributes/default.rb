default[:golang] = {
  :version => "1.3.3",
  :owner   => "root",
  :group   => "root",
  :mode    => 0755,
}

raise "node[:golang][:version] is required" if node[:golang][:version].nil? || node[:golang][:version].empty?

if Gem::Version.new(node[:golang][:version]) < Gem::Version.new("1.2.2")
  download_uri = "https://go.googlecode.com/files/go%s.%s-%s.%s"
else
  download_uri = "https://storage.googleapis.com/golang/go%s.%s-%s.%s"
end

default[:golang][:arch] = node[:kernel][:machine] == "x86_64" ? "amd64" : "386"

case node[:os]
when "linux", "darwin", "freebsd"
  default[:golang][:ext]        = "tar.gz"
  default[:golang][:uncompress] = "tar"
when "windows"
  default[:golang][:ext]        = "zip"
  default[:golang][:uncompress] = "zip"
end

default[:golang][:download_uri] = node[:golang][:download_uri] || download_uri % [
  node[:golang][:version], node[:os], default[:golang][:arch], default[:golang][:ext]
]

default[:golang][:install_dir] = node[:golang][:install_dir] || "/opt/go-#{node[:golang][:version]}"

case node[:os]
when "linux", "darwin", "freebsd"
  default[:golang][:uncompress_options] = node[:golang][:uncompress_options] ||
                                          ["-C", default[:golang][:install_dir], "--strip=1", "-xzf"].join(" ")
when "windows"
  default[:golang][:uncompress_options] = ""
end
