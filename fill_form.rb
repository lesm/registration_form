require 'watir'

browser = Watir::Browser.new :chrome

browser.goto ENV.fetch('FORM_URL', '')

# Find form
form = browser.form(id: ENV.fetch('FORM_ID', ''))

# Fill form inputs
form.text_field(index: 0).set(ENV.fetch('EMPLOYEE_NUMBER', ''))
form.text_field(index: 1).set(ENV.fetch('EMPLOYEE_NAME', ''))

date_and_time = Time.now.getlocal('-06:00').strftime('%Y-%m-%d-%H:%S')

# Take a screenshot before submission
browser.screenshot.save("before_submission_#{date_and_time}.png")

# Submit the form
# browser.button(type: 'submit').click

# Take a screenshot after submission
browser.screenshot.save("after_submission_#{date_and_time}.png")

browser.close
