using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web;
using System.Xml;

namespace OhBoi.Helpers
{
    public class RoszManager
    {
        public static string CreateRoster(HttpPostedFile file, bool isCompressed)
        {
            XmlDocument rosFile = new XmlDocument();

            using (MemoryStream rosStream = new MemoryStream())
            {
                if (isCompressed)
                {
                    using (ZipArchive za = new ZipArchive(file.InputStream))
                    {
                        ZipArchiveEntry entry = za.Entries.FirstOrDefault(x => x.Name.EndsWith(".ros", StringComparison.OrdinalIgnoreCase));
                        entry.Open().CopyTo(rosStream);
                    }
                }
                else
                    file.InputStream.CopyTo(rosStream);

                if (rosStream.Length > 0)
                    rosStream.Seek(0, SeekOrigin.Begin);    
                rosFile.Load(rosStream);
            }

            XmlNode gameSystem = rosFile.DocumentElement;
            string gameSystemId = gameSystem.Attributes["gameSystemId"].Value;
            string rosterCodePrefix = Configuration.GetCustomConfigKey(Configuration.CS_AppSettings, "GS-" + gameSystemId.ToLower(), "GS-default");
            string rosterCodeUId = Guid.NewGuid().ToString("n").Substring(0, 8).ToUpper();
            string rosterCode = $"{rosterCodePrefix}{rosterCodeUId}";
            while (ServiceCache.Current[rosterCode] != null)
            {
                rosterCodeUId = Guid.NewGuid().ToString("n").Substring(0, 8).ToUpper();
                rosterCode = $"{rosterCodePrefix}{rosterCodeUId}";
            }

            string jsonText = JsonConvert.SerializeXmlNode(rosFile);
            int MemoryDuration = int.Parse(Configuration.GetCustomConfigKey(Configuration.CS_AppSettings, "MemoryDuration"));
            DateTime expiry = DateTime.Now.AddMinutes(MemoryDuration);
            ServiceCache.Current.Insert(rosterCode, jsonText, expiry);
            ServiceCache.Current.Insert($"XML.{rosterCode}", rosFile.OuterXml, expiry);
            return rosterCode;
        }

        public static string GetRoster(string rosterCode, bool xml)
        {
            return (string)ServiceCache.Current[(xml ? "XML." : "") + rosterCode];
        }
    }
}