using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Messaging;
using System.ServiceModel;
using QueueVendas;

namespace ASIVesteSede
{
     public static class QueuesConfig
    {
        public static void Register()
        {
            using (ServiceHost receiver = new ServiceHost(typeof(VendaServico)))
            {
                /*
               string queueLSC = ".\\private$\\queueLSC";
               if ( ! MessageQueue.Exists( queueLSC ))
               {
                   MessageQueue.Create( queueLSC,false);
               }
                */
                receiver.Open();
                //Console.WriteLine("Esta pronto para receber ordems de venda");
            }
        }

    }
}