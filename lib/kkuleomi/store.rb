module Kkuleomi::Store
  def self.create_index(_force = false)
		repositories = [
			CategoryRepository,
			PackageRepository,
			VersionRepository,
			ChangeRepository,
			UseflagRepository,
			CommitRepository
		]

		settings = JSON.parse('{ "mapping": { "total_fields": { "limit": 50000 } } }')

		# In ES 1.5, we could use 1 mega-index. But in ES6, each model needs its own.
		repositories.each { |repository|
						repository.instance.create_index!(force: _force, settings: settings)
		}
  end
end
