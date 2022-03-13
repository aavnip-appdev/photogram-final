# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  # from ideas first draft - additional validations
  validates(:owner_id, { :presence => true })
  validates(:image, { :presence => true })

  # from ideas first draft - direct associations
  belongs_to(:owner, { :class_name => "User", :counter_cache => :own_photos_count })
  has_many(:likes, { :dependent => :destroy })
  has_many(:comments, { :dependent => :destroy })

  # from ideas first draft - indirect associations
  has_many(:fans, { :through => :likes, :source => :user })
  has_many(:followers, { :through => :owner, :source => :following })
  has_many(:fan_followers, { :through => :fans, :source => :following })

end
