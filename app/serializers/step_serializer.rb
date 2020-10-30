class StepSerializer < Blueprinter::Base
  identifier :id

  field :created_at

  association :cell, blueprint: CellSerializer
  association :gamer, blueprint: GamerSerializer
end
