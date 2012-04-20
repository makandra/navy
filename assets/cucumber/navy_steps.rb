When /^I open the "([^"]*)" (?:section|tab)$/ do |all_labels|
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
      scope = "div[data-navy-navigation-level='#{index + 1}']"
      if opens
        scope << "[data-navy-opened-by='#{opens}']"
      end
      scope << ' a'
      page.should have_css(scope, :text => label)
      section = find(scope, :text => label)
      opens = section["data-navy-opens"]
    end
    section.click
  end
end

When /^I expand the "([^"]*)" (?:section|tab)$/ do |label|
  page.execute_script("$('.navy-level-1 .navy-section:contains(\"#{label}\") .navy-section-expander').click()")
end

Then /^there should( not)? be a "([^"]*)" (?:section|tab)$/ do |negate, label|
  expectation = negate ? "should_not" : "should"
  page.send(expectation, have_css(".navy-navigation", :text => label))
end

Then /^I should be in the "([^"]*)" (?:section|tab)$/ do |label|
  page.should have_css(".navy-navigation .navy-active", :text => label)
end
