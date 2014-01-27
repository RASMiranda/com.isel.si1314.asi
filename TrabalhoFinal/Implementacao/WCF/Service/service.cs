//----------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//----------------------------------------------------------------

using System;
using System.Configuration;
using System.Messaging;
using System.ServiceModel;
using System.ServiceModel.MsmqIntegration;

namespace Microsoft.Samples.MSMQToWCF
{
        // Define a service contract. 
    [ServiceContract(Namespace = "http://Microsoft.Samples.MSMQToWCF")]
    [ServiceKnownType(typeof(VendaOrder))]
    public interface IVendaService
    {

        [OperationContract(IsOneWay = true, Action = "*")]
        void SubmitVenda(MsmqMessage<VendaOrder> msg);

    }
    // Service class which implements the service contract.
    // Added code to write output to the console window
    public class    VendaService : IVendaService
    {
        [OperationBehavior(TransactionScopeRequired = true, TransactionAutoComplete = true)]
        public void SubmitVenda(MsmqMessage<VendaOrder> ordermsg)
        {
            VendaOrder venda = ordermsg.Body;

            
            Console.WriteLine("Processing {0} ", venda);
        }

        // Host the service within this EXE console application.
        public static void Main()
        {
            // Get MSMQ queue name from app settings in configuration
            string queueName = ConfigurationManager.AppSettings["orderQueueName"];

            // Create the transacted MSMQ queue if necessary.
            if (!MessageQueue.Exists(queueName))
                MessageQueue.Create(queueName, true);

            // Create a ServiceHost for the OrderProcessorService type.
            using (ServiceHost serviceHost = new ServiceHost(typeof(VendaService)))
            {
                serviceHost.Open();

                // The service can now be accessed.
                Console.WriteLine("The service is ready.");
                Console.WriteLine("Press <ENTER> to terminate service.");
                Console.ReadLine();
            }
        }
    }


}


