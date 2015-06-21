require 'sqlite3'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require_relative 'database_class_methods'
require_relative 'database_instance_methods'
require_relative 'ship_names'
require_relative 'ship_types'
require_relative 'ship_locations'
# CONNECTION is my acronym for 'EVE Inventory Management', the appended project name onto my EVE thought process
# for the project
CONNECTION = SQLite3::Database.new('eim.db')

CONNECTION.execute("CREATE TABLE IF NOT EXISTS ship_names (id INTEGER PRIMARY KEY, ship_name TEXT, cost INTEGER, ship_types_id INTEGER, ship_locations_id INTEGER, FOREIGN KEY(ship_types_id) REFERENCES ship_types(id) , FOREIGN KEY(ship_locations_id) REFERENCES ship_locations(id));")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS ship_types (id INTEGER PRIMARY KEY, ship_type TEXT);")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS ship_locations (id INTEGER PRIMARY KEY, solar_system_name TEXT);")

CONNECTION.results_as_hash = true

#--------------------------------------------------------------------------------------------------------------------------------------

get "/home" do
  erb :"index"
end
# Method that acts as a receiver for list requests, and sends the user to
# the appropriate list in the "lists.erb" file.
get "/list/:list" do
  erb :"lists"
end
# Method that checks to see if a type has any data in it.  Displays a page to the user
# either showing the ships with the given type, or a page saying there was no
# data in that type to return
get "/show_ship_type_list" do
  @type_to_look = ShipType.find(params["type_id"])
  if @type_to_look.ships_where_type_matches == []
    erb :"nothing_exists"
  else
    erb :"ship_type_list"
  end
end
# Method that checks to see if a location has any data in it.  Displays a page to the user
# either showing the ships with the given location, or a page saying there was no
# data in that location to return
get "/show_ship_location_list" do
  @loc_to_look = ShipLocation.find(params["location_id"])
  if @loc_to_look.ships_where_stored == []
    erb :"nothing_exists"
  else
    erb :"ship_location_list"
  end
end
# Method that catches requests to go into the create.erb file
get "/new/:new" do
  erb :"create"
end
# Method that creates a new Ship row for our database, and creates a new
# Object of ShipName.  Sends the user to the "data_added.erb" page for 
# confirmation.
get "/create_ship" do
  add_hash = {"ship_name" => params["ship_name"], "cost" => params["cost"], "ship_types_id" => params["ship_types_id"], "ship_locations_id" => params["ship_locations_id"]}
  ShipName.add(add_hash)
  erb :"data_added"
end
# Method that creates a new Ship Type row for our database, and creates a new
# Object of ShipType.  Sends the user to the "data_added.erb" page for 
# confirmation.
get "/create_type" do
  add_hash = {"ship_type" => params["type"]}
  ShipType.add(add_hash)
  erb :"data_added"
end
# Method that creates a new Location row for our database, and creates a new
# Object of ShipLocation.  Sends the user to the "data_added.erb" page for 
# confirmation.
get "/create_location" do
  add_hash = {"solar_system_name" => "#{params["system"]} - #{params["station"]}"}
  ShipLocation.add(add_hash)
  erb :"data_added"
end
# Method that catches requests to go into the change.erb file
get "/change/:change" do
  erb :"change"
end
# Method that pulls the requested ship and sends the values into the "change_ship.erb" page
get "/change_ship" do
  @ship_to_mod = ShipName.find(params["ship_id"])
  erb :"change_ship"
end
# Method that takes the results from the "change_ship.erb" page and returns the params
# to update the ship in question.
# Takes the values entered in the form and sets the attributes of the ship the user has
# chosen to modify to those values entered, and sends the whole object to update the row
# in the database.
get "/change_ship_action" do
  ship_mod = ShipName.find(params["id"].to_i)
  ship_mod.ship_name = params["ship_name"]
  ship_mod.cost = params["cost"].to_i
  ship_mod.ship_types_id = params["ship_types_id"].to_i
  ship_mod.ship_locations_id = params["ship_locations_id"].to_i
  
  ship_mod.save
  erb :"data_modified"
end
# Method that takes the results from the "change.erb" page and returns the params
# to update the ship in question.
# Takes the values entered in the form and sets the attributes of the ship type the user has
# chosen to modify to those values entered, and sends the whole object to update the row
# in the database.
# This will send the user to the "cant_delete_data_exists.erb" page if there is ship data
# that corresponds to the ship type, otherwise shows success
get "/change_ship_type" do
  type_to_mod = ShipType.find(params["type_id"])
  
  if type_to_mod.ships_where_type_matches != []
    erb :"cant_delete_data_exists"
  else
    type_to_mod.ship_type = params["type_name"]
    type_to_mod.save
    erb :"data_modified"
  end
end
# Method that takes the results from the "change.erb" page and returns the params
# to update the ship in question.
# Takes the values entered in the form and sets the attributes of the location the user has
# chosen to modify to those values entered, and sends the whole object to update the row
# in the database.
# This will send the user to the "cant_delete_data_exists.erb" page if there is ship data
# that corresponds to the location, otherwise shows success
get "/change_location" do
  loc_to_mod = ShipLocation.find(params["location_id"])
  
  if loc_to_mod.ships_where_stored != []
    erb :"cant_delete_data_exists"
  else
    loc_to_mod.solar_system_name = "#{params["system"]} - #{params["station"]}"
    loc_to_mod.save
    erb :"data_modified"
  end
end
# Method that catches requests to go into the delete.erb file
get "/delete/:delete" do
  erb :"delete"
end
# Method that deletes an item from the database, called from our delete.erb file.
# Sends the user to the data_deleted.erb file after running the deletion
get "/show_ship_delete_list" do
  ShipName.delete(params["ship_delete_id"])
  erb :"data_deleted"
end
# Method that checks to see if a given type is empty, then deletes if it is.
# Sends the user to either a confirmation page if the type is empty, or to
# a page saying the data couldn't be deleted, because there was something found.
# in the type.
get "/show_delete_type_list" do
  type_to_look = ShipType.find(params["type_id"])
  if type_to_look.delete_type
    erb :"data_deleted"
  else
    erb :"cant_delete_data_exists"
  end
end
# Method that checks to see if a given location is empty, then deletes if it is.
# Sends the user to either a confirmation page if the location is empty, or to
# a page saying the data couldn't be deleted, because there was something found.
# in the location.
get "/show_delete_location_list" do
  loc_to_look = ShipLocation.find(params["location_id"])
  if loc_to_look.delete_location
    erb :"data_deleted"
  else
    erb :"cant_delete_data_exists"
  end
end