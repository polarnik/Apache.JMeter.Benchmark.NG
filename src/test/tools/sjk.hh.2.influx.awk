#!/bin/awk -v app=Apache.JMeter -v param=test.jmx -f sjk.hh.2.influx.awk

function escapeField(stringValue) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", stringValue)
       	gsub(/,/, "\\,", stringValue)
        gsub(/=/, "\\=", stringValue)
        gsub(/[[:space:]]+/, "\\ ", stringValue)
	return stringValue
}

function print2influx() {
	influxMessage = "sjk.hh"
	if (appEsc != "") {
		influxMessage = influxMessage ",app=" appEsc
	}

	if (paramEsc != "") {
		influxMessage = influxMessage ",param=" paramEsc
	}

	if (level != "") {
		influxMessage = influxMessage ",level=" level
	}

	if (Type != "") {
		TypeEsc = escapeField( Type )
		influxMessage = influxMessage ",Type=" TypeEsc
	}

	if (typeNameG1 != "") {
		G1 = escapeField( typeNameG1 )
		influxMessage = influxMessage ",Group1=" G1
	}

	if (typeNameG2 != "") {
		G2 = escapeField( typeNameG2 )
		influxMessage = influxMessage ",Group2=" G2
	}

	if (typeNameG3 != "") {
		G3 = escapeField( typeNameG3 )
		influxMessage = influxMessage ",Group3=" G3
	}


	print influxMessage " Instances=" $2 ",Bytes=" $3
}

function parseTypeName(typeName) {
    firstChar = substr(typeName, 1, 1)

    if (firstChar == "[" ) {
        return parseTypeName(substr(typeName, 2)) "[]"
    } else if (firstChar == "L"){
        if (substr(typeName, length(typeName)) == ";") {
            return "(class)" parseTypeName(substr(typeName, 2, length(typeName) - 2 ))
        } else
            return typeName
    } else if (typeName == "Z") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "boolean"
    } else if (typeName == "B") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "byte"
    } else if (typeName == "C") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "char"
    } else if (typeName == "D") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "double"
    } else if (typeName == "F") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "float"
    } else if (typeName == "I") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "int"
    } else if (typeName == "J") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "long"
    } else if (typeName == "S") {
        typeNameG1 = "java"
        typeNameG2 = "java"
        typeNameG3 = "java"
        return "short"
    } else {
        split(typeName, typeNameGroup, "\\.")
        if(typeNameGroup[1] != "")
            typeNameG1 = typeNameGroup[1]
        if(typeNameGroup[2] != "") {
            typeNameG2 = typeNameGroup[1] "." typeNameGroup[2]
        } else {
            typeNameG2 = typeNameG1
        }
        if(typeNameGroup[3] != "")
            typeNameG3 = typeNameGroup[1] "." typeNameGroup[2] "." typeNameGroup[3]
        else {
            typeNameG3 = typeNameG2
        }
        return typeName
    }
}

BEGIN {
	if (app != "") {
		appEsc = escapeField( app )
	}

	if (param != "") {
		paramEsc = escapeField( param )
	}

}

{
    Type = parseTypeName($4)

    print2influx()
}