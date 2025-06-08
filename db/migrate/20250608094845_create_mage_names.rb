class CreateMageNames < ActiveRecord::Migration[7.0]
  def change
    create_table :mage_names, id: :uuid do |t|
      t.uuid :ai_call_id, null: false
      t.string :name, null: false
      t.string :meaning, null: false
      t.string :race
      t.string :worldview
      t.string :element
      t.string :alignment

      t.timestamps
    end

    add_index :mage_names, :name, unique: true
  end
end
