namespace :import do
  desc "Import provinces, districts, and wards from API"
  task provinces: :environment do
    require_relative "../import_provinces"
    ImportProvinces.call
  end
end
