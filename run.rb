require './web_automation'
require './telegram_bot'

def fill_form
  web_automation.fill_form
rescue Watir::Exception::UnknownObjectException, Watir::Wait::TimeoutError
  sleep(2)
  web_automation.fill_form
end

def telegram_bot
  @telegram_bot ||= TelegramBot.new
end

def web_automation
  @web_automation ||= WebAutomation.new
end

if (1..5).cover?(Time.now.getlocal('-06:00').wday)
  # weekdays process
  fill_form
  telegram_bot.send_evidences(web_automation.screenshots_names)
else
  # weekend process
  telegram_bot.send_weekend_message
end
