class Useflag
  include ActiveModel::Model
  include ActiveModel::Validations

  ATTRIBUTES = [:id,
                :created_at,
                :updated_at,
                :name,
                :description,
                :atom,
                :scope,
                :use_expand_prefix].freeze
  attr_accessor(*ATTRIBUTES)

  validates :name, presence: true

  def initialize(attr = {})
    attr.each do |k, v|
      send("#{k}=", v) if ATTRIBUTES.include?(k.to_sym)
    end
  end

  def attributes
    @id = @name + '-' + (@atom || 'global') + '-' + @scope
    @created_at ||= DateTime.now
    @updated_at = DateTime.now
    ATTRIBUTES.each_with_object({}) do |attr, hash|
      if (value = send(attr))
        hash[attr] = value
      end
    end
  end
  alias to_hash attributes

  def all_fields
    [:name, :description, :atom, :scope, :use_expand_prefix]
  end

  def to_param
    name
  end

  def strip_use_expand
    name.gsub(use_expand_prefix + '_', '')
  end

  # Converts the model to a Hash
  #
  # @param [Array<Symbol>] fields Fields to export into the Hash, or all fields if nil
  # @return [Hash] Hash containing the selected fields
  def to_hsh(*fields)
    fields = all_fields if fields.empty?
    Hash[fields.map { |field| [field, send(field)] }]
  end
end
