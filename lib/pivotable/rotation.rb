class Pivotable::Rotation

  attr_reader :model, :name, :parent, :block, :selects, :groups, :joins, :loaded
  alias       :loaded? :loaded

  def initialize(model, name, parent = nil, &block)
    @model   = model
    @name    = name
    @parent  = parent
    @selects = []
    @groups  = []
    @joins   = []
    @block   = block
    @loaded  = false
  end

  def sum(*cols)
    calculate :sum, *cols
  end

  def minimum(*cols)
    calculate :minimum, *cols
  end

  def maximum(*cols)
    calculate :maximum, *cols
  end

  def average(*cols)
    calculate :average, *cols
  end

  def by(*cols)
    cols = columns(*cols)
    @selects += cols
    @groups  += cols
  end

  def calculate(function, *cols)
    columns(*cols).each do |col|
      col.calculate!(function)
      @selects << col
    end
  end

  def joins(*names)
    @joins += names
  end

  def merge(relation)
    load! unless loaded?

    selects.each do |column|
      relation = relation.select(column.to_select)
    end

    groups.each do |column|
      relation = relation.group(column.to_group)
    end

    joins.each do |join|
      relation = relation.joins(join)
    end

    relation
  end

  def load!
    return if loaded?

    instance_eval &model.pivotable(parent).block if parent
    instance_eval &block
    @loaded = true
  end

  private

    def columns(*cols)
      opts = cols.extract_options!
      cols.map do |col|
        Pivotable::Column.new(model, col, opts)
      end
    end

end