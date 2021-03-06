require 'singleton'

class UseflagRepository < BaseRepository
  include Singleton

  class << self
    extend Forwardable
    def_delegators :instance, :get_flags, :suggest, :local_for, :global, :use_expand
  end

  index_name "useflags-#{Rails.env}"

  klass Useflag

  mapping dynamic: 'strict' do
    indexes :id, type: 'keyword'
    indexes :name, type: 'text', fields: { raw: { type: "keyword" } }
    indexes :description, type: 'text'
    indexes :atom, type: 'keyword'
    indexes :scope, type: 'keyword'
    indexes :use_expand_prefix, type: 'keyword'
    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end

  # Retrieves all flags sorted by their state
  def get_flags(name)
    result = { local: {}, global: [], use_expand: [] }

    find_all_by("name.raw", name).each do |flag|
      case flag.scope
      when 'local'
        result[:local][flag.atom] = flag
      when 'global'
        result[:global] << flag
      when 'use_expand'
        result[:use_expand] << flag
      end
    end

    result
  end

  def suggest(q)
    results = search(
      size: 20,
      query: { match_phrase_prefix: { name: q } }
    )

    processed_results = {}
    results.each do |result|
      processed_results[result.name] = if processed_results.key? result.name
                                         Useflag.new('name' => result.name, 'description' => '(multiple definitions)', 'scope' => 'multi')
                                       else
                                         result
                                       end
    end

    processed_results.values.sort { |a, b| a.name.length <=> b.name.length }
  end

  # Loads the local USE flags for a given package in a name -> model hash
  #
  # @param [String] atom Package to find flags for
  # @return [Hash]
  def local_for(atom)
    map_by_name find_all_by(:atom, atom)
  end

  # Maps the global USE flags in the index by their name
  # This is expensive!
  #
  def global
    map_by_name find_all_by(:scope, 'global')
  end

  # Maps the USE_EXPAND variables in the index by their name
  #
  def use_expand
    map_by_name find_all_by(:scope, 'use_expand')
  end

  # Parse the "created_at" and "updated_at" fields in the document
  #
  def deserialize(document)
    hash = document['_source']
    hash['created_at'] = Time.parse(hash['created_at']).utc if hash['created_at']
    hash['updated_at'] = Time.parse(hash['updated_at']).utc if hash['updated_at']
    Useflag.new hash
  end

  private

  def map_by_name(collection)
    map = {}

    collection.each do |item|
      map[item.name] = item
    end

    map
  end
end
