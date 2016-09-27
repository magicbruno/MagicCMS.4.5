using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagicCMS.Marketing
{
    public enum RegisteredUserStatus
    {
        Activated, Expired, NotYetActivated, AlreadyActivated, WrongKey, SaveError, NotExists
    }
}