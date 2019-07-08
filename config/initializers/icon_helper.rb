module IconHelper
  # FontAwesome mappings used by IconHelper
  def self.available_types
    # Be sure to keep `app/javascript/src/default_images.js` up-to-date
    {
      # Inventory
      world:    { icon: 'globe',              style: 'fas' },
      figure:   { icon: 'user',               style: 'fas' },
      item:     { icon: 'wrench',             style: 'fas' },
      location: { icon: 'map-marker-alt',     style: 'fas' },
      fact:     { icon: 'exclamation-circle', style: 'fas' },

      # Attributes
      note:     { icon: 'sticky-note',        style: 'far' },
      dossier:  { icon: 'folder-open',        style: 'fas' },
      trait:    { icon: 'tag',                style: 'fas' },
      tag:      { icon: 'hashtag',            style: 'fas' },
      image:    { icon: 'image',              style: 'fas' },

      # Menu
      user:     { icon: 'user',               style: 'fas' },
      edit:     { icon: 'edit',               style: 'fas' },
      index:    { icon: 'list',               style: 'fas' },
      new:      { icon: 'plus',               style: 'fas' },
      delete:   { icon: 'trash',              style: 'fas' }
    }
  end
end
