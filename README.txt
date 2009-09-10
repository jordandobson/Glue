= glue

http://GlueNow.com

== DESCRIPTION:

The Glue gem enables posting to GlueNow.com API service using an account subdomain, username, password. In this version you can add a post by providing a title and body. You can access some basic info about a users account and check if their account info is valid and request public posts from an account using the same RSS that powers many of the Glue feeds.

== FEATURES/PROBLEMS:


  Adding new posts requires Title & Body text
  Access info about an account with successful login:
    * Email Address
    * If they are an admin
    * Their Author Name
  Check a subdomain is valid and belongs to an account
  Read all public posts
  Gem is thoroughly tested
  Only allows Adding & Reading posts at this time
  You can't edit or delete posts


== SYNOPSIS:

TO ADD A POST USING THE GLUENOW.COM API

  1. Instantiate your account - Provide subdomain, username and password of http://Your-Subdomain.GlueNow.com Account
    
        account = Glue::API.new("your-subdomain", "your-username", "your-password")
        
  2. Check if the account subdomain is valid
  
        account.valid_site?   
        
  3. Get more info about the user's account
    
        user = account.user_info
        
        user #=> {"rsp"=>{"user"=>{"author"=>"Jordan Dobson","admin"=>"true","email"=>"jordandobson@gmail.com"},"stat"=>"ok"}}
        
  4. Post Your Content - Title & Body are required
    
        response = account.post("My Title", "Body Text")
        
  5. Receive a Success or Error Hash

      SUCCESS
    
        response #=> {"rsp"=>{"post"=>{"title"=>"My Title","url"=>"http://bit.ly/sakIM","id"=>"14415","longurl"=>"http://jordandobson.com"},"stat"=>"ok"}}
    
      ERROR
    
        response #=> {}
        
        
TO READ POSTS USING GLUENOW.COM RSS
        
  1. Instantiate your Reader with your account info - Provide subdomain for http://Your-Subdomain.GlueNow.com Account
    
        account = Glue::RSS.new("your-account")
        
  2. Request posts from the RSS feed - Include an optional limit & page view for paging
    
        all_the_posts = account.feed
        
      OR

        limited_posts = account.feed(10, 3)
        
  3. Receive a Success or Error Hash - Example is simplified to include important nodes

      SUCCESS
    
        all_the_posts #=> {"rss"=>{"channel"=>{"item"=>{"pubDate"=>"Fri, 12 Sep 2008 00:00:00 +0000","title"=>"My Title","guid"=>"http://jordandobson.com#14415","dc:creator"=>"Jordan","description"=>"<p>Body Text</p>","link"=>"http://jordandobson.com","source"=>"Glue"}}}} 
    
      ERROR
    
        all_the_posts #=> {}
        
        

== REQUIREMENTS:

HTTParty

== INSTALL:

sudo gem install glue

== LICENSE:

(The MIT License)

Copyright (c) 2009 Squad, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
