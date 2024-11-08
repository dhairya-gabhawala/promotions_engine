class RemoveDescriptionsFromPromotions < ActiveRecord::Migration[7.2]
  def change
    remove_column :promotions, :description, :string
    remove_column :promotions, :short_description, :string
  end
end
