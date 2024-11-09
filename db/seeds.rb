# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


users = [{
	name: "Promo Admin",
	email: "admin@promotionsengine.com",
	password: "PromotionsAdmin",
	password_confirmation: "PromotionsAdmin"
}, {
	name: "Promo User",
	email: "user@promotionsengine.com",
	password: "PromotionsUser",
	password_confirmation: "PromotionsUser"
}]

users.each do |up|
	User.create(up)
end

properties = [{
	name: "Sample Property One"
}, {
	name: "Sample Property Two"
}]

properties.each do |property|
	Property.create(property)
end

sample_property_one = Property.first
sample_property_two = Property.last

promotions = [{
	property_id: sample_property_one.id,
	name: "Timeless Promotion",
	short_description: "This promotion is ever lasting.",
	description: "This promotion has no additional conditions, no product skus and no start or end date. This is a timeless promotion and always active across all scenarios.",
	code: "TIMELESS",
	link: "www.promotionsengine.com/timeless",
	rank: 1
}, {
	property_id: sample_property_one.id,
	name: "Date Range Promotion",
	short_description: "This promotion is limited to a date range.",
	description: "This promotion has a start and an end date, and will only be valid in the specifc date range.",
	code: "DATESPECIFIC",
	link: "www.promotionsengine.com/datespecific",
	start: "01/10/2024",
	end: "31/12/2024",
	rank: 2,
}, {
	property_id: sample_property_one.id,
	name: "Conditional Promotion",
	short_description: "This promotion is conditions based.",
	description: "This promotion has additional conditions, but no product skus.",
	code: "CONDITIONAL",
	link: "www.promotionsengine.com/conditional",
	rank: 3,
}, {
	property_id: sample_property_one.id,
	name: "Ranged and Conditional Promotion",
	short_description: "This promotion is range specific and conditions based.",
	description: "This promotion has additional conditions, but no product skus. Promotion will only be valid in a date range.",
	code: "RANGEDCONDITIONAL",
	link: "www.promotionsengine.com/ranged-conditional",
	start: "01/10/2024",
	end: "31/12/2024",
	rank: 4,
}, {
	property_id: sample_property_one.id,
	name: "Product Inclusion",
	short_description: "This promotion has a specific list of included products.",
	description: "This promotion will only be returned if the skus are passed and if the sku is included.",
	code: "SKUINCLUDED",
	link: "www.promotionsengine.com/sku-included",
	start: "01/10/2024",
	end: "31/12/2024",
	rank: 5,
}, {
	property_id: sample_property_one.id,
	name: "Product Exclusion",
	short_description: "This promotion has a specific list of excluded products.",
	description: "This promotion will only be returned if the skus are passed and if the sku is excluded.",
	code: "SKUEXCLUDED",
	link: "www.promotionsengine.com/sku-excluded",
	start: "01/10/2024",
	end: "31/12/2024",
	rank: 6,
}]

promotions.each do |promotion|
	Promotion.create(promotion)
end

conditional_promotion = sample_property_one.promotions.find_by(code: "CONDITIONAL")
cpc = Condition.create(promotion: conditional_promotion, by: "OR")
cpcg = cpc.groups.create(by: "OR")
cpcg.operations.create(variable_key: "country", operator: "Rulio::Operations::String::Contains", constant: "us")
cpcg.operations.create(variable_key: "country", operator: "Rulio::Operations::String::Contains", constant: "ca")

range_conditional_promotion = sample_property_one.promotions.find_by(code: "CONDITIONAL")
rcpc = Condition.create(promotion: range_conditional_promotion, by: "OR")
rcpcg = rcpc.groups.create(by: "OR")
rcpcg.operations.create(variable_key: "country", operator: "Rulio::Operations::String::Contains", constant: "us")
rcpcg.operations.create(variable_key: "country", operator: "Rulio::Operations::String::Contains", constant: "ca")

50.times.each do |i|
	sample_property_one.products.create(sku: "PRODUCT-#{i}")
end

products = Product.all
products_included_promotion = sample_property_one.promotions.find_by(code: "SKUINCLUDED")
included_relationships = []
products[0..25].each do |p|
	included_relationships.push({promotion_id: products_included_promotion.id, product_id: p.id, relationship: :include})
end
ProductsPromotion.upsert_all(included_relationships, unique_by: [:promotion_id, :product_id], update_only: [:relationship])

products_excluded_promotion = sample_property_one.promotions.find_by(code: "SKUEXCLUDED")
excluded_relationships = []
products[26..50].each do |p|
	excluded_relationships.push({promotion_id: products_excluded_promotion.id, product_id: p.id, relationship: :exclude})
end
ProductsPromotion.upsert_all(excluded_relationships, unique_by: [:promotion_id, :product_id], update_only: [:relationship])

