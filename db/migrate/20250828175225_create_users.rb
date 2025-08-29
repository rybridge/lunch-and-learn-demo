class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :introduction_email_sent_at

      t.timestamps
    end
  end
end
