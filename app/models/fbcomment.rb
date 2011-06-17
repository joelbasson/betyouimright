class Fbcomment
  include HTTParty
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  format :json
  attr_accessor :id, :user, :message, :created_time, :comments
  
  def self.find_by_page(page)
    result = get('https://graph.facebook.com/comments', :query => {:ids => page, :output => 'json'})
    if result && !result["error"]
      return result["#{page}"]["data"]
    else
      Array.new
    end
  end
  
  def self.build_from_page(page)
    result = get('https://graph.facebook.com/comments', :query => {:ids => page, :output => 'json'})
    if result && !result["error"]
      return Fbcomment.build_comments(result["#{page}"]["data"])
    else
      return Array.new
    end
  end
  
  def self.build_comments(comments)
      fbcomments = Array.new
      comments.each do |key, value|
         fbcomment = Fbcomment.new
         fbcomment.id = key["id"]
         fbcomment.message = key["message"]
         fbcomment.created_time = key["created_time"].to_time
         fbcommentuser = Fbcommentuser.new
         fbcommentuser.id = key["from"]["id"]
         fbcommentuser.name = key["from"]["name"]
         fbcomment.user = fbcommentuser
         fbcomment.comments = Array.new
         if key["comments"]
           fbcomment.comments = Fbcomment.build_comments(key["comments"]["data"])
         end 
         fbcomments << fbcomment
      end
      fbcomments
  end
  
end