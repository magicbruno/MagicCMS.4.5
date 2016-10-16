
## What is MagicCMS
We started to develop the project MagicCMS in the late 90 's. Today MagicCMS is a framework written in C# to create sites managed by Content Management System in a Windows environment. The source is shared under the MIT license. Library and documentation is available on http://docs.magiccms.org/. A site dedicated to the frame work is under development.

The framework includes:
* A database (Microsoft SQL Server) which stores the contents of the site
* A class library that provide a complete interface to objects stored in the database and the methods necessary to render them in html pages.
* A full back end interface that allows multiple levels of use (depending on the user's prerogative).

The logic with which MagicCMS is built is simple. 

All the elements that make up the interface and the contents of a website (menu, whole pages, sections of pages, image or video galleries, animated slide show, etc., etc., etc.) are encoded in a record structure and are stored in a database table. Another table allows you to establish parental relationships between the various objects. Different sections of a Home page will be child objects of the homepage, a slide in a slide show will be child of the slide show, the arguments children of the blog blog and articles children of arguments and so on. The site is so organized as a tree.

These elements have many common properties, but will be rendered in a web page in different ways. A slide and an article have both an HTML text content and both are children of their parent, but will appear very differently on a web page.

In objects encoding is provided a property, (**Tipo**) that distinguishes them and makes sure that they are used properly for their function.

Some types are predefined, regulated by the MagicCMS engine. For example, if I assign to a page as parent an object of **Tipo** menu, the page will be rendered as a menu item that links to the page itself, if I assign to a menu as parent an object of **Tipo** menu, the menu will be rendered as a sub (dropdown) menu of container menu. 

Most types, however, can be freely managed by the web developer. Each type definition is encoded is a record stored in a database table and can be freely modified. Editing definition you can:

* Define whether the object is a container (can be parent of other MagicPost objects).
* Specify which fields are displayed in the backend.
* Specify which labels are displayed for each field in the backend.
* Define whether the object can have an expiration.
* If the object can be rendered as an HTML page, specify which model (an ASP.NET MasterPage) will be used to render ...
* Write an help text (in HTML format) that the editor can consult during editing.

MagicCMS is a flexible structure.
## How MagicCMS works
The goal of MagicCMS is the same of any other CMS: allow you to build websites in which the customer can intervene without writing a line of code, and without knowing any specific language.

Each element of a web site (home page, simple pages, menus, blogs, Javascript animated slide show, photo or video galleries, etc.) can be managed even by a novice editor simply by filling fields in a form following contestual help instructions.

Creating a project with MagicCMS goes through these phases:

1. Once you have defined the structure and organization of information of the site will determine which parties the user must have access to additions and modifications.
1. For each of the editable parts (which can be virtually all elements of a site) will define the object types that will be. MagicCMS offers a flexible object that we called MagicPost, which does not serve merely to encode and store a post, but any element of the interface of a web application. Then for each of the types of editable parts to handle specific MagicPost type will be identified that can be customized.
1. The customization consists of three or four steps:
	* Define what fields will be exhibited in the process of editing and what labels will be used to describe them. In order to offer to editors a custom back end and as friendly as possible
	* Write a specific help for all types MagicPost. The help text is HTML formatted, and therefore can contain links, images, etc. The help can be accessed simultaneously during editing and make the back end self explanatory.
	* If necessary, you can make use of the potential offered by CKEditor, the leading Open Source online editor for HTML that MagicCMS uses for parts of the text in which HTML formatting is allowed. You may, for example, add HTML text templates to further facilitate the editing activities.
	* Finally, the elements rendering. MagicCMS use the  Asp.NET Web Forms model. You can define a rendering style for each type of object writing specific Asp.NET Master Pages. When MagicCMS engine must display a specific type of page, will load *on the fly* the Master Page specified in the definition of the type.
	
The types customization takes place using a suitable page of the back end UI. The Master Pages dedicated to the rendering must descend from the MagicCMS.PageBase.MasterTheme class (which is descended from System.Web.UI.Page) and inherit from this class some properties that make immediately available the access to the site configuration and to the rendered web page data.
The library is available on nuget.org and it can be installed in Microsoft Visual Studio through the Packages Management Console. The installation process includes the installation and registration of required third-party libraries, the registration of MagicCMS.dll and the installation of all back end interface files.

The library documentation is available on http://docs.magiccms.org/.

The sharing process, however, has just begun. Soon they will open a dedicated website and a facebook page and will learn more about.
Those who want to collaborate in the project, or just looking at the code, can *clone* the project at https://github.com/magicbruno/MagicCMS.4.5. The folders contain the entire Visual Studio solution.

## Localization
MagicCMS was developed with a focus on languages and offers an advanced method for the management of multilingual sites. Unlike other CMS in MagicCMS translation management is directly managed by the CMS engine. 

During configuration you will define which languages will be used on the site: the original (default) language and the languages in which the site will be translated. Then, for each web element stored in the database, during editing, you can add translations. A special MagicCMS object (the Language Button) will allow the user to change the language.

In the back end the original language and the translations for each item are managed simultaneously, so as to optimize the editing and correction process. When you get into editing or insert a new element, the back end UI will provide a tab for each of the activated languages in which you can insert the translation. Optionally you can configure MagicCMS to use, on request, Bing Translator for a first element translation, translation that the editor can then edit at will.

We refer to two examples of multilingual sites created with MagicCMS: the Ingegneri Riuniti S.p.A. Modena corporate websitea (http://ingegneririuniti.it/) made in English, French and Italian and http://brunomigliaretti.com/ in Italian and English.

## Extensions and customization 
The architecture of the library, strictly object-oriented, and the availability of documentation make MagicCMS easily extendable and compatible with other code written in C#. You may add tables to the database and/or access to existing tables using the classes provided by MagicCMS namespace.
MagicCMS is therefore a framework that can also be used for applications in which the management of informative web pages is only a part of the project.
## Connection with social networks
MagicCMS uses the Facebook library (https://github.com/facebook-csharp-sdk/facebook-csharp-sdk) that is installed along with the main library to interface to the Facebook API. It has created a specific class that in a simplified manner can collect post from any public Facebook page, and makes them available for viewing on a website page.
## Project status
MagicCMS is a fully functioning library and already used for creating and managing many Web sites, but it is accompanied by a still limited documentation.
### To do list
In the coming weeks it is expected some updates aimed primarily at facilitating the sharing of the project:
* Opening a dedicated bilingual website (English and Italian).
* Opening of a Facebook page (in Italian)
* Additions to the documents:
	* Detailed instructions for installing MagicCMS, database creation and connection to MagicCMS site.
	* Detailed informations on the database structure.
* Currently the backend interface and the error messages are only in Italian:
	* Make the back end interface bilingual (Italian and English)
	* Making error messages multilingual.