using System;
using System.Web;

namespace MagicCMS.Blogger
{
    /// <summary>
    /// Wrapper class for https://www.blogger.com rss
    /// </summary>
    public class BloggerRss : System.Collections.CollectionBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="BloggerRss"/> class.
        /// </summary>
        /// <param name="rssURL">The RSS URL.</param>
        public BloggerRss(string rssURL)
        {
            Init(rssURL);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BloggerRss"/> class.
        /// </summary>
        /// <param name="rssURL">The RSS URL.</param>
        /// <param name="maxNumPost">The maximum number post.</param>
        public BloggerRss(string rssURL, int maxNumPost)
        {
            Init(rssURL, maxNumPost);
        }

        /// <summary>
        /// Ottiene o imposta l'elemento in corrispondenza dell'indice specificato.
        /// </summary>
        /// <param name="index">The index.</param>
        /// <returns></returns>
        public BloggerPost this[int index]
        {
            get { return (BloggerPost)List[index]; }
            set { List[index] = value; }
        }

        /// <summary>
        /// Adds the specified item.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns>Resulting collection.</returns>
        public int Add(BloggerPost item)
        {
            return List.Add(item);
        }

        /// <summary>
        /// Determines whether [contains] [the specified item].
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns>True if item is contained</returns>
        public bool Contains(BloggerPost item)
        {
            return List.Contains(item);
        }

        /// <summary>
        /// Copies to array starting from index.
        /// </summary>
        /// <param name="array">The array.</param>
        /// <param name="index">The index.</param>
        public void CopyTo(BloggerPost[] array, int index)
        {
            List.CopyTo(array, index);
        }

        /// <summary>
        /// Search an item in collection.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <returns>Index number if found, otherwise -1.</returns>
        public int IndexOf(BloggerPost item)
        {
            return List.IndexOf(item);
        }

        /// <summary>
        /// Inserts at the specified index.
        /// </summary>
        /// <param name="index">The index.</param>
        /// <param name="item">The item.</param>
        public void Insert(int index, BloggerPost item)
        {
            List.Insert(index, item);
        }

        /// <summary>
        /// Removes the specified item.
        /// </summary>
        /// <param name="item">The item.</param>
        public void Remove(BloggerPost item)
        {
            List.Remove(item);
        }

        private void Init(string rssURL)
        {
            Init(rssURL, 0);
        }

        private void Init(string rssURL, int maxNumPost)
        {
            try
            {
                System.Net.WebRequest myRequest = System.Net.WebRequest.Create(rssURL);
                System.Net.WebResponse myResponse = myRequest.GetResponse();

                System.IO.Stream rssStream = myResponse.GetResponseStream();
                System.Xml.XmlDocument rssDoc = new System.Xml.XmlDocument();
                rssDoc.Load(rssStream);

                System.Xml.XmlNamespaceManager nspm = new System.Xml.XmlNamespaceManager(rssDoc.NameTable);
                nspm.AddNamespace("atom", "http://www.w3.org/2005/Atom");
                nspm.AddNamespace("media", "http://search.yahoo.com/mrss/");

                System.Xml.XmlNodeList rssItems = rssDoc.SelectNodes("rss/channel/item");

                int maxNum;
                if (maxNumPost == 0)
                {
                    maxNum = rssItems.Count;
                }
                else
                {
                    maxNum = Math.Min(maxNumPost, rssItems.Count);
                }

                for (int i = 0; i < maxNum; i++)
                {
                    System.Xml.XmlNode rssDetail;
                    BloggerPost bp = new BloggerPost();

                    rssDetail = rssItems.Item(i).SelectSingleNode("guid");
                    if (rssDetail != null)
                    {
                        bp.Guid = rssDetail.InnerText;
                    }
                    else
                    {
                        bp.Title = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("title");
                    if (rssDetail != null)
                    {
                        bp.Title = rssDetail.InnerText;
                    }
                    else
                    {
                        bp.Title = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("link");
                    if (rssDetail != null)
                    {
                        bp.Link = rssDetail.InnerText;
                    }
                    else
                    {
                        bp.Link = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("description");
                    if (rssDetail != null)
                    {
                        bp.Description = HttpContext.Current.Server.HtmlDecode(rssDetail.InnerText);
                    }
                    else
                    {
                        bp.Description = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("pubDate");
                    if (rssDetail != null)
                    {
                        bp.PubDate = HttpContext.Current.Server.HtmlDecode(rssDetail.InnerText);
                    }
                    else
                    {
                        bp.PubDate = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("author");
                    if (rssDetail != null)
                    {
                        bp.Author = HttpContext.Current.Server.HtmlDecode(rssDetail.InnerText);
                    }
                    else
                    {
                        bp.PubDate = "";
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("media:thumbnail", nspm);
                    if (rssDetail != null)
                    {
                        if (rssDetail.Attributes["url"] != null)
                        {
                            bp.Thumbnail = rssDetail.Attributes["url"].Value;
                        }
                        else
                        {
                            bp.Thumbnail = "";
                        }
                    }
                    else
                    {
                        bp.Thumbnail = null;
                    }

                    rssDetail = rssItems.Item(i).SelectSingleNode("atom:updated", nspm);
                    if (rssDetail != null)
                    {
                        bp.Updated = DateTime.Parse(rssDetail.InnerText);
                    }

                    this.Add(bp);
                }
            }
            catch (Exception)
            {
            }
        }
    }
}