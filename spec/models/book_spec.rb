require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book) }
  let(:second_book) { FactoryGirl.create(:book) }
  let(:rating) { FactoryGirl.create(:rating, book_id: book.id) } #rating = 10
  let(:rating2) { FactoryGirl.create(:rating, rating: 6, book_id: book.id) }
  let(:category) { FactoryGirl.create(:category) }
  let(:author) { FactoryGirl.create(:author) }
  let(:book_with_author) { FactoryGirl.create(:book, author: author) }
  let(:book_with_category) { FactoryGirl.create(:book, category: category) }
  let(:rating_for_second_book) { FactoryGirl.create(:rating, rating: 6, book_id: second_book.id) }
  
  context "associations" do
    it { expect(book).to have_many(:ratings).dependent(:destroy) }
    it { expect(book).to belong_to(:author) }
    it { expect(book).to belong_to(:category) }
    it { expect(book).to have_and_belong_to_many(:wishers).class_name("Customer") }
  end

  context "validations" do
    it { expect(book).to validate_presence_of(:title) }
    it { expect(book).to validate_presence_of(:price) }
    it { expect(book).to validate_presence_of(:in_stock) }
    it { expect(book).to validate_numericality_of(:in_stock).is_greater_than_or_equal_to(0) }
    it { expect(book).to validate_numericality_of(:price).is_greater_than_or_equal_to(0.01) }
    it { expect(book).to ensure_length_of(:description).is_at_most(400) }
  end

  context ".top_rated scope" do
    it "orders first 5 records with descending avg_rating" do
      rating.approved = true
      rating2.approved = true
      rating_for_second_book.approved = true
      rating.save!
      rating2.save!
      rating_for_second_book.save!
      expect(Book.top_rated).to eq([book, second_book])
    end
  end

  context ".with_author_id scope" do
    it "selects recors with certain author_id" do
      expect(Book.with_author_id(author.id)).to include(book_with_author)
    end
    it "do not selects recors without certain author_id" do
      expect(Book.with_author_id(author.id)).to_not include(book_with_category)
    end
  end

  context ".with_category_id scope" do
    it "selects recors with certain category_id" do
      expect(Book.with_category_id(category.id)).to include(book_with_category)
    end
    it "do not selects recors without certain category_id" do
      expect(Book.with_category_id(category.id)).to_not include(book_with_author)
    end
  end

  context ".sorted_by scope" do
    before do
      book.title = 'A'
      book.created_at = Time.now
      book.save
      second_book.title = "B"
      second_book.created_at = Time.now + 5.days
      second_book.save
    end
    it "orders recors by ascending title" do
      expect(Book.sorted_by('title_asc')).to eq([book, second_book])
    end
    it "orders recors by descending title" do
      expect(Book.sorted_by('title_desc')).to eq([second_book, book])
    end
    it "orders recors by descending creation date" do
      expect(Book.sorted_by('created_at_desc')).to eq([second_book, book])
    end
    it "orders recors by ascending creation date" do
      expect(Book.sorted_by('created_at_asc')).to eq([book, second_book])
    end
  end

  context ".search_query scope" do
    it "search recors with given title" do
      expect(Book.search_query(book.title)).to eq([book])
    end
  end

  context ".recalculate_avg_rating!" do
    it "counts and set avarage rating of the book if it has approved ratings" do
      rating.approved = true
      rating2.approved = true
      rating.save!
      rating2.save!
      book.recalculate_avg_rating!
      expect(book.reload.avg_rating).to eq(8)
    end
    it "sets zero rating for the book if it hasn't approved rating" do
      rating.approved = false
      rating2.approved = false
      rating.save!
      rating2.save!
      book.recalculate_avg_rating!
      expect(book.avg_rating).to eq(0)
    end
    it "sets zero rating for the book if it has no rating" do
      Rating.all.destroy_all
      book.recalculate_avg_rating!
      expect(book.avg_rating).to eq(0)
    end
  end
end

