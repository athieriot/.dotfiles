# coding: UTF-8

require 'skeeter'

Earthquake.init do
  config[:preview] ||= {}
  config[:preview][:width] ||= 80

  command :preview do |m|
    args = m[1].split(/\s+/)
    opts = Slop.parse!(args) do
      banner "Usage: :preview [-w width] username or url"
      on :w, :width, 'Width of preview', true
    end

    unless args[0]
      puts opts
      next
    end

    if args[0] =~ /^http/
      url = args[0]
    else
      url = twitter.show(args[0])["profile_image_url"]
    end

    width = opts[:width] =~ /^\d+$/ ? opts[:width] : config[:preview][:width]

    puts Skeeter.get(url, :width => width)
  end

  help :aview, "Preview an image", <<-HELP
    ⚡ :preview http://example.com/image.jpg
    ⚡ :preview jugyo
    ⚡ :preview -w 200 jugyo
  HELP
end
# https://gist.github.com/jugyo/2159775
