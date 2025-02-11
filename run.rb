require './web_automation'
require './telegram_bot'

telegram_bot = TelegramBot.new

if (1..5).cover?(Time.now.getlocal('-06:00').wday)
  web_automation = WebAutomation.new
  web_automation.fill_form

  telegram_bot.send_evidences(web_automation.screenshots_names)
else
  telegram_bot.send_weekend_message
end
