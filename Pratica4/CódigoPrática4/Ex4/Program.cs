using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Text;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Transactions;

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

            Console.WriteLine("Transferir session full" + montante + " euros de " + c1 + " para " + c2);

            DataContext dc = new DataContext(@"Data Source=wv-toshiba\instancia1;Initial Catalog=ASI;User ID=sa;Password=123");
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

            Console.WriteLine("Transferir session less" + montante + " euros de " + c1 + " para " + c2);

            DataContext dc = new DataContext(@"Data Source=wv-toshiba\instancia1;Initial Catalog=ASI;User ID=sa;Password=123");
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
