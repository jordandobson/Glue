= glue

http://Glue.RubyForge.org

http://GlueNow.com

== DESCRIPTION:

The Glue gem enables posting to GlueNow.com API service using an account subdomain, username, password. In this version you can add a post by providing a title, body, optional author name and optional private settings. You can also access some basic info about a users account and check if their account info is valid.

You can also request public posts from an account using the same RSS that powers the many Glue feeds.

== FEATURES/PROBLEMS:

* To Add a new post Title & Body text must be included
* Access info about an account with successful login:
  * Email Address
  * If they are an admin
  * Thier Author Name
* Can check if a subdomain is valid and belongs to an account
* Read all public posts
* This Gem is throughly tested
* Adding & Reading posts Only at this time
* You can't editor delete a posts yet
* No way to verify if a post has accepted the author name yet


== SYNOPSIS:

---- Adding Posts ----

1. Instantiate your account

    * Provide the subdomain, username and password for http://Your-Account.GlueNow.com
    
        account = Glue::API.new( "your-account", "j-username", "j-password" )
        
2. Check if the account subdomain is valid
  
        account.valid_site?   
        
3. Get more info about the user's account
    
        response = account.user_info
        
        response #=> {"rsp"=>{"user"=>{"author"=>"Jordan Dobson","admin"=>"true","email"=>"jordandobson@gmail.com"},"stat"=>"ok"}}
        
4. Post your Content

    * Both Title and Body are required - Set to a variable to check the response
    
        response = account.post("My Title", "My Body")
        
    * You can also choose to set the post as private and/or use the optional Author Name
    * In this example we set false for not private and true to use the author name
    
        response = account.post("My Title", "My Body", false, true) 
        

5. Get a success or error hash back

    * A Successful response would look like this
    
        response #=> {"rsp"=>{"post"=>{"title"=>"My Title","url"=>"http://bit.ly/sakIM","id"=>"14415","longurl"=>"http://jordandobson.com"},"stat"=>"ok"}}
    
    * A Error response would be empty like this
    
        response #=> {}

---- Reading Posts ----
        
1. Instantiate your Reader with your account info

    * Provide the subdomain for http://Your-Account.GlueNow.com
    
        account = Glue::RSS.new( "your-account" )
        
2. Request posts from the RSS feed

    * If you want all of them don't include any limiting or range. Defaults to up to 999 posts on one page
    
        response = account.feed
        
    * If you want to limit the results include a limit (1-999) and which page (used for paging)

        response = account.feed(10, 3)
        
3. Get an RSS feed back or HTML page - These Examples are simplified to include most important nodes

    * A successful RSS response would look like 
    
        response #=> {"rss"=>{"channel"=>{"item"=>{"pubDate"=>"Fri, 12 Sep 2008 00:00:00 +0000","title"=>"My Title","guid"=>"http://jordandobson.com#14415","dc:creator"=>"Jordan","description"=>"<p>My Body</p>","link"=>"http://jordandobson.com","source"=>"Glue"}}}} 
    
    * A failed HTML responsed would look like
    
        response #=> {"html"=>{"head"=>{"title"=>"GLUE | Web + Mobile Content Publishing"},"body"=>"<p>Webpage Body</p>"}}

== REQUIREMENTS:

* Mechanize & HTTParty
* Mocha (for tests)

== INSTALL:

* sudo gem install glue -include-dependencies

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
