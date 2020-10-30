class GameSerializer < Blueprinter::Base
  identifier :id

  fields :state, :dimension

  association :user, blueprint: UserSerializer
  association :steps, blueprint: StepSerializer
  association :winner, blueprint: UserSerializer
  association :gamers, blueprint: GamerSerializer

  field :cells do |game|
    game
      .cells
      .group_by(&:y)
      .values
      .sort_by{ |v| v.first.y }
      .each{ |v| v.sort_by!(&:x) }
  end

  field :current_gamer, blueprint: GamerSerializer
end
