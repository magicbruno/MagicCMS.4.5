using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace MagicCMS.Utils
{
    public static class HttpInternals
    {
        private static FieldInfo s_TheRuntime = typeof(HttpRuntime).GetField("_theRuntime", (BindingFlags.NonPublic | BindingFlags.Static));

        private static FieldInfo s_FileChangesMonitor = typeof(HttpRuntime).GetField("_fcm", (BindingFlags.NonPublic | BindingFlags.Instance));

        private static MethodInfo s_FileChangesMonitorStop = s_FileChangesMonitor.FieldType.GetMethod("Stop", (BindingFlags.NonPublic | BindingFlags.Instance));

        private static object HttpRuntime
        {
            get
            {
                return s_TheRuntime.GetValue(null);
            }
        }

        private static object FileChangesMonitor
        {
            get
            {
                return s_FileChangesMonitor.GetValue(HttpRuntime);
            }
        }

        public static void StopFileMonitoring()
        {
            s_FileChangesMonitorStop.Invoke(FileChangesMonitor, null);
        }
    }
}