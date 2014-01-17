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

namespace Ex2
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
        Conta obterConta(int numero);

        [OperationContract]
        void inserirConta(Conta c);

        [OperationContract]
        void alterarConta(Conta c);

        [OperationContract]
        void Transferir(int c1, int c2, float montante);

    
    }

    [ServiceBehavior(TransactionIsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                  TransactionTimeout = "00:03:00",
                  InstanceContextMode = InstanceContextMode.PerSession,
                  IncludeExceptionDetailInFaults = true
                  
                 )
    ]
    public class Servico : IServico
    {
        public Conta obterConta(int numero)
        {


            Console.WriteLine("obter " + numero);

            DataContext dc = getDataContext();
            Table<Conta> tc = dc.GetTable<Conta>();
            var conta = (from c in dc.GetTable<Conta>()
                         where c.Numero == numero
                         select c).SingleOrDefault();
            return conta;
        }


        public void inserirConta(Conta c)
        {
            DataContext dc = getDataContext();
            Table<Conta> tc = dc.GetTable<Conta>();
            tc.InsertOnSubmit(c);
            dc.SubmitChanges();
        }

        public void alterarConta(Conta c)
        {
            DataContext dc = getDataContext();
            Table<Conta> tc = dc.GetTable<Conta>();
            tc.Attach(c, true);
            try
            {
                dc.SubmitChanges(ConflictMode.ContinueOnConflict);
            }
            catch (ChangeConflictException)
            {
                dc.ChangeConflicts.ResolveAll(RefreshMode.KeepCurrentValues); // last -in - wins
                dc.SubmitChanges();
            }
        }

        [OperationBehavior(TransactionAutoComplete = false,
                           TransactionScopeRequired = true // false por omissão

        )]
        public void Transferir(int c1, int c2, float montante)
        {
            
                Console.WriteLine("Transferir " + montante + " euros de " + c1 + " para " + c2);

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

               
                Console.WriteLine("Fim de transferir");


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
