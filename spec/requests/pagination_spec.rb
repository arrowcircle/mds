# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pagination", type: :request do
  it "renders the Pagy 43 series nav in Russian" do
    create_list(:author, 21)

    get authors_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('class="pagy series-nav"')
    expect(response.body).to include('aria-current="page"')
    expect(response.body).to include('aria-label="Вперёд"')
  end
end
