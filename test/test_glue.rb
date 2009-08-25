require "test/unit"
require "#{File.dirname(__FILE__)}/../lib/glue.rb"
require "mocha"

class TestGlue < Test::Unit::TestCase

  def setup
    @subdomain  = 'AccountSubDomain'
    @username   = 'Username'
    @password   = 'Password'
    @client     = Glue::API.new( @subdomain, @username, @password )
    @title      = "My Title"
    @title2     = "Your Title"
    @body       = "Body Text"
    @body2      = "Hello World"
    @url        = "http://bit.ly/sakIM"
    @id         = "14415"
    @id2        = "14416"
    @lurl       = "http://jordandobson.com"
    @guid       = "#{@lurl}##{@id}"
    @guid2      = "#{@lurl}##{@id2}"
    @author     = "Jordan"
    
    @resp_fail  = {}
    
    @resp_ok    = { "rsp"     => {
                    "user"    => {
                    "author"  => @author,
                    "admin"   => "true"  ,
                    "email"   => nil    },
                    "stat"    => "ok"   }}
                    
    @post_ok    = { "rsp"     => {
                    "post"    => {
                    "title"   => @title , 
                    "url"     => @url   , 
                    "id"      => @id    , 
                    "longurl" => @lurl  },
                    "stat"    => "ok"   }}
                    
    @rss        = { "rss"         => {
                    "channel"     => {
                    "item"        => {
                    "pubDate"     => "Fri, 12 Sep 2008 00:00:00 +0000", 
                    "title"       => @title             , 
                    "guid"        => @guid              , 
                    "dc:creator"  => @author            , 
                    "description" => "<p>#{@body}</p>"  , 
                    "link"        => @lurl              ,
                    "source"      => "Glue"             }}}}
                    
    @rss_many   = { "rss"         => {
                    "channel"     => {
                    "item"        => [{
                    "pubDate"     => "Fri, 12 Sep 2008 00:00:00 +0000", 
                    "title"       => @title             , 
                    "guid"        => @guid              , 
                    "dc:creator"  => @author            , 
                    "description" => "<p>#{@body}</p>"  , 
                    "link"        => @lurl              ,
                    "source"      => "Glue"             },{
                    "pubDate"     => "Fri, 12 Sep 2009 00:00:00 +0000", 
                    "title"       => @title2            , 
                    "guid"        => @guid2             , 
                    "dc:creator"  => nil                , 
                    "description" => "<p>#{@body2}</p>" , 
                    "link"        => @lurl              ,
                    "source"      => "Glue"             }]}}}
                    
    @rss_empty  = { "rss"         => {
                    "channel"     => {
                    "pubDate"     => "Tue, 18 Aug 2009 10:48:28 +0000"  ,
                    "webMaster"   =>  "glue@jordan.gluenow.com (Glue)"  ,
                    "link"        =>  "http://jordandobson.com"         }}}
                    
    @html_page  = { "html"        => {
                    "head"        => {
                    "title"       => "GLUE | Web + Mobile Content Publishing" },
                    "body"        => "<p>Webpage Body</p>"                    }}
  end

  def test_raises_without_account_url
    assert_raise Glue::AuthError do
      Glue::API.new( '' , @username, @password )
    end
  end

  def test_raises_without_user
    assert_raise Glue::AuthError do
      Glue::API.new( @subdomain, '', @password )
    end
  end

  def test_raises_without_password
    assert_raise Glue::AuthError do
      Glue::API.new( @subdomain, @username, '' )
    end
  end

  def test_raises_with_number_account_url
    assert_raise NoMethodError do
      Glue::API.new( 00 , @username, @password )
    end
  end

  def test_raises_with_number_user
    assert_raise NoMethodError do
      Glue::API.new( @subdomain, 00, @password )
    end
  end

  def test_raises_with_number_password
    assert_raise NoMethodError do
      Glue::API.new( @subdomain, @username, 00 )
    end
  end

  def test_site_is_valid
    OpenURI.stubs(:open_uri).returns('<body id="login"></body>')
    assert    @client.valid_site?
  end

  def test_site_is_invalid
    OpenURI.stubs(:open_uri).returns('<body></body>')
    assert   !@client.valid_site?
  end

  def test_user_info_valid
    Glue::API.stubs(:post).returns(@resp_ok)
    actual       = @client.user_info
    assert_equal   "ok",     actual["rsp"]["stat"]
    assert                   actual["rsp"]["user"]
    assert_equal   "Jordan", actual["rsp"]["user"]["author"]
    assert_equal   "true",   actual["rsp"]["user"]["admin"]
    assert_equal   nil,      actual["rsp"]["user"]["email"]
  end

  def test_user_info_invalid
    Glue::API.stubs(:post).returns(@resp_fail)
    actual       = @client.user_info
    assert_equal   @resp_fail, actual
  end

  def test_bad_post_response
    Glue::API.stubs(:post).returns(@resp_fail)
    actual       = @client.post(@title, @body)
    assert_equal   @resp_fail, actual
  end

  def test_good_post_response
    Glue::API.stubs(:post).returns(@post_ok)
    actual       = @client.post(@title, @body)
    assert_equal   "ok",     actual["rsp"]["stat"]
    assert                   actual["rsp"]["post"]
    assert_equal   @title,   actual["rsp"]["post"]["title"]
    assert_equal   @url,     actual["rsp"]["post"]["url"]
    assert_equal   @id,      actual["rsp"]["post"]["id"]
    assert_equal   @lurl,    actual["rsp"]["post"]["longurl"]
  end
  
  # Need to test posting with the options
  
  def test_reading_single_post
      Glue::RSS.stubs(:get).returns(@rss)
      actual      = Glue::RSS.new('jordan').feed(1,1)['rss']['channel']["item"]
      assert_equal  @title,  actual["title"]
      assert_match  @body,   actual["description"]
      assert_equal  @lurl,   actual["link"]
      assert_equal  @guid,   actual["guid"]
      assert_equal  @author, actual["dc:creator"]
  end
  
  def test_reading_multiple_posts
      Glue::RSS.stubs(:get).returns(@rss_many)
      actual      = Glue::RSS.new('jordan').feed['rss']['channel']["item"]
      assert_equal  2,       actual.length

      # First Article
      assert_equal  @title,  actual.first["title"]
      assert_match  @body,   actual.first["description"]
      assert_equal  @lurl,   actual.first["link"]
      assert_equal  @guid,   actual.first["guid"]
      assert_equal  @author, actual.first["dc:creator"]

      # Last Article
      assert_equal  @title2, actual.last["title"]
      assert_match  @body2,  actual.last["description"]
      assert_equal  nil,     actual.last["dc:creator"]
      assert_equal  @lurl,   actual.last["link"]
      assert_equal  @guid2,  actual.last["guid"]
      
      assert_not_equal  actual.first["title"],       actual.last["title"]
      assert_not_equal  actual.first["description"], actual.last["description"]
      assert_not_equal  actual.first["dc:creator"],  actual.last["dc:creator"]
      assert_not_equal  actual.first["guid"],        actual.last["guid"]
      assert_equal      actual.first["link"],        actual.last["link"]
  end
  
  def test_no_public_posts_available
      Glue::RSS.stubs(:get).returns(@rss_empty)
      subdomain  = 'jordan'
      actual     = Glue::RSS.new(subdomain).feed
      assert       actual["rss"]["channel"]
      assert_nil   actual["rss"]["channel"]["item"]
      assert_match subdomain,   actual["rss"]["channel"]["webMaster"]
  end
  
  def test_bad_url
      Glue::RSS.stubs(:get).returns(@html_page)
      actual    = Glue::RSS.new('666-DIE-666').feed
      assert      actual["html"]
      assert_nil  actual["rss"]
      assert_raise NoMethodError do
        actual["rss"]["channel"]
      end      
   end

end