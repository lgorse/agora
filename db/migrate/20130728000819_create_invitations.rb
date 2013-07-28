class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.integer	:account_id
      t.string	:email
      t.boolean	:accepted
      t.integer	:invitee_id
      t.text    :message
      t.timestamps
    end
  end
end
