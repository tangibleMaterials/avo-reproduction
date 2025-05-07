class Avo::Resources::Requirement < Avo::BaseResource
  self.title = :id
  self.includes = []

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :values, as: :tags, help: "Comma-separated tags or array of strings"
  end
end
