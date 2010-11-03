ActiveRecord::Schema.define(:version => 0) do
  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
