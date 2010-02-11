module LocalizationHelper
  
  def l(key, key2 = nil)
    raise "Массив ключей локализации не найден" unless defined?(L10N)

    begin
      if key2
        L10N[key.to_s][key2.to_s]
      else
        L10N[key.to_s]
      end
    rescue Exception => e
      raise "Неизвестный ключ локализации: #{key}:#{key2}"
    end
  end
  
end
