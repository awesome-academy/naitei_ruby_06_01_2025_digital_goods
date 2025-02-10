require "net/http"
require "json"

class ImportProvinces
  def self.call
    new.import_data
  end

  def import_data
    url = ENV["API_PROVINCES"]
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    ActiveRecord::Base.transaction do
      data.each{|province_data| import_province(province_data)}
    end
  end

  private

  def import_province province_data
    province = Province.find_or_create_by(name: province_data["name"])

    province_data["districts"].each do |district_data|
      import_district(district_data, province)
    end
  end

  def import_district district_data, province
    district = District.find_or_create_by(name: district_data["name"],
                                          province:)

    district_data["wards"].each do |ward_data|
      Ward.find_or_create_by(name: ward_data["name"], district:)
    end
  end
end
