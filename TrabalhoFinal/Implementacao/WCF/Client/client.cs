//----------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//----------------------------------------------------------------

using System;
using System.Configuration;
using System.Messaging;
using System.Transactions;

namespace Microsoft.Samples.MSMQToWCF
{
	class Program
	{
		static void Main(string[] args)
		{
            //Connect to the queue
            MessageQueue orderQueue = new MessageQueue(@"FormatName:Direct=OS:" + ConfigurationManager.AppSettings["orderQueueName"]);

            // simula a criação de uma venda
            VendaOrder venda = new VendaOrder();
            venda.dadosVenda("Cliente", "Av. Conselheiro Emidio Navarro, Lisboa");

            venda.produto("scam1", 5, 25.4f);
            venda.produto("scam2", 1, 33.2f);

            Message msg = new Message();
            msg.Body = venda;
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required))
            {
                orderQueue.Send(msg, MessageQueueTransactionType.Automatic);
                // Complete the transaction.
                scope.Complete();
            }

            Console.WriteLine("Placed the order:{0}", venda);
            Console.WriteLine("Press <ENTER> to terminate client.");
            Console.ReadLine();
		}
	}
}

