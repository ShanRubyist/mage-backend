class MageNameJob < ApplicationJob
  queue_as :default

  def perform()
    ai_calls = AiCall.all #.where("created_at >= ?", 1.hour.ago)
    ai_calls.each do |ac|
      data = ac.data
      next unless data
      if data.class == String
        h = JSON.load(data)
      else
        h = data
      end

      # 之前的旧数据，data字段存的格式是{status: xx, data: xx}
      h = h['data'] if h['data']
      if h.class == String
        h = JSON.load(h)
      else
        h = h
      end

      h['names'].each do |name|
        begin
          ac.mage_names.create(name: name['name'],
                               meaning: name['meaning'],
                               race: name['race'],
                               worldview: name['worldview'],
                               element: name['element'],
                               alignment: name['alignment'],
                               gender: name['gender']
          )
        rescue
          Rails.logger.error "#{name['name']} exist"
        end
      end
    end
  end
end
