<%@ WebHandler Language="C#" Class="FileHandler" %>

using System.IO;
using System.Web;
using System.Web.SessionState;
using OhBoi.Helpers;

public class FileHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        try
        {
            if (context.Request.RequestType == "GET")
            {
                string rosterId = context.Request.QueryString["code"];
                string rawParam = context.Request.QueryString["type"];
                bool xmlVersion = context.Request.QueryString["type"] == "xml";
                rawParam = context.Request.QueryString["formatted"];
                bool formatted = string.IsNullOrEmpty(rawParam) ? false : rawParam.ToLower() == "true";

                if (!formatted)
                {
                    context.Response.ContentType = "text/plain";
                }
                else
                {
                    if (xmlVersion)
                    {
                        context.Response.ContentType = "application/xml";
                    }
                    else
                    {
                        context.Response.ContentType = "application/json";
                    }
                }

                if (string.IsNullOrEmpty(rosterId))
                {
                    context.Response.StatusCode = 500;
                    context.Response.Write("Please provide a Roster ID");
                    return;
                }

                string decodedRoster = RoszManager.GetRoster(rosterId.ToUpper(), xmlVersion);
                if (string.IsNullOrEmpty(decodedRoster))
                {
                    context.Response.StatusCode = 500;
                    context.Response.Write("The provided Roster ID is either invalid or expired.");
                    return;
                }
                context.Response.Write(decodedRoster);
                return;
            }
            else if (context.Request.RequestType == "POST")
            {
                context.Response.ContentType = "text/plain";

                if (context.Request.Files.Count == 0)
                {
                    context.Response.StatusCode = 501;
                    context.Response.Write("Please upload at least a file.");
                    return;
                }
                else if (context.Request.Files.Count > 1)
                {
                    context.Response.StatusCode = 501;
                    context.Response.Write("Only one file per time can be uploaded.");
                    return;
                }

                HttpFileCollection files = context.Request.Files;
                HttpPostedFile file = files[0];
                string fileName = file.FileName;
                string fileExt = Path.GetExtension(fileName).ToLower();
                if (!fileExt.Equals(".ros", System.StringComparison.OrdinalIgnoreCase)
                    && !fileExt.Equals(".rosz", System.StringComparison.OrdinalIgnoreCase))
                {
                    context.Response.StatusCode = 501;
                    context.Response.Write("Only .rosz and .ros files are allowed.");
                    return;
                }

                string rosterCode = RoszManager.CreateRoster(file, fileExt.Equals(".rosz", System.StringComparison.OrdinalIgnoreCase));
                context.Response.Write(rosterCode);
                return;
            }
            else
            {
                context.Response.StatusCode = 501;
                context.Response.Write("Invalid request");
                return;
            }
        }
        catch (System.Exception ex)
        {
            context.Response.StatusCode = 500;
            context.Response.Write("Unknown Error: " + ex.Message);
            return;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

