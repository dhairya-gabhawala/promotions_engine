class Promotion < ApplicationRecord

    enum :status, [:pending, :active, :archived]
    has_rich_text :short_description
    has_rich_text :description

    belongs_to :property
    has_many :products_promotions
    has_many :products, through: :products_promotions
    has_one :condition

    validates_presence_of :name, :description, :short_description, :code, :link, :rank, :status
    validates :code, :name, uniqueness: {scope: :property}

    def included_products
        products.select(:sku).where("products_promotions.relationship = 'include'")
    end

    def excluded_products
        products.select(:sku).where("products_promotions.relationship = 'exclude'")
    end

    def includes_products?(skus)
        products.where("products_promotions.relationship = 'include' AND products.sku IN (#{skus})")
    end

    def excludes_products?(skus)
        products.where("products_promotions.relationship = 'exclude' AND products.sku IN (#{skus})")
    end

end
