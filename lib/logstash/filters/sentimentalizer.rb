# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This plugin will analyze sentiment of a specified field and enrich the event
# with sentiment probability values.
class LogStash::Filters::Sentimentalizer < LogStash::Filters::Base

  config_name 'sentimentalizer'

  # Run sentiment analysis on this field
  config :source, :validate => :string, :default => 'message'

  # What key to place sentiment values under
  config :target, :validate => :string, :default => 'sentiment'

  public
  def register
    require 'sentimentalizer'

    # Monkey patch the weird defaults for positive/negative string values
    class Sentiment
        POSITIVE = 'positive'
        NEGATIVE = 'negative'
        NEUTRAL  = 'neutral'
    end

    Sentimentalizer.setup
  end # def register

  public
  def filter(event)
    return unless filter?(event)

    source = event[@source]

    if !source.nil?

      begin
        sentiment = Sentimentalizer.analyze(source)
      rescue NoMethodError => e
        @logger.error('Error parsing sentiment for field', :exception => e, :field => source)
      end

      if !sentiment.nil?
        event[@target] = {
          :probability => sentiment.overall_probability,
          :polarity    => sentiment.sentiment,
        }
      end

    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Sentimentalizer
