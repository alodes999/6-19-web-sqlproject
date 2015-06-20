require 'active_support'
require 'active_support/inflector'

module DatabaseInstanceMethods
  # Returns the stored value in the field passed from our DB.  The id number the method looks
  # for is referenced in the Object that the method is called on.
  # 
  # Accepts 1 argument, the field in our table we want to retrieve the information from
  # 
  # Returns a String or Integer, or whatever value is stored in the field we are requesting
  def get(field)
    table_name = self.class.to_s.tableize
    
    result = CONNECTION.execute("SELECT * FROM #{table_name} WHERE id = #{@id}}").first
    
    result[field]
  end
  # Saves the current values in our instance variables into the row in the table referenced
  # by our Object's id
  # 
  # Takes no arguments, using the instance's attributes
  # 
  # Returns the Object itself, along with syncing the row and Object
  def save
    table_name = self.class.to_s.tableize
    variables = self.instance_variables
    attr_hash = {}
    
    variables.each do |var|
      attr_hash["#{var.slice(1..-1)}"] = self.send("#{var.slice(1..-1)}")
    end
    
    single_variables = []
    
    attr_hash.each do |k, v|
      if v.is_a?(String)
        single_variables << "#{k} = '#{v}'"
      else
        single_variables << "#{k} = #{v}"
      end
    end
    
    vars_to_sql = single_variables.join(", ")
    
    CONNECTION.execute("UPDATE #{table_name} SET #{vars_to_sql} WHERE id = #{self.id}")
    
    return self
  end
end