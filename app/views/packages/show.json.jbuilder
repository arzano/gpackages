json.extract! @package, :atom, :description
json.href slf package_url(id: @package.atom)

json.versions @package.versions do |version|
  json.version version.version
  json.keywords version.keywords
  json.masks version.masks
end

json.herds @package.herds
json.maintainers @package.maintainers do |maintainer|
  json.email maintainer['email']
  json.name maintainer['name']
  json.description maintainer['description']
  json.type maintainer['type']

  if maintainer['type'] == 'project'
    json.members project_members(maintainer['email'])
  end
end

json.use do
  json.local @package.versions.first.useflags[:local] do |flag|
    json.name flag[:name]
    json.description strip_tags flag[:description]
  end

  json.global @package.versions.first.useflags[:global] do |flag|
    json.name flag[:name]
    json.description strip_tags flag[:description]
  end

  json.use_expand @package.versions.first.useflags[:use_expand].group_by { |u| u['use_expand_prefix'] } do |flag|
    json.set! flag[0] do
      json.array! flag[1] do |expand_flag|
        json.name expand_flag[:name].gsub(expand_flag[:use_expand_prefix] + '_', '')
        json.description strip_tags expand_flag[:description]
      end
    end
  end
end

json.extract! @package, :updated_at
