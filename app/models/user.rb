# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  default_account :integer
#  name            :string(255)
#  email           :string(255)
#  team            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin           :boolean          default(FALSE)
#  email_notify    :boolean          default(TRUE)
#

class User < ActiveRecord::Base
 require 'csv'
  attr_accessible :default_account, :admin, :email, :name, :team, :email_notify

  email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => EMAIL_FORMAT}
  validates :name, :presence => true
  validates :default_account, :presence => true

  before_validation :downcase_email
  after_create :join_to_default_account
  
  has_many :motion_users
  has_many :motions, :through => :motion_users

  has_many :account_users
  has_many :accounts, :through => :account_users

  has_many :invitations, :foreign_key => "inviter_id"
  has_many :reverse_invitations, :foreign_key => "invitee_id", :class_name => "Invitation"
  
  has_many :invitees, :through => :invitations, :source => :invitee
  has_many :inviters, :through => :reverse_invitations,:source => :inviter

  def join(account)
    AccountUser.create(:user_id => id, :account_id => account.id)
  end

  def joined?(account)
    account.users.include?(self)
  end

  def vote(motion)
  	MotionUser.create(:user_id => id, :motion_id => motion.id)
  end

  def unvote(motion)
    motion_users.find_by_motion_id(motion).destroy
  end

  def voted?(motion)
    motion.users.include?(self)
  end

  def invite(email, account_id)
    Invitation.create(:email => email, :account_id => account_id, :inviter_id => self.id)
  end

  def created_motions
    Motion.where(:created_by => self.id)
  end

  def self.create_from_csv(uploaded_file, account)
    @account = account
    @new_user_list = []
    file_name = uploaded_file.tempfile.to_path.to_s
    file = File.read(file_name)
    csv = CSV.parse(file, :headers => false, :col_sep => "\t")
    csv.each do |row|
      attribute = {:default_account => @account.id, :name => row[1].to_s, :email => row[3].to_s, :team => row[0].to_s, :admin => false}
      new_user = User.create(attribute)
      @new_user_list << new_user
    end
    @new_user_list
  end

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  def join_to_default_account
    self.join(Account.find(self.default_account))
  end

end
