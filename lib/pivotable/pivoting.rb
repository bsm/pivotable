module Pivotable::Pivoting

  # Apply pivot retations. Example:
  #
  #   Stat.pivot(:overall)
  #
  #   # Use custom (e.g. admin) rotation
  #   Stat.pivot(:admin, :by_day)
  #
  #   # Combine it with relations & scopes
  #   Stat.latest.order('some_column').pivot(:by_day).paginate :page => 1
  #
  def pivot(*args)
    rotation = args.pop
    scope    = args.first.is_a?(Symbol) ? args.shift : nil
    klass.pivotable(scope)[rotation].merge(self)
  end

end