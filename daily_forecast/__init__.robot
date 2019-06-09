*** Settings ***
Documentation   16 Day/Daily Forecast API Testcases
Resource        resource.robot

Library  Collections
Library  RequestsLibrary
Library  DateTime

Test Timeout    2 minutes

Suite Setup      Create Session  Get_Weather  ${BASE_URL}
Suite Teardown   Delete All Sessions


