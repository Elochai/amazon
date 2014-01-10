require 'spec_helper'

describe Category do
  let(:category) { FactoryGirl.create(:category) }

  context "associations" do
    it { expect(category).to have_many(:books) }
  end
  context "validations" do
    it { expect(category).to validate_presence_of(:title) }
    it { expect(category).to validate_uniqueness_of(:title) }
  end
end