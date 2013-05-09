# coding: UTF-8

require 'active_support/core_ext/hash'

Earthquake.init do
  command :look do |m|
    args = m[1].split(/\s+/)

    slop = Slop.new(:strict => true)
    slop.banner "Usage: :look user_name or image_url"
    slop.on :h, :help, 'Print this help message'
    slop.on :c, :color, 'Use ANSI colors in output.'
    slop.on :w, :width, 'Set output width, calculate height from ratio.', true

    begin
      slop.parse!(args)
    rescue => e
      puts e.message
      puts
      puts slop.help
      next
    end

    if args[0].nil? || slop.help?
      puts slop.help
      next
    end

    if args[0] =~ /^http/
      url = args[0]
    else
      url = twitter.show(args[0])["profile_image_url"]
    end

    jp2a_options = slop.to_hash.
      select { |k, v| !v.nil? }.
      map { |k, v| v.is_a?(String) ? "--#{k}=#{v}" : "--#{k}"}.
      join(" ")
    puts `convert #{url} jpg:- | jp2a #{jp2a_options} -`
  end

  help :aview, "Preview an image", <<-HELP
    ⚡ :look jugyo
    ⚡ :look -c http://www.google.com/intl/en/images/logo.gif
    ⚡ :look -c -w 100 http://www.google.com/intl/en/images/logo.gif
  HELP
end
# https://gist.github.com/jugyo/2167186
