class PagyComponent < ViewComponent::Base
  include Pagy::Frontend
  attr_reader :pagy
  def initialize(pagy)
    @pagy = pagy
  end
end
