# == Schema Information
#
# Table name: account_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AccountUser < ActiveRecord::Base
  attr_accessible :user_id, :account_id

  validates_uniqueness_of :user_id, :scope => :account_id
  validates :user_id, :presence => true
  validates :account_id, :presence => true

  belongs_to :user
  belongs_to :account
end
