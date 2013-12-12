﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.ServiceModel;
using System.Data.Linq.Mapping;
using System.Data.Linq;

using System.Runtime.Serialization;

namespace Ex1.c
{
    //[DataContract(Namespace = "MeuNamespace")]
    [DataContract]
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

    [ServiceContract]
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

      [ServiceBehavior(
                    TransactionIsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                    TransactionTimeout = "00:03:00",
                    InstanceContextMode=InstanceContextMode.Single,                  
                    IncludeExceptionDetailInFaults=true                    
                   )
      ]
      public class Servico : IServico
      {
          int n = 0;

          public Conta obterConta(int numero)
          {
             

              Console.WriteLine("obter " + numero);

              DataContext dc = new DataContext(@"Data Source=MIRANDA-LAPTOP\SQL2012DEINST1;Initial Catalog=ASI;Integrated Security=true");//TODO: CONFIGURATION FILE!
              Table<Conta> tc = dc.GetTable<Conta>();
              var conta = (from c in dc.GetTable<Conta>()
                           where c.Numero == numero
                           select c).SingleOrDefault();
              return conta;
          }


          public void inserirConta(Conta c)
          {
              DataContext dc = new DataContext(@"Data Source=MIRANDA-LAPTOP\SQL2012DEINST1;Initial Catalog=ASI;Integrated Security=true");//TODO: CONFIGURATION FILE!
              Table<Conta> tc = dc.GetTable<Conta>();
              tc.InsertOnSubmit(c);
              dc.SubmitChanges();
          }

          public void alterarConta(Conta c)
          {
              DataContext dc = new DataContext(@"Data Source=MIRANDA-LAPTOP\SQL2012DEINST1;Initial Catalog=ASI;Integrated Security=true");//TODO: CONFIGURATION FILE!
              Table<Conta> tc = dc.GetTable<Conta>();
              tc.Attach(c, true);
              try
              {
                  dc.SubmitChanges(ConflictMode.ContinueOnConflict);
              }
              catch (ChangeConflictException e)
              {
                  dc.ChangeConflicts.ResolveAll(RefreshMode.KeepCurrentValues); // last -in - wins
                  dc.SubmitChanges();
              }
          }

          [OperationBehavior(
                TransactionScopeRequired = true // false por omissão
            )]
          public void Transferir(int c1, int c2, float montante)
          {
              try
              {
                  Console.WriteLine("Transferir " + montante + " euros de " + c1 + " para " + c2);

                  DataContext dc = new DataContext(@"Data Source=MIRANDA-LAPTOP\SQL2012DEINST1;Initial Catalog=ASI;Integrated Security=true");//TODO: CONFIGURATION FILE!
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
                  

                  Console.WriteLine("No fim de transferir n = {0}", n++);
                  //Console.WriteLine("this.GetHashCode().ToString(): {0}" , this.GetHashCode().ToString());

              }
              catch (Exception ex) 
              {
                  throw ex;//Solucação conta inexistente
              }
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
