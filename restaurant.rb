class Restaurant
  attr_reader :r_id, :item, :price

  def initialize(id, price, item)
    @r_id = id
    @price = price
    @item = item
  end

  def self.find_best_restro(menu_data, order_items)
    menu_data_hash = menu_data.flatten.group_by{|x| x.r_id}
    restros = find_restaurant_that_can_full_fill_order(menu_data_hash, order_items)
    if restros.empty?
      puts "Nil"
      return
    end
    restros_with_candidate_item = from_each_restro_keep_items_that_have_atleast_one_order_item(restros, order_items)
    calculate_minimun_order_value_for_each_restro(restros_with_candidate_item, order_items)
  end

private
  
  # select only those restros which can fullfill the order
  def self.find_restaurant_that_can_full_fill_order(menu_data_hash, order_items) # eliminate all other restros
    restros_that_can_fullfill_order = []
    menu_data_hash.each do |k, menu_items|
      all_item_from_this_restro = []
      menu_items.each{|items| all_item_from_this_restro = all_item_from_this_restro + items.item}
      restros_that_can_fullfill_order << menu_items if (order_items & all_item_from_this_restro).length == order_items.length
    end

    restros_that_can_fullfill_order
  end

  # from the restros which can full fill the order keep only those menu item which are applicable
  def self.from_each_restro_keep_items_that_have_atleast_one_order_item(restros, order_items)
    candidate_item = []
    restros.each do |restro|
      candidate_item  << restro.select{ |items|  (items.item & order_items).any?}
    end
    candidate_item
  end

  def self.calculate_minimun_order_value_for_each_restro(restros_with_candidate_item, order_items)
    final_array = []
    restros_with_candidate_item.each do |restros|
      this_hash = prepare_init_hash(order_items)
      restros.each do |restro|
        restro.item.each do |i|
          this_hash[i] << restro if this_hash.has_key?(i)
        end
      end
      final_array << this_hash
    end

    prepare_patterns_and_find_minimum(final_array, order_items)
  end

  def self.prepare_init_hash(order_items)
    my_hash = {}
    order_items.each do |order_item|
      my_hash[order_item] = Array.new
    end
    my_hash
  end

  def self.prepare_patterns_and_find_minimum(data_array, order_items)
    new_arr = []
    data_array.each do |restro|
      id = restro[order_items.first].first.r_id
      price = minimun_price_for_this_item(restro, order_items)
      new_arr << [id.to_i, price.to_f]
    end
    new_arr.sort! { |a, b| a[1] <=> b[1]}
    puts "#{new_arr[0][0]} #{new_arr[0][1]}"
  end

  def self.minimun_price_for_this_item(restros, order_items)
    if (order_items).empty?
      return 0.0
    end
    item_to_satisfy = order_items.first
    menus = restros[item_to_satisfy]
    current_min = 1000000000000000000000.0
    menus.each do |m|
      mprice = minimun_price_for_this_item(restros, order_items - m.item)
      current_min =  m.price.to_f + mprice if m.price.to_f + mprice < current_min
    end
    return current_min
  end
end
