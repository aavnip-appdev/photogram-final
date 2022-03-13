# == Schema Information
#
# Table name: follow_requests
#
#  id           :integer          not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
class FollowRequest < ApplicationRecord
  # from ideas first draft - additional validations
  validates(:sender_id, { :presence => true })
  validates(:recipient_id, { :presence => true })
  validates(:recipient_id, { :uniqueness => { :scope => ["sender_id"], :message => "already requested" } })

  # from ideas first draft - direct associations
  belongs_to(:sender, { :class_name => "User", :counter_cache => :sent_follow_requests_count })
  belongs_to(:recipient, { :class_name => "User", :counter_cache => :received_follow_requests_count })

end
