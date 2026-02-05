*** Keywords ***
Add to Cart (Fail)
    Add Implicit Wait
    Get the page title
    Add first product to cart

    ${product_name}=    Get Text    xpath=//*[@id="1"]/p
    ${product_incart}=  Get Text    css=p.title

    # ❌ Intentionally fail by checking a wrong product name
    Should Be Equal    ${product_incart}    Incorrect Product Name
