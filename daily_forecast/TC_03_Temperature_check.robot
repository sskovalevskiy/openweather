*** Settings ***
Documentation   Temperature Difference is above 10C
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Variables ***
# Создаем переменную, в которой будет храниться результат выполнения теста
${passed}    ${FALSE}

*** Test Cases ***
TC_03_Day_night_temperature_difference_check
#   В цикле проверяем все города из списка, указанного в Resource
    :FOR  ${city}  IN  @{CITIES}
#    Сохраняем в список list прогноз на следующие 5 дней
    \   @{list}=     Get Forecast  ${city}
#    Во вложенном цикле проверяем условие, и возвращаем результат проверки в result
    \   ${result}=   Check Temperature Difference  ${city}  @{list}
#    Вычисляем значение passed по таблице истинности
    \   ${passed}=  Evaluate  ${passed} | ${result}
#    Если город найден, то passed == 'True', тест считается пройденным
    Should Be True  ${passed}   "There are NO cities that meet the requirements"

*** Keywords ***
Check Temperature Difference
    [Arguments]    ${city}  @{list}
    FOR  ${day}  IN  @{list}
        ${date}=    Get Date  ${day}
        ${temp}=    Get From Dictionary  ${day}  temp
        ${morn_temp}=    Get From Dictionary  ${temp}  morn
        ${day_temp}=    Get From Dictionary  ${temp}  day
        ${day_morn_temp_diff}=  Evaluate  ${day_temp} - ${morn_temp}
        ${condition}=  Evaluate  ${day_morn_temp_diff}>10
        Run Keyword If  ${condition}  Log   City - ${city}. Temperature difference - ${day_morn_temp_diff}, date - ${date}
    END
    [Return]   ${condition}
