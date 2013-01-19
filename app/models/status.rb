class Status < ActiveRecord::Base
  attr_accessible :message

  def self.recent(since)
    where(['updated_at >= ?', since]).order("updated_at desc")
  end
end
