*** Settings ***
Library    SeleniumLibrary
Resource    ./KeywordsFile.robot

*** Keywords ***
Add to Cart
    Add Implicit Wait
    Get the page title
    Add first product to cart
    Verify product is added to cart
