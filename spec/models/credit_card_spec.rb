require 'spec_helper'

describe CreditCard do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  context "associations" do
    it { expect(credit_card).to belong_to(:order) }
    it { expect(credit_card).to belong_to(:customer) }
  end
  context "validations" do
    it { expect(credit_card).to validate_presence_of(:number) }
    it { expect(credit_card).to validate_presence_of(:cvv) }
    it { expect(credit_card).to validate_presence_of(:expiration_month) }
    it { expect(credit_card).to validate_presence_of(:expiration_year) }
    it { expect(credit_card).to validate_presence_of(:firstname) }
    it { expect(credit_card).to validate_presence_of(:lastname) }
    it { expect(credit_card).to ensure_inclusion_of(:expiration_month).in_range(Time.now.month + 1..12) }
    it 'validate inclusion of exp year if december' do
      if Date.today.month == 12
        expect(credit_card).to ensure_inclusion_of(:expiration_year).in_range(Time.now.year + 1..Time.now.year + 15) 
      end
    end
    it 'validate inclusion of exp year if not december' do
      if Date.today.month != 12
        expect(credit_card).to ensure_inclusion_of(:expiration_year).in_range(Time.now.year..Time.now.year + 15) 
      end
    end
    it { expect(credit_card).to allow_value('1234567890123456').for(:number).with_message("should contain 12-16 digits")}
    it { expect(credit_card).to_not allow_value('12345').for(:number).with_message("should contain 12-16 digits")}
    it { expect(credit_card).to allow_value('1234').for(:cvv).with_message("should 3-4 digits")}
    it { expect(credit_card).to_not allow_value('12345').for(:cvv).with_message("should 3-4 digits")}
  end
end
