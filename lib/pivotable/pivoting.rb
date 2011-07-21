module Pivotable::Pivoting

  # Apply pivot retations. Example:
  #
  #   Stat.pivot(:overall)
  #
  #   # Use custom (e.g. admin) rotation
  #   Stat.pivot(:admin, :by_day)
  #
  #   # Same as
  #   Stat.pivot("admin:by_day")
  #
  #   # Combine it with relations & scopes
  #   Stat.latest.order('some_column').pivot(:by_day).paginate :page => 1
  #
  def pivot(*parts)
    klass.pivotable(*parts).merge(self)
  end

end