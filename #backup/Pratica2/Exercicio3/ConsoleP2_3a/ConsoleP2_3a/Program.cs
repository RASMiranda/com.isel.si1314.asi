using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.IO;



namespace ConsoleP2_3a
{
    class Sharding : IDisposable
    {
        private bool _disposed;
        private int NumNodes = 3;   // numero de nos do sharding
            // localizacao das instancias das replicas
        private string connectionStringBase = "Data Source=(local) ;Initial Catalog=DB2_3;"
            + "Integrated Security=true";
        private string connectionStringRep0;
        private string connectionStringRep1;
        private string connectionStringRep2;
        private List<SqlConnection> connectionsList = new List<SqlConnection>();

        public Sharding()
        {
            // configures connections for the three instancies /replicas
            connectionStringRep0 = connectionStringBase;
            connectionStringRep1 = connectionStringRep0.Replace("(local)", "FFSS\\ISELALFA");
            connectionStringRep2 = connectionStringRep0.Replace("(local)", "FFSS\\ISELBETA");
            //read conf. file to adjust to the specific environment 
            using (StreamReader reader = new StreamReader(@"..\..\..\..\..\00.config_inst.txt"))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    switch (line.Substring(0, 4))
                    {
                        case "Rep0":
                            connectionStringRep0 = connectionStringBase.Replace("(local)", line.Substring(5));
                            break;
                        case "Rep1":
                            connectionStringRep1 = connectionStringBase.Replace("(local)", line.Substring(5));
                            break;
                        case "Rep2":
                            connectionStringRep2 = connectionStringBase.Replace("(local)", line.Substring(5));
                            break;
                    }
                }
            }
            connectionsList.Add(new SqlConnection(connectionStringRep0));
            connectionsList.Add(new SqlConnection(connectionStringRep1));
            connectionsList.Add(new SqlConnection(connectionStringRep2));
            try
            {
                foreach (SqlConnection connection in connectionsList)
                {
                    connection.Open();
                }
                _disposed = false;
            }
            catch (Exception e)
            {
                Console.WriteLine("{0} - Open connection exception.", e);
            }

        }
        public SqlConnection getShard(int numero)
        {
                //como o sharding esta a usar o resto da divisao e as connection strings estao alinhadas
            return connectionsList.ElementAt(numero % NumNodes);
        }
        public SqlConnection getTempConnection(int numero)
        {
            //como o sharding esta a usar o resto da divisao e as connection strings estao alinhadas
            SqlConnection connection = new SqlConnection();
            int replicaNumber = numero % NumNodes;

            if (replicaNumber == 0) connection = new SqlConnection(connectionStringRep0);
            else if (replicaNumber == 1) connection = new SqlConnection(connectionStringRep1);
            else if (replicaNumber == 2) connection = new SqlConnection(connectionStringRep2);
            else
                connection = null;
            if ( connection != null) connection.Open();

            return connection;
        }
        public void closeTempConnection(SqlConnection connection)
        {
            //pode ser substituido por um retorno para uma pool
            if (connection != null) 
                connection.Close();
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
            // lista de disciplinas a inserir
            List<String> lstDisciplinas = new List<string>()
                {"Arq. de Computadores I","Arq. de Computadores II","Análise de Circuitos",
                 "Algoritmos e Estruturas de Dados","Arq. e Infra-estruturas Computacionais",
                 "Álgebra Linear e Geometria Analítica","Análise Matemática I","Análise Matemática II",
                 "Arquitectura de Sistemas de Informação","Ambientes Virtuais de Execução","Antenas"};
            // Lista de alunos a inserir
            List<String> lstAlunos = new List<string>()
                {"Antonio Saraiva","Antonio Silva","Antonio Borges",
                 "Joaquim Salvado","Ana Morais","Maria Martins", "Mario Silva"};

            // Create and open the connection in a using block. This 
            // ensures that all resources will be closed and disposed 
            // when the code exits. 
            using (Sharding globalDB = new Sharding())
            {
                //Para testes Limpa primeiro todos os elementos que tenham resultado de ensaios anteriores
                    //prepara comando para apagar "Alunos"
                SqlCommand deleteAluno = new SqlCommand();
                deleteAluno.CommandText = "delete  [dbo].[Alunos] ;";
                    //prepara comando para apagar "Inscricoes"
                SqlCommand deleteInscricao = new SqlCommand();
                deleteInscricao.CommandText = "delete [dbo].[Inscricao];";
                    //prepara comandos para apagar "Disciplinas"
                SqlCommand lerDisciplina = new SqlCommand();
                lerDisciplina.CommandText = "select codigo from [dbo].[disciplinas];";
                SqlCommand deleteDisciplina = new SqlCommand();
                deleteDisciplina.CommandText = "deleteDisciplina";
                deleteDisciplina.CommandType = CommandType.StoredProcedure;
                deleteDisciplina.Parameters.Add("@Cod", SqlDbType.Int);



                
                for (int i = 0; i < 3; i++)
                {   
                    int nAlunos, nInscricoes;
                        //determina a replica em funcao do Sharding
                    SqlConnection connection = new SqlConnection();
                    connection = globalDB.getShard(i);
                        //apaga inscricoes
                    deleteInscricao.Connection = connection;
                    nInscricoes = deleteInscricao.ExecuteNonQuery();
             
                        // apaga alunos
                    deleteAluno.Connection = connection;
                    nAlunos = deleteAluno.ExecuteNonQuery();
                    Console.WriteLine("Sharding key({0}) removidos: {1} inscricoes; {2} alunos;",
                            i,  nInscricoes,nAlunos);
                }
                // loop sobre "Disciplinas" para apagar usando o procedimento
                int nDisciplinas = 0;
                    //so precisa de correr num no pq esta replicada sincronamente em todos
                deleteDisciplina.Connection = globalDB.getTempConnection(0);
                lerDisciplina.Connection = globalDB.getShard(0);
                SqlDataReader readerDisciplinas = lerDisciplina.ExecuteReader();

                while (readerDisciplinas.Read())
                {
                    deleteDisciplina.Parameters["@Cod"].Value = readerDisciplinas[0];
                    deleteDisciplina.ExecuteNonQuery();

                    nDisciplinas++;
                }
                globalDB.closeTempConnection(deleteDisciplina.Connection);
                readerDisciplinas.Close();
                Console.WriteLine("Global removidas: {0} disciplinas;", nDisciplinas);

                
                // insere disciplinas usa a stored procedutre
                SqlCommand insereDisciplina = new SqlCommand();
                insereDisciplina.CommandType= CommandType.StoredProcedure;
                insereDisciplina.CommandText = "insereDisciplina";
                insereDisciplina.Parameters.Add("@Cod", SqlDbType.Int);
                insereDisciplina.Parameters.Add("@Designacao", SqlDbType.VarChar);
                int nDisciplina = 1;
                foreach (string disciplina in lstDisciplinas )
                {
                    insereDisciplina.Parameters["@Cod"].Value = nDisciplina;
                    insereDisciplina.Parameters["@Designacao"].Value = disciplina;
                    //nao tem sharding, apenas para garantir que ensaia o procedimento a correr em todas as replicas
                    insereDisciplina.Connection = globalDB.getShard( nDisciplina ); 
                    insereDisciplina.ExecuteNonQuery();
                    Console.WriteLine("\tInserted {0}:\t{1}", nDisciplina++, disciplina);
                }

                // insere alunos
                SqlCommand insereAluno = new SqlCommand();
                insereAluno.CommandText = "insert into [dbo].[Alunos] ( numero, nome) values( @Numero, @Nome);";
                //insereAluno.CommandType = CommandType.TableDirect;
                insereAluno.Parameters.Add("@Numero", SqlDbType.Int);
                insereAluno.Parameters.Add("@Nome", SqlDbType.VarChar);

                int naluno= 1;
                foreach (string aluno in  lstAlunos )
                {
                    insereAluno.Parameters["@Numero"].Value = naluno;
                    insereAluno.Parameters["@Nome"].Value = aluno;
                    insereAluno.Connection = globalDB.getShard(naluno);
                    insereAluno.ExecuteNonQuery();
                    Console.WriteLine("\tInserted {0}:\t{1}", naluno++, aluno);
                }

                SqlCommand insereInscricao = new SqlCommand();
                insereInscricao.CommandText = "insert into [dbo].[Inscricao] (numero, codigo, nota) values (@Numero, @Codigo, @Nota);";
                insereInscricao.Parameters.Add("@Numero", SqlDbType.Int);
                insereInscricao.Parameters.Add("@Codigo", SqlDbType.Int);
                insereInscricao.Parameters.Add("@Nota", SqlDbType.Int);
                int novasInscricoes = 0;
                for (int i = 1; i < 5; i++)
                {
                    insereInscricao.Connection = globalDB.getShard(i);
                    insereInscricao.Parameters["@Numero"].Value = i;
                    for (int j = 0; j < 2; j++)
                    {
                        insereInscricao.Parameters["@Codigo"].Value = i + j;
                        insereInscricao.Parameters["@Nota"].Value = 20 - j;
                        insereInscricao.ExecuteNonQuery();
                        novasInscricoes++;
                    }
                }
                Console.WriteLine("\tInscricoes realizadas:\t{0}", novasInscricoes);

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

