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

    @movie_with_special_characters = Movie.new(
      :title        => 'A & B Says "Cool Wassup?" <Woops>',
      :description  => ''
    )
    @movie_with_special_characters.save
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

  test "fb_opengraph_meta_tag_options_take_precedence_over_default_options" do
    fb_opengraph_meta_tags = @movie.fb_opengraph_meta_tags(:description => 'overwrite it', :url => 'http://www.imdb.com/')

    assert (not fb_opengraph_meta_tags.include?('<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:description" content="A group of U.S. Marines, under command of a renegade general, take over Alcatraz and threaten San Francisco Bay with biological weapons." />'))
    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:description" content="overwrite it" />'

    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:url" content="http://www.imdb.com/" />'
  end

  test "fb_opengraph_meta_tags_content_should_be_html_escaped" do
    fb_opengraph_meta_tags = @movie_with_special_characters.fb_opengraph_meta_tags
    assert (not fb_opengraph_meta_tags.include?('<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:title" content="A & B Says "Cool Wassup?" <Woops>" />'))
    assert fb_opengraph_meta_tags.include? '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:title" content="A &amp; B Says &quot;Cool Wassup?&quot; &lt;Woops&gt;" />'
  end 

  test "fb_opengraph_meta_tags_with_empty_content_should_not_be_added" do
    fb_opengraph_meta_tags = @movie_with_special_characters.fb_opengraph_meta_tags
    assert (not fb_opengraph_meta_tags.include?('<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:description" content="" />'))
  end
end
