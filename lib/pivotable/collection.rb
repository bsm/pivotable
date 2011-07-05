class Pivotable::Collection < Hash

  attr_reader :model

  def initialize(model)
    @model = model
    super()
  end

  # Adds a new rotation to this collection
  def rotation(name, &block)
    name, parent = name.is_a?(Hash) ? name.to_a.first : [name, nil]
    item = Pivotable::Rotation.new(self, name, parent, &block)
    self[item.name] = item
  end

end