class ImportCategories
  def self.call
    new.import_data
  end

  def import_data
    categories = [
      {id: 1, name: "Điện thoại", level: 1},
      {id: 2, name: "Hãng điện thoại", level: 2, parent_id: 1},
      {id: 3, name: "Mức giá điện thoại", level: 2, parent_id: 1},
      {id: 4, name: "Điện thoại hot", level: 2, parent_id: 1},
      {id: 5, name: "Hãng máy tính bảng", level: 2, parent_id: 1},
      {id: 6, name: "Máy tính bảng hot", level: 2, parent_id: 1},

      {id: 7, name: "Laptop", level: 1},
      {id: 8, name: "Thương hiệu", level: 2, parent_id: 7},
      {id: 9, name: "Nhu cầu sử dụng", level: 2, parent_id: 7},
      {id: 10, name: "Dòng chip", level: 2, parent_id: 7},
      {id: 11, name: "Phân khúc giá", level: 2, parent_id: 7},

      {id: 12, name: "Âm thanh", level: 1},
      {id: 13, name: "Chọn loại tai nghe", level: 2, parent_id: 12},
      {id: 14, name: "Hãng tai nghe", level: 2, parent_id: 12},
      {id: 15, name: "Chọn theo giá", level: 2, parent_id: 12},
      {id: 16, name: "Hãng loa", level: 2, parent_id: 12},
      {id: 17, name: "Chọn loại loa", level: 2, parent_id: 12},
      {id: 18, name: "Sản phẩm nổi bật", level: 2, parent_id: 12}
    ]

    ActiveRecord::Base.transaction do
      categories.each{|category_data| import_category(category_data)}
    end
  end

  private

  def import_category category_data
    parent_category =
      category_data[:parent_id] ? Category.find(category_data[:parent_id]) : nil
    parent_path = parent_category&.path

    full_path =
      if parent_path
        "#{parent_path}/#{category_data[:id]}"
      else
        "/#{category_data[:id]}"
      end

    Category.find_or_create_by!(
      id: category_data[:id],
      name: category_data[:name],
      path: full_path,
      level: category_data[:level]
    )
  end
end
