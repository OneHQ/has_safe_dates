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

Development
-------------------------

HasSafeDates is developed under Ruby-1.9.2-p290

To get the tests to run, make sure you have sqlite3 installed on your system, then
run:

    $ bundle install
    $ rake

Publishing and Releasing a Gem
--------------------------

Do the following to publish and push a new gem:

1) Make sure the local working copy is clean with no pending commits:

    $ git status
    # On branch master
    nothing to commit (working directory clean)

2) Edit the version number and increment per SEMVER versioning:

    $ vi lib/has_safe_dates/version.rb

3) Run gem build to create the gem:

    $ gem build has_safe_dates.gemspec

4) Test install the gem locally:

    $ gem install has_safe_dates-0.0.1.gem

5) Commit any changes and tag the commit at the current version:

    $ git commit lib/has_safe_dates/version.rb -m "Releasing v0.0.1"
    $ git tag v0.0.1
    $ git push

6) Push the gem to rubygems:

    $ gem push has_safe_dates-0.0.1.gem

