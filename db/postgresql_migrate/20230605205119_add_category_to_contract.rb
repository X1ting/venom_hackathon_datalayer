class AddCategoryToContract < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :category, :integer, default: 0
    add_column :contracts, :init_population_state, :integer, default: 0
  end
end
