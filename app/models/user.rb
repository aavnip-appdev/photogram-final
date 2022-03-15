# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  comments_count                 :integer
#  email                          :string
#  likes_count                    :integer
#  own_photos_count               :integer
#  password_digest                :string
#  private                        :boolean
#  received_follow_requests_count :integer
#  sent_follow_requests_count     :integer
#  username                       :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class User < ApplicationRecord
  # from draft account generator
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  # from ideas first draft - additional username validations
  validates(:username, { :presence => true })
  validates(:username, { :uniqueness => true })

  # from ideas first draft - direct associations
  has_many(:likes, { :foreign_key => "fan_id", :dependent => :destroy })
  has_many(:comments, { :foreign_key => "author_id", :dependent => :destroy })
  has_many(:sent_follow_requests, { :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy })
  has_many(:received_follow_requests, { :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:own_photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })

  # from ideas first draft - indirect associations
  has_many(:following, { :through => :sent_follow_requests, :source => :recipient })
  has_many(:followers, { :through => :received_follow_requests, :source => :sender })
  has_many(:liked_photos, { :through => :likes, :source => :photo })
  has_many(:feed, { :through => :following, :source => :own_photos })
  has_many(:activity, { :through => :following, :source => :liked_photos })

 
  def sender_follow_requests_accepted
    user_id = self.id
    accepted_requests = FollowRequest.where(:sender_id => user_id).where(:status => "accepted")

    accepted_ids = Array.new

    accepted_requests.each do |accepted|
    accepted_ids.push(accepted.recipient_id)
    end

    return accepted_ids 

  end
  
  def sender_follow_requests_pending
    user_id = self.id
    pending_requests = FollowRequest.where(:sender_id => user_id).where(:status => "pending")

    pending_ids = Array.new

    pending_requests.each do |pending|
    pending_ids.push(pending.recipient_id)
    end

    return pending_ids 
  end

  def sender_follow_requests_rejected
    user_id = self.id
    rejected_requests = FollowRequest.where(:sender_id => user_id).where(:status => "rejected")

    rejected_ids = Array.new

    rejected_requests.each do |rejected|
    rejected_ids.push(rejected.recipient_id)
    end

    return rejected_ids 
  end

  def recipient_follow_requests_accepted
    user_id = self.id
    pending_requests = FollowRequest.where(:recipient_id => user_id).where(:status => "accepted")

    pending_requests_ids = Array.new

    pending_requests.each do |pending|
    pending_requests_ids.push(pending.sender_id)
    end

    return pending_requests_ids 
  end

  
  def recipient_follow_requests_pending
    user_id = self.id
    pending_requests = FollowRequest.where(:recipient_id => user_id).where(:status => "pending")

    pending_requests_ids = Array.new

    pending_requests.each do |pending|
    pending_requests_ids.push(pending.sender_id)
    end

    return pending_requests_ids 
  end

end
