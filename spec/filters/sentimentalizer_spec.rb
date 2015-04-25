require 'spec_helper'
require "logstash/filters/sentimentalizer"

describe LogStash::Filters::Sentimentalizer do
  describe 'default sentiment configuration' do
    let(:config) do <<-CONFIG
      sentimentalizer { }
    CONFIG
    end

    sample("message" => "I hate this") do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('negative')
    end

    sample("message" => "I love this") do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('positive')
    end
  end
end
