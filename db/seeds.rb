def category_count
  40
end

def org_count
  30
end

def location_count
  (15..30).to_a.sample
end

def rand_category_ids
  n = (1..7).to_a.sample
  Category.pluck(:id).sample n
end

def rand_org_id
  Org.pluck(:id).sample
end

def rand_desc
  Faker::Lorem.paragraph sentence_count: 3, random_sentences_to_add: 4
end

def addr
  n = rand
  if n < 0.2
    return {}
  elsif n < 0.8
    return {address1: Faker::Address.street_address}
  else
    return {address1: Faker::Address.street_address, address2: Faker::Address.secondary_address}
  end
end

def create_all
  category_count.times do
    puts Category.create! name: Faker::Space.meteorite, description: rand_desc
  end

  org_count.times do
    puts Org.create! name: Faker::Company.name, desc: rand_desc, website: Faker::Internet.url
  end

  Category.all.each do |cat|
    location_count.times do
      puts Location.create!(
        org_id: rand_org_id,
        category_ids: rand_category_ids,

        name: Faker::Company.name,
        desc: rand_desc,
        website: Faker::Internet.url,

        **addr,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zip: Faker::Address.zip,
        neighborhood: rand < 0.8 ? Faker::Address.community : nil,
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
      )
    end
  end
end

if Category.any?
  puts "#{Category.count} categories already exist. Not creating fake data."
else
  create_all
end

if Comfy::Cms::Page.any?
  puts "#{Comfy::Cms::Page} pages already exist. Not creating initial pages."
else
  site = Comfy::Cms::Site.create! identifier: 'site', label: 'site', hostname: 'localhost'
  layout = Comfy::Cms::Layout.create!(
    site: site, identifier: 'default', label: 'default',
    app_layout: 'application', content: '{{ cms:markdown content }}',
  )
  # TODO: fill page with basic content and categories snippet
  page = Comfy::Cms::Page.create!(site: site, layout: layout, label: 'Home')
  ap page
end

if User.any?
  puts "#{User.count} users already exist. Not creating dev users."
else
  User.create! email: 'dev@womensdirectory.org'
  puts 'Sign into your dev user as dev@womensdirectory.org'
end
