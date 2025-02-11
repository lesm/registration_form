require './web_automation'
require './telegram_bot'

# Fill registration form
web_automation = WebAutomation.new
web_automation.fill_form

# Send evidences thorugh Telegram Bot
telegram_bot = TelegramBot.new
telegram_bot.send_evidences(web_automation.screenshots_names)
