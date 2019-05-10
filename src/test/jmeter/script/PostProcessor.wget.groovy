// prev - http://jmeter.apache.org/api/org/apache/jmeter/samplers/SampleResult.html
//

import java.util.regex.Matcher;
import java.util.regex.Pattern;

log.warn("Hello")

//Length: 1718181 (1.6M) [text/html]
Pattern pLength = Pattern.compile("(?im)^Длина[:] ([0-9]+) ");
Matcher mLength = pLength.matcher(prev.getResponseDataAsString());
if(mLength.find())
{
    int Length = Integer.parseInt(mLength.group(1));
    prev.setBodySize(Length);
}

//Content-Type
Pattern pContentType = Pattern.compile("(?im)^[ ]{2}Content[-]Type[:] (.*)");
Matcher mContentType = pContentType.matcher(prev.getResponseDataAsString());
if(mContentType.find())
{
    String ContentType = mContentType.group(1);
    prev.setContentType(ContentType);
}

Pattern pHeaders = Pattern.compile("(?im)^[ ]{2}([a-zA-Z].*[:].*)");
Matcher mHeaders = pHeaders.matcher(prev.getResponseDataAsString());
String headers = "";
while(mHeaders.find())
{
    headers = headers + mHeaders.group(1) + "\n";
}
prev.setResponseHeaders(headers);

//  HTTP/1.1 200 OK
Pattern pCodeMessage = Pattern.compile("(?im)^[ ]{2}HTTP[/]1[.][0-9] ([0-9]+) (.*)");
Matcher mCodeMessage = pCodeMessage.matcher(prev.getResponseDataAsString());
if(mCodeMessage.find())
{
    String Code = mCodeMessage.group(1);
    String Message = mCodeMessage.group(2);

    if(Code=="200")
    {
        prev.setSuccessful(true);
    }
    else
    {
        prev.setSuccessful(false);
    }

    prev.setResponseCode(Code);
    prev.setResponseMessage(Message);

}
