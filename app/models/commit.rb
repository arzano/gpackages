class Commit
  include ActiveModel::Model
  include ActiveModel::Validations

  ATTRIBUTES = %i[id
                  author_name
                  author_email
                  author_date
                  committer_name
                  committer_email
                  committer_date
                  message
                  files
                  packages
                  created_at
                  updated_at].freeze
  attr_accessor(*ATTRIBUTES)

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
end
