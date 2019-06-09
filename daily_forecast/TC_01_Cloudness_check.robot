*** Settings ***
Documentation   Cloudness is above 90%
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Variables ***
# Создаем переменную, в которой будет храниться результат выполнения теста
${passed}    ${FALSE}

*** Test Cases ***
TC_01_Cloudness_check
#   В цикле проверяем все города из списка, указанного в Resource
    :FOR  ${city}  IN  @{CITIES}
#    Сохраняем в список list прогноз на следующие 5 дней
    \   @{list}=     Get Forecast  ${city}
#    Во вложенном цикле Check Cloudness  проверяем, есть ли у данного города дни, удовлетворяющие условию
    \   ${result}=  Check Cloudness  ${city}  @{list}
#    Вычисляем значение passed по таблице истинности
    \   ${passed}=  Evaluate  ${passed} | ${result}
#    Если город найден, то passed == 'True', тест считается пройденным
    Should Be True  ${passed}   "There are NO cities that meet the requirements"

*** Keywords ***
Check Cloudness
    [Arguments]    ${city}  @{list}
    FOR    ${day}    IN    @{list}
        ${date}=    Get Date  ${day}
        ${clouds}=  Get From Dictionary  ${day}  clouds
        ${cloudy}=  Evaluate  ${clouds}>90
        Run Keyword If  ${cloudy}  Log  City - ${city}. Clouds - ${clouds}, date - ${date}
    END
    [Return]   ${cloudy}