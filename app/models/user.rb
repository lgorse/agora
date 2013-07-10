# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  email      :string(255)
#  team       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE)
#

class User < ActiveRecord::Base
 require 'csv'
  attr_accessible :account_id, :admin, :email, :name, :team

  email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => email_format}
  validates :name, :presence => true
  validates :account, :presence => true

  before_validation :downcase_email
  

  has_many :motion_users
  has_many :motions, :through => :motion_users
  belongs_to :account

  def join(motion)
  	MotionUser.create(:user_id => id, :motion_id => motion.id)
  end

  def unjoin(motion)
    motion_users.find_by_motion_id(motion).destroy
  end

  def joined?(motion)
    motion.users.include?(self)
  end

  def created_motions
    Motion.where(:created_by => self.id)
  end

  def self.create_from_csv(uploaded_file, account)
    @account = account;
    @new_user_list = []
    file_name = uploaded_file.tempfile.to_path.to_s
    file = File.read(file_name)
    csv = CSV.parse(file, :headers => false, :col_sep => "\t")
    csv.each do |row|
      attribute = {:account_id => @account.id, :name => row[1].to_s, :email => row[3].to_s, :team => row[0].to_s, :admin => false}
      new_user = User.create(attribute)
      @new_user_list << new_user
    end
    @new_user_list
  end

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

end
