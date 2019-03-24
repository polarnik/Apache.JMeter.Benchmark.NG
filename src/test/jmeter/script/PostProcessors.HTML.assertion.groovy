def expectedValue = Parameters

def variableNames = [ 'logo_CSS', 'logo_RegExp', 'logo_Boundary', 'logo_jsr223', 'logo_XPath', 'logo_bsh' ]

for (String variableName: variableNames) {

    def checkValue = vars.get(variableName)
    log.info(variableName + " = " + checkValue)
    if(checkValue != expectedValue) {
        log.error(variableName + " = " + checkValue + " != " + expectedValue)
    }
}
