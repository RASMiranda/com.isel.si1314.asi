using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.ServiceModel;

using System.Data.Linq.Mapping;
using System.Data.Linq;

using System.Runtime.Serialization;

using System.Messaging;

using System.Windows.Forms;
using System.IO;


namespace Ex3
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

    [ServiceContract(SessionMode = SessionMode.NotAllowed)] // também com Allowed temos sessionless
    public interface IServicoMSMQ
    {

        [OperationContract(IsOneWay = true)]
        void inserirConta(Conta c);

        [OperationContract(IsOneWay = true)]
        void alterarConta(Conta c);


    }
    
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)] // com sessionless também pode ser PerSession
    public class Servico : IServicoMSMQ
    {

        [OperationBehavior(TransactionAutoComplete = true,
                          TransactionScopeRequired = true
        )]
        public void inserirConta(Conta c)
        {
            DataContext dc = getDataContext();
            Table<Conta> tc = dc.GetTable<Conta>();
            tc.InsertOnSubmit(c);
            dc.SubmitChanges();
        }

        [OperationBehavior(TransactionAutoComplete = true,
                          TransactionScopeRequired = true
        )]
        public void alterarConta(Conta c)
        {
            //MessageBox.Show("AlterarConta");
            Console.WriteLine("AlterarConta");

            DataContext dc = getDataContext();
            Table<Conta> tc = dc.GetTable<Conta>();
            tc.Attach(c, true);
            try
            {
                dc.SubmitChanges(ConflictMode.ContinueOnConflict);
                //MessageBox.Show("Conta alterada");
                Console.WriteLine("Conta alterada");

            }
            catch (ChangeConflictException e)
            {
                //MessageBox.Show("Erro ao alterar a conta");
                Console.WriteLine("Erro ao alterar a conta: ChangeConflictException");
                Console.WriteLine("ChangeConflictException.Message: {0}", e.Message);
                Console.WriteLine("ChangeConflictException.StackTrace: {0}", e.StackTrace);
                //throw;
            }
            catch (Exception e)
            {
                Console.WriteLine("Erro ao alterar a conta: Exception");
                Console.WriteLine("Exception.Message: {0}", e.Message);
                Console.WriteLine("Exception.StackTrace: {0}", e.StackTrace);
                //throw;
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
            if (!MessageQueue.Exists(@".\private$\filaWCF"))
                MessageQueue.Create(@".\private$\filaWCF", true);  //ATENÇÃO: por omissão, a fila tem de ser transaccional

            NetMsmqBinding b = new NetMsmqBinding();
            b.ReceiveErrorHandling = ReceiveErrorHandling.Drop;

            ServiceHost host =
                    new ServiceHost(typeof(Servico));

            host.Open();
            Console.WriteLine("Serviço iniciado. Enter para terminar");
            Console.ReadLine();
            host.Close();
            MessageQueue.Delete(@".\private$\filaWCF");//grupo5

        }
    }
}