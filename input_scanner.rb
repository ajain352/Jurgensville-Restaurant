require "./load_restaurant_data"

class InputScanner #to check if the input params are proper

  def initialize(args)
    @item_list = chek_if_input_file_is_valid?(args.first) ? args.first : (raise ArgumentError.new("Invalid Input File Specified"))
    @item_ordered = check_if_valid_item_ordered?(args) ? args[1..args.length] : (raise ArgumentError.new("Invalid Item Ordered"))
    @restaurant_data_loader = LoadRestaurantData.new(@item_list, @item_ordered)
  end

  private

  def chek_if_input_file_is_valid?(file_name)
    !file_name.nil? && file_name.include?('.csv') && File.exist?(file_name)
  end

  def check_if_valid_item_ordered?(args)
    order_list = args[1..args.length]
    order_list.any?
  end
end