module ShipLists

  def self.main_menu
    puts "-------------------------"
    puts "1 - Look at a list"
    puts "2 - Enter a new record"
    puts "3 - Change a record"
    puts "4 - Delete a record"
    puts "9 - Quit"
    puts ""
  end

  def self.option_one
    puts "--------------------------------------------"
    puts "Which list would you like to look at?"
    puts "--------------------------------------------"
    puts "1 - Look at ships list"
    puts "2 - Look at ship types list"
    puts "3 - Look at ship locations list"
    puts "4 - Look at all ships in a given type"
    puts "5 - Look at all ships in a given location"
    puts "9 - Go back"
    puts ""
  end

  def self.option_two
    puts "-----------------------------------" 
    puts "What entry would you like to make?"
    puts "-----------------------------------"    
    puts "1 - Enter a new ship type"
    puts "2 - Enter a new ship location"
    puts "3 - Enter a new ship"
    puts "9 - Go back"
    puts ""
  end

  def self.option_three
    puts "--------------------------------"  
    puts "What would you like to change?"
    puts "--------------------------------"
    puts "1 - Change a ship record"
    puts "2 - Change a ship type record"
    puts "3 - Change a location record"
    puts "9 - Go back"
    puts ""
  end

  def self.option_three_one
    puts "---------------------------------------------------"
    puts "Ok, how would you like to modify this ship entry?"
    puts "---------------------------------------------------"
    puts "1 - Change a ship name"
    puts "2 - Change a ship cost"
    puts "3 - Change a ship type"
    puts "4 - Change a ship location"
    puts "9 - Go back"
    puts ""
  end

  def self.option_four
    puts "------------------------------------"
    puts "Ok, what would you like to delete?"
    puts "------------------------------------"
    puts "1 - Delete a ship record"
    puts "2 - Delete a ship type"
    puts "3 - Delete a ship location"
    puts "9 - Go back"
    puts ""
  end
  
  def self.list_three_choice
    bad_choice = (4..8)
    listchoice = gets.chomp.to_i
    while bad_choice.include?(listchoice) || listchoice > 9 || listchoice == 0
      puts "That is not a valid option, please reenter an option"
      listchoice = gets.chomp.to_i
    end
    listchoice
  end
  
  def self.list_four_choice
    bad_choice = (5..8)
    listchoice = gets.chomp.to_i
    while bad_choice.include?(listchoice) || listchoice > 9 || listchoice == 0      
      puts "That is not a valid option, please reenter an option"
      listchoice = gets.chomp.to_i
    end
    listchoice
  end
  
  def self.list_five_choice
    bad_choice = (6..8)
    listchoice = gets.chomp.to_i
    while bad_choice.include?(listchoice) || listchoice > 9 || listchoice == 0      
      puts "That is not a valid option, please reenter an option"
      listchoice = gets.chomp.to_i
    end
    listchoice
  end
  
  def self.ship_name_list
    list = ShipName.all
  
    list.each do |name|
      puts "#{name.id} - #{name.ship_name} - #{name.cost} - #{name.ship_types_id} - #{name.ship_locations_id}"
    end
  end
  
  def self.ship_type_list
    list = ShipType.all
    
    list.each do |type|
      puts "#{type.id} - #{type.ship_type}"
    end
  end
  
  def self.ship_loc_list
    list = ShipLocation.all
    
    list.each do |loc|
      puts "#{loc.id} - #{loc.solar_system_name}"
    end
  end

end