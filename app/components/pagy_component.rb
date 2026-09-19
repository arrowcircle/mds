class PagyComponent < ViewComponent::Base
  attr_reader :pagy
  def initialize(pagy)
    @pagy = pagy
  end
end
