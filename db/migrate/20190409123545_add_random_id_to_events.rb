class AddRandomIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :random_id, :string 
    add_index :events, :random_id, {unique: true}
    
    Event.find_each do |e|
      e.update(random_id: SecureRandom.uuid)
    end
  end
end
