require 'spec_helper'

class TestUser < ActiveRecord::Base; end

class Post < ActiveRecord::Base
  has_safe_dates :published_date, :safe_date, :error_message => 'is not a real date'
end

describe "HasSafeDates" do

  before(:each) do 
    @post = Post.new
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
        @post.reload
        @post.safe_date.should == Date.new(2012, 12, 1)
      end
    end

    ['     ', '', nil].each do |date|
      it "sets the field to nil if given the blank value #{date.inspect}" do
        @post.update_attribute(:safe_date, date)
        @post.reload
        @post.safe_date.should == nil
        @post.errors.should be_blank
      end
    end

    ['random', 'does not compute'].each do |date|
      it "sets the field to nil and sets a validation error if given the value #{date.inspect}" do
        @post.update_attribute(:safe_date, date)
        @post.reload
        @post.safe_date.should == nil
        @post.errors.should_not be_blank
      end
    end
  end

  describe "multiparameter parsing" do
    it "doesn't blow up when given an incorrect values" do
      invalid_attributes = {'published_date(1)' => "abc", 'published_date(2)' => "12", 'published_date(3)' => "1"}      
      expect {
        @post.update_attributes(invalid_attributes)
      }.to_not raise_error
    end

    it "does not interfere with a date column that it has not been told to make safe" do
      invalid_attributes = {'unsafe_date(1)' => "abc", 'unsafe_date(2)' => "12", 'unsafe_date(3)' => "1"}      
      expect {
        @post.update_attributes(invalid_attributes)
      }.to raise_error(ActiveRecord::MultiparameterAssignmentErrors, '1 error(s) on assignment of multiparameter attributes')
    end

  end



end