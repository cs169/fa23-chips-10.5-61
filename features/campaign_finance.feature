Feature: Search based on Campaign Finance

  As a user of the app
  So that I can easily find top 20 candidates based on campaign finance information
  I want to search campaign finance information

Background: On the page of Campaign Finance Page
  
  Given I am on the campaign finance search page

  Scenario: Search campaign finance
    Then I should see "Search for Campaign Finance"
    And I press "Search"
    Then I should see "Top 20 Candidates."
