using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.ServiceModel;

using System.Runtime.Serialization;

using System.Transactions;

[ServiceContract(SessionMode = SessionMode.NotAllowed)] // também com Allowe temos sessionless
public interface IServicoMSMQ
{

    [OperationContract(IsOneWay = true)]
    void inserirConta(Conta c);

    [OperationContract(IsOneWay = true)]
    void alterarConta(Conta c);

}

[ServiceContract]
public interface IServico
{
    [OperationContract]
    void alterarSaldo(int nc, float novoSaldo);
}


[DataContract(Namespace = "MeuNamespace")]
public class Conta
{
    [DataMember(IsRequired = true)]
    public int Numero { get; set; }
    [DataMember(IsRequired = true)]
    public string Titular { get; set; }
    [DataMember(IsRequired = true)]
    public float Saldo { get; set; }
}


namespace ClienteTrComMSMQ
{
    class Program
    {
        static void Main(string[] args)
        {

            ChannelFactory<IServicoMSMQ>
              servico = new ChannelFactory<IServicoMSMQ>(
          "clienteServicoMSMQ");

            //servico.Credentials.SupportInteractive = true;
            //servico.Credentials.Windows.ClientCredential.UserName = "user";
            //servico.Credentials.Windows.ClientCredential.Password = "???";

            IServicoMSMQ endpt = servico.CreateChannel();



            Conta c1 = new Conta { Numero = 1, Titular = "msmq1", Saldo = 0 };
            Conta c2 = new Conta { Numero = 1111, Titular = "msmq2", Saldo = 0 };

            using (TransactionScope ts = new TransactionScope())
            {
                Console.WriteLine("Vair alterar conta 1, pressione tecla para avançar...");
                Console.ReadLine();
                endpt.alterarConta(c1);// Se a fila é transaccional, o alinhamento é automático
                Console.WriteLine("Conta 1 alterada");
                Console.WriteLine("Vair alterar conta 2, pressione tecla para avançar...");
                Console.ReadLine();
                endpt.alterarConta(c2);
                Console.WriteLine("Conta 2 alterada");
                Console.WriteLine("Vair completar transaccao, pressione tecla para avançar...");
                Console.ReadLine();
                ts.Complete();
                Console.WriteLine("Transaccao completa");
                Console.WriteLine("Vair terminar bloco using, pressione tecla para avançar...");
                Console.ReadLine();
            }
            Console.WriteLine("Bloco using terminado, pressione teclar para terminar...");
            Console.ReadLine();
            
        }
    }
}
