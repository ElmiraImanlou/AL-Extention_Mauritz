dotnet
{
    assembly("System.Xml")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.Xml.XmlDocument"; "XmlDocument") { }
        type("System.Xml.XmlElement"; "XmlElement") { }
        type("System.Xml.XmlNode"; "XmlNode") { }
        type("System.Xml.XmlNamespaceManager"; "XmlNamespaceManager") { }
        type("System.Xml.XmlNodeList"; "XmlNodeList") { }
        type("System.Xml.XmlNodeChangedEventArgs"; "XmlNodeChangedEventArgs") { }
        type("System.Xml.Xsl.XslCompiledTransform"; "XslCompiledTransform") { }
        type("System.Xml.XmlReader"; "XmlReader") { }
        type("System.Xml.XmlWriter"; "XmlWriter") { }
    }
    assembly("System.Drawing")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';
        Version = '4.0.0.0';

        type("System.Drawing.Image"; "Image") { }
        type("System.Drawing.Imaging.ImageFormat"; "ImageFormat") { }
    }
    assembly("mscorlib")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.IO.MemoryStream"; "MemoryStream") { }
        type("System.Array"; "Array") { }
        type("System.Convert"; "Convert") { }
        type("System.IO.FileStream"; "FileStream") { }
        type("System.IO.FileMode"; "FileMode") { }
        type("System.IO.FileAccess"; "FileAccess") { }
        type("System.IO.StreamWriter"; "StreamWriter") { }
        type("System.Text.Encoding"; "Encoding") { }
        type("System.IO.File"; "File") { }
        type("System.Text.UTF8Encoding"; "UTF8Encoding") { }
        type("System.IO.Stream"; "Stream") { }
        type("System.IO.StreamReader"; "StreamReader") { }
        type("System.Collections.Generic.Dictionary`2"; "Dictionary_Of_T_U") { }
        type("System.Collections.Generic.List`1"; "List_Of_T") { }
    }
    assembly("System")
    {

        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type("System.Text.RegularExpressions.Regex"; "Regex") { }
        type("System.Text.RegularExpressions.MatchCollection"; "MatchCollection") { }
        type("System.Net.HttpWebRequest"; "HttpWebRequest") { }
        type("System.Net.HttpWebResponse"; "HttpWebResponse") { }
        type("System.Net.HttpStatusCode"; "HttpStatusCode") { }
        type("System.Collections.Specialized.NameValueCollection"; "NameValueCollection") { }
        type("System.Net.ServicePointManager"; "ServicePointManager") { }
        type("System.Net.SecurityProtocolType"; "SecurityProtocolType") { }
        type("System.Diagnostics.ProcessStartInfo"; "ProcessStartInfo") { }
        type("System.Diagnostics.ProcessWindowStyle"; "ProcessWindowStyle") { }
        type("System.Diagnostics.Process"; "Process") { }
        type("System.Text.RegularExpressions.Match"; "Match") { }
    }
    assembly("Spire.Pdf")
    {

        Culture = 'neutral';
        PublicKeyToken = '663f351905198cb3';
        Version = '5.10.5.20040';

        type("Spire.Pdf.PdfDocument"; "PdfDocument") { }
    }
    assembly("ERiCConnector")
    {

        Culture = 'neutral';
        PublicKeyToken = '395f73e9b1aacb9c';
        Version = '1.1.0.1';

        type("HalvotecERiC.ERiCConnector"; "ERiCConnector") { }
    }
}
