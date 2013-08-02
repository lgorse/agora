# == Schema Information
#
# Table name: motions
#
#  id         :integer          not null, primary key
#  created_by :integer
#  account_id :integer
#  details    :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email_sent :boolean          default(FALSE)
#  expires_at :datetime
#  email_time :datetime
#  anonymous  :boolean          default(FALSE)
#

class Motion < ActiveRecord::Base
  attr_accessible :account_id, :title,  :details, 
  :created_by, :expires_at, :email_sent,
  :email_time, :anonymous

  validates :created_by, :presence => true
  validates :account, :presence => true
  validates :expires_at, :presence => true
  validates :title, :presence => true, :length => {:maximum => TITLE_CHAR_MAX}
  validates :details, :length => {:within => 0..DETAILS_CHAR_MAX}
  validate :expires_at_cannot_be_in_the_past, :on => :create

  has_many :motion_users
  has_many :users, :through => :motion_users
  belongs_to :account

  has_many :replies

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

  def creator
    if self.anonymous
      User.new(:name => "Anonymous")
    else
      User.find(self.created_by)
    end
  end

  def replies_by(user)
    self.replies.where(:user_id => user.id)
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


end
