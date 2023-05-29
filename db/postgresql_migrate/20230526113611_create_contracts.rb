class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts, id: :uuid  do |t|
      t.string :name
      t.string :project_link
      t.string :tvc
      t.string :code_hash
      t.string :compiler_version
      t.string :linker_version
      t.integer :blockchain
      t.integer :network
      t.json :abi
      t.json :sources
      t.string :uploaded_by

      t.index :name
      t.index :code_hash

      t.timestamps
    end
  end
end
