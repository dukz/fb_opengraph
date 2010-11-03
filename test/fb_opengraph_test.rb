require 'test_helper'

class FbOpengraphTest < ActiveSupport::TestCase
  load_schema

  class Movie < ActiveRecord::Base
    has_fb_opengraph  :type => 'movie',
                      :title => :title,
                      :description => :description
  end

  def setup
    # Data Source: http://developers.facebook.com/docs/opengraph
    @movie = Movie.new(
      :title        => 'The Rock',
      :description  => 'A group of U.S. Marines, under command of a renegade general, take over Alcatraz and threaten San Francisco Bay with biological weapons.'
    )
    @movie.save
  end

  test "schema_loaded_properly" do
    assert_equal Array, Movie.all.class
  end

  test "fb_opengraph_meta_tags" do
    fb_opengraph_meta_tags = @movie.fb_opengraph_meta_tags
    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:type" content="movie" />'
    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:title" content="The Rock" />'
    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:description" content="A group of U.S. Marines, under command of a renegade general, take over Alcatraz and threaten San Francisco Bay with biological weapons." />'
  end
end
