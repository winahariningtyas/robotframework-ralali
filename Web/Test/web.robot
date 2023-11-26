*** Settings ***
Resource    ../resources/resource.robot
Library     SeleniumLibrary


*** Test Cases ***
Scenario: User want to register in Ralali
    Given user open browser to ralali
    When user click button login  
    And user complete form register  
    Then fetch otp from email
    And get otp from email