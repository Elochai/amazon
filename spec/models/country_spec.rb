require 'spec_helper'

describe Country do
  let(:country) { FactoryGirl.create(:country) }

  context "validations" do
    it { expect(country).to validate_presence_of(:name) }
    it { expect(country).to validate_uniqueness_of(:name) }
  end
end
