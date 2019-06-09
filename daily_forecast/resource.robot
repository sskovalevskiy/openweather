*** Variables ***
${BASE_URL}  http://api.openweathermap.org
${APP_ID}    ea574594b9d36ab688642d5fbeab847e
@{CITIES}    London  Moscow  Baku  Yerevan  Brussels  Budapest  Odessa  Osaka  Ottawa  Oslo  Potsdam  Sydney  Kugaaruk
...          Plymouth

*** Keywords ***
#   Keyword преобразует дату полученную в формате Unix epoch timestamp в стандартную гггг-мм-дд
Get Date
    [Arguments]  ${day}
    ${timestamp}=    Get From Dictionary  ${day}  dt
    ${date}=    Convert Date  ${timestamp}  result_format=%Y-%m-%d
    [Return]    ${date}

#   Keyword делает запрос к API для получения прогноза погоды на следующие 5 дней
Get Forecast
    [Arguments]  ${city}
#    Создаем переменную list в которую будет сохранен результат запроса к API
    @{list}=   Create List
#   Делаем максимум три запроса, после чего считаем тест не пройденным
    FOR    ${index}    IN RANGE    1    3
#       Запрос для API 16 Day/daily Forecast
        ${response}=  Send Request  ${city}
#       Возвращаемый JSON содержит список дней List с прогнозом погоды. Кладем его в переменную-список и возвращаем
        Exit For Loop If  ${response.status_code}==200
    END
    Should Not Be Empty  ${response.content}
    @{list}=      Get From Dictionary  ${response.json()}  list
    [Return]  @{list}

#   Keyword делает запрос к API для получения JSON с таймаутом 5 секунд
Send Request
    [Arguments]  ${city}
    [Timeout]  5 seconds
#    Запрос для API 16 Day/daily Forecast
    ${response}=  Get Request  Get_Weather  /data/2.5/forecast/daily?q=${city}&appid=${APP_ID}&cnt=5
    [Return]  ${response}

