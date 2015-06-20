class ShipName
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :ship_name, :cost, :ship_types_id, :ship_locations_id
  # Initializes a ShipName object.  Set with five optional parameters, the unique "id" of each location.
  # 
  # Our class methods are listed at the top, prefaced with self.  They are able to be called without an instantiated object.
  # 
  # We have 1 attribute
  # => arguments, a Hash that contains our information for our attributes
  def initialize(arguments = {})
    @id = arguments["id"]
    @ship_name = arguments["ship_name"]
    @cost = arguments["cost"]
    @ship_types_id = arguments["ship_types_id"]
    @ship_locations_id = arguments["ship_locations_id"]
  end
end