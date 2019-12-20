require 'singleton'

class CategoryRepository < BaseRepository
  include Singleton

  client ElasticsearchClient.default

  index_name "categories-#{Rails.env}"

  klass Category

  mapping dynamic: 'strict' do
    indexes :id, type: 'keyword'
    indexes :name, type: 'text'
    indexes :description, type: 'text'
    indexes :metadata_hash, type: 'keyword'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end

  # Parse the "created_at" and "updated_at" fields in the document
  #
  def deserialize(document)
    hash = document['_source']
    hash['created_at'] = Time.parse(hash['created_at']).utc if hash['created_at']
    hash['updated_at'] = Time.parse(hash['updated_at']).utc if hash['updated_at']
    Category.new hash
  end
end
