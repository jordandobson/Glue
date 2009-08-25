require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'open-uri'

module Glue

  VERSION = '1.0.3'
  DOMAIN  = 'gluenow.com'

  class AuthError < StandardError;                   end
  class FormatHelper; include HTTParty; format :xml; end

  class API < Glue::FormatHelper
  
    POST   = '/api/post'
    USER   = '/api/user'

    def initialize subdomain, user, pass
      raise  AuthError, 'Username, Password or Account subdomain is blank.' \
        if subdomain.empty? || user.empty? || pass.empty?
      @auth   = { :username => user, :password => pass }
      @site   = "#{subdomain}.#{DOMAIN}"
      self.class.base_uri @site
    end

    def valid_site?
      Nokogiri::HTML(open("http://#{@site}")).at('body#login') ? true : false
    end

    def user_info
      self.class.post(USER, :query => {}, :basic_auth => @auth)
    end

    def post title, body, *opts
      self.class.post(
        POST,
        :query      =>  {
        :title      =>  title,
        :body       =>  body,
        :draft      =>  opts.include?( :draft  )  ,
        :author     =>  opts.include?( :author )  },
        :basic_auth =>  @auth
      )
    end

  end
  
  class RSS < Glue::FormatHelper

    NEWS = '/news/rss'
    
    def initialize subdomain
      raise  AuthError, 'Account Subdomain is missing or blank' if subdomain.empty?
      self.class.base_uri "#{subdomain}.#{DOMAIN}"
    end
    
    def feed limit=999, page=1
      self.class.get("#{NEWS}?limit=#{limit}&page=#{page}")
    end
  
  end

end