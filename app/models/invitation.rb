# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  inviter_id :integer
#  account_id :integer
#  email      :string(255)
#  accepted   :boolean
#  invitee_id :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Invitation < ActiveRecord::Base
  attr_accessible :inviter_id, :account_id, :email, :message

  

  validates :inviter_id, :presence => true
  validates :email, :presence => true, :format => {:with => EMAIL_FORMAT}
  validates :account_id, :presence => true
  validate :invitation_validations, :on => :create

  belongs_to :inviter, :foreign_key => "inviter_id",  :class_name => "User"
  belongs_to :invitee, :foreign_key => "invitee_id", :class_name => "User"

  before_validation :downcase_email, :add_invitee_id_if_user
  after_create :email_invitee


  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  def add_invitee_id_if_user
    user = User.find_by_email(self.email)
    if user
      self.invitee_id = user.id
    end
  end

  def invitee_is_user?
    self.invitee_id.blank? ? false : true
  end
  

  def invitation_validations
    validate_invitation_sent
    validate_user_on_account
  end

  def validate_invitation_sent
    previous_invitation = Invitation.where(:inviter_id => self.inviter_id, :email => self.email, :account_id => self.account_id).first
    if previous_invitation
      errors.add(:email, "has already received an invitation for this community")
    end
  end

  def validate_user_on_account
    if self.invitee_is_user?
      user = User.find(self.invitee_id)
      if user.accounts.pluck(:'accounts.id').include?(self.account_id)
        errors.add(:email, "is already on this account")
      end
    end
  end

  def email_invitee
    #UserMailer.invite_email(self.id).deliver
    InviteWorker.perform_async(self.id)
  end

end
