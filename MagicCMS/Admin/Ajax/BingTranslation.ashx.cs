﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using MagicCMS.Core;
using MagicCMS.BingTranslator;
using MagicCMS.AccessToken;
using System.ServiceModel.Channels;
using System.ServiceModel;

/// <exclude />
namespace MagicCMS.Admin.Ajax
{
	/// <summary>
	/// Class BingTranslation. 
	/// </summary>
	/// <remarks>Translate a post via AJAX call using Bing Translation. Return a <see cref="MagicCMS.Core.AjaxJsonResponse"/> with data containing a 
	/// <see cref="MagicCMS.Core.MagicTranslation"/> object</remarks>
	/// <seealso cref="System.Web.IHttpHandler" />
	/// <seealso cref="System.Web.SessionState.IRequiresSessionState" />
	public class BingTranslation : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (MagicSession.Current.LoggedUser.Level < 4)
            {
                context.Response.StatusCode = 403;
                context.Response.StatusDescription = "Prerogative non sufficienti";
                context.Response.ContentType = "text/html";
                //context.Response.Write("Sessione scaduta.");
                return;
            }

            AjaxJsonResponse response = new AjaxJsonResponse
            {
                data = null,
                exitcode = 0,
                msg = Localize.Translate("Operazione conclusa con successo."),
                pk = 0,
                success = true
            };

            AdmAuthentication admAut;
            AdmAccessToken token;
			AzureAuthToken azureToken;

            int pk;
            string langid;
            string title, testoBreve, testoLungo, tags;
            string term;

            CMS_Config myConfig = new CMS_Config();
            MagicTranslation translation;

            int.TryParse(context.Request["Pk"], out  pk);
            langid = context.Request["LangId"];
            title = context.Request["Titolo"];
            testoBreve = context.Request["TestoBreve"];
            testoLungo = context.Request["TestoLungo"];
            tags = context.Request["Tags"];
            translation = new MagicTranslation(pk, langid);
            term = context.Request["term"];
			string authToken = "";

            if (String.IsNullOrEmpty(myConfig.TransSecretKey))
            {
                response.exitcode = 1;
                response.success = false;
                response.msg =  Localize.Translate("Necessario configurare una 'Client Secret Key' per utilizzare il motore di traduzione");
            }
			else if (String.IsNullOrEmpty(myConfig.TransClientId))
			{
				try
				{
					azureToken = new AzureAuthToken(myConfig.TransSecretKey);
					authToken = azureToken.GetAccessToken();

				}
				catch (Exception e)
				{
					response.exitcode = 2;
					response.success = false;
					response.msg = e.Message;
				}
			}
			else 
			{
				try
				{
					admAut = new AdmAuthentication(myConfig.TransClientId, myConfig.TransSecretKey);
					token = admAut.GetAccessToken();
					authToken = "Bearer " + token.access_token;
				}
				catch (Exception e)
				{
					response.exitcode = 2;
					response.success = false;
					response.msg = e.Message;
				}
			}
			if (!String.IsNullOrEmpty(authToken))
			{
				if (!String.IsNullOrEmpty(term))
				{
					try
					{
						// Translations
						response.data = TranslateMethod(authToken, myConfig.TransSourceLangId, langid, term, "text/plain");
					}
					catch (Exception e)
					{
						response.exitcode = 3;
						response.success = false;
						response.msg = e.Message;
					}
				}
				else if (pk == 0 || String.IsNullOrEmpty(langid))
				{
					response.exitcode = 4;
					response.success = false;
					response.msg = Localize.Translate("Dati incoerenti. Per creare una traduzione bisogna prima salvare il post originale.");
				}
				else
				{
					try
					{
						// Translations
						translation.TranslatedTitle = TranslateMethod(authToken, myConfig.TransSourceLangId, langid, title, "text/plain");
						translation.TranslatedTestoBreve = TranslateMethod(authToken, myConfig.TransSourceLangId, langid, testoBreve, "text/html");
						translation.TranslatedTestoLungo = TranslateMethod(authToken, myConfig.TransSourceLangId, langid, testoLungo, "text/html");
						translation.TranslatedTags = TranslateMethod(authToken, myConfig.TransSourceLangId, langid, tags, "text/plain");
						response.data = translation;
					}
					catch (Exception e)
					{
						response.exitcode = 100;
						response.success = false;
						response.msg = e.Message;
					}
				}
			}
 

            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string json = serializer.Serialize(response);

            context.Response.ContentType = "application/json";
            context.Response.Charset = "UTF-8";
            context.Response.Write(json);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private static string TranslateMethod(string authToken, string sourceLang, string destLang, string sourceText, string contentType)
        {
            
            // Add TranslatorService as a service reference, Address:http://api.microsofttranslator.com/V2/Soap.svc
            LanguageServiceClient client = new LanguageServiceClient();
            //Set Authorization header before sending the request
            HttpRequestMessageProperty httpRequestProperty = new HttpRequestMessageProperty();
            httpRequestProperty.Method = "POST";
            httpRequestProperty.Headers.Add("Authorization", authToken);

            // Creates a block within which an OperationContext object is in scope.
            using (OperationContextScope scope = new OperationContextScope(client.InnerChannel))
            {
                OperationContext.Current.OutgoingMessageProperties[HttpRequestMessageProperty.Name] = httpRequestProperty;
                //Keep appId parameter blank as we are sending access token in authorization header.
                return client.Translate("", sourceText, sourceLang, destLang, contentType, "general","");
				
            }
        }

    }
}