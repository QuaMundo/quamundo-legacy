# frozen_string_literal: true

RSpec.describe 'users/index_entry', type: :view do
  include_context 'Admin Session'

  let(:normal_user)    { create(:user) }

  it 'shows crud links of normal user' do
    render(partial: 'users/index_entry', locals: { index_entry: normal_user })
    expect(rendered).to have_content(normal_user.nick)
    expect(rendered).to have_content(normal_user.email)
    pending 'Not impelemented yet'
    expect(rendered).to have_link(href: user_path(user), title: 'delete')
  end

  it 'does not show delete link of admin user' do
    render(partial: 'users/index_entry', locals: { index_entry: user })
    pending 'Not impelemented yet'
    expect(rendered).not_to have_link(href: user_path(user), title: 'delete')
  end
end
