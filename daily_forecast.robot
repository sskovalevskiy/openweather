*** Settings ***
Documentation   16 Day/daily Forecast Testcases
Library  Collections
Library  RequestsLibrary
Library  DateTime

*** Variables ***
${BASE_URL}  http://api.openweathermap.org
${APP_ID}    5b323e4eb997b071cadf67df05d2f4e7
@{CITIES}    London  Moscow  Baku  Yerevan  Brussels  Budapest  Odessa  Osaka  Ottawa  Oslo  Potsdam  Sydney  Kugaaruk  Plymouth

*** Keywords ***
Check List
    [Arguments]    ${city}  @{list}
    FOR    ${day}    IN    @{list}
        ${date}=    Get From Dictionary  ${day}  dt
        ${date}=    Convert Date  ${date}  result_format=%Y-%m-%d
        ${clouds}=  Get From Dictionary  ${day}  clouds
        ${status}=  Evaluate  ${clouds}>90
#    Запрос для API 5 day / 3 hour forecast data (т.к. 16 day forecasts is only available for all paid accounts.)
#        ${cloudiness}=     Get From Dictionary  ${clouds}  all
#        ${status}=  Evaluate  ${cloudiness}>90
        Run Keyword If  ${status}  log to console  City - ${city}. Clouds - ${clouds}, date - ${date}
    END
#    Возвращаем статус: найден ли город удовлетворяющий условию
    [Return]  ${status}


*** Test Cases ***
TC_01_Clouds
    Create Session  Get_Weather  ${BASE_URL}
    :FOR  ${city}  IN  @{CITIES}
#    Запрос для API 5 day / 3 hour forecast data (т.к. 16 day forecasts is only available for all paid accounts.)
#    \   ${response}=  Get Request  Get_Weather  /data/2.5/forecast?q=${city}&appid=${APP_ID}

#    Запрос для API 16 Day/daily Forecast (16 day forecasts is only available for all paid accounts.)
    \   ${response}=  Get Request  Get_Weather  /data/2.5/forecast/daily?q=${city}&appid=${APP_ID}&cnt=5
#    Возвращаемый JSON содержит список дней List с прогнозом погоды. Кладем его в переменную-список
    \   @{list}=      Get From Dictionary  ${response.json()}  list
#    Во вложенном цикле Check List  проверяем, есть ли у данного города дни, удовлетворяющие условию
    \   ${status}=    Run Keyword And Return Status  Check List  ${city}  @{list}
#    Если город найден, то status == 'True', тест считается пройденным
    Run Keyword If  ${status}  Pass
    Fail  "There are NO cities that meet the requirements"