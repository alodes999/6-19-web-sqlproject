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

get "/list/:list" do
  erb :"lists"
end

get "/show_ship_type_list" do
  @type_to_look = ShipType.find(params["type_id"])
  if @type_to_look.ships_where_type_matches == []
    erb :"nothing_exists"
  else
    erb :"ship_type_list"
  end
end

get "/show_ship_location_list" do
  @loc_to_look = ShipLocation.find(params["location_id"])
  if @loc_to_look.ships_where_stored == []
    erb :"nothing_exists"
  else
    erb :"ship_location_list"
  end
end

get "/new/:new" do
  erb :"create"
end

get "/change/:change" do
  erb :"change"
end

get "/delete/:delete" do
  erb :"delete"
end

get "/show_ship_delete_list" do
  ShipName.delete(params["name_id"])
  erb :"data_deleted"
end

get "/show_delete_type_list" do
  type_to_look = ShipType.find(params["type_id"])
  if type_to_look.delete_type
    erb :"data_deleted"
  else
    erb :"cant_delete_data_exists"
  end
end

get "/show_delete_location_list" do
  loc_to_look = ShipLocation.find(params["location_id"])
  if loc_to_look.delete_location
    erb :"data_deleted"
  else
    erb :"cant_delete_data_exists"
  end
end