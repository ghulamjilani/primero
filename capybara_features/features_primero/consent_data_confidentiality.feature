# JIRA PRIMERO-110
# JIRA PRIMERO-232

@javascript @primero
Feature: Consent Data Confidentiality
  As a Social Worker, I want to enter details about data confidentiality so that we can record
  the child's (individual's) wishes with respect to sharing information.

  Scenario: As a logged in user, I should access the form section consent
    Given I am logged in as an admin with username "primero" and password "primero"
    When I access "form section page"
    And I press the "Data Confidentiality" button
    Then I should see the following fields:
    | Name                                                                                                                                      |
    | Consent Obtained From                                                                                                                 |
    | Does the child/person understand why the information is collected, how it will be used, what the process will be, and agrees to register? |
    | Does Child/Caregiver agree to share collected information with other organizations?                                                       |
    | Does Child/Caregiver agree to share name on posters/radio/Internet?                                                                       |
    | If other, please specify                                                                                                                  |

  Scenario: As a logged in user, I create a case details about data confidentiality
    Given I am logged in as an admin with username "primero" and password "primero"
    When I access "cases page"
    And I press the "Create a New Case" button
    And I press the "Data Confidentiality" button
    When I select "Child" from "Consent Obtained From"
    And I select "Yes" for "Does the child/person understand why the information is collected, how it will be used, what the process will be, and agrees to register?" radio button
    And I press "Save"
    Then I should see "Case record successfully created" on the page
    When I press the "Data Confidentiality" button
    Then I should see a value for "Consent Obtained From" on the show page with the value of "Child"
    And I should see a value for "Does the child/person understand why the information is collected, how it will be used, what the process will be, and agrees to register?" on the show page with the value of "Yes"