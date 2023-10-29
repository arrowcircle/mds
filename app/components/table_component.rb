class TableComponent < ViewComponent::Base
  include Pagy::Frontend
  attr_reader :items, :item_class, :headers, :current_user
  def initialize(items:, item_class:, headers: nil, current_user: nil)
    @items = items
    @item_class = item_class
    @headers = headers || item_class.headers || []
    @current_user = current_user
  end
end
