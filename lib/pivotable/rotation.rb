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

  # Calculate minimum. Calls #calculate with :via => :minimum.
  # See #calulate for examples.
  def minimum(*cols)
    opts = cols.extract_options!.update :function => :minimum
    calculate *(cols << opts)
  end

  # Calculate maximum. Calls #calculate with :via => :maximum.
  # See #calulate for examples.
  def maximum(*cols)
    opts = cols.extract_options!.update :function => :maximum
    calculate *(cols << opts)
  end

  # Calculate sum. Calls #calculate with :via => :sum.
  # See #calulate for examples.
  def sum(*cols)
    opts = cols.extract_options!.update :function => :sum
    calculate *(cols << opts)
  end

  # Calculate sum. Calls #calculate with :via => :average.
  # See #calulate for examples.
  def average(*cols)
    opts = cols.extract_options!.update :function => :average
    calculate *(cols << opts)
  end

  # Calculate value. Examples:
  #
  #   # Simple function
  #   calculate :views, :function => :sum
  #   # => SELECT SUM(table.views) AS views FROM table
  #
  #   # Use a special column
  #   calculate :page_views, :via => :views, :function => :sum
  #   # => SELECT SUM(table.views) AS page_views FROM table
  #
  #   # Use a custom SQL
  #   calculate :page_views, :via => "SUM(table.views)"
  #   # => SELECT SUM(table.views) AS page_views FROM table
  #
  #   # Use an AREL expressions
  #   calculate :page_views, :via => Model.arel_table[:views].sum
  #   # => SELECT SUM(table.views) AS page_views FROM table
  #
  def calculate(*cols)
    opts = cols.extract_options!
    cols.each do |col|
      @selects << Pivotable::Expression::Calculation.new(model, col, opts)
    end
  end

  # Group by a column. Examples:
  #
  #   # Simple function
  #   by :page_id
  #   # => SELECT table.page_id FROM table GROUP BY page_id
  #
  #   # Use a special column
  #   by :pageid, :via => page_id
  #   # => SELECT table.page_id AS pageid FROM table GROUP BY page_id
  #
  #   # Use a custom SQL
  #   by :page_id, :via => "page_id * 2"
  #   # => SELECT page_id * 2 AS page_id FROM table GROUP BY page_id * 2
  #
  #   # Use an AREL attributes
  #   by :pageid, :via => Model.arel_table[:page_id]
  #   # => SELECT table.page_id AS pageid FROM table GROUP BY page_id
  #
  def by(*cols)
    opts = cols.extract_options!
    cols.each do |col|
      expr = Pivotable::Expression::Generic.new(model, col, opts)
      @selects << expr
      @groups  << expr
    end
  end

  def joins(*args)
    @joins += args
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

end