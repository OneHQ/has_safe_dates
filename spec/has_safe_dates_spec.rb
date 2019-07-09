require 'spec_helper'

class TestUser < ActiveRecord::Base; end

class Post < ActiveRecord::Base
  has_safe_dates :published_date, :safe_date, :error_message => 'is not a real date'
end

class Comment < ActiveRecord::Base
  has_safe_dates :approved_at, :published_at, :error_message => 'is not a real date'
end

describe "HasSafeDates" do

  before(:each) do
    @post = Post.new
    @comment = Comment.new
  end

  describe "class method" do

    it "should work" do
      expect {
        TestUser.send(:has_safe_dates, :published_date)
      }.to_not raise_error
    end

    it "should raise an error if no fields are passed in" do
      expect {
        TestUser.send(:has_safe_dates)
      }.to raise_error(ArgumentError, 'Must define the fields you want to be converted to safe dates with "has_safe_dates :my_field_name_date, :my_other_field_name_date"')
    end

    it "does not touch an field that it has not been told to make safe" do
      @post.update_attribute(:unsafe_date, '1st of December 2012')
      @post.reload
      @post.unsafe_date.should be_nil
    end
  end

  describe "safe date parsing" do

    ['2012-12-1', '1st of December 2012', 'first of dec 2012', '1 Dec 2012'].each do |date|
      it "allows you to set the date as '#{date}'" do
        @post.update_attribute(:safe_date, date)
        @comment.update_attribute(:approved_at, date)
        @post.reload
        @comment.reload
        @post.safe_date.should == Date.new(2012, 12, 1)
        @comment.approved_at.should == Date.new(2012, 12, 1)
      end
    end

    ['     ', '', nil].each do |date|
      it "sets the field to nil if given the blank value #{date.inspect}" do
        @post.safe_date = date
        @post.valid?
        @post.safe_date.should == nil
        @post.errors.should be_blank
      end
    end

    ['random', 'does not compute'].each do |date|
      it "sets the field to nil and sets a validation error if given the value #{date.inspect}" do
        @post.safe_date = date
        @post.valid?
        @post.safe_date.should == nil
        @post.errors.should_not be_blank
        @post.errors[:safe_date].should == ['is not a real date']
      end
    end

  end

  describe "multiparameter parsing" do

    it "doesn't blow up when given an incorrect values" do
      invalid_post_attributes = {'published_date(1i)' => "2001", 'published_date(2i)' => "12", 'published_date(3i)' => "abc"}
      invalid_comment_attributes = {'approved_at(1i)' => "2001", 'approved_at(2i)' => "15", 'approved_at(3i)' => "17"}
      expect {
        @post.update(invalid_post_attributes)
        @comment.update(invalid_comment_attributes)
      }.to_not raise_error
    end

    it "does not interfere with a date column that it has not been told to make safe" do
      invalid_attributes = {'unsafe_date(1i)' => "2001", 'unsafe_date(2i)' => "12", 'unsafe_date(3i)' => "abc"}
      expect {
        @post.update(invalid_attributes)
      }.to raise_error(ActiveRecord::MultiparameterAssignmentErrors)
    end

    it "adds an error when Chronic returns nil" do
      invalid_post_attributes = {'published_date(1i)' => "2014", 'published_date(2i)' => "12", 'published_date(3i)' => "abc"}
      @post.update(invalid_post_attributes)
      @post.errors[:published_date].should == ['is not a real date']
    end

    context "with time" do
      it "works" do
        invalid_comment_attributes = {'published_at(1i)' => "2014", 'published_at(2i)' => "12", 'published_at(3i)' => "22", 'published_at(4i)' => "12", 'published_at(5i)' => "34"}
        expect {
          @comment.update(invalid_comment_attributes)
        }.to_not raise_error
        expect(@comment.published_at.utc.strftime("%FT%T%:z")).to eq(Time.new(2014, 12, 22, 12, 34).utc.strftime("%FT%T%:z"))
      end

      it "doesn't blow up when given an incorrect values" do
        invalid_post_attributes = {'published_date(1i)' => "2001", 'published_date(2i)' => "12", 'published_date(3i)' => "17", 'published_date(4i)' => "12", 'published_date(5i)' => "34"}
        invalid_comment_attributes = {'published_at(1i)' => "2001", 'published_at(2i)' => "15", 'published_at(3i)' => "17", 'published_at(4i)' => "12", 'published_at(5i)' => "34"}
        expect {
          @post.update(invalid_post_attributes)
          @comment.update(invalid_comment_attributes)
        }.to_not raise_error
      end

      it "does not interfere with a date column that it has not been told to make safe" do
        invalid_attributes = {'unsafe_date(1i)' => "2011", 'unsafe_date(2i)' => "9", 'unsafe_date(3i)' => "83", 'unsafe_date(4i)' => "12", 'unsafe_date(5i)' => "34"}
        expect {
          @post.update(invalid_attributes)
        }.to raise_error(ActiveRecord::MultiparameterAssignmentErrors)
      end

      it "adds an error when Chronic returns nil" do
        invalid_comment_attributes = {'published_at(1i)' => "2009", 'published_at(2i)' => "12", 'published_at(3i)' => "90", 'published_at(4i)' => "12", 'published_at(5i)' => "34"}
        @comment.update(invalid_comment_attributes)
        @comment.errors[:published_at].should == ['is not a real date']
      end
    end
  end

end
