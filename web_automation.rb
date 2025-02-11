# frozen_string_literal: true

require 'telegram/bot'
require 'watir'

class WebAutomation
  def initialize
    parsed_date = Time.now.getlocal('-06:00').strftime('%Y-%m-%d-%H:%S')

    @before_submission_screenshot = "before_submission_#{parsed_date}.png"
    @after_submission_screenshot = "after_submission_#{parsed_date}.png"
  end

  def fill_form
    browser.goto ENV.fetch('FORM_URL', '')

    form = browser.form(id: ENV.fetch('FORM_ID', ''))

    form.text_field(index: 0).set(ENV.fetch('EMPLOYEE_NUMBER', ''))
    form.text_field(index: 1).set(ENV.fetch('EMPLOYEE_NAME', ''))

    browser.screenshot.save(@before_submission_screenshot)

    # browser.span(text: 'Submit').click

    sleep(2)

    browser.screenshot.save(@after_submission_screenshot)

    browser.close
  end

  def screenshots_names
    [@before_submission_screenshot, @after_submission_screenshot]
  end

  private

  def browser
    @Browser ||= Watir::Browser.new(:chrome, options: browser_options)
  end

  def browser_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--window-size=1280,1024')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options
  end
end
