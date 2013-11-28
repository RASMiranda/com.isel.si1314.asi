
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Ex3.AlunosInterfaces;
using Ex3.Entidades;
using Ex3.DALAbstraction;


using System.Configuration;
using System.Transactions;

using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;



namespace Ex3.SpecificDAL
{
    public class DAOAlunoInteresse : IDAOAlunoInteresse
    {

        private string cs;

        public DAOAlunoInteresse()
        {

            cs = ConfigurationManager.ConnectionStrings["base dados"].ConnectionString;

        }

        public void Create(AlunoInteresse ai)
        {
            using (var ts = new TransactionScope(TransactionScopeOption.Required))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "INSERT INTO ALUNOSASSEST(NumAl,Interesse) VALUES(@NumAl,@Interesse)";
                SqlParameter p1 = new SqlParameter();
                SqlParameter p2 = new SqlParameter();
                
                cmd.Parameters.Add(p1);
                cmd.Parameters.Add(p2);

                p1.ParameterName = "@NumAl";
                p1.SqlDbType = SqlDbType.Int;
                p2.ParameterName = "@Interesse";
                p2.SqlDbType = SqlDbType.VarChar;
                p2.Size = 20;

                p1.Value = ai.Numero;
                p2.Value = ai.Interesse;
                using (var cn = new SqlConnection(cs))
                {
                    cn.Open();
                    cmd.Connection = cn;

                    cmd.ExecuteNonQuery();
                }

                ts.Complete();
            }
        }

        public AlunoInteresse Read(AlunoInteresseKey id)
        {


            throw new NotImplementedException("Oparação CRUD Ainda não implementada");

        }

        public void Update(AlunoInteresse ai)
        {
            throw new NotImplementedException("Oparação CRUD Ainda não implementada");
        }

        public void Delete(AlunoInteresse ai)
        {
            throw new NotImplementedException("Oparação CRUD Ainda não implementada");
        }


    }
}
