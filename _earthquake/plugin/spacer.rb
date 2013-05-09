Earthquake.init do
    output_filter do |item|
        next unless item['text']
        text = item["text"]
        
        puts "\n\n"
    end
end
# https://gist.github.com/athieriot/5550290
