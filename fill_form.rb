require 'telegram/bot'
require 'watir'
require 'debug'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--window-size=1280,1024')
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

browser = Watir::Browser.new(:chrome, options:)

browser.goto ENV.fetch('FORM_URL', '')

# Find form
form = browser.form(id: ENV.fetch('FORM_ID', ''))

# Fill form inputs
form.text_field(index: 0).set(ENV.fetch('EMPLOYEE_NUMBER', ''))
form.text_field(index: 1).set(ENV.fetch('EMPLOYEE_NAME', ''))

current_date = Time.now.getlocal('-06:00')
parsed_date = current_date.strftime('%Y-%m-%d-%H:%S')
before_submission_screenshot = "before_submission_#{parsed_date}.png"
after_submission_screenshot = "after_submission_#{parsed_date}.png"

# Take a screenshot before submission
browser.screenshot.save(before_submission_screenshot)

# Submit the form
# browser.button(type: 'submit').click

# Take a screenshot after submission
browser.screenshot.save(after_submission_screenshot)

browser.close

### Send screenshots by Telegram
TELEGRAM_BOT_TOKEN = ENV.fetch('TELEGRAM_BOT_TOKEN', '')
RECIPIENT_CHAT_ID = ENV.fetch('RECIPIENT_CHAT_ID', '')

EMOJIS = ['🥰', '😍', '😘', '😊', '❤️ '].freeze
DAYS_IN_SPANISH = {
  'Monday' => 'Lunes',
  'Tuesday' => 'Martes',
  'Wednesday' => 'Miércoles',
  'Thursday' => 'Jueves',
  'Friday' => 'Viernes',
}.freeze

day_of_week = DAYS_IN_SPANISH[current_date.strftime("%A")]

# Initialize the bot
Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  # File paths to the images
  image_paths = [before_submission_screenshot, after_submission_screenshot]

  # Create a media group payload
  media = image_paths.map.with_index do |path, index|
    {
      type: 'photo',
      media: "attach://photo_#{index + 1}" # Use the attach:// prefix
    }
  end

  # Prepare the files for upload
  files = image_paths.each_with_index.with_object({}) do |(path, index), hash|
    hash["photo_#{index + 1}"] = Faraday::UploadIO.new(path, 'image/png')
  end

  bot.api.send_message(
    chat_id: RECIPIENT_CHAT_ID,
    text: "Buenos días mi amor 🥰 🥰, te comparto las capturas de tu registro. \nQue tengas un bonito #{day_of_week} 😘"
  )

  # Send the media group
  bot.api.send_media_group(
    chat_id: RECIPIENT_CHAT_ID,
    media: media,
    **files
  )

  bot.api.send_message(
    chat_id: RECIPIENT_CHAT_ID,
    text: EMOJIS[rand(5)]
  )

rescue Telegram::Bot::Exceptions::ResponseError => e
  puts "Error: #{e.message}"
end
