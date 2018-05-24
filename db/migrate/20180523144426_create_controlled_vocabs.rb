class CreateControlledVocabs < ActiveRecord::Migration[5.1]
  def change
    create_table :controlled_vocabs do |t|
      t.string :field, null: false
      t.string :name, null: false
      t.string :image_filename

      t.timestamps
    end
  end
end
