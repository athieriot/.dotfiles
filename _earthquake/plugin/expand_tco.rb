require 'net/http'
require 'uri'
Earthquake.init do
    output_filter do |item|
        next unless item['text']
        text = item["text"]
        text.scan( /http:\/\/t\.co\/[a-zA-Z0-9\-]+/ ).each do |url|
            uri = URI.parse url
            Net::HTTP::start( uri.host , uri.port ) do |connection|
                connection.request_get uri.path do |response|
                    text.gsub! url , response['Location']
                end
            end
        end
        text
    end
end
# https://gist.github.com/jaspertandy/1385833
