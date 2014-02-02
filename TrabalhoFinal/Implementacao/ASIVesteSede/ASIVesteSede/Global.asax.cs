﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Data.Entity;
using ASIVesteSede.DAL;

namespace ASIVesteSede
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {

            /*
            Database.SetInitializer<ASIVesteContext>(null);
            using (var ctx = new ASIVesteContext())
            {
                ctx.Database.Initialize(true);
            }
             */

            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();
<<<<<<< HEAD
                      
=======
>>>>>>> db3664ca1f0faf82683e13ac848c6ef09285eaf6
            
        }
    }
}