Is there a way to pull a dynamic list of params to only change what we want out of a menu?

ie..  I want to change the cost and the type id of a ship.  If I run it in one form, params will have values for each attribute for the ship, even if it's ""  or 0.  I don't want to require a whole retype.. but I COULD pass the current values as defaults in the table?
ie..  if I use id 7, the attributes would be ```{id => 7, ship_name => "Proteus", cost => 92390128, ship_types_id => 9, ship_locations_id => 2}```


so..```
attrib_hash = attributes listed above
ship_to_change = ShipName.new(attrib_hash)```

ship_to_change would be an object.  If I pass it as @ship_to_change... could I then go into erb and have defaults as 

```<input type="text" name="ship_name" value="<%= @ship_to_change.name %>">``` ?

and for a select list? maybe:

``` <select name="type_id">
      <% ShipType.all.each do |type| %>
        <% if type.id = ship_to_change.id %>
          <option value"<%= type.id %>" selected><%= type.ship_type %></option>
        <% else %>
          <option value="<%= type.id %>"><%= type.ship_type %></option>
        <% end %>
      <% end %>
    </select>```

I'll give that a try when it comes to it.