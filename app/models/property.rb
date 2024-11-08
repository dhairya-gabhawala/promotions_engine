class Property < ApplicationRecord

    has_many :promotions, dependent: :destroy
    has_many :products, dependent: :destroy
    has_many :variables, dependent: :destroy

    validates_presence_of :name
    validates_uniqueness_of :name, :api_key, :secret

    before_create :generate_tokens
    after_create :default_variables

    def generate_tokens
        self.api_key = "PE-#{(SecureRandom.random_number(9e9)+1e7).to_i}"
        self.secret = (SecureRandom.random_number(9e50)+1e7).to_i
    end

    def default_variables
        self.variables.find_or_create_by!([
            {
                name: "Product SKUs",
                key: "skus",
                description: "Product SKUs are unique identifiers for the products and can be accepted as a list. Please send a \",\" separated list of SKU values to the API.",
                value_type: :list
            },
            {
                name: "Country",
                key: "country",
                description: "Country identifier helps for targeting promotions that are geographically restricted. This is a string parameter and can accept name, iso code or any other value.",
                value_type: :string
            },
            {
                name: "Language",
                key: "lang",
                description: "Language identifier helps for targeting promotions with their language variations.",
                value_type: :string
            },
            {
                name: "Page Path",
                key: "page_path",
                description: "Page path for being able to target promotions restricted and to be presented only on some pages.",
                value_type: :string
            }
        ])
    end
end
