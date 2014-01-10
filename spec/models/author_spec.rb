require 'spec_helper'

describe Author do
  let(:author) { FactoryGirl.create(:author) }

  context "associations" do
    it { expect(author).to have_many(:books) }
  end
  context "validations" do
    it { expect(author).to validate_presence_of(:firstname) }
    it { expect(author).to validate_presence_of(:lastname) }
  end
end
