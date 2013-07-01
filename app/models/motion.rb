# == Schema Information
#
# Table name: motions
#
#  id          :integer          not null, primary key
#  created_by  :integer
#  account_id  :integer
#  threshold   :integer
#  create_text :string(255)
#  join_text   :string(255)
#  cancel_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email_sent  :boolean          default(FALSE)
#  expires_at  :datetime
#  email_time  :datetime
#

class Motion < ActiveRecord::Base
  attr_accessible :account_id, :title,  :details, 
                  :created_by, :expires_at, :threshold, :email_sent,
                  :email_time

  validates :created_by, :presence => true
  validates :account, :presence => true
  validates :expires_at, :presence => true
  validates :threshold, :presence => true
  validates :title, :presence => true, :length => {:within => 1..TITLE_CHAR_MAX}
  validates :details, :presence => true, :length => {:within => 1..DETAILS_CHAR_MAX}
  validate :expires_at_cannot_be_in_the_past, :on => :create
  validate :cannot_have_two_unexpired_motions_in_same_account, :unless => "account.nil?", :on => :create

  has_many :motion_users
  has_many :users, :through => :motion_users
  belongs_to :account

  after_create :first_user


  def first_user
    MotionUser.create!(:user_id => self.created_by, :motion_id => self.id)
  end

  def threshold_met?
    users.count >= threshold
  end

  def send_email
    unless email_sent == true
      users.each {|user| MotionMailer.motion_email(user).deliver}
      update_attributes(:email_sent => true, 
                        :email_time => Time.now)
    end
  end

  def expires_at_cannot_be_in_the_past
    unless expires_at.blank?
      if expires_at < Time.now
        errors.add(:expires_at, "can't be in the past")
      end
    end
  end

  def cannot_have_two_unexpired_motions_in_same_account
    if account.motions.where("expires_at >= :now", :now => Time.now).exists?
      errors.add(:expires_at, "can't be earlier than a current motion")
    end
  end


end
