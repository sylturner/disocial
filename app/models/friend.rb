require 'open-uri'
class Friend < ActiveRecord::Base
  attr_accessible :name, :url
  before_update :set_name

  def set_name
    begin
      friend_profile = JSON.parse(open("#{url}/profile.json").read)
      friend_name = friend_profile["name"]
      self.name = friend_name
      self.last_error_message = nil
    rescue Errno::ECONNREFUSED => e
      #TODO: queue up to fetch later?
      self.last_error_message = "Friend's node is offline."
    end
  end

  def self.recent_updates
    friends = Friend.all
    updates = []
    offline_friends = []
    friends.each do |friend|
      begin
        recent_updates = JSON.parse(open("#{friend.url}/statuses/recent.json").read)
        updates << recent_updates.each{|update| update["friend"] = friend.attributes}
      rescue Errno::ECONNREFUSED => e
        offline_friends << friend
      end
    end
    updates.flatten!
    updates.sort!{|x,y| y["updated_at"] <=> x["updated_at"]}
    return {:updates => updates, :offline_friends => offline_friends}
  end
end
