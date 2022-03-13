# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :integer
#  photo_id   :integer
#
class Like < ApplicationRecord
  # from ideas first draft - additional validations
  validates(:photo_id, { :presence => true })
  validates(:photo_id, { :uniqueness => { :scope => ["fan_id"], :message => "already liked" } })
  validates(:fan_id, { :presence => true })

  # from ideas first draft - direct associations
  belongs_to(:user, { :foreign_key => "fan_id", :counter_cache => true })
  belongs_to(:photo, { :counter_cache => true })

end
