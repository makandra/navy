When /^I open the "([^"]*)" section$/ do |all_labels|
  labels = all_labels.split('>').collect(&:squish)
  if Capybara.current_session.driver.is_a? Capybara::Driver::Selenium
    if labels.size == 2
      When "I expand the \"#{labels.first}\" section"
    end
    When "I follow \"#{labels.last}\" within \".navy-level-#{labels.size}\""
  else
    opens = nil
    section = nil
    labels.each_with_index do |label, index|
      scope = ".navy-level-#{index + 1}"
      if opens
        scope << "[data-opened-by='#{opens}']"
      end
      with_scope(scope) do
        section = find_link(label)
        all_labels.should(simple_matcher('a reachable section') { |given, matcher| section.present? })
        opens = section["data-opens"]
      end
    end
    section.click
  end
end

When /^I expand the "([^"]*)" section$/ do |label|
  page.execute_script("$('.navy-level-1 .navy-section:contains(\"#{label}\") .navy-section-expander').click()")
end

Then /^there should( not)? be a "([^"]*)" tab$/ do |negate, label|
  expectation = negate ? "should not" : "should"
  Then "I #{expectation} see \"#{label}\" within \".navy-navigation\""
end

Then /^I should be in the "([^"]*)" section$/ do |label|
  Then "I should see \"#{label}\" within \".navy-navigation .navy-active\""
end

