class Pivotable::Column

  attr_reader :attribute

  def initialize(model, attribute, options = {})
    @as        = options[:as]
    @attribute = case attribute
    when Arel::Attribute
      attribute
    else
      model.arel_table[attribute]
    end
    raise ArgumentError, "Invalid attribute #{attribute.inspect}" unless @attribute
  end

  def name
    @as || attribute.name
  end

  def calculate!(function)
    @as     ||= attribute.name
    @function = attribute.send(function)
  end

  def to_select
    select = (@function || attribute).clone
    select.as(@as.to_s) if @as
    select
  end

  def to_group
    attribute.clone
  end

end