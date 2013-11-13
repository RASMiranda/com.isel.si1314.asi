using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;


namespace ConsoleP2_3a
{
    class Sharding : IDisposable
    {
        private bool _disposed;
        private int NumNodes = 3;   // numero de nos do sharding
            // localizacao das instancias das replicas
        private string connectionStringRep0 =
            "Data Source=(local);Initial Catalog=DB2_3;"
            + "Integrated Security=true";
        private string connectionStringRep1 =
            "Data Source=FFSS\\ISELALFA;Initial Catalog=DB2_3;"
            + "Integrated Security=true";
        private string connectionStringRep2 =
            "Data Source=FFSS\\ISELBETA;Initial Catalog=DB2_3;"
            + "Integrated Security=true";
        private List<SqlConnection> connectionsList = new List<SqlConnection>();

        public Sharding()
        {
            // _disposed = false
            // open das connections
            // implementação do método 
            // chamada à distribuição do sharding ....
            connectionsList.Add(new SqlConnection(connectionStringRep0));
            connectionsList.Add(new SqlConnection(connectionStringRep1));
            connectionsList.Add(new SqlConnection(connectionStringRep2));
            foreach (SqlConnection connection in connectionsList)
            {
                connection.Open();
            }
            _disposed = false;

        }
        public SqlConnection getShard(int numero)
        {
                //como o sharding esta a usar o resto da divisao e as connection strings estao alinhadas
            return connectionsList.ElementAt(numero % NumNodes);
        }

        public void Dispose()
        {
            Dispose(true);

            // Call SupressFinalize in case a subclass implements a finalizer.
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            // If you need thread safety, use a lock around these  
            // operations, as well as in your methods that use the resource. 
            if (!_disposed)
            {
                if (disposing)
                {
                    foreach (SqlConnection connection in connectionsList)
                    {
                        connection.Close();
                    }
                    connectionsList.Clear();

                    Console.WriteLine("Object disposed.");
                }

                // Indicate that the instance has been disposed.
                _disposed = true;
            }
        }
    }
    class Program
    {
        static void Main()
        {
            // Provide the query string with a parameter placeholder. 
            string queryString =
                "SELECT numero, nome  from dbo.alunos "
                    + "WHERE numero  > @numero "
                    + "ORDER BY numero DESC;";

            // Specify the parameter value. 
            int paramValue = 5;

            // Create and open the connection in a using block. This 
            // ensures that all resources will be closed and disposed 
            // when the code exits. 
            using (Sharding globalDB = new Sharding())
            {
                //Para testes Limpa primeiro todos os elementos que tenham resultado de ensaios anteriores
                SqlCommand deleteAluno = new SqlCommand();
                deleteAluno.CommandText = "delete  [dbo].[Alunos] ;";
                for (int i = 0; i < 3; i++)
                {   
                    int nAlunos;
                        // corre todas as replicas
                    deleteAluno.Connection = globalDB.getShard(i);
                    nAlunos = deleteAluno.ExecuteNonQuery();
                    Console.WriteLine("Sharing key({0}): removidos {1} alunos", i,nAlunos );
                }
                

                // insere alunos
                SqlCommand insereAluno = new SqlCommand();
                insereAluno.CommandText = "insert into [dbo].[Alunos] ( numero, nome) values( @Numero, @Nome);";
                //insereAluno.CommandType = CommandType.TableDirect;
                insereAluno.Parameters.Add("@Numero", SqlDbType.Int);
                insereAluno.Parameters.Add("@Nome", SqlDbType.VarChar);

                for (int i = 1; i < 10; i++)
                {
                    insereAluno.Parameters["@Numero"].Value = i;
                    insereAluno.Parameters["@Nome"].Value = "Antonio Fagundes";
                    insereAluno.Connection = globalDB.getShard(i);
                    insereAluno.ExecuteNonQuery();
                    Console.WriteLine("\tInserted {0}:\t{1}", i, "Antonio Fagundes");
                }
                SqlCommand lerAlunos = new SqlCommand();
                lerAlunos.CommandText = "SELECT numero, nome  from [dbo].[Alunos] "
                                        + "ORDER BY numero ASC;";
                //lerAlunos.CommandType = CommandType.TableDirect;

                for (int i = 0; i < 3; i++)
                {
                    Console.WriteLine("Ler Shard({0})", i);
                    lerAlunos.Connection = globalDB.getShard(i);
                    SqlDataReader reader = lerAlunos.ExecuteReader();
                    while (reader.Read())
                    {
                        Console.WriteLine("\t{0}\t{1}",
                            reader[0], reader[1]);
                    }
                    reader.Close();
                }
            }
            Console.ReadLine();

        }
    }
}

