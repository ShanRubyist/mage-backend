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

      h['names'].each do |name|
        ac.mage_names.create(name: name['name'],
                             meaning: name['meaning'],
                             race: name['race'],
                             worldview: name['worldview'],
                             element: name['element'],
                             alignment: name['alignment'])
      end
    end
  end
end
