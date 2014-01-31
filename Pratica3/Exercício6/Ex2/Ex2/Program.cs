using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity.Infrastructure;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.EntityClient;
using System.Configuration;

using System.Data.SqlClient;

using System.Data.Entity.Core.Objects;

using System.Transactions;
using System.Data.Common;

namespace Ex2
{
    public partial class ASIEntities7 : DbContext
    {
        public ASIEntities7(EntityConnection cn) : base(cn, false) { }
    }
 
    
    class Program
    {
        
        static void Main(string[] args)
        {


            EntityConnection cn = new EntityConnection("name=ASIEntities7");
            DbConnection dbcn = new SqlConnection( System.Configuration.ConfigurationManager.ConnectionStrings["base dados"].ConnectionString );

            var alnPedro = new Aluno { NumAl = 1001, Nome = "Pedro" };
            alnPedro.AlunosAssEsts = new HashSet<AlunosAssEst>();

            var alnPaula = new Aluno { NumAl = 1002, Nome = "Paula" };
            alnPaula.AlunosAssEsts = new HashSet<AlunosAssEst>();

            using (var ctx1 = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                //ctx1.Database.Log = Console.Write;

                ctx1.Alunos.Add(alnPedro);
                ctx1.Alunos.Add(alnPaula);

                // ExecuteDML(dbcn, "A trocar as voltas ao EF6 inserindo o Jose ADO.Net(1001)...", "INSERT INTO [BD3_1].[dbo].[Alunos] ([NumAl],[Nome]) VALUES (1001, 'Jose ADO.Net')");
                SaveContextChanges(ctx1, PoliticaConcorrencia.UsarInfoBD);
            }
            
            using (var ctxPessimista = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                //ctx4.Database.Log = Console.Write;

                Aluno alnPedroCtx = (from a in ctxPessimista.Alunos where a.NumAl == 1001 select a).First();
                alnPedroCtx.Nome = "Pedro ContextoEF6";

                ExecuteDML(dbcn, "O ADO.Net vai mudar o nome do Pedro para 'Pedro ADO.Net'.", "UPDATE [BD3_1].[dbo].[Alunos] SET [Nome] = 'Pedro ADO.Net' WHERE [NumAl] = 1001");
                
                Console.WriteLine("O EF6 vai mudar o nome do Pedro para 'Pedro ContextoEF6'. Antes de gravar, alnPedroCtx.Nome = {0}", alnPedroCtx.Nome);
                SaveContextChanges(ctxPessimista, PoliticaConcorrencia.UsarInfoBD);
                Console.WriteLine("Depois de gravadas as alteracoes com uma politica pessimista (vale o que esta na BD), o nome do Pedro no ambito do contexto EF6 é: alnPedroCtx.Nome = {0})", alnPedroCtx.Nome);
            }

            Console.WriteLine();

            using (var ctxOptimista = new ASIEntities7(cn))
            {
                // em alternativa a usar o Sql Server Profiler, pode fazer:
                //ctx5.Database.Log = Console.Write;

                Aluno alnPedroCtx = (from a in ctxOptimista.Alunos where a.NumAl == 1001 select a).First();
                alnPedroCtx.Nome = "Pedro ContextoEF6";

                ExecuteDML(dbcn, "O ADO.Net vai mudar o nome do Pedro para 'Pedro ADO.Net Outra Vez'.", "UPDATE [BD3_1].[dbo].[Alunos] SET [Nome] = 'Pedro ADO.Net Outra Vez' WHERE [NumAl] = 1001");
                
                Console.WriteLine("O EF6 vai mudar o nome do Pedro para 'Pedro ContextoEF6'. Antes de gravar, alnPedroCtx.Nome = {0}", alnPedroCtx.Nome);
                SaveContextChanges(ctxOptimista, PoliticaConcorrencia.UsarInfoCtx);
                Console.WriteLine("Depois de gravadas as alteracoes com uma politica optimista (vale o que esta no Contexto), o nome do Pedro no ambito do contexto EF6 é: alnPedroCtx.Nome = {0})", alnPedroCtx.Nome);
            }

            Console.WriteLine("Press any key to exit...");
            Console.ReadLine();
        }

        private static void ExecuteDML(DbConnection cn, String msg, String cmdTxt)
        {
            Console.WriteLine(msg);
            DbCommand cmd = cn.CreateCommand();
            cmd.CommandText = cmdTxt;
            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();
        }

        private enum PoliticaConcorrencia { UsarInfoBD, UsarInfoCtx, FnResolucaoConflitos };

        private static void SaveContextChanges(DbContext ctx, PoliticaConcorrencia politicaConcorrencia = PoliticaConcorrencia.UsarInfoCtx)
        {
            bool falha;
            do {
                falha = false;
                try { ctx.SaveChanges(); }
                catch (DbUpdateConcurrencyException ex) {
                    Console.WriteLine("Ocorreu uma DbUpdateConcurrencyException durante o SaveChanges.");
                    falha = true;
                    switch (politicaConcorrencia)
                    {
                        case PoliticaConcorrencia.UsarInfoBD:
                            {
                                // ignorar as alterações feitas no contexto e usar a informação corrente na BD (estado = unchanged)
                                ex.Entries.Single().Reload();
                                break;
                            }
                        case PoliticaConcorrencia.UsarInfoCtx:
                            {
                                // esmagar as alterações na BD
                                var entry = ex.Entries.Single();
                                var dbValues = entry.GetDatabaseValues();
                                entry.OriginalValues.SetValues(dbValues);
                                break;
                            }
                        case PoliticaConcorrencia.FnResolucaoConflitos:
                            {
                                // deixar que a aplicação cliente decida
                                var entry = ex.Entries.Single();
                                var dbValues = entry.GetDatabaseValues();
                                entry.CurrentValues.SetValues(ResolverConflitos(entry.OriginalValues, entry.CurrentValues, dbValues));
                                entry.OriginalValues.SetValues(dbValues);
                                break;
                            }
                        default:
                            throw new Exception("Politica desconhecida: " + politicaConcorrencia.ToString());
                    }
                }
            } while (falha);
        }

        private static DbPropertyValues ResolverConflitos(DbPropertyValues dbPropertyValues1, DbPropertyValues dbPropertyValues2, DbPropertyValues dbValues)
        {
            throw new NotImplementedException();
        }
    }
}
