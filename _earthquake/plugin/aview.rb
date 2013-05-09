# coding: UTF-8

require 'open-uri'
require 'tmpdir'

Earthquake.init do
  command :aview do |m|
    if m[1] =~ /^http/
      url = m[1]
    else
      url = twitter.show(m[1])["profile_image_url"]
    end

    Dir.mktmpdir do |dir|
      source = File.join(dir, File.basename(url))
      dest = File.join(dir, 'dest.pnm')
      File.open(source, 'wb') {|f| f << open(url).read}
      begin
        (system 'convert', source, dest) || (raise 'Faild to execute `convert`. Please install ImageMagick.')
        (system 'aview', '-driver', 'curses', dest) || (raise 'Faild to execute `aview`. Please install Aview.')
      rescue => e
        puts e.message
      end
    end
  end

  help :aview, "Show image as text using Aview", <<-HELP
    ⚡ :aview http://example.com/image.jpg
    ⚡ :aview jugyo
  HELP
end
# https://gist.github.com/jugyo/2156204
