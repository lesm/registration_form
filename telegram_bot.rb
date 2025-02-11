# frozen_string_literal: true

class TelegramBot
  TELEGRAM_BOT_TOKEN = ENV.fetch('TELEGRAM_BOT_TOKEN', '')
  RECIPIENT_CHAT_ID = ENV.fetch('RECIPIENT_CHAT_ID', '')
  EMOJIS = ['🥰', '😍', '😘', '😊', '❤️ '].freeze
  DAYS_IN_SPANISH = {
    'Monday' => 'Lunes',
    'Tuesday' => 'Martes',
    'Wednesday' => 'Miércoles',
    'Thursday' => 'Jueves',
    'Friday' => 'Viernes',
    'Saturday' => 'Sábado',
    'Sunday' => 'Domingo'
  }.freeze

  def send_evidences(images_paths)
    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      send_message(bot, RECIPIENT_CHAT_ID, header_message)
      send_media_group(bot, RECIPIENT_CHAT_ID, images_paths)
      send_message(bot, RECIPIENT_CHAT_ID, footer_message)
    rescue Telegram::Bot::Exceptions::ResponseError => e
      puts "Error: #{e.message}"
    end
  end

  def send_weekend_message
    message = "Buenos días mi amor 🥰 🥰, hoy no hay registro.\n" \
    "Que tengas un bonito #{day_of_week} 😘"

    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      send_message(bot, RECIPIENT_CHAT_ID, message)
      send_message(bot, RECIPIENT_CHAT_ID, footer_message)
    rescue Telegram::Bot::Exceptions::ResponseError => e
      puts "Error: #{e.message}"
    end
  end

  private

  def day_of_week
    current_date = Time.now.getlocal('-06:00')
    DAYS_IN_SPANISH[current_date.strftime("%A")]
  end

  def header_message
    "Buenos días mi amor 🥰 🥰, te comparto las capturas de tu registro.\n" \
    "Que tengas un bonito #{day_of_week} 😘"
  end

  def footer_message
    EMOJIS[rand(5)]
  end

  def send_message(bot, chat_id, text)
    bot.api.send_message(chat_id:, text:)
  end

  def send_media_group(bot, chat_id, images_paths)
    bot.api.send_media_group(
      chat_id:,
      media: build_media_structure(images_paths),
      **build_files_structure(images_paths)
    )
  end

  def build_media_structure(images_paths)
    images_paths.map.with_index do |path, index|
      {
        type: 'photo',
        media: "attach://photo_#{index + 1}" # Use the attach:// prefix
      }
    end
  end

  def build_files_structure(images_paths)
    images_paths.each_with_index.with_object({}) do |(path, index), hash|
      hash["photo_#{index + 1}"] = Faraday::UploadIO.new(path, 'image/png')
    end
  end
end
