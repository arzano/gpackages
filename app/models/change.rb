class Change
  include ActiveModel::Model
  include ActiveModel::Validations

  ATTRIBUTES = %i[_id
                  created_at
                  updated_at
                  package
                  category
                  change_type
                  version
                  arches
                  commit].freeze
  attr_accessor(*ATTRIBUTES)

  validates :package, presence: true

  def initialize(attr = {})
    attr.each do |k, v|
      send("#{k}=", v) if ATTRIBUTES.include?(k.to_sym)
    end
  end

  def attributes
    @created_at ||= DateTime.now
    @updated_at = DateTime.now
    ATTRIBUTES.each_with_object({}) do |attr, hash|
      if (value = send(attr))
        hash[attr] = value
      end
    end
  end
  alias to_hash attributes

  # Converts the model to an OpenStruct instance
  #
  # @param [Array<Symbol>] fields Fields to export into the OpenStruct, or all fields if nil
  # @return [OpenStruct] OpenStruct containing the selected fields
  def to_os(*fields)
    fields = all_fields if fields.empty?
    OpenStruct.new(Hash[fields.map { |field| [field, send(field)] }])
  end
end
