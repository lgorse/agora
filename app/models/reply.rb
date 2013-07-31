# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  motion_id  :integer
#  user_id    :integer
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reply < ActiveRecord::Base
  attr_accessible :motion_id, :text, :user_id

  belongs_to :user
  belongs_to :motion

  validates :motion, :presence => true
  validates :user, :presence => true
  validates :text, :presence => true

  default_scope :order => "created_at DESC"
end
