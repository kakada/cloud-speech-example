require 'firebase'

SYMPTOMS = [
  'tiêu chảy', 'tiêu chảy cấp', 'tử vong',
  'nước ngoài', 'nhiễm trùng', 'hô hấp', 'cấp tính', 'ho nhiều', 'sốt cao', 'tử vong',
]

def detect
  text = 'Tôi đang ở Kim Bôi, Hoà Bình. Tôi muốn báo cáo về một trường hợp tiêu chảy cấp và sốt cao ở gần nhà tôi.'

  symptoms = []
  SYMPTOMS.each do |s|
    if text.include? s
      symptoms.push s
    end
  end

  locations = []
  TREE.each do |province_name, districts|
    if text.include? province_name.to_s
      locations.push
      districts.each do |district_name, communes|
        if text.include? district_name.to_s
          puts district_name
          communes.each do |commune_name|
            if text.include? commune_name.to_s
              puts commune_name
              # break
            end
          end
          # break
        end
      end
      # break
    end
  end
end

detect()
