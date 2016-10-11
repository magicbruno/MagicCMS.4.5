using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class MagicGmap3MarkerOptions.
	/// </summary>
    public class MagicGmap3MarkerOptions
    {
		/// <summary>
		/// Gets or sets the icon.
		/// </summary>
		/// <value>The icon.</value>
        public string icon { get; set; }
		/// <summary>
		/// Initializes a new instance of the <see cref="MagicGmap3MarkerOptions"/> class.
		/// </summary>
		/// <param name="iconUrl">The icon URL.</param>
        public MagicGmap3MarkerOptions ( string iconUrl)
        {
            if (!String.IsNullOrEmpty(iconUrl))
                icon = iconUrl;
        }
    }

	/// <summary>
	/// Class MagicGmap3Marker. Used tu simplify handling of <see cref="MagicCMS.MagicPost"/> with <see cref="MagicCMS.MagicPost.Tipo"/> = <see cref="MagicCMS.MagicPostTypeInfo.Geolocazione"/>
	/// </summary>
    public class MagicGmap3Marker
    {
        private MagicPost _mp;

		/// <summary>
		/// Gets the lat LNG.
		/// </summary>
		/// <value>The lat LNG.</value>
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

		/// <summary>
		/// Gets the address.
		/// </summary>
		/// <value>The address.</value>
        public string address
        {
            get
            {
                return _mp.ExtraInfo;
            }
        }

		/// <summary>
		/// Gets the data.
		/// </summary>
		/// <value>The data.</value>
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

		/// <summary>
		/// Initializes a new instance of the <see cref="MagicGmap3Marker"/> class.
		/// </summary>
		/// <param name="post">The post.</param>
        public MagicGmap3Marker(MagicPost post)
        {
            _mp = post;
        }
    }
}