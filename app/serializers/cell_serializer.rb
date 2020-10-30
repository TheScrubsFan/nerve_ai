class CellSerializer < Blueprinter::Base
  identifier :id
  fields :x, :y, :kind
end
