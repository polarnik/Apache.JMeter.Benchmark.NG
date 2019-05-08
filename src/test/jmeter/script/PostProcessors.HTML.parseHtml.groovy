def varName = "htmlContent"
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
        logo_jsr223 = logo.substring(0, indexEnd)
    }
}

vars.put('logo_jsr223', logo_jsr223)

//def i = vars.getObject("i")
//if (i == null) {
//    i = 0;
//}
//i = i + 1;
//
//if (i % 10000 == 0) {
//    log.error("i is exist: " + i.toString())
//}
//vars.putObject("i", i);