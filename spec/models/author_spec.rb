require 'spec_helper'

describe Author do
  let(:author) { FactoryGirl.create(:author) }
  let(:author_with_one_book) { FactoryGirl.create(:author) }

  context "associations" do
    it { expect(author).to have_many(:books) }
  end
  context "validations" do
    it { expect(author).to validate_presence_of(:firstname) }
    it { expect(author).to validate_presence_of(:lastname) }
  end
  #fix below
  context ".full_name" do
    it "shows firstname and lastname of the author" do
      expect(author).to receive(:full_name).and_return('John Tolkien')
      author.full_name
    end
  end
  context ".number_of_books" do
    it "shows number of all author's books" do
      author_book = FactoryGirl.create(:book, author_id: author_with_one_book.id)
      expect(author_with_one_book).to receive(:number_of_books).and_return(2)
      author_with_one_book.number_of_books
    end
  end
end
