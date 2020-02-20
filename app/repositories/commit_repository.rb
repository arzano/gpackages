require 'singleton'

class CommitRepository < BaseRepository
  include Singleton

  client ElasticsearchClient.default

  index_name "commit-#{Rails.env}"

  klass Commit

  mapping dynamic: 'strict' do
    indexes :id, type: 'keyword'
    indexes :author_name, type: 'keyword'
    indexes :author_email, type: 'keyword'
    indexes :author_date, type: 'date'
    indexes :committer_name, type: 'keyword'
    indexes :committer_email, type: 'keyword'
    indexes :committer_date, type: 'date'
    indexes :message, type: 'text'
    indexes :files do
      indexes :modified, type: 'keyword'
      indexes :deleted, type: 'keyword'
      indexes :added, type: 'keyword'
    end
    indexes :packages, type: 'keyword'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end

  # Parse the "created_at" and "updated_at" fields in the document
  #
  def deserialize(document)
    hash = document['_source']
    hash['created_at'] = Time.parse(hash['created_at']).utc if hash['created_at']
    hash['updated_at'] = Time.parse(hash['updated_at']).utc if hash['updated_at']
    Commit.new hash
  end
end
