# == Schema Information
#
# Table name: motion_users
#
#  id         :integer          not null, primary key
#  motion_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MotionUser < ActiveRecord::Base
  attr_accessible :motion_id, :user_id

  validates :motion_id, :presence => true
  validates :user_id, :presence => true
  validates_uniqueness_of :motion_id, :scope => :user_id

  belongs_to :user
  belongs_to :motion

  after_destroy :check_remaining_users
  after_create :check_threshold_and_send_email


  def check_remaining_users
  	motion = Motion.find(motion_id)
  	motion.destroy if motion.users.blank?
  end

  def check_threshold_and_send_email
    if motion.threshold_met?
      motion.send_email
    end
  end


end
