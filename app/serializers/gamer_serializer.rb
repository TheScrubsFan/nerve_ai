class GamerSerializer < Blueprinter::Base
  identifier :id

  field :kind

  association :user, blueprint: UserSerializer
end
