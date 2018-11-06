module DeviseHelper
  # see:
  # https://github.com/plataformatec/devise/wiki/Override-devise_error_messages!-for-views
  def devise_error_messages!
    return '' unless devise_error_messages?
    render(partial: 'devise/shared/error_messages',
           locals: { msg: resource.errors.full_messages })
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
