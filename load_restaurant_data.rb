require "./restaurant"
require 'csv'

class LoadRestaurantData # to load menu data into the system

  def initialize(list, order_items)
    @menu_data = []
    load_restaurant_data_into_system(list)
    Restaurant.find_best_restro(@menu_data, order_items)
  end

  private

  def load_restaurant_data_into_system(list)
    CSV.foreach(list) do |row|
      row.map!{|x| x.strip unless x.nil?}
      row = row.compact
      unless row.empty?
        id = row[0]
        price = row[1]
        items = row[2..row.length]
        @menu_data << Restaurant.new(id, price, items)
      end
    end
  end
end
