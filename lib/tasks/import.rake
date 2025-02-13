namespace :import do
  desc "Import provinces, districts, and wards from API"
  task provinces: :environment do
    require_relative "../import_provinces"
    ImportProvinces.call
  end

  desc "Import categories level-1-2 into the database"
  task categories: :environment do
    require_relative "../import_categories"
    ImportCategories.call
  end
end
