class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :name
  self.includes = []

  def fields
    field :id, as: :id
    field :name, as: :text
    field :requirements, as: :has_many, nested: true
    field :organizations, as: :has_many, through: :user_organizations, name: "Organizations"

    field :user_organizations, as: :has_many, nested: true, show_on: :forms, name: "Organizations"
  end
end
