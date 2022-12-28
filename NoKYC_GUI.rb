require 'glimmer'
require 'glimmer-dsl-libui'

puts "Starting Container"
system("sudo docker start nokyc")
Thread.new do
	system("sudo docker exec -it nokyc sh -c tor")
end

include Glimmer
#Data set to variables to be displayed in the windows is obtained outside of windows
#Data set to variables that was obtained in the windows but set to a variable here is implicitly binded
#class CodeisLaw
#	include Glimmer::LibUI::Application
list = Array.new
price_list = Array.new
counter = 15
data = [
  ["Exchange", "Price", "Fiat", "Difference", "BTC min", "BTC max", "min", "max", "Method"]
]

window('NoKYC GUI', 400, 200) do
	vertical_box do
		table do
			text_column("Exchange")
			text_column("Price")
			text_column("Fiat")
			text_column("Difference")
			text_column("BTC min")
			text_column("BTC max")
			text_column("min")
			text_column("max")
			text_column("Method")

			cell_rows data
		end
		horizontal_box do
			button('Get Offers') do
				on_clicked do
					 
					puts 'Retrieving Offers'
					prices = `sudo docker exec -it -w /home/nokyc/nokyc nokyc bash -c 'python3 nokyc.py -t sell -f usd'`
					puts prices
					
					seperate = prices.split("Price:")
					list = seperate[-1]
					items = list.split("\n")
					#Merge objects after position 7
					price_list = Array.new
					
					items.each do |entry|
						corrected_items = Array.new
						unless entry == nil
							entry = entry.split(" ")
							if entry.count > 8
								corrected_items.push(entry[0..7])
								payment = entry[8..-1]
								list = " "
								unless payment == nil
									
									payment.each do |methods|
										methods = methods + " "										
										list = list + methods
									end
									corrected_items.push(list)
									price_list.push(corrected_items)
									
								end
							end
						end
					end
					
					data.each do |old|
						data.delete(old)
					end
					
					price_list.each do |list|
						
						data << list
					end
				end
			end
		end
	end
  
	on_closing do
		puts 'Stopping Container'
		Thread.new do
			system("sudo docker stop nokyc")
		end
	end
end.show

#end

#CodeisLaw.launch
