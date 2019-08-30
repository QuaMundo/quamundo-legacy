module IconHelper
  # FontAwesome mappings used by IconHelper
  def self.available_types
    # Be sure to keep `app/javascript/src/default_images.js` up-to-date
    {
      # Inventory
      world:            { icon: 'globe',                style: 'fas' },
      figure:           { icon: 'user',                 style: 'fas' },
      item:             { icon: 'wrench',               style: 'fas' },
      location:         { icon: 'map-marker-alt',       style: 'fas' },
      concept:          { icon: 'comment',              style: 'far' },
      fact:             { icon: 'exclamation-triangle', style: 'fas' },
      fact_constituent: { icon: 'random',               style: 'fas' },
      relation:         { icon: 'link',                 style: 'fas' },

      # Attribut        es
      note:             { icon: 'sticky-note',          style: 'far' },
      dossier:          { icon: 'folder-open',          style: 'fas' },
      trait:            { icon: 'tag',                  style: 'fas' },
      tag:              { icon: 'hashtag',              style: 'fas' },
      image:            { icon: 'image',                style: 'fas' },
      audio:            { icon: 'headphones',           style: 'fas' },
      video:            { icon: 'video',                style: 'fas' },
      file:             { icon: 'file',                 style: 'fas' },

      # Menu
      menu:             { icon: 'ellipsis-v',           style: 'fas' },
      user:             { icon: 'user',                 style: 'fas' },
      edit:             { icon: 'edit',                 style: 'fas' },
      index:            { icon: 'list',                 style: 'fas' },
      new:              { icon: 'plus',                 style: 'fas' },
      delete:           { icon: 'trash',                style: 'fas' }
    }
  end
end
