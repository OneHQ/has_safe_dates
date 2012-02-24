HasSafeDates
===========================

Installation
------------------------

In your Gemfile:

    gem "has_safe_dates"

Do a bundle install, then for each model add the has_safe_dates class method to your model:

    class Post < ActiveRecord::Base
      has_safe_dates :published_date
    end

You can now do things like this:

    post.update_attributes(:published_date => '1st of November 2012')

And it will work.

Uses [Chronic](https://github.com/mojombo/chronic) for parsing of the dates to help
