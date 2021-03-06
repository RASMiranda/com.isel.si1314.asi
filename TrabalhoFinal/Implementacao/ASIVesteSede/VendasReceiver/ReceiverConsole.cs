﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Messaging;
using System.ServiceModel;


namespace VendasReceiver
{
    class ReceiverConsole
    {
        static void Main(string[] args)
        {
            using ( ServiceHost receiver= new ServiceHost( typeof( VendaServico )))
            {
                string queueLSC = ".\\private$\\queueLSC";//TODO: config file
                if (!MessageQueue.Exists(queueLSC))
                    MessageQueue.Create(queueLSC, true);

                string queueLHD = ".\\private$\\queueLHD";//TODO: config file
                if (!MessageQueue.Exists(queueLHD))
                    MessageQueue.Create(queueLHD, true);

                receiver.Open();
                Console.WriteLine( "Esta pronto para receber ordems de venda");
                Console.WriteLine("Carregue em return para terminar");
                Console.ReadKey();
           }
        }
    }
}
