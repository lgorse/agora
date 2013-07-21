# == Schema Information
#
# Table name: motions
#
#  id         :integer          not null, primary key
#  created_by :integer
#  account_id :integer
#  threshold  :integer
#  details    :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email_sent :boolean          default(FALSE)
#  expires_at :datetime
#  email_time :datetime
#

class Motion < ActiveRecord::Base
  attr_accessible :account_id, :title,  :details, 
                  :created_by, :expires_at, :threshold, :email_sent,
                  :email_time

  validates :created_by, :presence => true
  validates :account, :presence => true
  validates :expires_at, :presence => true
  validates :threshold, :presence => true
  validates :title, :presence => true, :length => {:maximum => TITLE_CHAR_MAX}
  validates :details, :length => {:within => 0..DETAILS_CHAR_MAX}
  validate :expires_at_cannot_be_in_the_past, :on => :create

  has_many :motion_users
  has_many :users, :through => :motion_users
  belongs_to :account

  after_create :add_motion_expiration_to_email_queue, :first_user, :add_motion_notification_to_email_queue

  default_scope :order => 'expires_at'

  def first_user
    MotionUser.create!(:user_id => self.created_by, :motion_id => self.id)
  end

  def add_motion_expiration_to_email_queue
    ExpirationWorker.perform_at(self.expires_at, self.id)
  end

  def add_motion_notification_to_email_queue
    NewMotionWorker.perform_async(self.id)
  end
  

  def threshold_met?
    users.count >= threshold
  end

  def current?
    expires_at >= Time.now
  end

  def new_motion_email
    account.users.each {|user| MotionMailer.notification_email(user, self).deliver if user.email_notify?}
  end

  def send_email
    unless email_sent == true
      account.users.each {|user| MotionMailer.motion_email(user, self).deliver unless user.email_notify == false}
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

  def check_threshold_and_send_email
    if threshold_met?
      send_email
    end
  end


end
