# == Schema Information
#
# Table name: noise_users
#
#  id         :integer          not null, primary key
#  noise_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NoiseUser < ActiveRecord::Base
  attr_accessible :noise_id, :user_id

  validates :noise_id, :presence => true
  validates :user_id, :presence => true
  validates_uniqueness_of :noise_id, :scope => :user_id

  belongs_to :user
  belongs_to :noise

  after_destroy :check_remaining_users
  after_create :check_threshold_and_send_email


  def check_remaining_users
  	noise = Noise.find(noise_id)
  	noise.destroy if noise.users.blank?
  end

  def check_threshold_and_send_email
    if noise.threshold_met?
      noise.send_email
    end
  end


end
