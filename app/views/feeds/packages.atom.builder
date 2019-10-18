@feed_id ||= nil

atom_feed(id: atom_id(@feed_type, @feed_id, 'feed')) do |feed|

  all_packages = PackageRepository.default_search(@query, 0, 10_000)

  feed.title @feed_title
  feed.updated !all_packages.empty? ? all_packages.first.created_at : Time.now

  feed.author do |author|
    author.name 'Gentoo Packages Database'
  end

  all_packages.each do |package|
    atom = package.atom

    commit = CommitRepository.find_sorted_by :packages, atom, :date, "desc", 1
    commit = commit.first

    if package.nil?
      logger.warn "Package nil!"
      next
    end

    id = atom

    feed.entry(
      package,
      id: atom_id(@feed_type, @feed_id, id),
      url: absolute_link_to_package(atom)) do |entry|
      entry.updated commit ? commit.date.to_datetime.rfc3339 : Time.now.to_datetime.rfc3339

      entry.title(t :feed_keyworded_title,
                    atom: atom,
                    description: package.description)
      entry.content(t :feed_commit_content,
                      hash: commit ? commit.id[0..6] : "",
                      message: commit ? commit.message : "No commit available")
    end
  end
end
