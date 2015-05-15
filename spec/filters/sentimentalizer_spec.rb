require 'spec_helper'
require "logstash/filters/sentimentalizer"

describe LogStash::Filters::Sentimentalizer do
  describe 'default sentiment configuration' do
    let(:config) do <<-CONFIG
      filter {
        sentimentalizer { }
      }
    CONFIG
    end

    sample 'Horrible' do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('negative')
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be < 0.5
    end

    sample 'Fantastic' do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('positive')
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be > 0.5
    end
  end

  describe 'twitter hashtag scoring without scrubbing' do
    let(:config) do <<-CONFIG
      filter {
        sentimentalizer {
            scrub => false
        }
      }
    CONFIG
    end

    sample 'What a #horrible idea' do
      expect(subject).to include("message")
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be_within(0.1).of(0.5)
    end

    sample 'What a #fantastic idea' do
      expect(subject).to include("message")
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be_within(0.1).of(0.5)
    end
  end

  describe 'twitter hashtag scoring with scrubbing' do
    let(:config) do <<-CONFIG
      filter {
        sentimentalizer {
            scrub => true
        }
      }
    CONFIG
    end

    sample 'What a #horrible idea' do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('negative')
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be < 0.1
    end

    sample 'What a #fantastic idea' do
      expect(subject).to include("message")
      expect(subject['sentiment']['polarity']).to eq('positive')
      expect(subject['sentiment']['probability']).to be_a(Float)
      expect(subject['sentiment']['probability']).to be > 0.9
    end
  end
end
