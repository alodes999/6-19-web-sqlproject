class ShipLocation
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :solar_system_name
  # Initializes a ShipLocation object.  Set with one parameter, the unique "id" of each location.
  # 
  # Our class methods are listed at the top, prefaced with self.  They are able to be called without an instantiated object.
  # 
  # We have 2 attributes   - id, the table id number referenced with the Object
  #                        - solar_system_name, a String with the solar system name.
  # 
  def initialize(arguments = {})
    @id = arguments["id"]
    @solar_system_name = arguments["solar_system_name"]
  end
  # Instance method for deleting a location
  # 
  # Accepts no arguments, relying on the instantiated object's type_id
  # 
  # Calls our ships_where_stored method to verify the location is empty before deletion
  #
  # Returns Boolean
  def delete_location
    if ships_where_stored.empty?
      CONNECTION.execute("DELETE FROM ship_locations WHERE id = #{@id};")
    else
      false
    end
  end
  # Lists the ships at the location referenced with this object's instantiation
  # 
  # Accepts no arguments, only passing the defined argument from instantiation to this method
  #
  # Returns a list of ships currently at the location referenced in our @id attribute
  def ships_where_stored
    list = CONNECTION.execute("SELECT * FROM ship_names WHERE ship_locations_id = #{@id};")
    array_list = []
    
    list.each do |type|
      array_list << ShipName.new(type)
    end
    
    array_list
  end
end