require 'open-uri'
class Friend < ActiveRecord::Base
  attr_accessible :name, :url
  before_create :set_name

  def set_name
    friend_profile = JSON.parse(open("#{url}/profile.json").read)
    friend_name = friend_profile["name"]
    self.name = friend_name
  end

  def self.recent_updates
    friends = Friend.all
    updates = []
    friends.each do |friend|
      recent_updates = JSON.parse(open("#{friend.url}/statuses/recent.json").read)
      updates << recent_updates.each{|update| update["friend"] = friend.attributes}
    end
    updates.flatten!
    updates.sort!{|x,y| y["updated_at"] <=> x["updated_at"]}
  end
end
