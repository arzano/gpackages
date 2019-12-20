class Category
  include ActiveModel::Model
  include ActiveModel::Validations

  ATTRIBUTES = %i[id
                  created_at
                  updated_at
                  name
                  description
                  metadata_hash].freeze
  attr_accessor(*ATTRIBUTES)

  validates :name, presence: true

  def initialize(attr = {})
    attr.each do |k, v|
      send("#{k}=", v) if ATTRIBUTES.include?(k.to_sym)
    end
  end

  def attributes
    @id = @name
    @created_at ||= DateTime.now
    @updated_at = DateTime.now
    ATTRIBUTES.each_with_object({}) do |attr, hash|
      if (value = send(attr))
        hash[attr] = value
      end
    end
  end
  alias to_hash attributes

  # Determines if the document model needs an update from the repository model
  #
  # @param [Portage::Repository::Category] category_model
  def needs_import?(category_model)
    metadata_hash != category_model.metadata_hash
  end

  # Populates values from a repository category model
  #
  # @param [Portage::Repository::Category] category_model Input category model
  def import(category_model)
    self.name = category_model.name
    self.description = category_model.description
    self.metadata_hash = category_model.metadata_hash
  end

  # Populates values from a repository category model and saves
  #
  # @param [Portage::Repository::Category] category_model Input category model
  def import!(category_model)
    import(category_model)
    CategoryRepository.save(self)
  end

  # Returns the URL parameter for referencing this package (Rails internal stuff)
  def to_param
    name
  end
end
