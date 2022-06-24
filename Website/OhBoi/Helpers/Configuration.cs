using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Web;

namespace OhBoi.Helpers
{
    public class Configuration
    {
        public const string CS_AppSettings = "appSettings";
        public const string CS_GameSystems = "GameSystems";

        public static string GetCustomConfigKey(string ConfigSection, string Key, string Default = "default")
        {
            NameValueCollection SecSettings = (NameValueCollection)ConfigurationManager.GetSection(ConfigSection);
            if (SecSettings.AllKeys.Contains(Key))
                return SecSettings[Key];
            return SecSettings[Default];
        }
    }
}