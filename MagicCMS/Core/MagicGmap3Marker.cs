using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
    public class MagicGmap3MarkerOptions
    {
        public string icon { get; set; }
        public MagicGmap3MarkerOptions ( string iconUrl)
        {
            if (!String.IsNullOrEmpty(iconUrl))
                icon = iconUrl;
        }
    }

    public class MagicGmap3Marker
    {
        private MagicPost _mp;

        public List<Double> latLng
        {
            get
            {
                List<Double> coord = new List<double>();
                double lat, lng;
                string address = _mp.ExtraInfo.Replace("(", "").Replace(")", "").Replace(" ","");
                string[] coordArray = address.Split(new char[] {','}, StringSplitOptions.RemoveEmptyEntries);
                if (coordArray.Length == 2)
                {
                    if (Double.TryParse(coordArray[0], NumberStyles.AllowDecimalPoint, new CultureInfo("en-US"), out lat) &&
                        Double.TryParse(coordArray[1], NumberStyles.AllowDecimalPoint, new CultureInfo("en-US"), out lng))
                    {
                        coord.Add(lat);
                        coord.Add(lng);
                    }
                }
                return coord;
            }
        }

        public string addres
        {
            get
            {
                return _mp.ExtraInfo;
            }
        }

        public string data
        {
            get
            {
                return _mp.TestoBreve_RT;
            }
        }

        public MagicGmap3MarkerOptions options
        {
            get
            {
                return new MagicGmap3MarkerOptions(_mp.Url2);
            }
        }

        public MagicGmap3Marker(MagicPost post)
        {
            _mp = post;
        }
    }
}