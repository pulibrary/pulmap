require 'rails_helper'

describe BlacklightAdvancedSearch::ParsingNestingParser, type: :helper do
  subject(:parsing_nesting_parser) { Object.new.extend(BlacklightAdvancedSearch::ParsingNestingParser) }
  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.add_facet_field 'type'
    end
  end

  describe "#local_param_hash" do
    context 'with config[key] being nil' do
      let(:key) { "foo" }

      it "does not fail do no nil error" do
        expect { parsing_nesting_parser.local_param_hash(key, blacklight_config) }.not_to raise_error
      end
    end
  end
end
