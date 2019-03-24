def varName = Parameters
def htmlContent = vars.get(varName)

def logo_jsr223 = '_NOT_FOUND_'

def logo = ""
def boundaryStart = '<img class="logo" src="./images/logo.svg" alt="'
def indexStart = htmlContent.indexOf(boundaryStart) + boundaryStart.length()
if (indexStart != -1) {
    logo = htmlContent.substring(indexStart)
    def boundaryEnd = '"></a>'
    def indexEnd = logo.indexOf(boundaryEnd)
    if(indexEnd != -1) {
        logo = logo.substring(0, indexEnd)
        logo_jsr223 = logo
    }
}

vars.put('logo_jsr223', logo_jsr223)