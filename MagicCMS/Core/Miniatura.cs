﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;

namespace MagicCMS.Core
{
	/// <summary>
	/// Class Miniatura. Wrapper class for MagicCMS image miniatures management.
	/// </summary>
	/// <seealso cref="System.IDisposable" />
    public class Miniatura : IDisposable
    {
		/// <summary>
		/// Initializes a new empty instance of the <see cref="Miniatura"/> class.
		/// </summary>
        public Miniatura()
        {
            Pk = 0;
            Opath = "";
            Width = 0;
            Height = 0;
            BmpData = null;
            OdateTicks = 0;
        }

        /// <summary>
		/// Retrieve a miniature object from the database.
        /// </summary>
        /// <param name="pk">Unique id of Miniatura instance</param>
        public Miniatura(int pk)
        {
            Init(pk);
        }

        /// <summary>
		/// Search an item Miniatura in the database. If it does not exist create it.
        /// </summary>
        /// <param name="url">Image Url</param>
		/// <param name="width">Width of the thumbnail.</param>
		/// <param name="height">Height of the thumbnail. If the height is 0, it is automatically calculated and it is proportionally.</param>
        public Miniatura(string url, int width, int height)
        {
            Init(url, width, height);
        }

		/// <summary>
		/// Search a Miniatura in the database. If it does not exist create it.
		/// </summary>
		/// <param name="physicalPath">The physical path.</param>
		/// <param name="width">Width of the thumbnail.</param>
		/// <param name="height">Height of the thumbnail. If the height is 0, it is automatically calculated and it is proportionally.</param>
		/// <param name="fileDate">The file date.</param>
        public Miniatura(string physicalPath, int width, int height, DateTime fileDate)
        {
            Init(physicalPath, width, height, fileDate);
        }

        ~Miniatura()
        {
            Dispose(false);
        }

		/// <summary>
		/// It performs activities in the application, such as freedom, releases or resets unmanaged resources.
		/// </summary>
        public void Dispose()
        {
            Dispose(true);
        }

		/// <summary>
		/// Inserts this instance in Miniature database.
		/// </summary>
		/// <returns>System.Int32. Unique ID of inserted Miniatura</returns>
        public int Insert()
        {

            if (Pk == 0 && File.Exists(Opath) && Width != 0 && Height != 0 && BmpData != null && OdateTicks != 0)
            {

                SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
                string cmdstr = "	INSERT IMG_MINIATURE  " +
                                "		( " +
                                "			IMG_MIN_OPATH,  " +
                                "			IMG_MIN_BIN,  " +
                                "			IMG_MIN_HEIGHT,  " +
                                "			IMG_MIN_WIDTH,  " +
                                "			IMG_MIN_ODATE_TICKS " +
                                "		)  " +
                                "		VALUES  " +
                                "		( " +
                                "			@OPATH, " +
                                "			@BIN, " +
                                "			@HEIGHT, " +
                                "			@WIDTH, " +
                                "			@ODATE_TICKS " +
                                "		) " +
                                "	SELECT @@identity  ";

                SqlCommand cmd = new SqlCommand(cmdstr, conn);
                try
                {
                    MemoryStream ms = new MemoryStream();
                    BmpData.Save(ms, ImageFormat.Jpeg);
                    ms.Position = 0;
                    Byte[] imgBuffer = new Byte[ms.Length];
                    ms.Read(imgBuffer, 0, (int)ms.Length);
                    conn.Open();
                    cmd.Parameters.AddWithValue("@OPATH", Opath);
                    cmd.Parameters.AddWithValue("@BIN", imgBuffer);
                    cmd.Parameters.AddWithValue("@HEIGHT", Height);
                    cmd.Parameters.AddWithValue("@WIDTH", Width);
                    cmd.Parameters.AddWithValue("@ODATE_TICKS", OdateTicks);
                    Pk = Convert.ToInt32(cmd.ExecuteScalar());
                }
                finally
                {
                    //if (conn.State == ConnectionState.Open)
                    //    conn.Close();
                    conn.Dispose();
                    cmd.Dispose();
                }
            }
            return Pk;
        }

        private void Dispose(Boolean disposing)
        {
            if (!disposed)
            {

                if (disposing)
                {
                    if (this.BmpData != null)
                        this.BmpData.Dispose();
                }
            }
            disposed = true;

        }

        private void Init(int pk)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            string cmdstr =  "	SELECT " +
                             "			IM.IMG_MIN_PK, " +
                             "			IM.IMG_MIN_OPATH, " +
                             "			IM.IMG_MIN_BIN, " +
                             "			IM.IMG_MIN_HEIGHT, " +
                             "			IM.IMG_MIN_WIDTH, " +
                             "			IM.IMG_MIN_ODATE_TICKS " +
                             "	FROM IMG_MINIATURE IM  " +
                             "	WHERE IM.IMG_MIN_PK = @PK  ";

            SqlCommand cmd = new SqlCommand(cmdstr, conn);
            try
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@PK", pk);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);
                if (reader.HasRows)
                {
                    Populate(reader);
                }
                else
                {
                    Pk = 0;
                }
            }
            finally
            {
                //if (conn.State == ConnectionState.Open)
                //    conn.Close();
                conn.Dispose();
                cmd.Dispose();
            }
        }

        private void Init(string url, int width, int height)
        {
            string path = HttpContext.Current.Server.MapPath(url);
            FileInfo fi = new FileInfo(path);
            DateTime fileDate;
            if (fi.Exists)
                fileDate = fi.LastWriteTime;
            else
                fileDate = DateTime.Now;
            Init(path, width, height, fileDate);
                
        }

        private void Init(string path, int width, int height, DateTime fileDate)
        {
            SqlConnection conn = new SqlConnection(MagicUtils.MagicConnectionString);
            string cmdstr = "	SELECT " +
                            "			IM.IMG_MIN_PK, " +
                            "			IM.IMG_MIN_OPATH, " +
                            "			IM.IMG_MIN_BIN, " +
                            "			IM.IMG_MIN_HEIGHT, " +
                            "			IM.IMG_MIN_WIDTH, " +
                            "			IM.IMG_MIN_ODATE_TICKS " +
                            "	FROM IMG_MINIATURE IM " +
                            "	WHERE IM.IMG_MIN_OPATH = @OPATH  " +
                            "			AND (IM.IMG_MIN_HEIGHT = @HEIGHT OR @HEIGHT = 0) " +
                            "			AND IM.IMG_MIN_WIDTH = @WIDTH  " +
                            "			AND IM.IMG_MIN_ODATE_TICKS = @ODATE_TICKS ";

            SqlCommand cmd = new SqlCommand(cmdstr, conn);
            try
            {
                conn.Open();
                cmd.Parameters.AddWithValue("@OPATH", path);
                cmd.Parameters.AddWithValue("@HEIGHT", height);
                cmd.Parameters.AddWithValue("@WIDTH", width);
                cmd.Parameters.AddWithValue("@ODATE_TICKS", fileDate.Ticks);
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.SingleRow);

                // If height is 0 height is assumed as 'auto' based on width resizing 
                int autoHeight;
                if (reader.HasRows)
                {
                    Populate(reader);
                }
                else if (!File.Exists(path))
                {
                    return;
                }
                else
                {
					try
					{
						BmpData = CreateThumbnail(path, width, height, out autoHeight);
					}
					catch 
					{
						BmpData = null;
						autoHeight = 0;
					} 
					Pk = 0;
                    Width = width;
                    Height = autoHeight;
                    Opath = path;
                    OdateTicks = fileDate.Ticks;
                    Insert();
                }
            }
            finally
            {
                //if (conn.State == ConnectionState.Open)
                //    conn.Close();
                conn.Dispose();
                cmd.Dispose();
            }
        }

        private void Populate(SqlDataReader reader)
        {
            if (reader.Read())
            {
                Pk = Convert.ToInt16(reader.GetValue(0));
                Opath = Convert.ToString(reader.GetValue(1));
                object img = reader.GetValue(2);
                if (img != null)
                {
                    MemoryStream ms = new MemoryStream((byte[])img);
                    Bitmap b = new Bitmap(ms);
                    BmpData = b;
                }
                Height = Convert.ToInt32(reader.GetValue(3));
                Width = Convert.ToInt32(reader.GetValue(4));
                OdateTicks = Convert.ToInt64(reader.GetValue(5));
            }
        }

        private static Bitmap CreateThumbnail(string path, int lnWidth, int lnHeight, out int newHeight)
        {  
            Bitmap loBMP = new Bitmap(path);
            System.Drawing.Bitmap bmpOut = null;
            //try
            //{
            //Bitmap loBMP = new Bitmap(File.InputStream);
            ImageFormat loFormat = loBMP.RawFormat;

            decimal lnRatio = (decimal)loBMP.Width / loBMP.Height;
            decimal tnRatio;
            if (lnHeight > 0)
                tnRatio = (decimal)lnWidth / lnHeight;
            else
            {
                tnRatio = lnRatio;
                decimal lnTemp = lnWidth / lnRatio;
                lnHeight = (int)lnTemp;

            }
            int lnNewWidth = 0;
            int lnNewHeight = 0;

            //*** If the image is smaller than a thumbnail just return it
            //if (loBMP.Width < lnWidth && loBMP.Height < lnHeight)
            //    return loBMP;


            if (lnRatio <= tnRatio)
            {
                lnNewWidth = lnWidth;
                decimal lnTemp = lnNewWidth / lnRatio;
                lnNewHeight = (int)Math.Ceiling(lnTemp);
            }
            else
            {
                lnNewHeight = lnHeight;
                decimal lnTemp = lnNewHeight * lnRatio;
				lnNewWidth = (int)Math.Ceiling(lnTemp);
            }

            // System.Drawing.Image imgOut =
            //      loBMP.GetThumbnailImage(lnNewWidth,lnNewHeight,
            //                              null,IntPtr.Zero);

            // *** This code creates cleaner (though bigger) thumbnails and properly
            // *** and handles GIF files better by generating a white background for
            // *** transparent images (as opposed to black)
            bmpOut = new Bitmap(lnWidth, lnHeight);
            Graphics g = Graphics.FromImage(bmpOut);
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            g.FillRectangle(Brushes.White, 0, 0, lnWidth, lnHeight);
            int x = (lnWidth - lnNewWidth) / 2;
            int y = (lnHeight - lnNewHeight) / 2;
            g.DrawImage(loBMP, x, y, lnNewWidth, lnNewHeight);

            loBMP.Dispose();
            //}
            //catch
            //{
            //    return null;
            //}
            newHeight = lnHeight;
            return bmpOut;
        }


        private Boolean disposed = false;

        private int _pk;

		/// <summary>
		/// Gets or sets the pk. Unique ID.
		/// </summary>
		/// <value>The pk.</value>
        public int Pk
        {
            get { return _pk; }
            set { _pk = value; }
        }

        private string _opath;

		/// <summary>
		/// Gets or sets the opath. Complete Path of image.
		/// </summary>
		/// <value>The opath.</value>
        public string Opath
        {
            get { return _opath; }
            set { _opath = value; }
        }

        private Bitmap _bmpData;

		/// <summary>
		/// Gets or sets the BMP data.
		/// </summary>
		/// <value>The BMP data.</value>
        public Bitmap BmpData
        {
            get { return _bmpData; }
            set { _bmpData = value; }
        }

        private int _width;

		/// <summary>
		/// Gets or sets the width.
		/// </summary>
		/// <value>The width.</value>
        public int Width
        {
            get { return _width; }
            set { _width = value; }
        }

        private int _height;

		/// <summary>
		/// Gets or sets the height.
		/// </summary>
		/// <value>The height.</value>
        public int Height
        {
            get { return _height; }
            set { _height = value; }
        }

		/// <summary>
		/// Gets or sets the odate ticks. File date.
		/// </summary>
		/// <value>The odate ticks.</value>
        public Int64 OdateTicks { get; set; }

		/// <summary>
		/// Gets the original URL.
		/// </summary>
		/// <value>The original URL.</value>
        public string OriginalUrl
        {
            get
            {
                string url = "";
                FileInfo fi = new FileInfo(_opath);
                if (fi.Exists)
                {
                    //url = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + HttpRuntime.AppDomainAppVirtualPath + fi.Name;
                    string appPath = HttpContext.Current.Server.MapPath("~");
                    url = "/" + fi.FullName.Replace(appPath, "").Replace("\\", "/");
                    //url = new Uri(url).AbsolutePath;
                }

                return url;
            }
        }

		/// <summary>
		/// Gets the gallery from path. Create a list of Miniatura.Pk from the images of a directory.
		/// </summary>
		/// <param name="url">The URL.</param>
		/// <param name="width">The width.</param>
		/// <param name="height">The height.</param>
		/// <returns>List of miniature pk (unique IDs)</returns>
        public static List<int> GetGalleryFromPath(string url, int width, int height)
        {
            List<int> pkList = new List<int>();
            List<string> extensions = new List<string>() {".gif", ".jpeg", ".jpg", ".png"};
            //Uri gal;
            //try
            //{
            //    gal = new Uri(url);
            //}
            //catch (UriFormatException)
            //{
            //    gal = new Uri("http://" + HttpContext.Current.Request.Url.Host + url);
            //}
            //string galpath = HttpContext.Current.Server.UrlDecode(gal.AbsolutePath.Substring(0, gal.AbsolutePath.LastIndexOf("/")) + "/");
            string galpath = url.Substring(0, url.LastIndexOf("/")) + "/";
            string[] filenames = Directory.GetFiles(HttpContext.Current.Server.MapPath(galpath));
            int larg = width, alt = height;
            larg = (larg == 0) ? 100 : larg;
            alt = (alt == 0) ? 100 : alt;
            for (int i = 0; i < filenames.Length; i++)
            {
                FileInfo fi = new FileInfo(filenames[i]);
                string ext = fi.Extension.ToLower();
                if (extensions.Contains(ext)) {
                    Miniatura min = new Miniatura(galpath + fi.Name, larg, alt);
                    if (min.Pk > 0)
                        pkList.Add(min.Pk);
                    min.Dispose();
                }
            }
            return pkList;
        }

		/// <summary>
		/// Create a list of <see cref="MagicCMS.Core.MiniatuaInfo"/> from the images of a directory.
		/// </summary>
		/// <param name="url">The URL.</param>
		/// <param name="width">The width.</param>
		/// <param name="height">The height.</param>
		/// <returns>List of  <see cref="MagicCMS.Core.MiniatuaInfo"/>.</returns>
		public static List<MiniaturaInfo> GetMiniaturesInfoFromPath(string url, int width, int height)
        {
            List<MiniaturaInfo> minList = new List<MiniaturaInfo>();
            List<string> extensions = new List<string>() { ".gif", ".jpeg", ".jpg", ".png" };
            //Uri gal;
            //try
            //{
            //    gal = new Uri(url);
            //}
            //catch (UriFormatException)
            //{
            //    gal = new Uri("http://" + HttpContext.Current.Request.Url.Host + url);
            //}
            //string galpath = HttpContext.Current.Server.UrlDecode(gal.AbsolutePath.Substring(0, gal.AbsolutePath.LastIndexOf("/"))) + "/";
            if (String.IsNullOrEmpty(url))
                return minList;

            string galpath = url.Substring(0, url.LastIndexOf("/")) + "/";
            string[] filenames = Directory.GetFiles(HttpContext.Current.Server.MapPath(galpath));
            int larg = width, alt = height;
            larg = (larg == 0) ? 100 : larg;
            //alt = (alt == 0) ? 100 : alt;
            for (int i = 0; i < filenames.Length; i++)
            {
                FileInfo fi = new FileInfo(filenames[i]);
                string ext = fi.Extension.ToLower();
                if (extensions.Contains(ext))
                {
                    Miniatura min = new Miniatura(galpath + fi.Name, larg, alt);
                    if (min.Pk > 0)
                        minList.Add(new MiniaturaInfo(min.Pk, min.OriginalUrl, min.Width, min.Height));
                }
            }
            return minList;
        }
    }
}