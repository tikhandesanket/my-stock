class Item < ActiveRecord::Base

	validates :name,  presence: true
	# An item will either be in listed OR delisted state. 
	# When a file is uploaded and a record is created/ updated, the record must be in 'listed' state
	# If the user syncronizes their inventory then any item that's not present in the file must be moved to "delisted" state
	STATE_OPTIONS = %w(delisted listed)
  	validates :state, :inclusion => {:in => STATE_OPTIONS, message: "Expecting value of state is in #{STATE_OPTIONS} but got '%{value}'."}
  	validates :weight, numericality: true
  	validates :price, numericality: true

	# Use Case - Item.import(file)
	# Description - Used to import items from an csv file and save that into database
	# @param [file] file <file should be in csv format>
	# @return nil
	def self.import(file)
		return if file.blank?
		# TODO: 
		# 1. Sample file used here has three columns with following headers
		# 	- Name
		# 	- Weight
		# 	- Price
		# 	Currently it supports single price column and it represents (total price of item)
		# 	As a user, I should be able to upload a file with "Price per unit" (Total Price/ weight) OR "Total Price" OR both and it should save the record's price accordingly
		# 2. As a user, I should be able to update a record's price or weight by reuploading the file post correction. 
		# 3. As a user, I should be able to syncronize my inventory OR upload just the updates (make use of states)
		# item = Item.find_by_name(row_hash[:name]) || Person.new(:name => row_hash[:name])
		# person.update_attributes!(:weight => row_hash[:weight], :price =>  row_hash[:price],:state => "listed" )
		CSV.foreach(file.path, headers: true) do |row|
			if Item.count==0
				row_hash = row.to_hash
				row_hash["state"] = "listed"
				Item.create! row_hash
			else
				item = Item.find_by_name(row['name']) || Item.new(:name => row['name'],:state => 'delisted' )
				item.update_attributes!(:weight => row['weight'], :price =>  row['price'])
			end
		end
	end
	def total_price(price,weight)
		return (price/weight).round(2)
	end
end
