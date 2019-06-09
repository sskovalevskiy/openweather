*** Settings ***
Documentation  Heavy Intensity Rain is predicted
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Variables ***
${passed}    ${FALSE}

*** Test Cases ***
TC_02_Heavy_intensity_rain_check
    :FOR  ${city}  IN  @{CITIES}
    \   @{list}=     Get Forecast  ${city}
    \   ${result}=   Check Heavy Intensity Rain Existence  ${city}  @{list}
    \   ${passed}=  Evaluate  ${passed} | ${result}
#    Если город найден, то passed == 'True', тест считается пройденным
    Should Be True  ${passed}   "There are NO cities that meet the requirements"

*** Keywords ***
Check Heavy Intensity Rain Existence
    [Arguments]    ${city}  @{list}

    FOR  ${day}  IN  @{list}
        ${date}=    Get Date  ${day}
        ${weather}=    Get From Dictionary  ${day}  weather
        ${description}=   Get From Dictionary  ${weather}[0]   description
        ${rain}=  Evaluate  $description == 'heavy intensity rain'
        Run Keyword If  ${rain}  log   City - ${city}. Heavy Intensity Rain - ${date}.
    END
    [Return]   ${rain}