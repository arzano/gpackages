require 'time'

class Portage::Util::History
  class << self
    def update
      return [] if KKULEOMI_DISABLE_GIT == true

      latest_commit_id = KKULEOMI_FIRST_COMMIT
      latest_commit = CommitRepository.n_sorted_by(1, 'committer_date', 'desc').first

      latest_commit_id = latest_commit.id unless latest_commit.nil?

      git = Kkuleomi::Util::Exec
            .cmd(KKULEOMI_GIT)
            .in(KKULEOMI_RUNTIME_PORTDIR)
            .args(
              'log', '--name-status', '--no-merges', '--date=iso8601', '--format=fuller', '--reverse',
              "#{latest_commit_id}..HEAD")
            .run

      raw_log, stderr, status = git.stdout, git.stderr, git.exit_status
      fail "Cannot get git log: #{stderr}" unless status == 0

      parse raw_log
    end

    private

    def parse(raw_log)
      count = raw_log.split("\n\ncommit ").slice(0, 10000).size

      raw_log.split("\n\ncommit ").slice(0, 10000).each do |raw_commit|
        commit_lines = raw_commit.lines

        _id = commit_lines.shift.gsub('commit ', '').strip

        commit_lines.shift =~ /^Author:\s+(.*) <([^>]*)>$/
        _author_name = $1
        _author_email = $2
        _author_date = Time.parse(commit_lines.shift[/^AuthorDate:\s+(.*)$/, 1]).utc

        commit_lines.shift =~ /^Commit:\s+(.*) <([^>]*)>$/
        _committer_name = $1
        _committer_email = $2
        _committer_date = Time.parse(commit_lines.shift[/^CommitDate:\s+(.*)$/, 1]).utc

        commit_lines.shift
        _raw_message = []
        while (line = commit_lines.shift) != "\n" && !line.nil?
          _raw_message << line
        end

        _raw_files = commit_lines
        _files = {added: [], modified: [], deleted: []}
        _packages = []
        _raw_files.each do |file|
          mode, file = file.split "\t"

          _packages << (file.strip.split('/')[0] + '/' + file.strip.split('/')[1]) if file.strip.split('/').size >= 3

          case mode
            when 'M'
              _files[:modified] << file.strip
            when 'D'
              _files[:deleted] << file.strip
            when 'A'
              _files[:added] << file.strip
          end
        end

        commit = Commit.new
        commit.id = _id
        commit.author_name = _author_name
        commit.author_email = _author_email
        commit.author_date = _author_date
        commit.committer_name = _committer_name
        commit.committer_email = _committer_email
        commit.committer_date = _committer_date
        commit.message = _raw_message.map { |l| l.strip }.join("\n")
        commit.files = _files
        commit.packages = _packages.to_set
        CommitRepository.save(commit)
      end

      CommitsUpdateJob.perform_later if count >= 10000
    end
  end
end
