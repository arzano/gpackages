require 'singleton'

class ChangeRepository < BaseRepository
  include Singleton

  client ElasticsearchClient.default

  index_name "change-#{Rails.env}"

  klass Change

  mapping dynamic: 'strict' do
    indexes :id, type: 'keyword'
    indexes :package, type: 'keyword'
    indexes :category, type: 'keyword'
    indexes :change_type, type: 'keyword'
    indexes :version, type: 'keyword'
    indexes :arches, type: 'keyword'
    indexes :commit, type: 'keyword'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end

  # Parse the "created_at" and "updated_at" fields in the document
  #
  def deserialize(document)
    hash = document['_source']
    hash['created_at'] = Time.parse(hash['created_at']).utc if hash['created_at']
    hash['updated_at'] = Time.parse(hash['updated_at']).utc if hash['updated_at']
    Change.new hash
  end

end
