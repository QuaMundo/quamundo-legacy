module IconHelper
  # FontAwesome mappings used by IconHelper
  def self.available_types
      {
        # Inventory
        world:    { icon: 'globe',          style: 'fas' },
        figure:   { icon: 'user',           style: 'fas' },
        item:     { icon: 'wrench',         style: 'fas' },
        location: { icon: 'map-marker-alt', style: 'fas' },
        fact:     { icon: 'exclamation',    style: 'fas' },

        # Menu
        user:     { icon: 'user',           style: 'fas' },
        edit:     { icon: 'edit',           style: 'fas' },
        index:    { icon: 'list',           style: 'fas' },
        new:      { icon: 'plus',           style: 'fas' },
        delete:   { icon: 'trash',          style: 'fas' }
      }
  end
end
