require "hits_counter/version"
require "hits_counter/engine"
require "hits_counter/app/models/hc_matching_hit.rb"

module HitsCounter
  def self.match_url(url)
    return false if url.blank?

    config = Rails.configuration.hc_config
    if config.blank? or config.class != Hash
      puts 'config error!, config needs to be a hash, example: {
        "exact": ["/", "/a"],
        "regex": ["/a*"]
      }'
      return false
    end

    config.each do |type, patterns|
      patterns.each do |pattern|
        if type == "regex"
          regex = parse_to_regex(pattern)
          puts regex
          if !!(url =~ regex)
            record_hit(url, pattern)
          end
        elsif (type == "exact") and (url == pattern)
          record_hit(url, pattern)
        end
      end
    end
  end

  def self.parse_to_regex(pattern)
    escaped = Regexp.escape(pattern).gsub('\*','.*?')
    Regexp.new "^#{escaped}$", Regexp::IGNORECASE
  end

  def self.record_hit(url, match_to)
    hc = HitsCounter::HcMatchingHit.new
    hc.url = url
    hc.match_to = match_to
    hc.created_at = Time.now()
    hc.save!
  end

  def self.to_csv(data)
    require "csv"
    CSV.generate(options = {}) do |csv|
      data.each do |d|
        csv << d
      end
    end
  end
end
