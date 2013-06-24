# == Schema Information
#
# Table name: noises
#
#  id          :integer          not null, primary key
#  created_by  :integer
#  account_id  :integer
#  expires_at  :time
#  threshold   :integer
#  create_text :string(255)
#  agree_text  :string(255)
#  cancel_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email_sent  :boolean
#

class Noise < ActiveRecord::Base
  attr_accessible :account_id, :agree_text, :cancel_text, :create_text, :created_by, :expires_at, :threshold

  validates :created_by, :presence => true
  validates :account, :presence => true
  validates :expires_at, :presence => true
  validates :threshold, :presence => true
  validates :create_text, :presence => true, :length => {:within => 1..MAX_BUTTON_TEXT}
  validates :agree_text, :presence => true, :length => {:within => 1..MAX_BUTTON_TEXT}
  validates :cancel_text, :presence => true, :length => {:within => 1..MAX_BUTTON_TEXT}
  validate :expires_at_cannot_be_in_the_past
  validate :cannot_have_two_unexpired_noises_in_same_account, :unless => "account.nil?"

  has_many :noise_users
  has_many :users, :through => :noise_users
  belongs_to :account

  after_create :first_user


  def first_user
    NoiseUser.create!(:user_id => self.created_by, :noise_id => self.id)
  end

  def expires_at_cannot_be_in_the_past
    unless expires_at.blank?
      if expires_at < Time.now
        errors.add(:expires_at, "can't be in the past")
      end
    end
  end

  def cannot_have_two_unexpired_noises_in_same_account
    if account.noises.where("expires_at >= :now", :now => Time.now).exists?
      errors.add(:expires_at, "can't be earlier than a current noise")
    end
  end


end
