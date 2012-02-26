# require File.join(File.dirname(__FILE__), 'fixtures/document')

ActiveRecord::Schema.define(:version => 0) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.date     "approved_at"
    t.date     "created_at"
    t.date     "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.date     "published_date"
    t.date     "safe_date"
    t.date     "unsafe_date"
    t.date     "created_at"
    t.date     "updated_at"
  end

end
