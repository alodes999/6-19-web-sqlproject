require 'active_support'
require 'active_support/inflector'

module DatabaseClassMethods
  # Gets all of the rows of the table of the Class that calls this method
  # 
  # Accepts no arguments, only pulling the various rows from the corresponding table
  # 
  # Returns an Array of Objects of the Class that sent the method.
  def all
    table_name = self.to_s.tableize
    results = CONNECTION.execute("SELECT * FROM #{table_name};")
    array_list = []

    results.each do |hash|
      array_list << self.new(hash)
    end

    array_list
  end
  # Finds the row matching the id provided in the Class table that calls the method
  # 
  # Accepts 1 argument, the id number of the row requested in the corresponding Class table
  # 
  # Returns an Object synced with the matching row in the calling Class's table.
  def find(id)
    table_name = self.to_s.tableize
    
    result = CONNECTION.execute("SELECT * FROM #{table_name} WHERE id = #{id};").first
    
    self.new(result)
  end
  # Creates a new row in the Class table calling the method, while also returning
  # an Object of the same Class
  # 
  # Accepts a Hash of arguments like so:
  # 
  # Example: for a new name object/row:
  #    - name = {"name" => Blerb, "cost" => 1234, "type_id" => 1, "location_id" => 3}"
  #     => #<Name: F9123u049u50, "id": 1, "name": Blerb, "cost": 1234, "type_id": 1, "location_id": 1>
  #    - type = {"name" => Blerbspot}
  #     => #<Type: 0f9088xf09, "id": 1, "name": Blerbspot>
  # 
  # Returns an Object of the Class type calling the method, and also adds the new row
  # to the table.
  def add(arguments={})
    table_name = self.to_s.tableize
    columns_array = arguments.keys
    values_array = arguments.values  
    columns_for_sql = columns_array.join(", ")
    ind_values_for_sql = []
    
    values_array.each do |item|
      if item.is_a?(String)
        ind_values_for_sql << "'#{item}'"
      else
        ind_values_for_sql << item
      end
    end
    
    values_for_sql = ind_values_for_sql.join(", ")
    CONNECTION.execute("INSERT INTO #{table_name} (#{columns_for_sql}) VALUES (#{values_for_sql});")
    arguments["id"] = CONNECTION.last_insert_row_id
    self.new(arguments)
  end
  # Deletes a row from the table.  Can be called on the class itself, and deletes a row from the
  # Class table that called it
  # 
  # Accepts 1 argument, the id number of the row to delete in the table that called the method
  # 
  # Returns [], and deletes the row from the table
  def delete(id_to_delete)
    table_name = self.to_s.tableize
    
    CONNECTION.execute("DELETE FROM #{table_name} WHERE id = #{id_to_delete};")
  end
end