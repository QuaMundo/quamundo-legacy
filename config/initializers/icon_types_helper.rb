module IconTypesHelper
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
      fact:             { icon: 'exclamation-circle',   style: 'fas' },
      fact_constituent: { icon: 'random',               style: 'fas' },
      relation:         { icon: 'link',                 style: 'fas' },
      ancestors:        { icon: 'users',                style: 'fas' },

      # Attributes
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
      delete:           { icon: 'trash',                style: 'fas' },
      permissions:      { icon: 'lock',                 style: 'fas' },

      # Misc
      start_date:       { icon: 'step-forward',         style: 'fas' },
      end_date:         { icon: 'step-backward',        style: 'fas' }
    }
  end
end
