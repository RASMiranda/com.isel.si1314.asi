using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Text;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Transactions;
using System.IO;

namespace Ex4
{
    [DataContract(Namespace = "MeuNamespace")]
    [Table(Name = "Contas")]
    public class Conta
    {
        [DataMember(IsRequired = true)]
        [Column(IsPrimaryKey = true, UpdateCheck = UpdateCheck.Never)]
        public int Numero { get; set; }
        [Column(Name = "Titular", UpdateCheck = UpdateCheck.Never)]
        [DataMember(IsRequired = true)]
        public string Titular { get; set; }
        [Column(UpdateCheck = UpdateCheck.Never)]
        [DataMember(IsRequired = true)]
        public float Saldo { get; set; }
    }

    [ServiceContract(SessionMode = SessionMode.Required)
    ]
    public interface IServico
    {

        [OperationContract]
        void TransferirSessionFull(int c1, int c2, float montante);
        [OperationContract]
        void Finalizar();
        [OperationContract]
        void TransferirSessionLess(int c1, int c2, float montante);

    }

    [ServiceBehavior(TransactionIsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                  TransactionTimeout = "00:03:00",
                  InstanceContextMode = InstanceContextMode.PerSession,
                  IncludeExceptionDetailInFaults = true
                 )
    ]
    public class Servico : IServico
    {


        [OperationBehavior(TransactionAutoComplete = false,
                           TransactionScopeRequired = true // false por omissão

        )]
        public void TransferirSessionFull(int c1, int c2, float montante)
        {
            //try
            //{
                Console.WriteLine("Transferir session full" + montante + " euros de " + c1 + " para " + c2);

                DataContext dc = getDataContext();
                Table<Conta> tc = dc.GetTable<Conta>();
                var conta1 = (from c in dc.GetTable<Conta>()
                              where c.Numero == c1
                              select c).SingleOrDefault();
                var conta2 = (from c in dc.GetTable<Conta>()
                              where c.Numero == c2
                              select c).SingleOrDefault();

                conta1.Saldo -= montante;
                dc.SubmitChanges();
                conta2.Saldo += montante;
                dc.SubmitChanges();


                Console.WriteLine("Fim de transferir session full");


            //}
            //catch (Exception e)
            //{
            //    Console.WriteLine("Exception.Message: {0}", e.Message);
            //    Console.WriteLine("Exception.StackTrace: {0}", e.StackTrace);
            //    throw e;
            //}
        }

        [OperationBehavior(TransactionAutoComplete = true,
                    TransactionScopeRequired = true // false por omissão

        )]
        public void Finalizar()
        {

            Console.WriteLine("Finalizar");

        }

        [OperationBehavior(TransactionAutoComplete = true,
                   TransactionScopeRequired = true // false por omissão

)]
        public void TransferirSessionLess(int c1, int c2, float montante)
        {
            try
            {

                Console.WriteLine("Transferir session less" + montante + " euros de " + c1 + " para " + c2);

                DataContext dc = getDataContext();
                Table<Conta> tc = dc.GetTable<Conta>();
                var conta1 = (from c in dc.GetTable<Conta>()
                              where c.Numero == c1
                              select c).SingleOrDefault();
                var conta2 = (from c in dc.GetTable<Conta>()
                              where c.Numero == c2
                              select c).SingleOrDefault();

                conta1.Saldo -= montante;
                dc.SubmitChanges();
                conta2.Saldo += montante;
                dc.SubmitChanges();


                Console.WriteLine("Fim de transferir session less");

            }
            catch (Exception e)
            {
                Console.WriteLine("Exception.Message: {0}", e.Message);
                Console.WriteLine("Exception.StackTrace: {0}", e.StackTrace);
                throw e;
            }


        }

        private DataContext getDataContext()
        {
            String conStr = getConnectionString();
            return new DataContext(conStr);
        }

        private string getConnectionString()
        {

            string connectionStringBase = @"Server=(myServerAddress) ;Database=ASI;"
             + "User Id=(myUsername);"
             + "Password=(myPassword)";
            using (StreamReader reader = new StreamReader(@"..\..\..\..\..\00.config_inst.txt"))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    switch (line.Substring(0, 12))
                    {
                        case "PrincipalDBA":
                            connectionStringBase = connectionStringBase.Replace("(myServerAddress)", line.Substring(13));
                            break;
                        case "PrincipalUSR":
                            connectionStringBase = connectionStringBase.Replace("(myUsername)", line.Substring(13));
                            break;
                        case "PrincipalPWD":
                            connectionStringBase = connectionStringBase.Replace("(myPassword)", line.Substring(13));
                            break;
                    }
                }
            }
            return connectionStringBase;
        }

    }


    class Program
    {
        static void Main(string[] args)
        {
            ServiceHost host = new ServiceHost(typeof(Servico));

            host.Open();
            Console.WriteLine("Serviço iniciado. Enter para terminar");
            Console.ReadLine();
            host.Close();

        }
    }
}
