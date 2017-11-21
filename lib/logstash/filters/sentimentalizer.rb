# encoding: utf-8

require 'logstash/filters/base'
require 'logstash/namespace'

# This plugin will analyze sentiment of a specified field and enrich the event
# with sentiment probability values.
class LogStash::Filters::Sentimentalizer < LogStash::Filters::Base
  config_name 'sentimentalizer'

  # Run sentiment analysis on this field
  config :source, :validate => :string, :default => 'message'

  # What key to place sentiment values under
  config :target, :validate => :string, :default => 'sentiment'

  # Should we scrub hashtags to better extract their sentiment?
  config :scrub, :validate => :boolean, :default => true

  public

  def register
    require 'sentimentalizer'

    # Monkey patch the weird defaults for positive/negative string values
    %w[POSITIVE NEGATIVE NEUTRAL].each do |s|
      Sentiment.send(:remove_const, s)
      Sentiment.const_set(s, s.downcase)
    end

    Sentimentalizer.setup
  end # def register

  def filter(event)
    return unless filter?(event)

    unless event.get(@source).nil?
      source = event.get(@source).dup
      begin
        sentiment = Sentimentalizer.analyze(
          @scrub ? source.gsub(/\B#(\S+)\b/, '\1') : source
        )
      rescue NoMethodError => e
        @logger.error(
          'Error parsing sentiment for field',
          :exception => e,
          :field => source
        )
      end

      unless sentiment.nil?
        event.set(
          @target,
          'probability' => sentiment.overall_probability,
          'polarity'    => sentiment.sentiment
        )
      end
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Sentimentalizer
