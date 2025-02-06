require 'watir'

browser = Watir::Browser.new :chrome

browser.goto ENV.fetch('FORM_URL', '')

form = browser.form(id: ENV.fetch('FORM_ID', ''))

form.text_field(index: 0).set(ENV.fetch('EMPLOYEE_NUMBER', ''))
form.text_field(index: 1).set(ENV.fetch('EMPLOYEE_NAME', ''))

# Take a screenshot before submission
browser.screenshot.save('before_submission.png')

# Submit the form
# browser.button(type: 'submit').click

# Take a screenshot after submission
# browser.screenshot.save('after_submission.png')

browser.close
